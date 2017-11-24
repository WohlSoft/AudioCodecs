#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = OPNMIDI
INSTALLINCLUDES = $$PWD/include/*
INSTALLINCLUDESTO = OPNMIDI
include($$PWD/../audio_codec_common.pri)

macx: QMAKE_CXXFLAGS_WARN_ON += -Wno-absolute-value

INCLUDEPATH += $$PWD $$PWD/include

HEADERS += \
    include/opnmidi.h \
    src/fraction.hpp \
    src/opnbank.h \
    src/opnmidi_mus2mid.h \
    src/opnmidi_private.hpp \
    src/opnmidi_xmi2mid.h \
    src/Ym2612_ChipEmu.h

SOURCES += \
    src/opnmidi.cpp \
    src/opnmidi_load.cpp \
    src/opnmidi_midiplay.cpp \
    src/opnmidi_opn2.cpp \
    src/opnmidi_private.cpp \
    src/Ym2612_ChipEmu.cpp \
    src/opnmidi_mus2mid.c \
    src/opnmidi_xmi2mid.c

