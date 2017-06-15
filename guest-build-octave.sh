#!/bin/sh
#
# Build Octave from a source tree at ~/octave-default

set -xe

init=/tmp/guest-initializations.sh
. "$init"

timestamp=$(cat $basedir/octave-default/HG-TIMESTAMP)
export SOURCE_DATE_EPOCH=$timestamp
export TZ=UTC0

( cd $basedir/octave-default && sh bootstrap )

mkdir -p $basedir/octave-build
( cd $basedir/octave-build \
  && sh ../octave-default/configure --build=x86_64-linux \
                                    --with-blas \
                                    --without-osmesa \
                                    JAVA_HOME=/usr/lib/jvm/default-java )
make -C $basedir/octave-build -j$(getconf _NPROCESSORS_ONLN) all
diff $basedir/octave-default/HG-ID $basedir/octave-build/HG-ID
cp $basedir/octave-default/HG-TIMESTAMP $basedir/octave-build/HG-TIMESTAMP

perl $(dirname $0)/fix-jar-timestamps.pl \
     --timestamp=$timestamp \
     $basedir/octave-build/scripts/java/octave.jar
