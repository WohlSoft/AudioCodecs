cmake_minimum_required (VERSION 2.8.11)
project (libFLAC)

add_definitions(
    -DHAVE_CONFIG_H
    -DFLAC__NO_DLL
)

add_library(FLAC STATIC
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

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include_p)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../libogg/include)

target_include_directories(FLAC PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

