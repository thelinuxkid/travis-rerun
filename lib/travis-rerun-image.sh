# DO NOT CALL THIS DIRECTLY. USE travis-rerun INSTEAD.

set -e

TRAVIS_COOKBOOK=${TRAVIS_COOKBOOK:=travis_ci_mega}

echo "setting up cookbooks..."
cd $SRC_PATH
# TODO thelinuxkid/travis-cookbooks PR pending
safe_clone https://github.com/thelinuxkid/travis-cookbooks cookbooks
cd $SRC_PATH/cookbooks/cookbooks

cd $SRC_PATH
# TODO thelinuxkid/packer-templates' HEAD is at the last working version
safe_clone https://github.com/thelinuxkid/packer-templates templates
cd $SRC_PATH/templates

cp -au $SRC_PATH/cookbooks/cookbooks/* $SRC_PATH/templates/cookbooks > /dev/null
cp -au $SRC_PATH/cookbooks/community-cookbooks/* $SRC_PATH/templates/cookbooks > /dev/null

echo "running $TRAVIS_COOKBOOK..."
# sudo rm -rf ~travis/perl5/perlbrew/perls/5.2{0,2}-shrplib
sudo -E chef-client -z -o $TRAVIS_COOKBOOK
