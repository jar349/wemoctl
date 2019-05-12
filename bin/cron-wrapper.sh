#!/usr/bin/env bash

## Some assumptions
# I assume that docker is in /usr/bin but perhaps it isn't for you
DOCKER=/usr/bin/docker
DOCKER_SERVER=docker.pkg.github.com
WEMOCTL_REPO=jar349/wemoctl
WEMOCTL_VERSION="latest"
WEMOCTL_IMAGE="$DOCKER_SERVER/$WEMOCTL_REPO/wemoctl:$WEMOCTL_VERSION"

## arguments to this script
DEVICE="$1"
STATE="$2"

if [[ -z "$DEVICE" ]]; then
  echo "A device must be specified"
  exit 1
fi

if [[ -z "$STATE" ]]; then
  echo "A state must be specified"
else
  if [[ "on" != "$STATE" ]] && [[ "off" != "$STATE" ]]; then
    echo "The specified state must be either on or off"
    exit 1
  fi
fi

# ensure that we have the version of the docker image we want
$DOCKER pull $WEMOCTL_IMAGE 2>&1 > /dev/null

OUTPUT=$($DOCKER run --rm --network host $WEMOCTL_IMAGE pipenv run wemoctl power --device "$DEVICE" $STATE 2>&1) && rc=$? || rc=$?

if [[ $rc != 0 ]]; then
  echo "Exit Code: $rc"
  echo "$OUTPUT"
fi

exit $rc

