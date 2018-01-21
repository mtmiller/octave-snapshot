#!/bin/sh

set -e

d=$( dirname $0 )

trap $d/guest-destroy.sh EXIT

echo "1. Provisioning virtual machine ..."
$d/guest-provision.sh --vagrant > guest-provision.log 2>&1

echo "2. Preparing user enviroment and pulling Octave source ..."
vagrant ssh -c "sh /vagrant/guest-prepare-octave.sh" > guest-prepare-octave.log 2>&1

echo "3. Building Octave ..."
vagrant ssh -c "sh /vagrant/guest-build-octave.sh" > guest-build-octave.log 2>&1

echo "4. Installing and compressing Octave binary image ..."
vagrant ssh -c "sh /vagrant/guest-bundle-octave.sh" > guest-bundle-octave.log 2>&1

echo "5. Publishing Octave binary image ..."
vagrant ssh -c "sh /vagrant/guest-publish-octave.sh s3://octave-snapshot/public/" > guest-publish-octave.log 2>&1
