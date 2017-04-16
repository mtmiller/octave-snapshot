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
