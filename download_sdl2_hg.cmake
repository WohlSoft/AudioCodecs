
# This file downloads, configures and build SDL2 from official HG dependencies package.
#
# Output Variables:
# SDL2_INSTALL_DIR			    The install directory
# SDL2_REPOSITORY_PATH  		The reposotory directory

# Require ExternalProject and GIT!
include(ExternalProject)
find_package(Git REQUIRED)

# Posttible Input Vars:
# <None>

option(WITH_SDL2_WASAPI "Enable WASAPI audio output support for Windows build of SDL2" ON)
if(WIN32)
    message("== AudioCodecs: WITH_SDL2_WASAPI = ${WITH_SDL2_WASAPI}")
    set(SDL2_WASAPI_FLAG "-DWASAPI=${WITH_SDL2_WASAPI}")
endif()

# SET OUTPUT VARS
# set(SDL2_INSTALL_DIR ${CMAKE_BINARY_DIR}/external/install)
set(SDL2_INSTALL_DIR ${CMAKE_BINARY_DIR})
set(SDL2_REPOSITORY_PATH ${SDL2_INSTALL_DIR})

set(SDL2_CMAKE_FPIC_FLAG "")
if(NOT WIN32)
    set(SDL2_CMAKE_FPIC_FLAG "-DSDL_STATIC_PIC=ON")
endif()

set(SDL2_HG_BRANCH "default" CACHE STRING "HG branch for SDL2 (official Mercurial mainstream repo)")
set(SDL2_GIT_BRANCH "origin/master" CACHE STRING "GIT branch for SDL2 (unofficial Git mirror)")

# Remove this workaround when the tarball is symlink-free for better Windows compatibility.
# In the meantime, use the auto-tracking SDL2 Git repo:
set(SDL2_PROJECT_BRANCH)
if(USE_LOCAL_SDL2)
    message("== SDL2 will be built from a local copy")
elseif(WIN32 AND MINGW)
    set(SDL_SOURCE_PATH_GIT "https://github.com/spurious/SDL-mirror.git")
    message("== SDL2 will be downloaded as unofficial GIT repository from '${SDL2_GIT_BRANCH}' revision")
    set(SDL2_PROJECT_BRANCH GIT_TAG "${SDL2_GIT_BRANCH}")
else()
    set(SDL_SOURCE_PATH_URL "https://hg.libsdl.org/SDL/archive/${SDL2_HG_BRANCH}.tar.bz2")
    message("== SDL2 will be downloaded from official Mercurial as TAR-BZ2 archive from '${SDL2_HG_BRANCH}' revision")
endif()

set(APPLE_FLAGS)
if(APPLE)
    set(APPLE_FLAGS "-DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif()

if(USE_LOCAL_SDL2)
    ExternalProject_Add(
        SDL2HG
        PREFIX ${CMAKE_BINARY_DIR}/external/SDL2
        DOWNLOAD_COMMAND ""
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/SDL2/
        CMAKE_ARGS
            "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
            "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
            "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}"
            "-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
            -DSNDIO=OFF
            -DSDL_SHARED=${BUILD_SDL2_SHARED}
            -DSDL_STATIC=${BUILD_SDL2_STATIC}
            -DCMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
            ${SDL2_CMAKE_FPIC_FLAG}
            ${SDL2_WASAPI_FLAG}
            ${APPLE_FLAGS}
    )
else()
    ExternalProject_Add(
        SDL2HG
        PREFIX ${CMAKE_BINARY_DIR}/external/SDL2
        GIT_REPOSITORY ${SDL_SOURCE_PATH_GIT}
        ${SDL2_PROJECT_BRANCH}
        URL ${SDL_SOURCE_PATH_URL}
        CMAKE_ARGS
            "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
            "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
            "-DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}"
            "-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
            -DSNDIO=OFF
            -DSDL_SHARED=${BUILD_SDL2_SHARED}
            -DSDL_STATIC=${BUILD_SDL2_STATIC}
            -DCMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
            ${SDL2_CMAKE_FPIC_FLAG}
            ${SDL2_WASAPI_FLAG}
            ${APPLE_FLAGS}
    )
endif()


# Install built SDL's headers and libraries into actual installation directory
install(
    CODE "file( GLOB builtSdl2Heads \"${CMAKE_BINARY_DIR}/include/SDL2/*.h\" )"
    CODE "file( INSTALL \${builtSdl2Heads} DESTINATION \"${CMAKE_INSTALL_PREFIX}/include/SDL2\" )"
    CODE "file( GLOB builtSdlLibs \"${CMAKE_BINARY_DIR}/lib/*SDL2*\" )"
    CODE "file( INSTALL \${builtSdlLibs} DESTINATION \"${CMAKE_INSTALL_PREFIX}/lib\" )"
    CODE "file( GLOB builtSdlCMakeConfs \"${CMAKE_BINARY_DIR}/lib/cmake/SDL2/*\" )"
    CODE "file( INSTALL \${builtSdlCMakeConfs} DESTINATION \"${CMAKE_INSTALL_PREFIX}/lib/cmake/SDL2\" )"
    CODE "file( GLOB builtSdlPkgConfs \"${CMAKE_BINARY_DIR}/lib/pkgconfig/sdl2.pc\" )"
    CODE "file( INSTALL \${builtSdlPkgConfs} DESTINATION \"${CMAKE_INSTALL_PREFIX}/lib/pkgconfig\" )"
    CODE "file( GLOB builtSdlBins \"${CMAKE_BINARY_DIR}/bin/*SDL2*\" )"
    CODE "file( INSTALL \${builtSdlBins} DESTINATION \"${CMAKE_INSTALL_PREFIX}/bin\" )"
)
