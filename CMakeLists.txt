cmake_minimum_required(VERSION 3.2...3.10)
project(AudioCodecs VERSION 1.0.0 LANGUAGES C CXX)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if(POLICY CMP0058) # Dependencies
    cmake_policy(SET CMP0058 NEW)
endif()

if(POLICY CMP0077) # Cache variables override since 3.12
    cmake_policy(SET CMP0077 NEW)
endif()

string(TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)

if(NOT EMSCRIPTEN AND NOT VITA)
    option(CODECS_BUILD_SHARED "Build shared libraries if possible" OFF)
    option(CODECS_BUILD_STATIC "Build static libraries if possible" ON)
else()
    set(CODECS_BUILD_SHARED OFF)
    set(CODECS_BUILD_STATIC ON)
endif()

option(DOWNLOAD_SDL2_DEPENDENCY "Download, compile, and install SDL's SDL2 branch" OFF)
option(USE_LOCAL_SDL2 "Build SDL2 from local copy" OFF)
if(ANDROID)
    option(USE_USE_NDK_MAKE "Build SDL2 for Android using NDK Make" OFF)
endif()
set(SDL2_REPO_PATH "" CACHE PATH "Path to the SDL2")

if(${CMAKE_SYSTEM_NAME} STREQUAL "Emscripten")
    set(EMSCRIPTEN 1)
    message("AudioCodecs using Emscripten!")
endif()

if(NOT WIN32 AND NOT VITA AND NOT EMSCRIPTEN AND NOT ANDROID)
    option(ENABLE_FPIC "Build static libraries as position independent code" ON)
elseif(ANDROID)
    set(ENABLE_FPIC ON)
else()
    set(ENABLE_FPIC OFF)
endif()

option(DISABLE_SIMD "Disable all SIMD optimizations as possible" OFF)

if(NINTENDO_3DS)
    set(DISABLE_HEAVY_SYNTHS ON)
else()
    option(DISABLE_HEAVY_SYNTHS "Disable all heavy chip emulators and prefer fastest" OFF)
endif()


if(NOT SDL2_REPO_PATH)
    # Try to resolve sqlite dependency
    if(DOWNLOAD_SDL2_DEPENDENCY OR USE_LOCAL_SDL2)
        if(NOT EMSCRIPTEN AND NOT VITA)
            option(BUILD_SDL2_SHARED "Enable shared build of SDL2" ON)
            option(BUILD_SDL2_STATIC "Enable static build of SDL2" ON)
        else()
            set(BUILD_SDL2_SHARED OFF)
            set(BUILD_SDL2_STATIC ON)
        endif()
        # Download and configure SDL2 dependency
        include(download_sdl2_hg.cmake)
        set(SDL2_REPO_PATH ${SDL2_INSTALL_DIR})
    endif()
endif()

link_directories(${CMAKE_BINARY_DIR}/lib)

if(SDL2_REPO_PATH)
    link_directories(${SDL2_INSTALL_DIR}/lib)
    include_directories(${SDL2_INSTALL_DIR}/include)
    message("SDL2 Repo folder is ${SDL2_REPO_PATH}")
endif()

# --- TODO: implement building or usage of pre-built libSDL here ---
# set(SNDIO OFF) # Disable sndio that is not needed to us
# add_subdirectory(libSDL2)

option(BUILD_OGG_VORBIS "Enable building of OGG and Vorbis" ON)
option(OGG_UNSAFE_DISABLE_CRC "[Unsafe] disable checksum when playing OGG files" OFF)
mark_as_advanced(OGG_UNSAFE_DISABLE_CRC)
if(BUILD_OGG_VORBIS)
    add_subdirectory(libogg)
    add_subdirectory(libvorbis)
    add_dependencies(vorbis ogg)
    add_dependencies(vorbisfile vorbis ogg)
    add_dependencies(vorbisenc vorbis ogg)

    add_subdirectory(tremor)
    add_dependencies(vorbisidec ogg)
endif()

option(BUILD_FLAC "Enable building of FLAC" ON)
if(BUILD_FLAC)
    add_subdirectory(libFLAC)
endif()

