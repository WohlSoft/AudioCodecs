cmake_minimum_required (VERSION 2.8.11)
project (libsmpeg)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++98 -Wno-pedantic -Wno-unused-but-set-variable -Wno-sequence-point")
endif()

add_definitions(
    -DNOCONTROLS
    -DSTDC_HEADERS=1
    -DHAVE_SYS_TYPES_H=1
    -DHAVE_SYS_STAT_H=1
    -DHAVE_STDLIB_H=1
    -DHAVE_STRING_H=1
    -DHAVE_MEMORY_H=1
    -DHAVE_INTTYPES_H=1
    -DHAVE_STDINT_H=1
    -D_THREAD_SAFE
    -DTHREADED_AUDIO
)

IF(NOT WIN32)
    add_definitions(
        -DHAVE_UNISTD_H=1
        -DHAVE_DLFCN_H=1
        -DHAVE_STRINGS_H=1
    )
ELSEIF(NOT MSVC)
    add_definitions(
        -DWIN32
    )
ENDIF()

add_library(smpeg STATIC
    src/MPEG.cpp
    src/MPEGlist.cpp
    src/MPEGring.cpp
    src/MPEGstream.cpp
    src/MPEGsystem.cpp
    src/smpeg.cpp
    src/audio/bitwindow.cpp
    src/audio/filter.cpp
    src/audio/filter_2.cpp
    src/audio/hufftable.cpp
    src/audio/MPEGaudio.cpp
    src/audio/mpeglayer1.cpp
    src/audio/mpeglayer2.cpp
    src/audio/mpeglayer3.cpp
    src/audio/mpegtable.cpp
    src/audio/mpegtoraw.cpp
    src/video/decoders.cpp
    src/video/floatdct.cpp
    src/video/gdith.cpp
    src/video/jrevdct.cpp
    src/video/motionvec.cpp
    src/video/MPEGvideo.cpp
    src/video/parseblock.cpp
    src/video/readfile.cpp
    src/video/util.cpp
    src/video/video.cpp
    src/video/mmxflags_asm.S
    src/video/mmxidct_asm.S
)

# libSDL2
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../libSDL2/include/")
    # TODO: Implement automatical downloading and unpacking of hg.libsdl.org/SDL
    # or using of separated repository for libSDL's backup
    message("SDL2 found in ${CMAKE_CURRENT_SOURCE_DIR}/../libSDL2/include folder")
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../libSDL2/include)
else()
    if(SDL2_REPO_PATH)
        add_dependencies(smpeg SDL2HG)
    else()
        find_library(SDL2_LIBRARY SDL2)
        message("Found ${SDL2_LIBRARY}")
    endif()
endif()

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include/smpeg)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)

target_include_directories(smpeg PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS smpeg
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/smpeg/smpeg.h
        include/smpeg/MPEGframe.h
        DESTINATION include/smpeg/)

