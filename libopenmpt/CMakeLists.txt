cmake_minimum_required (VERSION 2.8.11...3.5)
project (libOpenMPT)

include(TestBigEndian)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

TEST_BIG_ENDIAN(WORDS_BIGENDIAN)
if(WORDS_BIGENDIAN)
    add_definitions(-DWORDS_BIGENDIAN=1)
endif()

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    # Turn on warnings and legacy C/C++ standards to support more compilers
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -std=c99")
endif()

macro(use_cxx11)
    if(CMAKE_VERSION VERSION_LESS "3.1")
        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang" OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU" OR "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Intel")
            set (CMAKE_CXX_FLAGS "-std=c++11 ${CMAKE_CXX_FLAGS}")
        endif()
    else ()
        set (CMAKE_CXX_STANDARD 11)
    endif ()
endmacro(use_cxx11)

use_cxx11()

add_definitions(
    -DHAVE_CONFIG_H
    -DLIBOPENMPT_BUILD
    -DMPT_ENABLE_FILEIO_STDIO
    #-DMODPLUG_TRACKER
)
if(NOT WIN32)
add_definitions(
	-DMPT_WITH_VORBIS
	-DMPT_WITH_OGG
	-DMPT_WITH_VORBISFILE
	-DMPT_WITH_FLAC
	)
endif()

add_library(openmpt STATIC
    src/common/ComponentManager.cpp
    src/common/FileReader.cpp
    src/common/Logging.cpp
    src/common/misc_util.cpp
    src/common/mptCPU.cpp
    src/common/mptFileIO.cpp
    src/common/mptIO.cpp
    src/common/mptLibrary.cpp
    src/common/mptOS.cpp
    src/common/mptPathString.cpp
    src/common/mptRandom.cpp
    src/common/mptString.cpp
    src/common/mptStringFormat.cpp
    src/common/mptStringParse.cpp
    src/common/mptTime.cpp
    src/common/mptUUID.cpp
    src/common/Profiler.cpp
    src/common/serialization_utils.cpp
    src/common/stdafx.cpp
    src/common/typedefs.cpp
    src/common/version.cpp
    src/libopenmpt/libopenmpt_c.cpp
    src/libopenmpt/libopenmpt_cxx.cpp
    src/libopenmpt/libopenmpt_ext.cpp
    src/libopenmpt/libopenmpt_impl.cpp
    # src/libopenmpt/libopenmpt_modplug.c
    # src/libopenmpt/libopenmpt_modplug_cpp.cpp
    src/soundlib/AudioCriticalSection.cpp
    src/soundlib/Dither.cpp
    src/soundlib/Dlsbank.cpp
    src/soundlib/Fastmix.cpp
    src/soundlib/InstrumentExtensions.cpp
    src/soundlib/ITCompression.cpp
    src/soundlib/ITTools.cpp
    src/soundlib/Load_669.cpp
    src/soundlib/Load_amf.cpp
    src/soundlib/Load_ams.cpp
    src/soundlib/Load_dbm.cpp
    src/soundlib/Load_digi.cpp
    src/soundlib/Load_dmf.cpp
    src/soundlib/Load_dsm.cpp
    src/soundlib/Load_far.cpp
    src/soundlib/Load_gdm.cpp
    src/soundlib/Load_imf.cpp
    src/soundlib/Load_it.cpp
    src/soundlib/Load_itp.cpp
    src/soundlib/load_j2b.cpp
    src/soundlib/Load_mdl.cpp
    src/soundlib/Load_med.cpp
    src/soundlib/Load_mid.cpp
    src/soundlib/Load_mo3.cpp
    src/soundlib/Load_mod.cpp
    src/soundlib/Load_mt2.cpp
    src/soundlib/Load_mtm.cpp
    src/soundlib/Load_okt.cpp
    src/soundlib/Load_plm.cpp
    src/soundlib/Load_psm.cpp
    src/soundlib/Load_ptm.cpp
    src/soundlib/Load_s3m.cpp
    src/soundlib/Load_sfx.cpp
    src/soundlib/Load_stm.cpp
    src/soundlib/Load_ult.cpp
    src/soundlib/Load_umx.cpp
    src/soundlib/Load_wav.cpp
    src/soundlib/Load_xm.cpp
    src/soundlib/Message.cpp
    src/soundlib/MIDIEvents.cpp
    src/soundlib/MIDIMacros.cpp
    src/soundlib/MixerLoops.cpp
    src/soundlib/MixerSettings.cpp
    src/soundlib/MixFuncTable.cpp
    src/soundlib/Mmcmp.cpp
    src/soundlib/ModChannel.cpp
    src/soundlib/modcommand.cpp
    src/soundlib/ModInstrument.cpp
    src/soundlib/ModSample.cpp
    src/soundlib/ModSequence.cpp
    src/soundlib/modsmp_ctrl.cpp
    src/soundlib/mod_specifications.cpp
    src/soundlib/MPEGFrame.cpp
    src/soundlib/OggStream.cpp
    src/soundlib/patternContainer.cpp
    src/soundlib/pattern.cpp
    src/soundlib/plugins/DigiBoosterEcho.cpp
    src/soundlib/plugins/dmo/Compressor.cpp
    src/soundlib/plugins/dmo/Distortion.cpp
    src/soundlib/plugins/dmo/DMOPlugin.cpp
    src/soundlib/plugins/dmo/Echo.cpp
    src/soundlib/plugins/dmo/Gargle.cpp
    src/soundlib/plugins/dmo/ParamEq.cpp
    src/soundlib/plugins/dmo/WavesReverb.cpp
    src/soundlib/plugins/PluginManager.cpp
    src/soundlib/plugins/PlugInterface.cpp
    src/soundlib/RowVisitor.cpp
    src/soundlib/S3MTools.cpp
    src/soundlib/SampleFormats.cpp
    src/soundlib/SampleIO.cpp
    src/soundlib/Sndfile.cpp
    src/soundlib/Snd_flt.cpp
    src/soundlib/Snd_fx.cpp
    src/soundlib/Sndmix.cpp
    src/soundlib/SoundFilePlayConfig.cpp
    src/soundlib/Tables.cpp
    src/soundlib/Tagging.cpp
    src/soundlib/tuningbase.cpp
    src/soundlib/tuningCollection.cpp
    src/soundlib/tuning.cpp
    src/soundlib/UpgradeModule.cpp
    src/soundlib/WAVTools.cpp
    src/soundlib/WindowedFIR.cpp
    src/soundlib/XMTools.cpp
)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/svn_version)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/common)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include/libopenmpt)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include/libmodplug)

target_link_libraries(openmpt zlib)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../zlib/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../libogg/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../libvorbis/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../libFLAC/include)
target_include_directories(openmpt PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS openmpt
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/libopenmpt/libopenmpt_config.h
        include/libopenmpt/libopenmpt_ext.hpp
        include/libopenmpt/libopenmpt.h
        include/libopenmpt/libopenmpt.hpp
        include/libopenmpt/libopenmpt_stream_callbacks_file.h
        include/libopenmpt/libopenmpt_version.h
        DESTINATION include/libopenmpt)

