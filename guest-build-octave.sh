#!/bin/sh
#
# Build Octave from a source tree at ~/octave-default

set -e

basedir=$HOME

cd $basedir/octave-default
sh bootstrap

mkdir -p $basedir/octave-build
cd $basedir/octave-build
sh ../octave-default/configure --build=x86_64-linux \
                               --with-blas \
                               --without-osmesa \
                               JAVA_HOME=/usr/lib/jvm/default-java
make -j$(getconf _NPROCESSORS_ONLN) all
rm -rf $basedir/octave-dest
mkdir -p $basedir/octave-dest
make -j$(getconf _NPROCESSORS_ONLN) install DESTDIR=$basedir/octave-dest
