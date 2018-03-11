#!/bin/sh
#
# Perform the build procedure in a non-interactive setting

set -e

d=$( cd $( dirname $0 ) && pwd )

workdir=$( mktemp -d "${TMPDIR-/tmp}/octave-snapshot.XXXXXX" )

sha256sums_url="https://s3.amazonaws.com/octave-snapshot/public/SHA256SUMS"

success=yes

cd "$workdir"

curl -s "$sha256sums_url" | grep "snapshot.tar" > sha256sums-before

if ! sh $d/build.sh; then
  success=no
  last_log_file=$( ls -t guest*.log | head -n1 )
  if [ -e "$last_log_file" ]; then
    tail=$( tail -n10 "$last_log_file" )
  fi

  : ${HOSTNAME=$( cat /etc/mailname )}
  : ${LOGNAME=$( id -un )}
  date=$( date -R )
  to="${LOGNAME}@${HOSTNAME}"
  /usr/sbin/sendmail -t <<EOF
To: $to
Date: $date
Subject: [octave-snapshot] Failed

The latest build of octave-snapshot has failed.

The last lines of ${last_log_file} were:

${tail}

Sincerely,

octave-snapshot
EOF
fi

if [ x"$success" = xyes ]; then
  curl -s "$sha256sums_url" | grep "snapshot.tar" > sha256sums-after
  if ! cmp -s sha256sums-before sha256sums-after; then
    $d/docker-trigger-build.sh
  fi
fi

cd /
rm -rf "$workdir"
