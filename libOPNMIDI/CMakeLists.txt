cmake_minimum_required (VERSION 2.8.11)
project (libOPNMIDI)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

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

