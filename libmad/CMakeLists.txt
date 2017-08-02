cmake_minimum_required (VERSION 2.8.11)
project (libMAD)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

add_definitions(
    -DFPM_DEFAULT
    -DHAVE_CONFIG_H
)

add_library(mad STATIC
    src/bit.c
    src/decoder.c
    src/fixed.c
    src/frame.c
    src/huffman.c
    src/layer12.c
    src/layer3.c
    src/stream.c
    src/synth.c
    src/timer.c
    src/version.c
)

target_include_directories(mad PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

