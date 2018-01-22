#!/bin/sh
#
# Provision an Ubuntu build system

set -e

d=$( dirname $0 )
ssh_config_file="$d/.octave-snapshot-ssh-config"

type=unspecified

while [ -n "$1" ]; do
  case "$1" in
    --vagrant) type=vagrant ;;
    *) ;;
  esac
  shift
done

case "$type" in
  vagrant)
    $d/guest-provision-vagrant.sh
    ;;
  *)
    echo >&2 "$0: missing build system provisioning scheme"
    exit 1
    ;;
esac

scp -F "$ssh_config_file" $d/guest-*.sh guest:
scp -F "$ssh_config_file" $d/fix-jar-timestamps.pl guest:
if [ -e "$d/aws_credential_file.txt" ]; then
  scp -F "$ssh_config_file" "$d/aws_credential_file.txt" guest:
fi
