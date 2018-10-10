cmake_minimum_required (VERSION 2.8.11)
project(AudioCodecs)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(POLICY CMP0058) # Dependencies
    cmake_policy(SET CMP0058 NEW)
endif()

option(DOWNLOAD_SDL2_DEPENDENCY "Download, compile, and install SDL2's master branch" OFF)
set(SDL2_REPO_PATH "" CACHE PATH "Path to the SDL2")

if(${CMAKE_SYSTEM_NAME} STREQUAL "Emscripten")
    set(EMSCRIPTEN 1)
    message("AudioCodecs using Emscripten!")
endif()

if(NOT SDL2_REPO_PATH)
    # Try to resolve sqlite dependency
    if(DOWNLOAD_SDL2_DEPENDENCY)
        option(BUILD_SDL2_SHARED "Enable shared build of SDL2" ON)
        option(BUILD_SDL2_STATIC "Enable static build of SDL2" ON)
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

option(BUILD_OGG_VORBIS "Enable building of OGG and Vorbis" ON)
if(BUILD_OGG_VORBIS)
    add_subdirectory(libogg)
    add_subdirectory(libvorbis)
    add_dependencies(vorbis ogg)
    add_dependencies(vorbisfile vorbis ogg)
    add_dependencies(vorbisenc vorbis ogg)
endif()

if(NOT EMSCRIPTEN)
    option(BUILD_FLAC "Enable building of FLAC" ON)
    if(BUILD_FLAC)
        add_subdirectory(libFLAC)
    endif()
endif()

option(BUILD_ID3TAGSDL "Enable building of libID3TAG-SDL" ON)
if(BUILD_ID3TAGSDL)
    add_subdirectory(libid3tag-sdl)
    if(DOWNLOAD_SDL2_DEPENDENCY)
        add_dependencies(id3tag SDL2HG)
    endif()
endif()

option(BUILD_MP3_MAD "Enable building of libMAD" ON)
if(BUILD_MP3_MAD)
    add_subdirectory(libmad)
endif()

option(BUILD_MP3_SMPEG "Enable building of libSMPEG" OFF)
if(BUILD_MP3_SMPEG)
    add_subdirectory(smpeg)
    if(DOWNLOAD_SDL2_DEPENDENCY)
        add_dependencies(smpeg SDL2HG)
    endif()
endif()

option(BUILD_GME "Enable building of GME" ON)
if(BUILD_GME)
    add_subdirectory(zlib)
    add_subdirectory(libgme)
    if(BUILD_GME_STATIC)
        add_dependencies(gme_static zlib)
    endif()
    if(BUILD_GME_SHARED)
        add_dependencies(gme_shared zlib)
    endif()
endif()

option(BUILD_TIMIDITYSDL "Enable building of Timidity-SDL" ON)
if(BUILD_TIMIDITYSDL)
    add_subdirectory(libtimidity-sdl)
endif()

option(BUILD_MODPLUG "Enable building of libModPlug" ON)
if(BUILD_MODPLUG)
    add_subdirectory(libmodplug)
endif()

option(BUILD_OPUS "Enable building of OPUS" ON)
if(BUILD_OPUS)
    if(NOT BUILD_OGG_VORBIS)
        add_subdirectory(libogg)
    endif()
    add_subdirectory(libopus)
    add_subdirectory(libopusfile)
    target_include_directories(opus PUBLIC ${CMAKE_SOURCE_DIR}/libogg/include)
    target_include_directories(opusfile PUBLIC ${CMAKE_SOURCE_DIR}/libogg/include)
    add_dependencies(opus ogg)
    add_dependencies(opusfile opus ogg)
endif()

if(NOT MSVC)
    # For now this is not buildable under MSVC yet :-(
    option(BUILD_OPENMPT "Enable building of libOpenMPT" OFF)
    if(BUILD_OPENMPT)
        add_subdirectory(libopenmpt)
    endif()
endif()

option(BUILD_ADLMIDI "Enable building of libADLMIDI" ON)
if(BUILD_ADLMIDI)
    add_subdirectory(libADLMIDI)
endif()

option(BUILD_OPNMIDI "Enable building of libOPNMIDI" ON)
if(BUILD_OPNMIDI)
    add_subdirectory(libOPNMIDI)
endif()

