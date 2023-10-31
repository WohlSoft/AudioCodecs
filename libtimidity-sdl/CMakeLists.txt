cmake_minimum_required(VERSION 3.2...3.5)
project(libTimiditySDL VERSION 0.2 LANGUAGES C)

set(AUDIO_CODECS_KEEP_SSE ON)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

# Turn on warnings and legacy C/C++ standards to support more compilers
set(CMAKE_C_STANDARD 90)

if(NOT MSVC)
    ac_add_c_warning_flag("all" ALL)
    ac_add_c_warning_flag("pedantic" PEDANTIC)
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
    # Crutches and bicycles
    src/utils.c
)
target_compile_definitions(timidity PRIVATE -DHAVE_CONFIG_H=0)

set_target_properties(timidity PROPERTIES OUTPUT_NAME "timidity_sdl2")

if(DOWNLOAD_SDL2_DEPENDENCY OR USE_LOCAL_SDL2)
    add_dependencies(timidity SDL2HG)
    target_include_directories(timidity PRIVATE ${CMAKE_BINARY_DIR}/include/SDL2)
elseif(SDL2_REPO_PATH)
    target_link_libraries(timidity PUBLIC SDL2)
    target_include_directories(timidity PRIVATE ${SDL2_REPO_PATH}/include/SDL2)
else()
    if(HAIKU)
        find_library(SDL2_LIBRARY SDL2)
        find_path(SDL2_INCLUDE_DIR "SDL.h" PATH_SUFFIXES SDL2)
        if(NOT SDL2_LIBRARY AND NOT SDL2_INCLUDE_DIR)
            message(FATAL_ERROR "The SDL2 Library was not found!")
        endif()
        set(SDL2_INCLUDE_DIRS ${SDL2_INCLUDE_DIR})
        set(SDL2_LIBRARIES ${SDL2_LIBRARY})
    elseif(VITA)
        set(CMAKE_FIND_ROOT_PATH_OLD ${CMAKE_FIND_ROOT_PATH})
        set(CMAKE_FIND_ROOT_PATH_OLD2 "${CMAKE_FIND_ROOT_PATH}")
        set(CMAKE_FIND_ROOT_PATH "${CMAKE_FIND_ROOT_PATH_OLD}")

        find_library(SDL2_LIBRARY SDL2)
        find_path(SDL2_INCLUDE_DIR "SDL.h" PATH_SUFFIXES SDL2)

        set(SDL2_INCLUDE_DIRS ${SDL2_INCLUDE_DIR})
        set(SDL2_LIBRARIES ${SDL2_LIBRARY})

        message("SDL2_LIBRARY: ${SDL2_LIBRARY}")
        message("SDL2_LIBRARIES: ${SDL2_LIBRARIES}")
        message("SDL2_INCLUDE_DIR: ${SDL2_INCLUDE_DIR}")
        message("SDL2_INCLUDE_DIRS: ${SDL2_INCLUDE_DIRS}")
        message("CMAKE_FIND_ROOT_PATH: ${CMAKE_FIND_ROOT_PATH}")

        if(NOT SDL2_LIBRARY AND NOT SDL2_INCLUDE_DIR)
            message(FATAL_ERROR "libtimidity-sdl: The SDL2 Library was not found!")
        endif()

        set(CMAKE_FIND_ROOT_PATH "${CMAKE_FIND_ROOT_PATH_OLD2}")
    else()
        find_package(SDL2 REQUIRED)
        if(TARGET SDL2::SDL2)
            set(SDL2_LIBRARIES SDL2::SDL2main SDL2::SDL2)
        elseif(TARGET SDL2::SDL2-static)
            set(SDL2_LIBRARIES SDL2::SDL2main SDL2::SDL2-static)
        endif()
    endif()
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
