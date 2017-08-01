#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = zlib
INSTALLINCLUDES = $$PWD/include/*
INSTALLINCLUDESTO = zlib
include($$PWD/../audio_codec_common.pri)

INCLUDEPATH += $$PWD $$PWD/include

!win*-msvc*:{
    QMAKE_CFLAGS_WARN_ON += \
        -Wno-implicit-function-declaration \
        -Wno-implicit-fallthrough

} else {
    DEFINES += _CRT_SECURE_NO_WARNINGS
    QMAKE_CFLAGS_WARN_ON   += /wd4100 /wd4244 /wd4005 /wd4013 /wd4047 /wd4996
    QMAKE_CXXFLAGS_WARN_ON += /wd4100 /wd4101 /wd4244 /wd4800 /wd4104 /wd4146
}

HEADERS += \
    include/zlib.h \
    include/zutil.h \
	include/zconf.h \
    src/crc32.h \
    src/deflate.h \
    src/gzguts.h \
    src/inffast.h \
    src/inffixed.h \
    src/inflate.h \
    src/inftrees.h \
    src/trees.h

SOURCES += \
    src/adler32.c \
    src/compress.c \
    src/crc32.c \
    src/deflate.c \
    src/gzclose.c \
    src/gzlib.c \
    src/gzread.c \
    src/gzwrite.c \
    src/infback.c \
    src/inffast.c \
    src/inflate.c \
    src/inftrees.c \
    src/trees.c \
    src/uncompr.c \
    src/zutil.c

