#!/bin/sh
#
# Destroy a EC2 instance

set -e

d=$( cd $( dirname $0 ) && pwd )

state_file="$PWD/.octave-snapshot-guest-state"
if [ -e "$state_file" ]; then
  . "$state_file"
fi

if [ -n "$instance_id" ]; then
  aws ec2 terminate-instances --instance-id "$instance_id" > /dev/null

  state=unknown
  while [ "$state" != "terminated" ]; do
    sleep 1
    out=$( aws ec2 describe-instances --instance-id "$instance_id" )
    state=$( printf "%s" "$out" | jq -r ".Reservations[0].Instances[0].State.Name" )
  done
fi

if [ -n "$key_pair_name" ]; then
  aws ec2 delete-key-pair --key-name "$key_pair_name"
fi

if [ -n "$security_group_id" ]; then
  aws ec2 delete-security-group --group-id "$security_group_id"
fi

if [ -n "$ssh_private_key_file" ]; then
  rm -f "$ssh_private_key_file"
fi
