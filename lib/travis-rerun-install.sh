# DO NOT CALL THIS DIRECTLY. USE travis-rerun INSTEAD.

set -e

UBUNTU_VER=14.04
RUBY_VER=2.1

CHEF_DEB="chefdk_0.10.0-1_amd64.deb"
CHEF_URL="https://opscode-omnibus-packages.s3.amazonaws.com/ubuntu/12.04/x86_64/$CHEF_DEB"

install_ruby() {
  sudo apt-add-repository -y ppa:brightbox/ruby-ng &> /dev/null
  sudo apt-get -q update > /dev/null
  sudo apt-get -qy install ruby$RUBY_VER ruby$RUBY_VER-dev > /dev/null
}

ubuntu_version() {
  set +e
  which lsb_release > /dev/null
  test $? -eq 0 || die "requires ubuntu $UBUNTU_VER"
  test $(lsb_release -rs) == $UBUNTU_VER || die "requires ubuntu $UBUNTU_VER"
  set -e
}

install_packages() {
  sudo apt-get -q update > /dev/null
  sudo apt-get -qy install \
      git \
      python-software-properties gnupg2 \
      build-essential > /dev/null
  webget $CHEF_DEB $CHEF_URL 2>&1 >/dev/null || die "failed to download $URL"
  sudo dpkg -iG $CHEF_DEB > /dev/null
}

ruby_version() {
  set +e
  which ruby > /dev/null
  test $? -eq 0 || install_ruby
  version=$(ruby -v | cut -c6-8)
  test $version \> $RUBY_VER || test $version == $RUBY_VER || install_ruby
  set -e
  echo 'gem: --no-rdoc --no-ri' > $HOME/.gemrc
  gem install --quiet bundler > /dev/null
}

clone_repos() {
  cd $SRC_PATH
  # TODO thelinuxkid/travis-builder' HEAD is at the last working version
  safe_clone https://github.com/thelinuxkid/travis-build builder
  safe_clone https://github.com/travis-ci/travis.rb cli
}

install_travis() {
  cd $SRC_PATH/cli
  gem build --quiet travis.gemspec > /dev/null
  # TODO lock down version
  gem install --quiet travis-*.gem > /dev/null
  bundle install --quiet > /dev/null
  cd $SRC_PATH/builder
  gem build --quiet travis-build.gemspec > /dev/null
  # TODO lock down version
  gem install --quiet travis-build-*.gem > /dev/null
  bundle install --quiet > /dev/null
  mkdir -p $HOME/.travis
  ln -sf $SRC_PATH/builder $HOME/.travis/travis-build
}

log "installing travis-rerun to $TRAVIS_RERUN_PATH..."
make_path $TRAVIS_RERUN_PATH $SRC_PATH

log "checking operating system requirements..."
ubuntu_version

log "installing required packages..."
install_packages
ruby_version

log "installing travis..."
clone_repos
install_travis
