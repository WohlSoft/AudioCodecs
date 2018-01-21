cmake_minimum_required (VERSION 2.8.11)
project (libMAD)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    # Turn on warnings and legacy C/C++ standards to support more compilers
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wno-pedantic -std=c99")
endif()

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

install(TARGETS mad
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/mad.h
        DESTINATION include/)

