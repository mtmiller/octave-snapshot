#!/bin/sh

set -e

# 1. Build Octave in a virtual machine using Vagrant

echo "Starting Vagrant and building Octave (may take about 1 hour)..."
vagrant up --provision > vagrant-build.log 2>&1

# 2. Clean up and archive the built Octave payload

rm -f octave/lib/octave/*/lib*.la

HG_ID=$(cat octave-build/HG-ID)
VERSION=$(sed -n 's/^VERSION = \(.*\)/\1/p' octave-build/Makefile)

case "$VERSION" in
  *+) suffix="$VERSION$HG_ID" ;;
  *)  suffix="$VERSION+$HG_ID" ;;
esac
dir=octave-ubuntu-trusty-$suffix

mv octave $dir
tar --posix --owner=root:0 --group=root:0 --file=- --create $dir | xz > $dir.tar.xz

# 3. Delete intermediate files and Vagrant virtual machine

rm -rf octave
rm -rf octave-build
rm -rf octave-default
rm -rf octave-dest
rm -rf $dir
vagrant destroy -f > /dev/null 2>&1

echo
echo "Now upload the file $dir.tar.xz to a public URL"
echo
