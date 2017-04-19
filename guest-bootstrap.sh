#!/bin/sh
#
# Bootstrap an Ubuntu guest to build Octave's default branch

set -xe

apt-get update
apt-get upgrade -y
apt-get build-dep -y octave
apt-get install -y bison
apt-get install -y git
apt-get install -y icoutils
apt-get install -y libqt5scintilla2-dev
apt-get install -y librsvg2-bin
apt-get install -y libsndfile1-dev
apt-get install -y mercurial
apt-get install -y portaudio19-dev
apt-get install -y qtbase5-dev-tools
apt-get install -y qttools5-dev
apt-get install -y qttools5-dev-tools

# 2. Install Python build dependencies
apt-get install -y blt-dev libbluetooth-dev libbz2-dev libdb-dev libexpat1-dev \
                   libffi-dev libgdbm-dev libreadline-dev libsqlite3-dev \
                   libssl-dev tk-dev zlib1g-dev

# 3. Install GNU tar build dependencies
apt-get install -y libacl1-dev libattr1-dev libselinux1-dev
