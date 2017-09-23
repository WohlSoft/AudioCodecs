#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = smpeg
INSTALLINCLUDES = $$PWD/include/smpeg.h
include($$PWD/../audio_codec_common.pri)

win*-msvc*: {
DEFINES += _CRT_SECURE_NO_WARNINGS
QMAKE_CFLAGS += /wd4244 /wd4146
}

INCLUDEPATH += $$PWD/src/ $$PWD/include/smpeg/

debug {
    DEFINES += DEBUG
} else: release: {
    DEFINES += NDEBUG
    QMAKE_CFLAGS += -O3
}

*g++*||*clang*: QMAKE_CXXFLAGS_WARN_ON += -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-type-limits

DEFINES += \
    NOCONTROLS \
    STDC_HEADERS=1 \
    HAVE_SYS_TYPES_H=1 \
    HAVE_SYS_STAT_H=1 \
    HAVE_STDLIB_H=1 \
    HAVE_STRING_H=1 \
    HAVE_MEMORY_H=1 \
    HAVE_STRINGS_H=1 \
    HAVE_INTTYPES_H=1 \
    HAVE_STDINT_H=1 \
    _THREAD_SAFE

!win32: {
    DEFINES +=
        HAVE_UNISTD_H=1 \
        HAVE_DLFCN_H=1
}

HEADERS +=\
    $$PWD/include/smneg/smpeg.h \
    $$PWD/include/smneg/MPEGframe.h \
    $$PWD/src/MPEG.h \
    $$PWD/src/MPEGaction.h \
    $$PWD/src/MPEGaudio.h \
    $$PWD/src/MPEGerror.h \
    $$PWD/src/MPEGlist.h \
    $$PWD/src/MPEGring.h \
    $$PWD/src/MPEGstream.h \
    $$PWD/src/MPEGsystem.h \
    $$PWD/src/MPEGvideo.h \
    $$PWD/src/video/decoders.h \
    $$PWD/src/video/dither.h \
    $$PWD/src/video/proto.h \
    $$PWD/src/video/util.h \
    $$PWD/src/video/video.h

SOURCES += \
    src/MPEG.cpp \
    src/MPEGlist.cpp \
    src/MPEGring.cpp \
    src/MPEGstream.cpp \
    src/MPEGsystem.cpp \
    src/smpeg.cpp \
    src/audio/bitwindow.cpp \
    src/audio/filter.cpp \
    src/audio/filter_2.cpp \
    src/audio/hufftable.cpp \
    src/audio/MPEGaudio.cpp \
    src/audio/mpeglayer1.cpp \
    src/audio/mpeglayer2.cpp \
    src/audio/mpeglayer3.cpp \
    src/audio/mpegtable.cpp \
    src/audio/mpegtoraw.cpp \
    src/video/decoders.cpp \
    src/video/floatdct.cpp \
    src/video/gdith.cpp \
    src/video/jrevdct.cpp \
    src/video/motionvec.cpp \
    src/video/MPEGvideo.cpp \
    src/video/parseblock.cpp \
    src/video/readfile.cpp \
    src/video/util.cpp \
    src/video/video.cpp \
    src/video/mmxflags_asm.S \
    src/video/mmxidct_asm.S
