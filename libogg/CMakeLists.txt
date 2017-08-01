cmake_minimum_required (VERSION 2.8.11)
project (libOGG)

add_library(ogg STATIC
    src/bitwise.c
    src/framing.c
)

target_include_directories(ogg PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

