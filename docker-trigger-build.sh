#!/bin/sh
#
# Trigger a build of the Docker image on Docker Hub

set -e

d=$( cd $( dirname $0 ) && pwd )
n=$( basename $0 )

docker_repository="mtmiller/octave-snapshot"
docker_repository_url="https://registry.hub.docker.com/u/${docker_repository}"

tokenfile="$d/docker_trigger_token.txt"
if [ -e "$tokenfile" ]; then
  . "$tokenfile"
fi

if [ x"$docker_trigger_token" = x ]; then
  echo >&2 "$n: trigger token not defined, missing docker_trigger_token.txt?"
fi

trigger_url="${docker_repository_url}/trigger/${docker_trigger_token}/"

out=$( curl -s -X POST \
            -H 'Content-Type: application/json' \
            -d '{"build": true}' "$trigger_url" )

[ $? -eq 0 ] && [ "$out" = OK ]
