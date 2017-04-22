#!/bin/sh
#
# Fetch and prepare the Octave source for building in ~/octave-default

set -xe

basedir=$HOME
hg_revision="@"
hg_url="https://hg.savannah.gnu.org/hgweb/octave/"

# 1. New Python and Mercurial required for reliable https

git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

export PYENV_VERSION=2.7.13
pyenv install 2.7.13
pip install mercurial

# 2. Clone the official Octave repository

rm -rf $basedir/octave-default
hg clone "$hg_url" $basedir/octave-default
hg --repository "$basedir/octave-default" update --clean --rev "$hg_revision"
hg --repository "$basedir/octave-default" identify --id --rev "$hg_revision" \
  > "$basedir/octave-default/HG-ID"
hg --repository "$basedir/octave-default" log --rev "$hg_revision" \
                                              --template "{date|hgdate}" \
  | sed -n 's/^\([0-9]\+\) .*/\1/p' \
  > "$basedir/octave-default/HG-TIMESTAMP"
rm -rf "$basedir"/octave-default/.hg*
rm -rf "$basedir"/octave-default/gnulib/.hg*
