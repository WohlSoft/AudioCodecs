#!/bin/bash

VER=1.32.7
pre=

if [[ -d mpg123 ]]; then
    rm -Rf mpg123
fi

wget --content-disposition https://www.mpg123.de/download/mpg123-${VER}.tar.bz2 -O mpg123-repo.tar.bz2
tar -xf mpg123-repo.tar.bz2
mv mpg123-${VER} mpg123

rm -Rf mpg123/build/
rm -Rf mpg123/doc/
rm -Rf mpg123/m4/
rm -Rf mpg123/man1/
rm -Rf mpg123/scripts/
rm -Rf mpg123/aclocal.m4
rm -Rf mpg123/configure
rm -Rf mpg123/configure.ac
rm -Rf mpg123/makedll.sh
rm -Rf mpg123/Makefile.am
rm -Rf mpg123/Makefile.in
rm -Rf mpg123/windows-builds.sh

rm -Rf ../mpg123
rm -Rf ../libmpg123
mv mpg123 ../libmpg123
rm mpg123-repo.tar.bz2
