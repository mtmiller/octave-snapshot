#!/bin/sh
#
# Publish the compressed Octave image to a given destination

set -xe

init=/tmp/guest-initializations.sh
. "$init"

filename=octave-ubuntu-trusty-snapshot.tar.xz

arg="$1"

if [ x"$arg" = x ]; then
  echo >&2 "$0: missing required destination URI"
  exit 1
fi

dest_file=
dest_s3_bucket=

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
  s3://*/)
    dest_s3_bucket=$arg
    ;;
  *)
    echo >&2 "$0: unrecognized destination URI scheme: $arg"
    exit 1
    ;;
esac

if [ "$dest_file" ]; then
  cp "$basedir/$filename" "$dest_file"
elif [ "$dest_s3_bucket" ]; then
  s3cmd put "$basedir/$filename" "$dest_s3_bucket"
fi
