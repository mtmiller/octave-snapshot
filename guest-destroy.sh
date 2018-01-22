#!/bin/sh
#
# Destroy created Ubuntu build system

set -e

d=$( cd $( dirname $0 ) && pwd )

ssh_config_file="$d/.octave-snapshot-ssh-config"
state_file="$d/.octave-snapshot-guest-state"
if [ -e "$state_file" ]; then
  . "$state_file"
fi

case "$guest_provision_type" in
  vagrant)
    vagrant destroy --force "$vagrant_machine_name" > /dev/null 2>&1
    ;;
  *)
    ;;
esac

rm -f "$ssh_config_file"
rm -f "$state_file"
