#!/bin/sh

set -e

echo "1. Provisioning virtual machine ..."
vagrant up --provision > guest-provision.log 2>&1

echo "2. Preparing user enviroment and pulling Octave source ..."
vagrant ssh -c "sh /vagrant/guest-prepare-octave.sh" > guest-prepare-octave.log 2>&1

echo "3. Building Octave ..."
vagrant ssh -c "sh /vagrant/guest-build-octave.sh" > guest-build-octave.log 2>&1

echo "4. Installing and compressing Octave binary image ..."
vagrant ssh -c "sh /vagrant/guest-bundle-octave.sh" > guest-bundle-octave.log 2>&1

echo "5. Publishing Octave binary image ..."
vagrant ssh -c "sh /vagrant/guest-publish-octave.sh s3://octave-snapshot/public/" > guest-publish-octave.log 2>&1

vagrant destroy -f > /dev/null 2>&1
