#!/bin/bash
set -o pipefail

USAGE="$0 [-v]"

COMMON_URL=https://raw.githubusercontent.com/thelinuxkid/travis-rerun/master/lib/travis-rerun-common.sh
source <(curl -s $COMMON_URL)

usage() {
  echo "$USAGE"
  echo "installs travis-rerun at $TRAVIS_RERUN_PATH"
  exit 0
}

if [ -z $1 ]; then
  usage
fi

# get user options
while [ $# -gt 0 ]; do
  # get options
  arg="$1"
  shift

  case "$arg" in
  -h|--help) usage ;;
  -v|--verbose) verbose="-v" ;;
  --*)
    die "unrecognised option: '$arg'\n$USAGE" ;;
  *)
    die "too many arguments\n$USAGE"
    ;;
  esac
done

setup() {
  set -e
  if [ -z $(which git) ]; then
    log "installing git..."
    sudo apt-get -q update > /dev/null
    sudo apt-get -qy install git > /dev/null
  fi
  make_path $TRAVIS_RERUN_PATH $SRC_PATH && cd $SRC_PATH
  safe_clone https://github.com/thelinuxkid/travis-rerun && cd travis-rerun
  set +e
}

setup
./bin/travis-rerun $verbose install
