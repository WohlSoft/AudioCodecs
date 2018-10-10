#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = id3tag
INSTALLINCLUDES = $$PWD/include/*
INSTALLINCLUDESTO = id3tag
include($$PWD/../audio_codec_common.pri)

exists($$PWD/../../../_common/lib_destdir.pri):{
    include($$PWD/../../../_common/lib_destdir.pri)
    INCLUDEPATH += $$PWD/../../_builds/$$TARGETOS/include/
    LIBS += -L$$PWD/../../_builds/$$TARGETOS/lib/
}

INCLUDEPATH += $$PWD $$PWD/include
LIBS += -lSDL2

!win*-msvc*:{
    QMAKE_CFLAGS_WARN_ON += \
        -Wno-implicit-function-declaration \
        -Wno-implicit-fallthrough \
        -Wno-pointer-sign \

} else {
    DEFINES += _CRT_SECURE_NO_WARNINGS
    QMAKE_CFLAGS_WARN_ON   += /wd4100 /wd4244 /wd4005 /wd4013 /wd4047 /wd4996
    QMAKE_CXXFLAGS_WARN_ON += /wd4100 /wd4101 /wd4244 /wd4800 /wd4104 /wd4146
}

HEADERS += \
    include/id3tag.h \
    src/compat.h \
    crc.h \
    src/debug.h \
    src/field.h \
    src/file.h \
    src/frame.h \
    src/frametype.h \
    src/genre.h \
    src/global.h \
    src/latin1.h \
    src/parse.h \
    src/render.h \
    src/tag.h \
    src/ucs4.h \
    src/utf8.h \
    src/utf16.h \
    src/util.h \
    src/version.h

SOURCES += \
    src/id3_file.c \
    src/id3_compat.c \
    src/id3_crc.c \
    src/id3_field.c \
    src/id3_frame.c \
    src/id3_frametype.c \
    src/id3_genre.c \
    src/id3_latin1.c \
    src/id3_parse.c \
    src/id3_render.c \
    src/id3_tag.c \
    src/id3_ucs4.c \
    src/id3_utf16.c \
    src/id3_utf8.c \
    src/id3_util.c \
    src/id3_version.c

contains(DEFINES, DEBUG): include($$PWD/debug.pri)

