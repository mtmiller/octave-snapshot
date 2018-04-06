#!/bin/sh
#
# Provision an Ubuntu build system

set -e

d=$( cd $( dirname $0 ) && pwd )
n=$( basename $0 )

ssh_config_file="$PWD/.octave-snapshot-ssh-config"

type=unspecified

while [ -n "$1" ]; do
  case "$1" in
    --ec2)     type=ec2 ;;
    --vagrant) type=vagrant ;;
    *)         ;;
  esac
  shift
done

case "$type" in
  ec2)
    sh -x $d/guest-provision-ec2.sh
    ;;
  vagrant)
    sh -x $d/guest-provision-vagrant.sh
    ;;
  *)
    echo >&2 "$n: missing build system provisioning scheme"
    exit 1
    ;;
esac

scp -F "$ssh_config_file" $d/guest-*.sh guest:
scp -F "$ssh_config_file" $d/fix-jar-timestamps.pl guest:
scp -F "$ssh_config_file" $d/fix-qhc-timestamps.sh guest:
if [ -e "$d/aws_credential_file.txt" ]; then
  scp -F "$ssh_config_file" "$d/aws_credential_file.txt" guest:
fi
