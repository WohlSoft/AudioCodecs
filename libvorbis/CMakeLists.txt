cmake_minimum_required(VERSION 3.2...3.5)
project(libVorbis VERSION 1.3.7 LANGUAGES C)

include(CheckIncludeFile)

set(CMAKE_C_STANDARD 99)

set(AUDIO_CODECS_KEEP_SSE ON)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

add_definitions(
    -DHAVE_CONFIG_H
)

check_include_file(alloca.h HAVE_ALLOCA_H)

add_definitions(-DFLOAT_LOOKUP -DINT_LOOKUP)

configure_file(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config/config.h)

if(NOT MSVC)
    ac_disable_c_warning_flag("unused-function" UNUSED_FUNCTION)
    ac_disable_c_warning_flag("unused-variable" UNUSED_VARIABLE)
endif()

if(MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4244 /wd4267 /wd4305")
endif()

add_library(vorbis STATIC
    lib/analysis.c
    lib/bitrate.c
    lib/block.c
    lib/codebook.c
    lib/envelope.c
    lib/floor0.c
    lib/floor1.c
    lib/info.c
    lib/lookup.c
    lib/lpc.c
    lib/lsp.c
    lib/mapping0.c
    lib/mdct.c
    lib/psy.c
    lib/registry.c
    lib/res0.c
    lib/sharedbook.c
    lib/smallft.c
    lib/synthesis.c
    lib/window.c
)

add_library(vorbisfile STATIC
    lib/vorbisfile.c
)

add_library(vorbisenc STATIC
    lib/vorbisenc.c
)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/lib
    ${CMAKE_CURRENT_SOURCE_DIR}/../libogg/include
    ${CMAKE_CURRENT_BINARY_DIR}/config
)

target_include_directories(vorbis PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(vorbisfile PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(vorbisfile PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS vorbis vorbisfile vorbisenc
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/vorbis/codec.h
        include/vorbis/vorbisenc.h
        include/vorbis/vorbisfile.h
        DESTINATION include/vorbis)
