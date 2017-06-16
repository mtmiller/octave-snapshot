FROM ubuntu:trusty
MAINTAINER Mike Miller <mtmiller@octave.org>

RUN apt-get update && apt-get --no-install-recommends --yes install \
    autoconf \
    automake \
    build-essential \
    curl \
    default-jre-headless \
    epstool \
    g++ \
    gcc \
    gdb \
    gfortran \
    ghostscript \
    gnuplot-qt \
    info \
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
    libqt4-network \
    libqt4-opengl \
    libqscintilla2-11 \
    libreadline-dev \
    libsndfile1 \
    libsuitesparse-dev \
    libtool \
    make \
    pstoedit \
    texinfo \
    transfig \
    unzip \
    xz-utils \
    zip \
  && apt-get clean \
  && rm -rf \
    /tmp/hsperfdata* \
    /var/*/apt/*/partial \
    /var/lib/apt/lists/* \
    /var/log/apt/term*

ADD https://s3.amazonaws.com/octave-snapshot/public/SHA256SUMS /
RUN curl -SL https://s3.amazonaws.com/octave-snapshot/public/octave-ubuntu-trusty-snapshot.tar.xz \
  | tar -xJC /usr/local --strip-components=1
