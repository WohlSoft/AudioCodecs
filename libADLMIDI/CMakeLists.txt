cmake_minimum_required (VERSION 2.8.11)
project (libADLMIDI)

add_library(ADLMIDI STATIC
    src/adldata.cpp
    src/adlmidi.cpp
    src/adlmidi_load.cpp
    src/adlmidi_midiplay.cpp
    src/adlmidi_opl3.cpp
    src/adlmidi_private.cpp
    src/adlmidi_mus2mid.c
    src/adlmidi_xmi2mid.c
    src/nukedopl3.c
)

target_include_directories(ADLMIDI PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

