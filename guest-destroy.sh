#!/bin/sh
#
# Destroy created Ubuntu build system

set -e

d=$( cd $( dirname $0 ) && pwd )

ssh_config_file="$PWD/.octave-snapshot-ssh-config"
state_file="$PWD/.octave-snapshot-guest-state"
if [ -e "$state_file" ]; then
  . "$state_file"
fi

case "$guest_provision_type" in
  ec2)
    $d/guest-destroy-ec2.sh
    ;;
  vagrant)
    $d/guest-destroy-vagrant.sh
    ;;
  *)
    ;;
esac

rm -f "$ssh_config_file"
rm -f "$state_file"
