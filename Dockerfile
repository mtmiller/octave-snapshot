FROM ubuntu:trusty
MAINTAINER Mike Miller <mtmiller@octave.org>

RUN apt-get update && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    default-jre-headless \
    epstool \
    g++ \
    gcc \
    gdb \
    gfortran \
    ghostscript \
    gnuplot-qt \
    less \
    libarpack2-dev \
    libcurl4-gnutls-dev \
    libfftw3-dev \
    libfltk-gl1.3 \
    libfontconfig-dev \
    libfreetype6-dev \
    libgl1-mesa-dev \
    libgl2ps-dev \
    libglpk36 \
    libglu1-mesa-dev \
    libgraphicsmagick++-dev \
    libhdf5-dev \
    libncurses-dev \
    libopenblas-base \
    libpcre3-dev \
    libportaudio2 \
    libqhull6 \
    libqrupdate-dev \
    libqt5network5 \
    libqt5opengl5 \
    libqt5scintilla2-11 \
    libreadline-dev \
    libsndfile1 \
    libsuitesparse-dev \
    libtool \
    make \
    pstoedit \
    texinfo \
    transfig \
    unzip \
    zip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/*/apt/*/partial

# Fetch and unpack Octave snapshot built elsewhere into /usr/local
ADD https://s3.amazonaws.com/octave-snapshot/public/octave-ubuntu-trusty-snapshot.tar.xz /octave.tar.xz
RUN tar --directory=/usr/local --extract --file=/octave.tar.xz --strip-components=1 && rm -f /octave.tar.xz
RUN ldconfig
