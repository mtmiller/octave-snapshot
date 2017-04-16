#!/bin/sh
#
# Fetch and prepare the Octave source for building in ~/octave-default

set -e

basedir=$HOME

rm -rf $basedir/octave-default

## FIXME: why does https fail on Ubuntu 14.04?
hg clone http://hg.savannah.gnu.org/hgweb/octave/ $basedir/octave-default
