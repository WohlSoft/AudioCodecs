cmake_minimum_required (VERSION 2.8.11)
project (libGME CXX)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

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

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
endif()

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-inconsistent-missing-override")
endif()

if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4101 /wd4800 /wd4702 /wd4706 /wd4805 /wd4310 /wd4244 /wd4456 /wd4459 /wd4146 /wd4127 /wd4458 /wd4267 /wd4804")
endif()

# Settings
option(BUILD_GME_STATIC "Build static library of Game-Music-EMU" ON)
option(BUILD_GME_SHARED "Build shared library of Game-Music-EMU" OFF)

set(GME_YM2612_EMU "MAME" CACHE STRING "Which YM2612 emulator to use: \"Nuked\" (LGPLv2.1+), \"MAME\" (GPLv2+), or \"GENS\" (LGPLv2.1+)")

add_definitions(
    -DSPC_MORE_ACCURACY
    -D_REENTRANT
    -D_USE_MATH_DEFINES
    -DHAVE_ZLIB_H
)

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


include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../zlib/include)

set(GME_INSTALL_TARGETS)

if(BUILD_GME_STATIC)
    add_library(gme_static STATIC ${libgme_SRCS})
    set_target_properties(gme_static PROPERTIES OUTPUT_NAME gme)
    target_include_directories(gme_static PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
    target_include_directories(gme_static PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
    list(APPEND GME_INSTALL_TARGETS gme_static)
    message("== GME will be built as static library ==")
endif()

if(BUILD_GME_SHARED)
    add_library(gme_shared SHARED ${libgme_SRCS})
    set_target_properties(gme_shared PROPERTIES OUTPUT_NAME gme)
    target_link_libraries(gme_shared zlib)
    target_include_directories(gme_shared PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
    target_include_directories(gme_shared PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
    list(APPEND GME_INSTALL_TARGETS gme_shared)
    message("== GME will be built as shared library ==")
endif()

install(TARGETS ${GME_INSTALL_TARGETS}
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/gme.h
        DESTINATION include/)

