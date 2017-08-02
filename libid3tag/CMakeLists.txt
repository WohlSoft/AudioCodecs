cmake_minimum_required (VERSION 2.8.11)
project (libID3TAG)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

add_library(id3tag STATIC
    src/id3_file.c
    src/id3_compat.c
    src/id3_crc.c
    src/id3_field.c
    src/id3_frame.c
    src/id3_frametype.c
    src/id3_genre.c
    src/id3_latin1.c
    src/id3_parse.c
    src/id3_render.c
    src/id3_tag.c
    src/id3_ucs4.c
    src/id3_utf16.c
    src/id3_utf8.c
    src/id3_util.c
    src/id3_version.c
)

target_link_libraries(id3tag SDL2)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../SDL2/include)
target_include_directories(id3tag PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

