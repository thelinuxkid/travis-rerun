TRAVIS_RERUN_PATH=${TRAVIS_RERUN_PATH:=/opt/travis-rerun}
SRC_PATH=$TRAVIS_RERUN_PATH/src

export GEM_HOME=${GEM_HOME:=$TRAVIS_RERUN_PATH/gems}
export PATH=$PATH:$GEM_HOME/bin

die() {
  echo -e >&2 "error: $@"
  exit 1
}

log() {
  if [ $verbose ]; then
    echo >&2 "$@"
  fi
}

assert_has() {
  if [ -z $(which "$1") ]; then
     die "please install $1"
  fi
}

indent() {
  count="$2"
  if [ -z "$count" ]; then
      count=1
  fi
  printf "%${count}s" | tr ' ' '\t' | expand -t 4 && echo -e "$1"
}

webget() {
  if type wget >/dev/null;
  then
    # -nc + -O return 1 if file already exists
    wget -nc -q -O "$1" "$2" || test -f "$1"
    return
  fi

  if type curl >/dev/null;
  then
    curl -s -o "$1" "$2"
    return
  fi

  die "please install wget or curl"
}

make_path() {
  for path in "$@"; do
    sudo mkdir -p $path
    sudo chown -R $USER:$USER $path
  done
}

safe_clone() {
  dstdir=$2
  if [ -z "$dstdir" ]; then
    dstdir=$(echo $1 |  awk -F\/ '{print $NF}')
  fi
  # remove trialing .git
  dstdir="${dstdir%.*}"
  if [ ! -e "$dstdir" ]; then
    git clone -q "$@"
  fi
}
