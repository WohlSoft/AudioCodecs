cmake_minimum_required (VERSION 2.8.11)
project (libGME)

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

add_definitions(
    -DSPC_MORE_ACCURACY
    -D_REENTRANT
    -D_USE_MATH_DEFINES
    -DHAVE_ZLIB_H
)

add_library(gme STATIC
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
    src/Ym2612_Emu.cpp
)

target_link_libraries(gme zlib)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../zlib/include)
target_include_directories(gme PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(gme PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

install(TARGETS gme
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/gme.h
        DESTINATION include/)

