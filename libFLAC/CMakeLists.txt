cmake_minimum_required(VERSION 3.2...3.5)
project(libFLAC VERSION 1.3.4 LANGUAGES C)

include(CheckIncludeFiles)
include(CheckFunctionExists)
include(TestBigEndian)
set(AUDIO_CODECS_KEEP_SSE ON)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

TEST_BIG_ENDIAN(WORDS_BIGENDIAN)
if(WORDS_BIGENDIAN)
    add_definitions(-DCPU_IS_BIG_ENDIAN=1)
    add_definitions(-DCPU_IS_LITTLE_ENDIAN=0)
    add_definitions(-DWORDS_BIGENDIAN=1)
else()
    add_definitions(-DCPU_IS_BIG_ENDIAN=0)
    add_definitions(-DCPU_IS_LITTLE_ENDIAN=1)
endif()

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    # Turn on warnings and legacy C/C++ standards to support more compilers
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99")
endif()

if(NOT MSVC)
    ac_add_c_warning_flag("all" ALL)
    ac_disable_c_warning_flag("pedantic" PEDANTIC)
    ac_disable_c_warning_flag("shift-negative-value" SHIFT_NEGATIVE_VALUE)
endif()

if(MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4267 /wd4334 /wd4996 /wd4244")
endif()

add_definitions(
    -DHAVE_CONFIG_H
    -DFLAC__NO_DLL
)

set(FLAC_VERSION "${libFLAC_VERSION}")

CHECK_FUNCTION_EXISTS(fseeko HAVE_FSEEKO)
if(HAVE_FSEEKO)
    add_definitions(-DHAVE_FSEEKO)
endif()

if(WIN32)
    CHECK_FUNCTION_EXISTS(_wutime64 HAVE_WUTIME64)
    try_compile(HAVE_WUTIME64_BUILT
                ${CMAKE_BINARY_DIR}/compile_tests
                ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/wutime64/wutime64_test.c
    )
    if(HAVE_WUTIME64 AND HAVE_WUTIME64_BUILT)
        message("TEST: _wutime64 found and compiling!")
        add_definitions(-DHAVE_WUTIME64)
    else()
        message("TEST: _wutime64 DISABLED: found: [${HAVE_WUTIME64}] compiling: [${HAVE_WUTIME64_BUILT}]")
    endif()
endif()

set(FLAC_SRC)

list(APPEND FLAC_SRC
    src/libFLAC/bitmath.c
    src/libFLAC/bitreader.c
    src/libFLAC/bitwriter.c
    src/libFLAC/cpu.c
    src/libFLAC/crc.c
    src/libFLAC/fixed.c
    src/libFLAC/fixed_intrin_sse2.c
    src/libFLAC/fixed_intrin_ssse3.c
    src/libFLAC/format.c
    src/libFLAC/lpc.c
    src/libFLAC/lpc_intrin_neon.c
    src/libFLAC/lpc_intrin_sse2.c
    src/libFLAC/lpc_intrin_sse41.c
    src/libFLAC/lpc_intrin_avx2.c
    src/libFLAC/lpc_intrin_vsx.c
    src/libFLAC/md5.c
    src/libFLAC/memory.c
    src/libFLAC/metadata_iterators.c
    src/libFLAC/metadata_object.c
    src/libFLAC/ogg_decoder_aspect.c
    src/libFLAC/ogg_encoder_aspect.c
    src/libFLAC/ogg_helper.c
    src/libFLAC/ogg_mapping.c
    src/libFLAC/stream_decoder.c
    src/libFLAC/stream_encoder.c
    src/libFLAC/stream_encoder_intrin_sse2.c
    src/libFLAC/stream_encoder_intrin_ssse3.c
    src/libFLAC/stream_encoder_intrin_avx2.c
    src/libFLAC/stream_encoder_framing.c
    src/libFLAC/window.c
)

if(WIN32)
    list(APPEND FLAC_SRC
        src/libFLAC/win_utf8_io.c
    )
endif()

add_library(FLAC STATIC
    ${FLAC_SRC}
)

target_include_directories(FLAC PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_compile_definitions(FLAC PRIVATE
    -DVERSION="${FLAC_VERSION}"
    -DPACKAGE_VERSION="${FLAC_VERSION}"
)
target_include_directories(FLAC PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/../libogg/include
)
target_include_directories(FLAC PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/include_p
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libFLAC
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libFLAC/include
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
