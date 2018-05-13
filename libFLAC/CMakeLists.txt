cmake_minimum_required (VERSION 2.8.11)
project (libFLAC)

include(CheckIncludeFiles)
include(CheckFunctionExists)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    # Turn on warnings and legacy C/C++ standards to support more compilers
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99 -Wall -Wno-pedantic")
endif()

add_definitions(
    -DHAVE_CONFIG_H
    -DFLAC__NO_DLL
)

set(FLAC_VERSION "1.3.2")

CHECK_FUNCTION_EXISTS(fseeko HAVE_FSEEKO)
if(HAVE_FSEEKO)
    add_definitions(-DHAVE_FSEEKO)
endif()

set(FLAC_SRC)

list(APPEND FLAC_SRC
    src/bitmath.c
    src/bitreader.c
    src/bitwriter.c
    src/cpu.c
    src/crc.c
    src/fixed.c
    src/format.c
    src/lpc.c
    src/md5.c
    src/memory.c
    src/metadata_iterators.c
    src/metadata_object.c
    src/ogg_decoder_aspect.c
    src/ogg_encoder_aspect.c
    src/ogg_helper.c
    src/ogg_mapping.c
    src/stream_decoder.c
    src/stream_encoder.c
    src/stream_encoder_framing.c
    src/window.c
)

if(WIN32)
    add_definitions(-DUNICODE -D_UNICODE)
    list(APPEND FLAC_SRC
        src/win_utf8_io.c
        src/windows_unicode_filenames.c
    )
endif()

add_library(FLAC STATIC
    ${FLAC_SRC}
)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include_p)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../libogg/include)

target_include_directories(FLAC PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_compile_definitions(FLAC PRIVATE
    -DVERSION="${FLAC_VERSION}"
    -DPACKAGE_VERSION="${FLAC_VERSION}"
)

install(TARGETS FLAC
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/FLAC/all.h
        include/FLAC/assert.h
        include/FLAC/callback.h
        include/FLAC/export.h
        include/FLAC/format.h
        include/FLAC/metadata.h
        include/FLAC/ordinals.h
        include/FLAC/stream_decoder.h
        include/FLAC/stream_encoder.h
        DESTINATION include/FLAC/)

