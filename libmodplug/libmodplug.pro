#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = modplug
INSTALLINCLUDES = $$PWD/include/*
INSTALLINCLUDESTO = modplug
include($$PWD/../audio_codec_common.pri)

INCLUDEPATH += $$PWD $$PWD/include

!win*-msvc*:{
    QMAKE_CXXFLAGS_WARN_ON  += \
        -Wno-unused-parameter \
        -Wno-implicit-fallthrough
    !macx:{
        QMAKE_CXXFLAGS_WARN_ON += \
            -Wno-unused-but-set-variable
    }
} else {
    DEFINES += _CRT_SECURE_NO_WARNINGS
    QMAKE_CFLAGS_WARN_ON   += /wd4100 /wd4244 /wd4005 /wd4013 /wd4047 /wd4996
    QMAKE_CXXFLAGS_WARN_ON += /wd4100 /wd4101 /wd4244 /wd4800 /wd4104 /wd4146
}

DEFINES += \
    MODPLUG_NO_FILESAVE \
    HAVE_CONFIG_H \
    MODPLUG_STATIC \
    MODPLUG_BUILD=1 \
    _REENTRANT \
    _USE_MATH_DEFINES

HEADERS += \
    include/modplug.h \
    src/config.h \
    src/it_defs.h \
    src/load_pat.h \
    src/sndfile.h \
    src/stdafx.h \
    src/tables.h

SOURCES += \
    src/fastmix.cpp \
    src/load_669.cpp \
    src/load_abc.cpp \
    src/load_amf.cpp \
    src/load_ams.cpp \
    src/load_dbm.cpp \
    src/load_dmf.cpp \
    src/load_dsm.cpp \
    src/load_far.cpp \
    src/load_it.cpp \
    # src/load_j2b.cpp \
    src/load_mdl.cpp \
    src/load_med.cpp \
    src/load_mid.cpp \
    src/load_mod.cpp \
    src/load_mt2.cpp \
    src/load_mtm.cpp \
    src/load_okt.cpp \
    src/load_pat.cpp \
    src/load_psm.cpp \
    src/load_ptm.cpp \
    src/load_s3m.cpp \
    src/load_stm.cpp \
    src/load_ult.cpp \
    src/load_umx.cpp \
    src/load_wav.cpp \
    src/load_xm.cpp \
    src/mmcmp.cpp \
    src/modplug.cpp \
    src/snd_dsp.cpp \
    src/snd_flt.cpp \
    src/snd_fx.cpp \
    src/sndfile.cpp \
    src/sndmix.cpp

