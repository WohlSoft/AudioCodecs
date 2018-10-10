cmake_minimum_required (VERSION 2.8.11)
project (libTimiditySDL C)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    # Turn on warnings and legacy C/C++ standards to support more compilers
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -pedantic -std=c90")
endif()

add_library(timidity STATIC
    src/common.c
    src/instrum.c
    src/mix.c
    src/output.c
    src/playmidi.c
    src/readmidi.c
    src/resample.c
    src/tables.c
    src/timidity.c
)

if(DOWNLOAD_SDL2_DEPENDENCY)
    add_dependencies(timidity SDL2HG)
elseif(SDL2_REPO_PATH)
    include_directories(${SDL2_REPO_PATH}/include)
else()
    find_library(SDL2_LIBRARY SDL2)
    message("Found ${SDL2_LIBRARY}")
endif()

target_link_libraries(timidity SDL2)

target_include_directories(timidity PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS timidity
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/timidity.h
        DESTINATION include/)

