cmake_minimum_required (VERSION 2.8.11)
project (libZLib)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

IF(NOT MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-implicit-function-declaration -Wno-implicit-fallthrough")
ELSE()
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4100 /wd4244 /wd4005 /wd4013 /wd4047 /wd4996")
ENDIF()

add_library(zlib STATIC
    src/adler32.c
    src/compress.c
    src/crc32.c
    src/deflate.c
    src/gzclose.c
    src/gzlib.c
    src/gzread.c
    src/gzwrite.c
    src/infback.c
    src/inffast.c
    src/inflate.c
    src/inftrees.c
    src/trees.c
    src/uncompr.c
    src/zutil.c
)

target_include_directories(zlib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS zlib
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/zconf.h
        include/zlib.h
        include/zutil.h
        DESTINATION include/)

