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

INCLUDEPATH += $$PWD/src/ $$PWD/include/

debug {
    DEFINES += DEBUG
} else: release: {
    DEFINES += NDEBUG
    QMAKE_CFLAGS += -O3
}

*g++*||*clang*: QMAKE_CXXFLAGS_WARN_ON += -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-type-limits

DEFINES += NOCONTROLS

HEADERS +=\
    $$PWD/include/smpeg.h \
    $$PWD/src/MPEG.h \
    $$PWD/src/MPEGaction.h \
    $$PWD/src/MPEGaudio.h \
    $$PWD/src/MPEGerror.h \
    $$PWD/src/MPEGframe.h \
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
    $$PWD/src/MPEG.cpp \
    $$PWD/src/MPEGlist.cpp \
    $$PWD/src/MPEGring.cpp \
    $$PWD/src/MPEGstream.cpp \
    $$PWD/src/MPEGsystem.cpp \
    $$PWD/src/smpeg.cpp \
    $$PWD/src/audio/bitwindow.cpp \
    $$PWD/src/audio/filter.cpp \
    $$PWD/src/audio/filter_2.cpp \
    $$PWD/src/audio/hufftable.cpp \
    $$PWD/src/audio/MPEGaudio.cpp \
    $$PWD/src/audio/mpeglayer1.cpp \
    $$PWD/src/audio/mpeglayer2.cpp \
    $$PWD/src/audio/mpeglayer3.cpp \
    $$PWD/src/audio/mpegtable.cpp \
    $$PWD/src/audio/mpegtoraw.cpp \
    $$PWD/src/video/decoders.cpp \
    $$PWD/src/video/floatdct.cpp \
    $$PWD/src/video/gdith.cpp \
    $$PWD/src/video/jrevdct.cpp \
    $$PWD/src/video/motionvec.cpp \
    $$PWD/src/video/MPEGvideo.cpp \
    $$PWD/src/video/parseblock.cpp \
    $$PWD/src/video/readfile.cpp \
    $$PWD/src/video/util.cpp \
    $$PWD/src/video/video.cpp \
    $$PWD/src/video/mmxflags_asm.S \
    $$PWD/src/video/mmxidct_asm.S
