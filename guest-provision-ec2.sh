#!/bin/sh
#
# Provision a EC2 instance

set -e

d=$( cd $( dirname $0 ) && pwd )
n=$( basename $0 )

if ! aws --version > /dev/null; then
  echo >&2 "$n: aws command is required for provisioning with --ec2"
  exit 1
fi

if [ $( echo '{}' | jq . ) != '{}' ]; then
  echo >&2 "$n: jq command is required for provisioning with --ec2"
  exit 1
fi

image_id="ami-33e4bc49"
instance_type="t2.medium"
key_pair_name="octave-snapshot-key"
security_group_desc="octave-snapshot build host security group"
security_group_name="octave-snapshot-sg"
ssh_private_key_file="$d/$key_pair_name.pem"

ssh_config_file="$d/.octave-snapshot-ssh-config"
state_file="$d/.octave-snapshot-guest-state"

rm -f "$ssh_config_file"
rm -f "$state_file"

echo "guest_provision_type=ec2" >> "$state_file"

out=$( aws ec2 create-security-group --description "$security_group_desc" \
                                     --group-name "$security_group_name" )

security_group_id=$( printf "%s" "$out" | jq -r ".GroupId" )
echo "security_group_id=$security_group_id" >> "$state_file"

aws ec2 authorize-security-group-ingress --group-name "$security_group_name" \
                                         --protocol tcp \
                                         --port 22 \
                                         --cidr 0.0.0.0/0

out=$( aws ec2 create-key-pair --key-name "$key_pair_name" )
echo "key_pair_name=$key_pair_name" >> "$state_file"

echo "ssh_private_key_file=$ssh_private_key_file" >> "$state_file"
printf "%s" "$out" | jq -r ".KeyMaterial" > "$ssh_private_key_file"
chmod 0400 "$ssh_private_key_file"

out=$( aws ec2 run-instances --image-id "$image_id" \
                             --instance-type "$instance_type" \
                             --key-name "$key_pair_name" \
                             --security-group-ids "$security_group_id" )

instance_id=$( printf "%s" "$out" | jq -r ".Instances[0].InstanceId" )
echo "instance_id=$instance_id" >> "$state_file"

state=unknown
while [ "$state" != running ]; do
  sleep 1
  out=$( aws ec2 describe-instances --instance-id "$instance_id" )
  state=$( printf "%s" "$out" | jq -r ".Reservations[0].Instances[0].State.Name" )
done

address=$( printf "%s" "$out" | jq -r ".Reservations[0].Instances[0].PublicIpAddress" )

cat <<EOF > "$ssh_config_file"
Host guest
  HostName $address
  User ubuntu
  Port 22
  IdentityFile $ssh_private_key_file
  IdentitiesOnly yes
  PasswordAuthentication no
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  LogLevel FATAL
EOF

sleep 1
while ! ssh -F "$ssh_config_file" guest true > /dev/null 2>&1; do
  sleep 1
done

scp -F "$ssh_config_file" "$d/guest-bootstrap.sh" guest:
ssh -F "$ssh_config_file" guest sudo -H sh -x guest-bootstrap.sh --with-qt=4
