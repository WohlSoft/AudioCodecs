cmake_minimum_required(VERSION 3.2)
project(libTimiditySDL VERSION 0.2 LANGUAGES C)

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

set_target_properties(timidity PROPERTIES OUTPUT_NAME "timidity_sdl2")

if(DOWNLOAD_SDL2_DEPENDENCY)
    add_dependencies(timidity SDL2HG)
    target_include_directories(timidity PRIVATE ${CMAKE_BINARY_DIR}/include/SDL2)
elseif(SDL2_REPO_PATH)
    target_link_libraries(timidity PUBLIC SDL2)
    target_include_directories(timidity PRIVATE ${SDL2_REPO_PATH}/include)
else()
    find_package(SDL2 REQUIRED)
    message("Found ${SDL2_LIBRARIES}")
    target_include_directories(timidity PRIVATE ${SDL2_INCLUDE_DIRS})
    target_link_libraries(timidity PUBLIC ${SDL2_LIBRARIES})
endif()

install(TARGETS timidity
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        src/timidity.h
        DESTINATION include/
)
