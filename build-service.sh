#!/bin/sh
#
# Perform the build procedure in a non-interactive setting

set -e

d=$( cd $( dirname $0 ) && pwd )

workdir=$( mktemp -d "${TMPDIR-/tmp}/octave-snapshot.XXXXXX" )

cd "$workdir"

if ! sh $d/build.sh; then
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

cd /
rm -rf "$workdir"
