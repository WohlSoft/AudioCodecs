#!/bin/bash

VER=5.6.0
pre=

wget --content-disposition https://github.com/dbry/WavPack/archive/refs/tags/${VER}.tar.gz -O WavPack-repo.tar.gz
tar -xf WavPack-repo.tar.gz
mv WavPack-${VER} WavPack

rm -Rf WavPack/acinclude/
rm -Rf WavPack/audition/
rm -Rf WavPack/cli/
rm -Rf WavPack/doc/
rm -Rf WavPack/fuzzing/
rm -Rf WavPack/man/
rm -Rf WavPack/wavpackexe/
rm -Rf WavPack/winamp/
rm -Rf WavPack/wvgainexe/
rm -Rf WavPack/wvtagexe/
rm -Rf WavPack/wvunpackexe/
rm -Rf WavPack/xmms/
rm -Rf WavPack/acinclude.m4
rm -Rf WavPack/configure
rm -Rf WavPack/configure.ac
rm -Rf WavPack/autogen.sh
rm -Rf WavPack/Makefile.am

rm -Rf ../WavPack
mv WavPack ../WavPack
rm WavPack-repo.tar.gz
