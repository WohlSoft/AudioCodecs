cmake_minimum_required(VERSION 3.2...3.5)
project(libGME VERSION 0.6.2 LANGUAGES CXX)

set(AUDIO_CODECS_KEEP_SSE ON)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)
include(TestBigEndian)

macro(use_cxx11)
  if (CMAKE_VERSION VERSION_LESS "3.1")
    if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
      set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")
    endif ()
  else ()
    set (CMAKE_CXX_STANDARD 11)
  endif ()
endmacro(use_cxx11)

use_cxx11()

if(NOT MSVC)
    ac_add_c_warning_flag("all" ALL)
    ac_add_cxx_warning_flag("all" ALL)
    ac_disable_c_warning_flag("inconsistent-missing-override" INCONSISTENT_MISSING_OVERRIDE)
    ac_disable_cxx_warning_flag("inconsistent-missing-override" INCONSISTENT_MISSING_OVERRIDE)

    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        add_definitions(-DLIBGME_VISIBILITY)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=hidden")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden")

        # Try to protect against undefined behavior from signed integer overflow
        # This has caused miscompilation of code already and there are other
        # potential uses; see https://bitbucket.org/mpyne/game-music-emu/issues/18/
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fwrapv")
    endif()
endif()

if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4101 /wd4800 /wd4702 /wd4706 /wd4805 /wd4310 /wd4244 /wd4456 /wd4459 /wd4146 /wd4127 /wd4458 /wd4267 /wd4804")
endif()

if(POLICY CMP0077) # Cache variables override since 3.12
    cmake_policy(SET CMP0077 NEW)
endif()

test_big_endian(WORDS_BIGENDIAN)
if(WORDS_BIGENDIAN)
    add_definitions(-DBLARGG_BIG_ENDIAN=1)
else()
    add_definitions(-DBLARGG_LITTLE_ENDIAN=1)
endif()

# Settings
option(BUILD_GME_STATIC "Build static library of Game-Music-EMU" ON)
option(BUILD_GME_SHARED "Build shared library of Game-Music-EMU" OFF)

set(GME_YM2612_EMU "MAME" CACHE STRING "Which YM2612 emulator to use: \"Nuked\" (LGPLv2.1+), \"MAME\" (GPLv2+), or \"GENS\" (LGPLv2.1+)")
option(GME_ENABLE_ZLIB "Enable ZLib support (such as VGZ files and other GZ-packed files)" ON)
option(GME_USE_SYSTEM_ZLIB "Use Zlib from the system" OFF)

add_definitions(
    -DSPC_ISOLATED_ECHO_BUFFER
    -D_REENTRANT
    -D_USE_MATH_DEFINES
)

if(NOT NINTENDO_3DS)
    add_definitions(-DSPC_MORE_ACCURACY)
else()
    add_definitions(
        -DSPC_LESS_ACCURATE
    )
endif()

if(GME_ENABLE_ZLIB)
    add_definitions(
        -DHAVE_ZLIB_H
    )
endif()

set(libgme_SRCS
    src/Ay_Apu.cpp
    src/Ay_Cpu.cpp
    src/Ay_Emu.cpp
    src/Blip_Buffer.cpp
    src/Classic_Emu.cpp
    src/Data_Reader.cpp
    src/Dual_Resampler.cpp
    src/Effects_Buffer.cpp
    src/Fir_Resampler.cpp
    src/Gb_Apu.cpp
    src/Gb_Cpu.cpp
    src/Gb_Oscs.cpp
    src/Gbs_Emu.cpp
    src/gme.cpp
    src/Gme_File.cpp
    src/Gym_Emu.cpp
    src/Hes_Apu.cpp
    src/Hes_Cpu.cpp
    src/Hes_Emu.cpp
    src/Kss_Cpu.cpp
    src/Kss_Emu.cpp
    src/Kss_Scc_Apu.cpp
    src/M3u_Playlist.cpp
    src/Multi_Buffer.cpp
    src/Music_Emu.cpp
    src/Nes_Apu.cpp
    src/Nes_Cpu.cpp
    src/Nes_Fme7_Apu.cpp
    src/Nes_Namco_Apu.cpp
    src/Nes_Oscs.cpp
    src/Nes_Vrc6_Apu.cpp
    src/Nsfe_Emu.cpp
    src/Nsf_Emu.cpp
    src/Nes_Fds_Apu.cpp
    src/Nes_Vrc7_Apu.cpp
    src/ext/emu2413.c
    src/ext/panning.c
    src/Sap_Apu.cpp
    src/Sap_Cpu.cpp
    src/Sap_Emu.cpp
    src/Sms_Apu.cpp
    src/Snes_Spc.cpp
    src/Spc_Cpu.cpp
    src/Spc_Dsp.cpp
    src/Spc_Emu.cpp
    src/Spc_Filter.cpp
    src/Vgm_Emu.cpp
    src/Vgm_Emu_Impl.cpp
    src/Ym2413_Emu.cpp
)

