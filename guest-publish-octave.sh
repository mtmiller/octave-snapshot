#!/bin/sh
#
# Publish the compressed Octave image to a given destination

set -xe

init=/tmp/guest-initializations.sh
. "$init"

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

archives=$(awk '{print $2}' "$basedir/SHA256SUMS")
files="$archives SHA1SUMS SHA256SUMS"

if [ "$dest_file" ]; then
  for file in $files; do
    cp "$basedir/$file" "$dest_file"
  done
elif [ "$dest_s3_bucket" ]; then
  for file in $files; do
    s3cmd put "$basedir/$file" "$dest_s3_bucket"
  done
fi
