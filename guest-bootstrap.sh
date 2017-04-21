#!/bin/sh
#
# Bootstrap an Ubuntu guest to build Octave's default branch

set -xe

n=$(basename "$0")
t=$(getopt --name "$n" --options "" --longoptions "with-qt:" -- "$@")
eval set -- "$t"

with_qt=5

while :; do
  case "$1" in
    --with-qt)
      case "$2" in
        4|5)
          with_qt=$2
          ;;
        *)
          echo >&2 "$n: invalid option value for --with-qt: $2"
          exit 1
          ;;
      esac
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      echo >&2 "$n: error handling command line arguments: $1"
      exit 1
      ;;
  esac
done

apt-get update
apt-get --yes upgrade

case "$with_qt" in
  4)
    qt_packages="
  libqscintilla2-dev
  libqt4-dev
  libqt4-dev-bin
  libqt4-opengl-dev
  qt4-dev-tools
  qt4-linguist-tools
    "
    ;;
  5)
    qt_packages="
  libqt5scintilla2-dev
  qtbase5-dev-tools
  qttools5-dev
  qttools5-dev-tools
    "
    ;;
esac

# 1. Install Octave build dependencies
apt-get --yes build-dep octave
apt-get --yes install \
  bison \
  git \
  icoutils \
  librsvg2-bin \
  libsndfile1-dev \
  mercurial \
  portaudio19-dev \
  qtchooser \
  $qt_packages

# 2. Install Python build dependencies
apt-get --yes install \
  blt-dev \
  libbluetooth-dev \
  libbz2-dev \
  libdb-dev \
  libexpat1-dev \
  libffi-dev \
  libgdbm-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  tk-dev \
  zlib1g-dev

# 3. Install GNU tar build dependencies
apt-get --yes install \
  libacl1-dev \
  libattr1-dev \
  libselinux1-dev

# 4. Install GNU tar from latest upstream release
curl -SL https://ftp.gnu.org/gnu/tar/tar-latest.tar.xz \
  | tar -xJC /usr/src
( cd /usr/src/tar-* \
  && FORCE_UNSAFE_CONFIGURE=1 ./configure --disable-nls \
  && make -j$(getconf _NPROCESSORS_ONLN) all \
  && make -j$(getconf _NPROCESSORS_ONLN) install )
