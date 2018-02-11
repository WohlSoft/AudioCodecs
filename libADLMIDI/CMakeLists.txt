cmake_minimum_required (VERSION 2.8.11)
project (libADLMIDI)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

add_definitions(-DADLMIDI_DISABLE_CPP_EXTRAS)

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    # Turn on warnings and legacy C/C++ standards to support more compilers
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -pedantic -std=c90")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -pedantic -std=gnu++98")
endif()

if(WIN32)
    add_definitions(-DUNICODE -D_UNICODE)
endif()

set(ADLMIDI_SRCS)

list(APPEND ADLMIDI_SRCS
    src/adldata.cpp
    src/adlmidi.cpp
    src/adlmidi_load.cpp
    src/adlmidi_midiplay.cpp
    src/adlmidi_opl3.cpp
    src/adlmidi_private.cpp
    src/adlmidi_mus2mid.c
    src/adlmidi_xmi2mid.c
)

option(ADLMIDI_USE_DOSBOX_EMULATOR "Use faster but less accurate DosBox emulator" OFF)
if(ADLMIDI_USE_DOSBOX_EMULATOR)
    add_definitions(-DADLMIDI_USE_DOSBOX_OPL)
    list(APPEND ADLMIDI_SRCS
        src/dbopl.cpp
    )
else()
    list(APPEND ADLMIDI_SRCS
        src/nukedopl3.c
    )
endif()

add_library(ADLMIDI STATIC
    ${ADLMIDI_SRCS}
)

target_include_directories(ADLMIDI PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS ADLMIDI
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/adlmidi.h
        DESTINATION include/)

