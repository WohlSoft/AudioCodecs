cmake_minimum_required (VERSION 2.8.11)
project (AudioCodecs)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

option(DOWNLOAD_SDL2_DEPENDENCY "Downloads and compiles SDL2 from official Mercurial directly" OFF)
set(SDL2_REPO_PATH "" CACHE PATH "Path to the SDL2")

if(NOT SDL2_REPO_PATH)
    # Try to resolve sqlite dependency
    if(DOWNLOAD_SDL2_DEPENDENCY)
        # Download and configure SDL2 dependency
        include(download_sdl2_hg.cmake)
        set(SDL2_REPO_PATH ${SDL2_INSTALL_DIR})
    endif()
endif()

if(SDL2_REPO_PATH)
    link_directories(${SDL2_INSTALL_DIR}/lib)
    include_directories(${SDL2_INSTALL_DIR}/include)
    message("SDL2 Repo folder is ${SDL2_REPO_PATH}")
endif()

# --- TODO: implement building or usage of pre-built libSDL here ---
# set(SNDIO OFF) # Disable sndio that is not needed to us
# add_subdirectory(libSDL2)

add_subdirectory(libogg)
add_subdirectory(libvorbis)
add_subdirectory(libFLAC)
add_subdirectory(libid3tag)
add_subdirectory(libmad)
add_subdirectory(smpeg)
add_subdirectory(zlib)
add_subdirectory(libgme)
add_subdirectory(libtimidity)
add_subdirectory(libmodplug)
if(NOT MSVC)
    # For now this is not buildable under MSVC yet :-(
    add_subdirectory(libopenmpt)
endif()
add_subdirectory(libADLMIDI)
add_subdirectory(libOPNMIDI)
