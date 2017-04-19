#!/bin/sh
#
# Publish the compressed Octave image to a given destination

set -xe

basedir=$HOME
filename=octave-ubuntu-trusty-snapshot.tar.xz

arg="$1"

if [ x"$arg" = x ]; then
  echo >&2 "$0: missing required destination URI"
  exit 1
fi

dest_file=

case "$arg" in
  file:///*)
    dest_file="/${arg#file:///}"
    ;;
  file://localhost/*)
    dest_file="/${arg#file://localhost/}"
    ;;
  file://*)
    echo >&2 "$0: unrecognized or malformed file URI: $arg"
    exit 1
    ;;
  *)
    echo >&2 "$0: unrecognized destination URI scheme: $arg"
    exit 1
    ;;
esac

if [ "$dest_file" ]; then
  cp "$basedir/$filename" "$dest_file"
fi
