#!/bin/sh
#
# Copyright (C) 2018 Mike Miller
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Fix the timestamps of the metadata stored in one or more QCH files.

set -e

progname="fix-qch-timestamps.sh"

: ${SQLITE3=sqlite3}

if ! $SQLITE3 -version > /dev/null; then
  echo >&2 "$progname: $SQLITE3: command not found"
  exit 1
fi

timestamp=$(date +%s)

if [ -n "$SOURCE_DATE_EPOCH" ]; then
  timestamp=$SOURCE_DATE_EPOCH
fi

while [ -n "$1" ]; do
  case "$1" in
    --timestamp)
      shift
      timestamp=$1
      ;;
    --timestamp=*)
      timestamp=${1#--timestamp=}
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo >&2 "$progname: invalid option -- '$1'"
      exit 1
      ;;
    *)
      break
      ;;
  esac
  shift
done

if ! date -d "@$timestamp" > /dev/null; then
  echo >&2 "$progname: invalid timestamp: $timestamp"
  exit 1
fi

timestamp_string=$(TZ=UTC0 date -d "@$timestamp" "+%Y-%m-%dT%H:%M:%S")

perlprog="
if    (/'CreationDate'/)     { s|,'\\d+.*'\\)|,'$timestamp_string')|; }
elsif (/'CreationTime'/)     { s|,\\d+\\)|,$timestamp)|; }
elsif (/'LastRegisterTime'/) { s|,'\\d+.*'\\)|,'$timestamp_string')|; }
"

for file in "$@"; do
  tmp_db=$(mktemp ${TMPDIR-/tmp}/fix-qch.XXXXXX)
  tmp_dump=$(mktemp ${TMPDIR-/tmp}/fix-qch.XXXXXX)
  $SQLITE3 "$file" '.dump' > "$tmp_dump"
  perl -pi -e "$perlprog" "$tmp_dump"
  $SQLITE3 "$tmp_db" < "$tmp_dump"
  cp "$tmp_db" "$file"
  rm -f "$tmp_db" "$tmp_dump"
done