# so is Ym2612_Emu
if(GME_YM2612_EMU STREQUAL "Nuked")
    add_definitions(-DVGM_YM2612_NUKED)
    set(libgme_SRCS ${libgme_SRCS}
                src/Ym2612_Nuked.cpp
        )
    message("VGM/GYM: Nuked OPN2 emulator will be used")
elseif(GME_YM2612_EMU STREQUAL "MAME")
    add_definitions(-DVGM_YM2612_MAME)
    set(libgme_SRCS ${libgme_SRCS}
                src/Ym2612_MAME.cpp
        )
    message("VGM/GYM: MAME YM2612 emulator will be used")
else()
    add_definitions(-DVGM_YM2612_GENS)
    set(libgme_SRCS ${libgme_SRCS}
                src/Ym2612_GENS.cpp
        )
    message("VGM/GYM: GENS 2.10 emulator will be used")
endif()

if(GME_USE_SYSTEM_ZLIB)
    find_package(ZLIB REQUIRED)
else()
    include_directories(${CMAKE_BINARY_DIR}/zlib-include)
endif()

set(GME_INSTALL_TARGETS)

if(BUILD_GME_STATIC)
    add_library(gme_static STATIC ${libgme_SRCS})
    set_target_properties(gme_static PROPERTIES OUTPUT_NAME gme)
    target_compile_definitions(gme_static PRIVATE -DBLARGG_BUILD_DLL)
    target_include_directories(gme_static PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
    target_include_directories(gme_static PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
    if(GME_ENABLE_ZLIB AND GME_USE_SYSTEM_ZLIB)
        target_include_directories(gme_static PRIVATE ${ZLIB_INCLUDE_DIRS})
    endif()
    list(APPEND GME_INSTALL_TARGETS gme_static)
    message("== GME will be built as static library ==")
endif()

if(BUILD_GME_SHARED)
    add_library(gme_shared SHARED ${libgme_SRCS})
    set_target_properties(gme_shared PROPERTIES OUTPUT_NAME gme)
    target_compile_definitions(gme_shared PRIVATE -DBLARGG_BUILD_DLL)
    if(GME_ENABLE_ZLIB)
        if(GME_USE_SYSTEM_ZLIB)
            target_include_directories(gme_static PRIVATE ${ZLIB_INCLUDE_DIRS})
            target_link_libraries(gme_shared ${ZLIB_LIBRARIES})
        else()
            target_link_libraries(gme_shared zlib)
        endif()
    endif()
    target_include_directories(gme_shared PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
    target_include_directories(gme_shared PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
    list(APPEND GME_INSTALL_TARGETS gme_shared)
    set_target_properties(gme_shared PROPERTIES VERSION ${libGME_VERSION} SOVERSION ${libGME_VERSION_MAJOR})
    message("== GME will be built as shared library ==")
endif()

install(TARGETS
    ${GME_INSTALL_TARGETS}
    LIBRARY DESTINATION "lib"
    ARCHIVE DESTINATION "lib"
    INCLUDES DESTINATION "include"
)

install(FILES
    src/gme.h
    src/blargg_source.h
    DESTINATION include/gme
)
