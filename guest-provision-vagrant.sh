#!/bin/sh
#
# Provision a virtual machine using Vagrant

set -e

d=$( dirname $0 )
ssh_config_file="$d/.octave-snapshot-ssh-config"
state_file="$d/.octave-snapshot-guest-state"

rm -f "$ssh_config_file"
rm -f "$state_file"

vagrant_machine_name="default"

echo "guest_provision_type=vagrant" >> "$state_file"
echo "vagrant_machine_name=$vagrant_machine_name" >> "$state_file"

vagrant up --provision "$vagrant_machine_name"

vagrant ssh-config "$vagrant_machine_name" \
  | sed "s/^Host $vagrant_machine_name/Host guest/" \
  > "$ssh_config_file"
