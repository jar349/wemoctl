#! /usr/bin/env bash
set -e

# inspired by the beautiful script I found here:
# https://github.com/fsaintjacques/semver-tool/blob/master/src/semver

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

PROG=release
USAGE="\
  Usage:
    $PROG version <version>
    $PROG current

    Arguments:
      <version>  This should follow semver format: n.n.n  But beware that 
                 this script does not validate the input.

    Commands:
      version    Prepares a release for the specified <version>

      current    Returns the last released version"

function error {
  echo -e "$1" >&2
  exit 1
}

function usage-help {
  error "$USAGE"
}

function command-current {
  # big assumption here about the location of this script
  cat $BASE_DIR/.version
}

function command-version {
  if [ -z "$1" ]; then
    echo "A <version> argument must be provided to the version command"
    usage-help
  fi

  local newver=$1
  echo $newver > $BASE_DIR/.version
  git add $BASE_DIR/.version
  git commit -m "releasing version $newver"
  git tag "$newver"
  git push origin --tags
  docker build -t jar349/wemoctl:$newver $BASE_DIR
  docker tag jar349/wemoctl:$newver docker.pkg.github.com/jar349/wemoctl/wemoctl:latest
  docker tag jar349/wemoctl:$newver docker.pkg.github.com/jar349/wemoctl/wemoctl:$newver
  docker push docker.pkg.github.com/jar349/wemoctl/wemoctl:$newver
  docker push docker.pkg.github.com/jar349/wemoctl/wemoctl:latest
  echo "Version $newver has been released!" 
}

case $# in
  0) echo "Unknown command: $*"; usage-help;;
esac

case $1 in
  current) command-current;;
  version) shift; command-version "$@";;
  *) echo "Unknown arguments: $*"; usage-help;;
esac

