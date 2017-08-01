#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = ADLMIDI
INSTALLINCLUDES = $$PWD/include/*
INSTALLINCLUDESTO = ADLMIDI
include($$PWD/../audio_codec_common.pri)

macx: QMAKE_CXXFLAGS_WARN_ON += -Wno-absolute-value

INCLUDEPATH += $$PWD $$PWD/include

HEADERS += \
    include/adlmidi.h \
    src/adldata.hh \
    src/adlmidi_mus2mid.h \
    src/adlmidi_private.hpp \
    src/adlmidi_xmi2mid.h \
    src/fraction.h \
    src/nukedopl3.h

SOURCES += \
    src/adldata.cpp \
    src/adlmidi.cpp \
    src/adlmidi_load.cpp \
    src/adlmidi_midiplay.cpp \
    src/adlmidi_opl3.cpp \
    src/adlmidi_private.cpp \
    src/adlmidi_mus2mid.c \
    src/adlmidi_xmi2mid.c \
    src/nukedopl3.c
