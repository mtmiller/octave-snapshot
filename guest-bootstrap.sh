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

case "$with_qt" in
  4)
    qt_packages="
  libqscintilla2-dev
  libqt4-dev
  libqt4-dev-bin
  libqt4-opengl-dev
  qt4-default
  qt4-dev-tools
  qt4-linguist-tools
    "
    ;;
  5)
    qt_packages="
  libqt5opengl5-dev
  libqt5scintilla2-dev
  qt5-default
  qtbase5-dev
  qtbase5-dev-tools
  qttools5-dev
  qttools5-dev-tools
    "
    ;;
esac

mkdir -p /etc/apt/apt.conf.d
echo 'APT::Install-Recommends "false";'  > /etc/apt/apt.conf.d/99minimize
echo 'APT::Install-Suggests "false";'   >> /etc/apt/apt.conf.d/99minimize

apt-get update
apt-get --yes upgrade

# 1. Install Octave build dependencies
apt-get --yes install \
  autoconf \
  automake \
  bison \
  curl \
  default-jdk \
  desktop-file-utils \
  epstool \
  flex \
  g++ \
  gawk \
  gcc \
  gfortran \
  ghostscript \
  git \
  gnuplot-nox \
  gperf \
  icoutils \
  less \
  libarchive-zip-perl \
  libarpack2-dev \
  libblas-dev \
  libbz2-dev \
  libc6-dev \
  libcurl4-gnutls-dev \
  libfftw3-dev \
  libfltk1.3-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libgl1-mesa-dev \
  libgl2ps-dev \
  libglpk-dev \
  libglu1-mesa-dev \
  libgraphicsmagick++1-dev \
  libhdf5-dev \
  liblapack-dev \
  libncurses5-dev \
  libpcre3-dev \
  libqhull-dev \
  libqrupdate-dev \
  libreadline-dev \
  librsvg2-bin \
  libsndfile1-dev \
  libsuitesparse-dev \
  libsundials-serial-dev \
  libtool \
  lzip \
  make \
  perl \
  portaudio19-dev \
  pstoedit \
  $qt_packages \
  qtchooser \
  sqlite3 \
  texinfo \
  texlive-base \
  texlive-binaries \
  texlive-fonts-recommended \
  texlive-generic-recommended \
  texlive-latex-base \
  transfig \
  unzip \
  xz-utils \
  zip \
  zlib1g-dev

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

# 5. Install GNU Texinfo from newer upstream release
curl -SL https://ftp.gnu.org/gnu/texinfo/texinfo-6.5.tar.xz \
  | tar -xJC /usr/src
( cd /usr/src/texinfo-6.5 \
  && ./configure --disable-nls \
  && make -j$(getconf _NPROCESSORS_ONLN) all \
  && make -j$(getconf _NPROCESSORS_ONLN) install )
