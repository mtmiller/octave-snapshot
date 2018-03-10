#!/bin/sh
#
# Pack an installed Octave chroot into a compressed binary archive

set -e

init=/tmp/guest-initializations.sh
. "$init"

hg_id=$(cat $basedir/octave-build/HG-ID 2> /dev/null | sed 's/[[:space:]]*//g')
version=$(sed -n 's/^VERSION = \(.*\)/\1/p' $basedir/octave-build/Makefile 2> /dev/null | sed 's/[[:space:]]*//g')
timestamp=$(cat $basedir/octave-build/HG-TIMESTAMP)
case "$version" in
  *+) suffix="$version$hg_id" ;;
  *)  suffix="$version+$hg_id" ;;
esac
export SOURCE_DATE_EPOCH=$timestamp
export TAR_OPTIONS="--format=ustar"
export TAR_OPTIONS="${TAR_OPTIONS} --sort=name --mtime=@${SOURCE_DATE_EPOCH}"
export TAR_OPTIONS="${TAR_OPTIONS} --owner=0 --group=0 --numeric-owner"
export TZ=UTC0

make -C $basedir/octave-build -j$(getconf _NPROCESSORS_ONLN) dist
source_archives=$(cd $basedir/octave-build && ls octave-*.*.tar.*)
for f in $source_archives; do
  cp "$basedir/octave-build/$f" $basedir
done

binary_archive=octave-ubuntu-trusty-snapshot.tar.xz
packname=octave-ubuntu-trusty-$suffix
chrootdir=$basedir/$packname

rm -rf $chrootdir
mkdir -p $chrootdir
make -C $basedir/octave-build install DESTDIR=$chrootdir
for d in bin include lib libexec share; do
  mv $chrootdir/usr/local/$d $chrootdir/$d
done
rm -rf $chrootdir/usr

rm -f $chrootdir/lib/octave/*/lib*.la
gzip -9n $chrootdir/share/info/*.info* $chrootdir/share/man/man1/*.1
chmod -R a+rX,u+w,go-w $chrootdir

archives="$source_archives $binary_archive"
( cd $basedir && tar -c $packname ) | xz > $basedir/$binary_archive
( cd $basedir && sha1sum $archives ) > $basedir/SHA1SUMS
( cd $basedir && sha256sum $archives ) > $basedir/SHA256SUMS
