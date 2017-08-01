#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = mad
INSTALLINCLUDES = $$PWD/include/mad.h
include($$PWD/../audio_codec_common.pri)

DEFINES += FPM_DEFAULT HAVE_CONFIG_H

win*-msvc*: {
    DEFINES += _CRT_SECURE_NO_WARNINGS
    QMAKE_CFLAGS += /wd4244 /wd4146
}

!win*-msvc*:{
    QMAKE_CFLAGS_WARN_ON  += \
        -Wno-implicit-fallthrough
}

debug {
    DEFINES += DEBUG
} else: release: {
    DEFINES += NDEBUG
    !win*-msvc*: QMAKE_CFLAGS += -O3
}

HEADERS +=\
    include/mad.h

HEADERS += \
    src/bit.h \
    src/decoder.h \
    src/fixed.h \
    src/frame.h \
    src/global.h \
    src/huffman.h \
    src/layer12.h \
    src/layer3.h \
    src/stream.h \
    src/synth.h \
    src/timer.h \
    src/version.h \
    src/config.h

SOURCES += \
    src/bit.c \
    src/decoder.c \
    src/fixed.c \
    src/frame.c \
    src/huffman.c \
    src/layer12.c \
    src/layer3.c \
    src/stream.c \
    src/synth.c \
    src/timer.c \
    src/version.c

DISTFILES += \
    src/D.dat \
    src/qc_table.dat \
    src/rq_table.dat \
    src/sf_table.dat \
    src/imdct_s.dat
