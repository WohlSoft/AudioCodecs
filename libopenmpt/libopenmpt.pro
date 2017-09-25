#
#  Project file for the Qt Creator IDE
#

TEMPLATE = lib
CONFIG  -= qt
CONFIG  += staticlib

TARGET = openmpt
INSTALLINCLUDES = $$PWD/include/*
INSTALLINCLUDESTO = openmpt
include($$PWD/../audio_codec_common.pri)

INCLUDEPATH += $$PWD/src $$PWD/src/common $$PWD/src/build/svn_version $$PWD/include $$PWD/include/libopenmpt  $$PWD/include/libmodplug

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

DEFINES += LIBOPENMPT_BUILD HAVE_CONFIG_H

HEADERS += \
    include/libmodplug/modplug.h \
    include/libmodplug/sndfile.h \
    include/libmodplug/stdafx.h \
    include/libopenmpt/libopenmpt_config.h \
    include/libopenmpt/libopenmpt_ext.hpp \
    include/libopenmpt/libopenmpt.h \
    include/libopenmpt/libopenmpt.hpp \
    include/libopenmpt/libopenmpt_stream_callbacks_file.h \
    include/libopenmpt/libopenmpt_version.h \
    src/build/svn_version/svn_version.h \
    src/common/BuildSettings.h \
    src/common/CompilerDetect.h \
    src/common/ComponentManager.h \
    src/common/Endianness.h \
    src/common/FileReader.h \
    src/common/FlagSet.h \
    src/common/Logging.h \
    src/common/misc_util.h \
    src/common/mptAtomic.h \
    src/common/mptBufferIO.h \
    src/common/mptCPU.h \
    src/common/mptCRC.h \
    src/common/mptFileIO.h \
    src/common/mptIO.h \
    src/common/mptLibrary.h \
    src/common/mptMutex.h \
    src/common/mptOS.h \
    src/common/mptPathString.h \
    src/common/mptRandom.h \
    src/common/mptStringFormat.h \
    src/common/mptString.h \
    src/common/mptStringParse.h \
    src/common/mptThread.h \
    src/common/mptTime.h \
    src/common/mptTypeTraits.h \
    src/common/mptUUID.h \
    src/common/Profiler.h \
    src/common/serialization_utils.h \
    src/common/stdafx.h \
    src/common/StringFixer.h \
    src/common/typedefs.h \
    src/common/version.h \
    src/common/versionNumber.h \
    src/config.h \
    src/libopenmpt/libopenmpt_impl.hpp \
    src/libopenmpt/libopenmpt_internal.h \
    src/libopenmpt/libopenmpt_stream_callbacks_fd.h \
    src/soundlib/AudioCriticalSection.h \
    src/soundlib/AudioReadTarget.h \
    src/soundlib/ChunkReader.h \
    src/soundlib/Dither.h \
    src/soundlib/Dlsbank.h \
    src/soundlib/FloatMixer.h \
    src/soundlib/IntMixer.h \
    src/soundlib/ITCompression.h \
    src/soundlib/ITTools.h \
    src/soundlib/Loaders.h \
    src/soundlib/Message.h \
    src/soundlib/MIDIEvents.h \
    src/soundlib/MIDIMacros.h \
    src/soundlib/Mixer.h \
    src/soundlib/MixerInterface.h \
    src/soundlib/MixerLoops.h \
    src/soundlib/MixerSettings.h \
    src/soundlib/MixFuncTable.h \
    src/soundlib/ModChannel.h \
    src/soundlib/modcommand.h \
    src/soundlib/ModInstrument.h \
    src/soundlib/ModSample.h \
    src/soundlib/ModSequence.h \
    src/soundlib/modsmp_ctrl.h \
    src/soundlib/mod_specifications.h \
    src/soundlib/MPEGFrame.h \
    src/soundlib/OggStream.h \
    src/soundlib/patternContainer.h \
    src/soundlib/pattern.h \
    src/soundlib/plugins/DigiBoosterEcho.h \
    src/soundlib/plugins/dmo/Compressor.h \
    src/soundlib/plugins/dmo/Distortion.h \
    src/soundlib/plugins/dmo/DMOPlugin.h \
    src/soundlib/plugins/dmo/Echo.h \
    src/soundlib/plugins/dmo/Gargle.h \
    src/soundlib/plugins/dmo/ParamEq.h \
    src/soundlib/plugins/dmo/WavesReverb.h \
    src/soundlib/plugins/PluginManager.h \
    src/soundlib/plugins/PluginMixBuffer.h \
    src/soundlib/plugins/PluginStructs.h \
    src/soundlib/plugins/PlugInterface.h \
    src/soundlib/Resampler.h \
    src/soundlib/RowVisitor.h \
    src/soundlib/S3MTools.h \
    src/soundlib/SampleFormatConverters.h \
    src/soundlib/SampleFormat.h \
    src/soundlib/SampleIO.h \
    src/soundlib/Snd_defs.h \
    src/soundlib/Sndfile.h \
    src/soundlib/SoundFilePlayConfig.h \
    src/soundlib/Tables.h \
    src/soundlib/Tagging.h \
    src/soundlib/tuningbase.h \
    src/soundlib/tuningcollection.h \
    src/soundlib/tuning.h \
    src/soundlib/WAVTools.h \
    src/soundlib/WindowedFIR.h \
    src/soundlib/XMTools.h \
    src/config.h

SOURCES += \
    src/common/ComponentManager.cpp \
    src/common/FileReader.cpp \
    src/common/Logging.cpp \
    src/common/misc_util.cpp \
    src/common/mptCPU.cpp \
    src/common/mptFileIO.cpp \
    src/common/mptIO.cpp \
    src/common/mptLibrary.cpp \
    src/common/mptOS.cpp \
    src/common/mptPathString.cpp \
    src/common/mptRandom.cpp \
    src/common/mptString.cpp \
    src/common/mptStringFormat.cpp \
    src/common/mptStringParse.cpp \
    src/common/mptTime.cpp \
    src/common/mptUUID.cpp \
    src/common/Profiler.cpp \
    src/common/serialization_utils.cpp \
    src/common/stdafx.cpp \
    src/common/typedefs.cpp \
    src/common/version.cpp \
    src/libopenmpt/libopenmpt_c.cpp \
    src/libopenmpt/libopenmpt_cxx.cpp \
    src/libopenmpt/libopenmpt_ext.cpp \
    src/libopenmpt/libopenmpt_impl.cpp \
    # src/libopenmpt/libopenmpt_modplug.c \
    # src/libopenmpt/libopenmpt_modplug_cpp.cpp \
    src/soundlib/AudioCriticalSection.cpp \
    src/soundlib/Dither.cpp \
    src/soundlib/Dlsbank.cpp \
    src/soundlib/Fastmix.cpp \
    src/soundlib/InstrumentExtensions.cpp \
    src/soundlib/ITCompression.cpp \
    src/soundlib/ITTools.cpp \
    src/soundlib/Load_669.cpp \
    src/soundlib/Load_amf.cpp \
    src/soundlib/Load_ams.cpp \
    src/soundlib/Load_dbm.cpp \
    src/soundlib/Load_digi.cpp \
    src/soundlib/Load_dmf.cpp \
    src/soundlib/Load_dsm.cpp \
    src/soundlib/Load_far.cpp \
    src/soundlib/Load_gdm.cpp \
    src/soundlib/Load_imf.cpp \
    src/soundlib/Load_it.cpp \
    src/soundlib/Load_itp.cpp \
    src/soundlib/load_j2b.cpp \
    src/soundlib/Load_mdl.cpp \
    src/soundlib/Load_med.cpp \
    src/soundlib/Load_mid.cpp \
    src/soundlib/Load_mo3.cpp \
    src/soundlib/Load_mod.cpp \
    src/soundlib/Load_mt2.cpp \
    src/soundlib/Load_mtm.cpp \
    src/soundlib/Load_okt.cpp \
    src/soundlib/Load_plm.cpp \
    src/soundlib/Load_psm.cpp \
    src/soundlib/Load_ptm.cpp \
    src/soundlib/Load_s3m.cpp \
    src/soundlib/Load_sfx.cpp \
    src/soundlib/Load_stm.cpp \
    src/soundlib/Load_ult.cpp \
    src/soundlib/Load_umx.cpp \
    src/soundlib/Load_wav.cpp \
    src/soundlib/Load_xm.cpp \
    src/soundlib/Message.cpp \
    src/soundlib/MIDIEvents.cpp \
    src/soundlib/MIDIMacros.cpp \
    src/soundlib/MixerLoops.cpp \
    src/soundlib/MixerSettings.cpp \
    src/soundlib/MixFuncTable.cpp \
    src/soundlib/Mmcmp.cpp \
    src/soundlib/ModChannel.cpp \
    src/soundlib/modcommand.cpp \
    src/soundlib/ModInstrument.cpp \
    src/soundlib/ModSample.cpp \
    src/soundlib/ModSequence.cpp \
    src/soundlib/modsmp_ctrl.cpp \
    src/soundlib/mod_specifications.cpp \
    src/soundlib/MPEGFrame.cpp \
    src/soundlib/OggStream.cpp \
    src/soundlib/patternContainer.cpp \
    src/soundlib/pattern.cpp \
    src/soundlib/plugins/DigiBoosterEcho.cpp \
    src/soundlib/plugins/dmo/Compressor.cpp \
    src/soundlib/plugins/dmo/Distortion.cpp \
    src/soundlib/plugins/dmo/DMOPlugin.cpp \
    src/soundlib/plugins/dmo/Echo.cpp \
    src/soundlib/plugins/dmo/Gargle.cpp \
    src/soundlib/plugins/dmo/ParamEq.cpp \
    src/soundlib/plugins/dmo/WavesReverb.cpp \
    src/soundlib/plugins/PluginManager.cpp \
    src/soundlib/plugins/PlugInterface.cpp \
    src/soundlib/RowVisitor.cpp \
    src/soundlib/S3MTools.cpp \
    src/soundlib/SampleFormats.cpp \
    src/soundlib/SampleIO.cpp \
    src/soundlib/Sndfile.cpp \
    src/soundlib/Snd_flt.cpp \
    src/soundlib/Snd_fx.cpp \
    src/soundlib/Sndmix.cpp \
    src/soundlib/SoundFilePlayConfig.cpp \
    src/soundlib/Tables.cpp \
    src/soundlib/Tagging.cpp \
    src/soundlib/tuningbase.cpp \
    src/soundlib/tuningCollection.cpp \
    src/soundlib/tuning.cpp \
    src/soundlib/UpgradeModule.cpp \
    src/soundlib/WAVTools.cpp \
    src/soundlib/WindowedFIR.cpp \
    src/soundlib/XMTools.cpp
