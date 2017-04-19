#!/bin/sh
#
# Bootstrap an Ubuntu guest to build Octave's default branch

set -xe

apt-get update
apt-get --yes upgrade

# 1. Install Octave build dependencies
apt-get --yes build-dep octave
apt-get --yes install \
  bison \
  git \
  icoutils \
  libqt5scintilla2-dev \
  librsvg2-bin \
  libsndfile1-dev \
  mercurial \
  portaudio19-dev \
  qtbase5-dev-tools \
  qttools5-dev \
  qttools5-dev-tools

# 2. Install Python build dependencies
apt-get --yes install \
  blt-dev \
  libbluetooth-dev \
  libbz2-dev \
  libdb-dev \
  libexpat1-dev \
  libffi-dev \
  libgdbm-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  tk-dev \
  zlib1g-dev

# 3. Install GNU tar build dependencies
apt-get --yes install \
  libacl1-dev \
  libattr1-dev \
  libselinux1-dev
