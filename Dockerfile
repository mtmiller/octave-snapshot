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
RUN apt-get install -y libamd2.3.1
RUN apt-get install -y libarpack2
RUN apt-get install -y libcamd2.3.1
RUN apt-get install -y libccolamd2.8.0
RUN apt-get install -y libcholmod2.1.2
RUN apt-get install -y libcolamd2.8.0
RUN apt-get install -y libcurl3-gnutls
RUN apt-get install -y libcxsparse3.1.2
RUN apt-get install -y libfftw3-double3
RUN apt-get install -y libfftw3-single3
RUN apt-get install -y libfltk-gl1.3
RUN apt-get install -y libfontconfig1
RUN apt-get install -y libfreetype6
RUN apt-get install -y libgl1-mesa-glx
RUN apt-get install -y libgl2ps0
RUN apt-get install -y libglpk36
RUN apt-get install -y libglu1-mesa
RUN apt-get install -y libgraphicsmagick++3
RUN apt-get install -y libhdf5-7
RUN apt-get install -y libncurses5
RUN apt-get install -y libopenblas-base
RUN apt-get install -y libpcre3
RUN apt-get install -y libportaudio2
RUN apt-get install -y libqhull6
RUN apt-get install -y libqrupdate1
RUN apt-get install -y libqt5network5
RUN apt-get install -y libqt5opengl5
RUN apt-get install -y libqt5scintilla2-11
RUN apt-get install -y libreadline6
RUN apt-get install -y libsndfile1
RUN apt-get install -y libumfpack5.6.2

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
ADD https://mtmxr.com/octave-ubuntu-trusty-snapshot.tar.xz /octave.tar.xz
RUN tar --directory=/usr/local --extract --file=/octave.tar.xz --strip-components=1
RUN rm -f /octave.tar.xz
