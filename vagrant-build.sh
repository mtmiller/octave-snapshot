#!/bin/sh

set -e

apt-get update
apt-get upgrade -y
apt-get build-dep -y octave
apt-get install -y bison
apt-get install -y icoutils
apt-get install -y libqt5scintilla2-dev
apt-get install -y librsvg2-bin
apt-get install -y libsndfile1-dev
apt-get install -y mercurial
apt-get install -y portaudio19-dev
apt-get install -y qtbase5-dev-tools
apt-get install -y qttools5-dev
apt-get install -y qttools5-dev-tools

basedir=/vagrant

cd $basedir
rm -rf octave-default
hg clone http://hg.savannah.gnu.org/hgweb/octave/ octave-default
cd octave-default
./bootstrap

cd $basedir
mkdir -p octave-build
cd octave-build

../octave-default/configure --build=x86_64-linux \
                            --with-blas \
                            --without-osmesa \
                            JAVA_HOME=/usr/lib/jvm/default-java

make -j$(getconf _NPROCESSORS_ONLN) all
make -j$(getconf _NPROCESSORS_ONLN) install DESTDIR=$basedir/octave-dest

cd $basedir
mkdir -p octave
mv octave-dest/usr/local/* octave
