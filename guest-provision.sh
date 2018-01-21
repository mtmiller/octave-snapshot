#!/bin/sh
#
# Provision an Ubuntu build system

set -e

type=unspecified

while [ -n "$1" ]; do
  case "$1" in
    --vagrant) type=vagrant ;;
    *) ;;
  esac
  shift
done

case "$type" in
  vagrant)
    vagrant up --provision
    ;;
  *)
    echo >&2 "$0: missing build system provisioning scheme"
    exit 1
    ;;
esac
