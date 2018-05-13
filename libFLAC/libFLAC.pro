#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = FLAC
INSTALLINCLUDES = $$PWD/include/FLAC/*
INSTALLINCLUDESTO = FLAC
include($$PWD/../audio_codec_common.pri)

DEFINES += "VERSION=\\\"1.3.2\\\"" "PACKAGE_VERSION=\\\"1.3.2\\\""

DEFINES     += HAVE_CONFIG_H FLAC__NO_DLL
win*-msvc*: {
    DEFINES += _CRT_SECURE_NO_WARNINGS
    QMAKE_CFLAGS += /wd4244
} else {
    QMAKE_CFLAGS_WARN_ON = \
        -Wno-implicit-fallthrough
}
#win32:DEFINES += HAVE_FSEEKO
macx: QMAKE_CFLAGS_WARN_ON = -Wall -Wno-unused-variable

INCLUDEPATH += $$PWD $$PWD/include $$PWD/include_p $$PWD/src/libFLAC $$PWD/src/libFLAC/include
INCLUDEPATH += $$PWD/../libogg/include

HEADERS += \
    include/FLAC/all.h \
    include/FLAC/assert.h \
    include/FLAC/callback.h \
    include/FLAC/export.h \
    include/FLAC/format.h \
    include/FLAC/metadata.h \
    include/FLAC/ordinals.h \
    include/FLAC/stream_decoder.h \
    include/FLAC/stream_encoder.h \
    include_p/share/grabbag/cuesheet.h \
    include_p/share/grabbag/file.h \
    include_p/share/grabbag/picture.h \
    include_p/share/grabbag/replaygain.h \
    include_p/share/grabbag/seektable.h \
    include_p/share/alloc.h \
    include_p/share/compat.h \
    include_p/share/endswap.h \
    include_p/share/getopt.h \
    include_p/share/grabbag.h \
    include_p/share/macros.h \
    include_p/share/private.h \
    include_p/share/replaygain_analysis.h \
    include_p/share/replaygain_synthesis.h \
    include_p/share/safe_str.h \
    include_p/share/utf8.h \
    include_p/share/win_utf8_io.h \
    src/libFLAC/ia32/nasm.h \
    src/libFLAC/include/private/all.h \
    src/libFLAC/include/private/bitmath.h \
    src/libFLAC/include/private/bitreader.h \
    src/libFLAC/include/private/bitwriter.h \
    src/libFLAC/include/private/cpu.h \
    src/libFLAC/include/private/crc.h \
    src/libFLAC/include/private/fixed.h \
    src/libFLAC/include/private/float.h \
    src/libFLAC/include/private/format.h \
    src/libFLAC/include/private/lpc.h \
    src/libFLAC/include/private/macros.h \
    src/libFLAC/include/private/md5.h \
    src/libFLAC/include/private/memory.h \
    src/libFLAC/include/private/metadata.h \
    src/libFLAC/include/private/ogg_decoder_aspect.h \
    src/libFLAC/include/private/ogg_encoder_aspect.h \
    src/libFLAC/include/private/ogg_helper.h \
    src/libFLAC/include/private/ogg_mapping.h \
    src/libFLAC/include/private/stream_encoder.h \
    src/libFLAC/include/private/stream_encoder_framing.h \
    src/libFLAC/include/private/window.h \
    src/libFLAC/include/protected/all.h \
    src/libFLAC/include/protected/stream_decoder.h \
    src/libFLAC/include/protected/stream_encoder.h \
    src/libFLAC/config.h

SOURCES += \
    src/libFLAC/bitmath.c \
    src/libFLAC/bitreader.c \
    src/libFLAC/bitwriter.c \
    src/libFLAC/cpu.c \
    src/libFLAC/crc.c \
    src/libFLAC/fixed.c \
    src/libFLAC/format.c \
    src/libFLAC/lpc.c \
    src/libFLAC/md5.c \
    src/libFLAC/memory.c \
    src/libFLAC/metadata_iterators.c \
    src/libFLAC/metadata_object.c \
    src/libFLAC/ogg_decoder_aspect.c \
    src/libFLAC/ogg_encoder_aspect.c \
    src/libFLAC/ogg_helper.c \
    src/libFLAC/ogg_mapping.c \
    src/libFLAC/stream_decoder.c \
    src/libFLAC/stream_encoder.c \
    src/libFLAC/stream_encoder_framing.c \
    src/libFLAC/window.c

# Include this if you want use integer-only version
#SOURCES += \
#    src/float.c

# Uncoment this if you want use ASM optimizations
#SOURCES += \
#    src/lpc_intrin_avx2.c \
#    src/lpc_intrin_sse.c \
#    src/lpc_intrin_sse2.c \
#    src/lpc_intrin_sse41.c \
#    src/fixed_intrin_sse2.c \
#    src/fixed_intrin_ssse3.c \
#    src/stream_encoder_intrin_avx2.c \
#    src/stream_encoder_intrin_sse2.c \
#    src/stream_encoder_intrin_ssse3.c

win32: include($$PWD/win_utf8_io.pri)