option(BUILD_MPG123 "Enable building of libMPG123" ON)
if(BUILD_MPG123)
    set(BUILD_LIBOUT123 OFF CACHE BOOL "" FORCE)
    set(BUILD_PROGRAMS OFF CACHE BOOL "" FORCE)
    set(NETWORK OFF CACHE BOOL "" FORCE)
    set(IPV6 OFF CACHE BOOL "" FORCE)
    add_subdirectory(libmpg123/ports/cmake)
    #AucioCodecs: Enable -fPIC if needed
    if(ENABLE_FPIC)
        set_target_properties(libmpg123 PROPERTIES COMPILE_FLAGS "-fPIC")
        if(TARGET libsyn123)
            set_target_properties(libsyn123 PROPERTIES COMPILE_FLAGS "-fPIC")
        endif()
    endif()
    unset(BUILD_LIBOUT123)
    unset(BUILD_PROGRAMS)
    unset(NETWORK)
    unset(IPV6)
endif()

option(BUILD_GME "Enable building of GME" ON)
option(BUILD_GME_SYSTEM_ZLIB "Use ZLib from the system for GME" OFF)
if(BUILD_GME)
    set(BUILD_SHARED_LIBS ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    set(BUILD_GME_STATIC ${CODECS_BUILD_STATIC} CACHE BOOL "" FORCE)
    set(BUILD_GME_SHARED ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    if(DISABLE_HEAVY_SYNTHS)
        set(GME_YM2612_EMU "GENS"  CACHE STRING "" FORCE)
    endif()
    mark_as_advanced(BUILD_SHARED_LIBS BUILD_GME_STATIC BUILD_GME_SHARED)
    if(NOT BUILD_GME_SYSTEM_ZLIB)
        add_subdirectory(zlib)
    else()
        set(GME_USE_SYSTEM_ZLIB ON CACHE BOOL "" FORCE)
        mark_as_advanced(GME_USE_SYSTEM_ZLIB)
    endif()
    add_subdirectory(libgme)
    if(NOT BUILD_GME_SYSTEM_ZLIB)
        if(BUILD_GME_STATIC)
            add_dependencies(gme_static zlibstatic)
        endif()
        if(BUILD_GME_SHARED)
            add_dependencies(gme_shared zlibstatic)
        endif()
    endif()
    unset(GME_YM2612_EMU)
    unset(GME_USE_SYSTEM_ZLIB)
    unset(BUILD_SHARED_LIBS)
    unset(BUILD_GME_STATIC)
    unset(BUILD_GME_SHARED)
endif()

option(BUILD_TIMIDITYSDL "Enable building of Timidity-SDL" ON)
if(BUILD_TIMIDITYSDL)
    add_subdirectory(libtimidity-sdl)
endif()

option(BUILD_MODPLUG "Enable building of libModPlug" ON)
if(BUILD_MODPLUG)
    set(MODPLUG_BUILD_SHARED ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    set(MODPLUG_BUILD_STATIC ${CODECS_BUILD_STATIC} CACHE BOOL "" FORCE)
    mark_as_advanced(MODPLUG_BUILD_SHARED MODPLUG_BUILD_STATIC)
    add_subdirectory(libmodplug)
    unset(MODPLUG_BUILD_SHARED)
    unset(MODPLUG_BUILD_STATIC)
endif()

option(BUILD_LIBXMP "Enable building of libXMP" ON)
if(BUILD_LIBXMP AND ${CMAKE_VERSION} VERSION_LESS "3.4")
    messages(WARNING "To build libXMP, the CMake 3.4 or newer is required. The libXMP component will be disabled...")
elseif(BUILD_LIBXMP)
    set(BUILD_SHARED ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    set(BUILD_STATIC ${CODECS_BUILD_STATIC} CACHE BOOL "" FORCE)
    set(LIBXMP_PIC ${ENABLE_FPIC} CACHE BOOL "" FORCE)
    mark_as_advanced(BUILD_SHARED BUILD_STATIC LIBXMP_PIC)
    add_subdirectory(libxmp)
    unset(LIBXMP_PIC)
    unset(BUILD_SHARED)
    unset(BUILD_STATIC)
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

option(BUILD_WAVPACK "Enable building of WavPack" ON)
if(BUILD_WAVPACK)
    set(WAVPACK_BUILD_DOCS OFF CACHE BOOL "" FORCE)
    set(WAVPACK_INSTALL_DOCS OFF CACHE BOOL "" FORCE)
    set(WAVPACK_BUILD_PROGRAMS OFF CACHE BOOL "" FORCE)
    set(WAVPACK_ENABLE_LIBCRYPTO OFF CACHE BOOL "" FORCE)
    set(WAVPACK_BUILD_WINAMP_PLUGIN OFF CACHE BOOL "" FORCE)
    set(WAVPACK_BUILD_COOLEDIT_PLUGIN OFF CACHE BOOL "" FORCE)
    set(BUILD_SHARED_LIBS ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    set(BUILD_TESTING OFF CACHE BOOL "" FORCE)
    if(NINTENDO_3DS OR NINTENDO_WII OR NINTENDO_WIIU)
        set(WAVPACK_ENABLE_THREADS OFF CACHE BOOL "" FORCE)
    endif()
    if(NINTENDO_WII OR NINTENDO_WIIU)
        set(WAVPACK_ENABLE_ASM OFF CACHE BOOL "" FORCE)
    endif()
    if(NINTENDO_3DS)
        set(WAVPACK_ENABLE_DSD OFF CACHE BOOL "" FORCE)
    endif()
    add_subdirectory(WavPack)
    # Avoid the Windows version to have "wavpackdll" name
    set_target_properties(wavpack PROPERTIES OUTPUT_NAME wavpack)
    if(ENABLE_FPIC)
        set_target_properties(wavpack PROPERTIES COMPILE_FLAGS "-fPIC")
    endif()
    unset(WAVPACK_BUILD_DOCS)
    unset(WAVPACK_INSTALL_DOCS)
    unset(WAVPACK_BUILD_PROGRAMS)
    unset(WAVPACK_ENABLE_LIBCRYPTO)
    unset(WAVPACK_BUILD_WINAMP_PLUGIN)
    unset(WAVPACK_BUILD_COOLEDIT_PLUGIN)
    unset(WAVPACK_ENABLE_THREADS)
    unset(WAVPACK_ENABLE_ASM)
    unset(WAVPACK_ENABLE_DSD)
    unset(BUILD_TESTING)
    unset(BUILD_SHARED_LIBS)
endif()

option(BUILD_FLUIDLITE "Enable building of FluidLite" ON)
if(BUILD_FLUIDLITE)
    # if(NOT BUILD_OGG_VORBIS) # // Enable in condition of SF3 support usage
    #     message(FATAL_ERROR "You should enable the build of the Vorbis to get use the FluidLite")
    # endif()
    set(FLUIDLITE_BUILD_STATIC ${CODECS_BUILD_STATIC} CACHE BOOL "" FORCE)
    set(FLUIDLITE_BUILD_SHARED ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    set(AUDIOCODECS_FLUIDLITE_ENABLE_SF3 ON)

    if(BUILD_OGG_VORBIS)
        set(FLUIDLITE_USE_STB_VORBIS_DEFAULT OFF)
    else()
        set(FLUIDLITE_USE_STB_VORBIS_DEFAULT ON)
    endif()

    option(FLUIDLITE_USE_STB_VORBIS "Use the stb-vorbis for the FluidLite instead of the Xiph Vorbis" ${FLUIDLITE_USE_STB_VORBIS_DEFAULT})

    set(AUDIOCODECS_FLUIDLITE_ENABLE_STB_VORBIS ${FLUIDLITE_USE_STB_VORBIS})
    add_subdirectory(FluidLite)
    if(FLUIDLITE_BUILD_STATIC AND BUILD_OGG_VORBIS)
        add_dependencies(fluidlite-static ogg vorbis vorbisfile)
    endif()
    if(FLUIDLITE_BUILD_SHARED AND BUILD_OGG_VORBIS)
        add_dependencies(fluidlite ogg vorbis vorbisfile)
    endif()
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
    set(libADLMIDI_STATIC ${CODECS_BUILD_STATIC} CACHE BOOL "" FORCE)
    set(libADLMIDI_SHARED ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    mark_as_advanced(libADLMIDI_SHARED libADLMIDI_STATIC)

    if(DISABLE_HEAVY_SYNTHS)
        set(USE_NUKED_EMULATOR OFF CACHE BOOL "" FORCE)
        set(USE_OPAL_EMULATOR OFF CACHE BOOL "" FORCE)
        set(USE_JAVA_EMULATOR OFF CACHE BOOL "" FORCE)
        set(USE_ESFMU_EMULATOR OFF CACHE BOOL "" FORCE)
        set(USE_YMFM_EMULATOR OFF CACHE BOOL "" FORCE)
        set(USE_NUKED_OPL2_LLE_EMULATOR OFF CACHE BOOL "" FORCE)
        set(USE_NUKED_OPL3_LLE_EMULATOR OFF CACHE BOOL "" FORCE)
        mark_as_advanced(USE_NUKED_EMULATOR USE_OPAL_EMULATOR USE_JAVA_EMULATOR USE_ESFMU_EMULATOR USE_YMFM_EMULATOR USE_NUKED_OPL2_LLE_EMULATOR USE_NUKED_OPL3_LLE_EMULATOR)
    endif()

    add_subdirectory(libADLMIDI)

    unset(libADLMIDI_STATIC)
    unset(libADLMIDI_SHARED)
    if(DISABLE_HEAVY_SYNTHS)
        unset(USE_NUKED_EMULATOR)
        unset(USE_OPAL_EMULATOR)
        unset(USE_JAVA_EMULATOR)
        unset(USE_ESFMU_EMULATOR)
        unset(USE_YMFM_EMULATOR)
        unset(USE_NUKED_OPL2_LLE_EMULATOR)
        unset(USE_NUKED_OPL3_LLE_EMULATOR)
    endif()
endif()

option(BUILD_OPNMIDI "Enable building of libOPNMIDI" ON)
if(BUILD_OPNMIDI)
    set(libOPNMIDI_STATIC ${CODECS_BUILD_STATIC} CACHE BOOL "" FORCE)
    set(libOPNMIDI_SHARED ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    set(USE_VGM_FILE_DUMPER OFF CACHE BOOL "" FORCE)
    set(WITH_MIDI2VGM OFF CACHE BOOL "" FORCE)
    mark_as_advanced(libOPNMIDI_STATIC libOPNMIDI_SHARED USE_VGM_FILE_DUMPER WITH_MIDI2VGM)

    if(DISABLE_HEAVY_SYNTHS)
        set(USE_MAME_EMULATOR OFF CACHE BOOL "" FORCE)
        set(USE_NUKED_EMULATOR OFF CACHE BOOL "" FORCE)
        set(USE_YMFM_EMULATOR OFF CACHE BOOL "" FORCE)
        mark_as_advanced(USE_MAME_EMULATOR USE_NUKED_EMULATOR USE_YMFM_EMULATOR)
    endif()

    add_subdirectory(libOPNMIDI)

    unset(libOPNMIDI_STATIC)
    unset(libOPNMIDI_SHARED)
    unset(USE_VGM_FILE_DUMPER)
    unset(WITH_MIDI2VGM)
    if(DISABLE_HEAVY_SYNTHS)
        unset(USE_MAME_EMULATOR)
        unset(USE_NUKED_EMULATOR)
        unset(USE_YMFM_EMULATOR)
    endif()
endif()

option(BUILD_EDMIDI "Enable building of libEDMIDI" ON)
if(BUILD_EDMIDI)
    set(libEDMIDI_STATIC ${CODECS_BUILD_STATIC} CACHE BOOL "" FORCE)
    set(libEDMIDI_SHARED ${CODECS_BUILD_SHARED} CACHE BOOL "" FORCE)
    mark_as_advanced(libEDMIDI_STATIC libEDMIDI_SHARED)
    add_subdirectory(libEDMIDI)
    unset(libEDMIDI_STATIC)
    unset(libEDMIDI_SHARED)
endif()
