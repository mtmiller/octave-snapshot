#!/bin/sh

set -e

# 1. Build Octave in a virtual machine using Vagrant

echo "Starting Vagrant and building Octave (may take about 1 hour)..."
vagrant box update
vagrant up --provision
vagrant ssh -c "sh /vagrant/guest-prepare-octave.sh" > vagrant-build.log 2>&1
vagrant ssh -c "sh /vagrant/guest-build-octave.sh"  >> vagrant-build.log 2>&1
vagrant ssh -c "sh /vagrant/guest-bundle-octave.sh" >> vagrant-build.log 2>&1
vagrant ssh -c "mv octave-ubuntu-trusty-snapshot.tar.xz /vagrant" >> vagrant-build.log 2>&1

vagrant destroy -f > /dev/null 2>&1

echo
echo "Now upload the file octave-ubuntu-trusty-snapshot.tar.xz to a public URL"
echo
