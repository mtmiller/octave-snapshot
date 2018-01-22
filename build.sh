#!/bin/sh

set -e

d=$( cd $( dirname $0 ) && pwd )

trap "sh $d/guest-destroy.sh" EXIT

echo "1. Provisioning virtual machine ..."
sh $d/guest-provision.sh --vagrant > guest-provision.log 2>&1

ssh_config_file="$d/.octave-snapshot-ssh-config"

echo "2. Preparing user enviroment and pulling Octave source ..."
ssh -F "$ssh_config_file" guest sh -x guest-prepare-octave.sh > guest-prepare-octave.log 2>&1

echo "3. Building Octave ..."
ssh -F "$ssh_config_file" guest sh -x guest-build-octave.sh > guest-build-octave.log 2>&1

echo "4. Installing and compressing Octave binary image ..."
ssh -F "$ssh_config_file" guest sh -x guest-bundle-octave.sh > guest-bundle-octave.log 2>&1

echo "5. Publishing Octave binary image ..."
ssh -F "$ssh_config_file" guest sh -x guest-publish-octave.sh s3://octave-snapshot/public/ > guest-publish-octave.log 2>&1
