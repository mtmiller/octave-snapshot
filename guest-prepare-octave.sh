#!/bin/sh
#
# Fetch and prepare the Octave source for building in ~/octave-default

set -xe

basedir=$HOME
hg_revision="@"
hg_url="https://hg.savannah.gnu.org/hgweb/octave/"

# 1. Create a file of constants and initializations for this build

init=/tmp/guest-initializations.sh
echo >  "$init" "# shell initializations for octave-snapshot"
echo >> "$init"
echo >> "$init" "basedir=$basedir"
. "$init"

# 2. New Python and Mercurial required for reliable https

git clone https://github.com/pyenv/pyenv.git $HOME/.pyenv
echo >> "$init" "export PYENV_ROOT=\$HOME/.pyenv"
echo >> "$init" "export PATH=\$PYENV_ROOT/bin:\$PATH"
echo >> "$init" "eval \"\$(pyenv init -)\""
. "$init"

python_version=2.7.13
pyenv install $python_version
pyenv global $python_version
pip install mercurial

# 3. Install S3cmd to enable pushing final results to S3

pip install s3cmd

# 4. Clone the official Octave repository

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
