cmake_minimum_required (VERSION 2.8.11)
project (libTimidity)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

add_library(timidity STATIC
    src/common.c
    src/filter.c
    src/instrum.c
    src/mix.c
    src/output.c
    src/playmidi.c
    src/readmidi.c
    src/sdl_a.c
    src/sdl_c.c
    src/tables.c
    src/timidity.c
    src/ctrlmode.c
    src/resample_timidity.c
)

target_link_libraries(timidity SDL2)

target_include_directories(timidity PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS timidity
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/timidity.h
        DESTINATION include/)

