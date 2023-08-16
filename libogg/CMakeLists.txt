cmake_minimum_required(VERSION 3.2...3.5)
project(libOGG VERSION 1.3.5 LANGUAGES C)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

set(CMAKE_C_STANDARD 90)

add_library(ogg STATIC
    src/bitwise.c
    src/framing.c
)

target_include_directories(ogg PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)


install(TARGETS ogg
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/ogg/config_types.h
        include/ogg/ogg.h
        include/ogg/os_types.h
        DESTINATION include/ogg)
