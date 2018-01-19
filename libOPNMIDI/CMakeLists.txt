cmake_minimum_required (VERSION 2.8.11)
project (libOPNMIDI)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

add_definitions(-DUSE_LEGACY_EMULATOR)

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    # Turn on warnings and legacy C/C++ standards to support more compilers
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -pedantic -std=c90")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic -std=c++98")
endif()

if(WIN32)
    add_definitions(-DUNICODE -D_UNICODE)
endif()

add_library(OPNMIDI STATIC
    src/opnmidi.cpp
    src/opnmidi_load.cpp
    src/opnmidi_midiplay.cpp
    src/opnmidi_opn2.cpp
    src/opnmidi_private.cpp
    src/Ym2612_ChipEmu.cpp
    src/opnmidi_mus2mid.c
    src/opnmidi_xmi2mid.c
)

target_include_directories(OPNMIDI PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS OPNMIDI
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/opnmidi.h
        DESTINATION include/)

