#!/bin/sh
#
# Destroy created Ubuntu build system

set -e

vagrant destroy -f > /dev/null 2>&1
