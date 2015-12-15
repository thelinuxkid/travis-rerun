# travis-rerun - re-run Travis CI jobs offline

Sometimes errors show up in continuous integration that don't appear
elsewhere. With travis-rerun you can mirror Travis CI to facilitate
debugging. You can build the image your job ran on and create a script to
run it.

It is **strongly** suggested that you use travis-rerun on a VM/container
as [building](#build) the disk [image](#images) will make permanent changes
to your system.

## Images

Currently, travis-rerun only builds the [mega image](https://docs.travis-ci.com/user/trusty-ci-environment#Environment-common-to-all-VM-images)
which is based on Ubuntu 14.04.3. Following the Travis CI documentation,
travis-rerun should be [installed](#install) either on the
[2015-09-08 revision of 14.04.3](https://cloud-images.ubuntu.com/releases/14.04.3/release-20150908/)
or on a Google Compute Engine instance using the
ubuntu-1404-trusty-v20150909a image (now in the deprecated images list).
Neither choice is without caveats and these are not the only choices.
See the [build](#build) section for more details before starting. The
`Worker Information` section of the job log can help you figure out which
image you need.

## Install

In an instance of the appropriate [image](#images)
```sh
wget -q https://raw.githubusercontent.com/thelinuxkid/travis-rerun/master/install-travis-rerun.sh
chmod +x install-travis-rerun.sh
./install-travis-rerun.sh -v

TRAVIS_RERUN_PATH=${TRAVIS_RERUN_PATH:=/opt/travis-rerun}
export GEM_HOME=${GEM_HOME:=$TRAVIS_RERUN_PATH/gems}
export PATH=$PATH:$TRAVIS_RERUN_PATH/src/travis-rerun/bin:$GEM_HOME/bin
```
This will install this tool and most of its depencies to `$TRAVIS_RERUN_PATH`
which defaults to `/opt/travis-rerun`.

## Build

Once built, the [mega image](#images) is about 16GB. If you decide to use a
Google Compute Engine instance for the build make sure you have
a storage strategy in place. /usr will be ~6GB, /home ~7GB and TRAVIS_RERUN_PATH
~3GB.

In an instance of the appropriate [image](#images)
```
travis-rerun -v image
```

## Script + run

In an instance of the appropriate [image](#images) with the Travis CI repo
as the first argument and the complete job number as the second.
```
travis-rerun thelinuxkid/travis-rerun 1.1 > debug.sh
chmod +x debug.sh
./debug.sh
```
