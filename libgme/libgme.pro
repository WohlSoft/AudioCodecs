#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib
CONFIG  += c++11

TARGET = gme
INSTALLINCLUDES = $$PWD/include/*
INSTALLINCLUDESTO = gme
include($$PWD/../audio_codec_common.pri)

INCLUDEPATH += $$PWD $$PWD/include $$PWD/../zlib/include

!win*-msvc*:{
    QMAKE_CXXFLAGS_WARN_ON  += \
        -Wno-implicit-fallthrough
} else {
    DEFINES += _CRT_SECURE_NO_WARNINGS
    QMAKE_CFLAGS_WARN_ON   += /wd4100 /wd4244 /wd4005 /wd4013 /wd4047 /wd4996
    QMAKE_CXXFLAGS_WARN_ON += /wd4100 /wd4101 /wd4244 /wd4800 /wd4104 /wd4146
}

DEFINES += \
    SPC_MORE_ACCURACY \
    _REENTRANT \
    _USE_MATH_DEFINES

LIBS += -lzlib

HEADERS += \
    include/gme.h \
    src/Ay_Apu.h \
    src/Ay_Cpu.h \
    src/Ay_Emu.h \
    src/blargg_common.h \
    src/blargg_config.h \
    src/blargg_endian.h \
    src/blargg_source.h \
    src/Blip_Buffer.h \
    src/Classic_Emu.h \
    src/Data_Reader.h \
    src/Dual_Resampler.h \
    src/Effects_Buffer.h \
    src/Fir_Resampler.h \
    src/Gb_Apu.h \
    src/Gb_Cpu.h \
    src/gb_cpu_io.h \
    src/Gb_Oscs.h \
    src/Gbs_Emu.h \
    src/Gme_File.h \
    src/gme_types.h \
    src/Gym_Emu.h \
    src/GZipHelper.h \
    src/Hes_Apu.h \
    src/Hes_Cpu.h \
    src/hes_cpu_io.h \
    src/Hes_Emu.h \
    src/Kss_Cpu.h \
    src/Kss_Emu.h \
    src/Kss_Scc_Apu.h \
    src/M3u_Playlist.h \
    src/Multi_Buffer.h \
    src/Music_Emu.h \
    src/Nes_Apu.h \
    src/Nes_Cpu.h \
    src/nes_cpu_io.h \
    src/Nes_Fme7_Apu.h \
    src/Nes_Namco_Apu.h \
    src/Nes_Oscs.h \
    src/Nes_Vrc6_Apu.h \
    src/Nsfe_Emu.h \
    src/Nsf_Emu.h \
    src/Sap_Apu.h \
    src/Sap_Cpu.h \
    src/sap_cpu_io.h \
    src/Sap_Emu.h \
    src/Sms_Apu.h \
    src/Sms_Oscs.h \
    src/Snes_Spc.h \
    src/Spc_Cpu.h \
    src/Spc_Dsp.h \
    src/Spc_Emu.h \
    src/Spc_Filter.h \
    src/Vgm_Emu.h \
    src/Vgm_Emu_Impl.h \
    src/Ym2413_Emu.h \
    src/Ym2612_Emu.h

SOURCES += \
    src/Ay_Apu.cpp \
    src/Ay_Cpu.cpp \
    src/Ay_Emu.cpp \
    src/Blip_Buffer.cpp \
    src/Classic_Emu.cpp \
    src/Data_Reader.cpp \
    src/Dual_Resampler.cpp \
    src/Effects_Buffer.cpp \
    src/Fir_Resampler.cpp \
    src/Gb_Apu.cpp \
    src/Gb_Cpu.cpp \
    src/Gb_Oscs.cpp \
    src/Gbs_Emu.cpp \
    src/gme.cpp \
    src/Gme_File.cpp \
    src/Gym_Emu.cpp \
    src/Hes_Apu.cpp \
    src/Hes_Cpu.cpp \
    src/Hes_Emu.cpp \
    src/Kss_Cpu.cpp \
    src/Kss_Emu.cpp \
    src/Kss_Scc_Apu.cpp \
    src/M3u_Playlist.cpp \
    src/Multi_Buffer.cpp \
    src/Music_Emu.cpp \
    src/Nes_Apu.cpp \
    src/Nes_Cpu.cpp \
    src/Nes_Fme7_Apu.cpp \
    src/Nes_Namco_Apu.cpp \
    src/Nes_Oscs.cpp \
    src/Nes_Vrc6_Apu.cpp \
    src/Nsfe_Emu.cpp \
    src/Nsf_Emu.cpp \
    src/Sap_Apu.cpp \
    src/Sap_Cpu.cpp \
    src/Sap_Emu.cpp \
    src/Sms_Apu.cpp \
    src/Snes_Spc.cpp \
    src/Spc_Cpu.cpp \
    src/Spc_Dsp.cpp \
    src/Spc_Emu.cpp \
    src/Spc_Filter.cpp \
    src/Vgm_Emu.cpp \
    src/Vgm_Emu_Impl.cpp \
    src/Ym2413_Emu.cpp \
    src/Ym2612_Emu.cpp

