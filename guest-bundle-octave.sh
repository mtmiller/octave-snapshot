#!/bin/sh
#
# Pack an installed Octave chroot into a compressed binary archive

set -xe

basedir=$HOME

hg_id=$(cat $basedir/octave-build/HG-ID 2> /dev/null | sed 's/[[:space:]]*//g')
version=$(sed -n 's/^VERSION = \(.*\)/\1/p' $basedir/octave-build/Makefile 2> /dev/null | sed 's/[[:space:]]*//g')
timestamp=$(cd $basedir/octave-default && hg log --rev "$hg_id" --template "{date}")
case "$version" in
  *+) suffix="$version$hg_id" ;;
  *)  suffix="$version+$hg_id" ;;
esac

filename=octave-ubuntu-trusty-snapshot.tar.xz
packname=octave-ubuntu-trusty-$suffix
chrootdir=$basedir/$packname

rm -rf $chrootdir
mkdir -p $chrootdir
mv $basedir/octave-dest/usr/local/* $chrootdir

rm -f $chrootdir/lib/octave/*/lib*.la
chmod -R a+rX,u+w,go-w $chrootdir
( cd $basedir \
  && tar -c \
         --group=root:0 \
         --mtime="@$timestamp" \
         --owner=root:0 \
         --sort=name \
         $packname ) \
  | xz > $basedir/$filename
