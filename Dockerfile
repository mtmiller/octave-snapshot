FROM ubuntu:trusty
MAINTAINER Mike Miller <mtmiller@octave.org>
RUN apt-get update
RUN apt-get upgrade -y

# Install basic development environment
RUN apt-get install -y autoconf
RUN apt-get install -y automake
RUN apt-get install -y build-essential
RUN apt-get install -y g++
RUN apt-get install -y gcc
RUN apt-get install -y gdb
RUN apt-get install -y gfortran
RUN apt-get install -y gperf
RUN apt-get install -y libtool
RUN apt-get install -y make

# Install shared libraries needed by Octave
RUN apt-get install -y libarpack2-dev
RUN apt-get install -y libcurl4-gnutls-dev
RUN apt-get install -y libfftw3-dev
RUN apt-get install -y libfltk-gl1.3
RUN apt-get install -y libfontconfig-dev
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libgl1-mesa-dev
RUN apt-get install -y libgl2ps-dev
RUN apt-get install -y libglpk36
RUN apt-get install -y libglu1-mesa-dev
RUN apt-get install -y libgraphicsmagick++-dev
RUN apt-get install -y libhdf5-dev
RUN apt-get install -y libncurses-dev
RUN apt-get install -y libopenblas-base
RUN apt-get install -y libpcre3-dev
RUN apt-get install -y libportaudio2
RUN apt-get install -y libqhull6
RUN apt-get install -y libqrupdate-dev
RUN apt-get install -y libqt5network5
RUN apt-get install -y libqt5opengl5
RUN apt-get install -y libqt5scintilla2-11
RUN apt-get install -y libreadline-dev
RUN apt-get install -y libsndfile1
RUN apt-get install -y libsuitesparse-dev

# Install programs and utilities used by some Octave functions
RUN apt-get install -y default-jre-headless
RUN apt-get install -y epstool
RUN apt-get install -y ghostscript
RUN apt-get install -y gnuplot-qt
RUN apt-get install -y less
RUN apt-get install -y pstoedit
RUN apt-get install -y texinfo
RUN apt-get install -y transfig
RUN apt-get install -y unzip
RUN apt-get install -y zip

# Fetch and unpack Octave snapshot built elsewhere into /usr/local
ADD https://s3.amazonaws.com/octave-snapshot/public/octave-ubuntu-trusty-snapshot.tar.xz /octave.tar.xz
RUN tar --directory=/usr/local --extract --file=/octave.tar.xz --strip-components=1 && rm -f /octave.tar.xz
RUN ldconfig
