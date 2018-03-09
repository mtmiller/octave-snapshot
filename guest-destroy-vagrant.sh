#!/bin/sh
#
# Destroy a virtual machine using Vagrant

set -e

d=$( cd $( dirname $0 ) && pwd )

state_file="$PWD/.octave-snapshot-guest-state"
if [ -e "$state_file" ]; then
  . "$state_file"
fi

if [ -n "$vagrant_machine_name" ]; then
  exec vagrant destroy --force "$vagrant_machine_name" > /dev/null 2>&1
fi
