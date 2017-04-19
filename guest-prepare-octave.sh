#!/bin/sh
#
# Fetch and prepare the Octave source for building in ~/octave-default

set -xe

basedir=$HOME

# 1. New Python and Mercurial required for reliable https

git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

export PYENV_VERSION=2.7.13
pyenv install 2.7.13
pip install mercurial

# 2. New GNU tar required for making a reproducible archive of the results

curl -SL https://ftp.gnu.org/gnu/tar/tar-latest.tar.xz \
  | tar -xJC $HOME
( cd $HOME/tar-* \
  && ./configure --disable-nls --prefix=$HOME \
  && make -j$(getconf _NPROCESSORS_ONLN) all \
  && make -j$(getconf _NPROCESSORS_ONLN) install )

# 3. Clone the official Octave repository

rm -rf $basedir/octave-default
hg clone https://hg.savannah.gnu.org/hgweb/octave/ $basedir/octave-default
