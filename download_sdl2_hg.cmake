
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

# SET OUTPUT VARS
# set(SDL2_INSTALL_DIR ${CMAKE_BINARY_DIR}/external/install)
set(SDL2_INSTALL_DIR ${CMAKE_BINARY_DIR})
set(SDL2_REPOSITORY_PATH ${SDL2_INSTALL_DIR})

set(SDL2_CMAKE_FPIC_FLAG "")
if(NOT WIN32)
    set(SDL2_CMAKE_FPIC_FLAG "-DSDL_STATIC_PIC=ON")
else()
    set(SDL2_NOWASAPI "-DWASAPI=OFF")
endif()

ExternalProject_Add(
    SDL2HG
    PREFIX ${CMAKE_BINARY_DIR}/external/SDL2
    # URL https://hg.libsdl.org/SDL/archive/default.tar.bz2
    # Re-enable when the tarball is symlink-free for better Windows compatibility.
    # Use git in the meantime until the tarball is fixed:
    DOWNLOAD_COMMAND git clone --depth=1 https://github.com/spurious/SDL-mirror.git SDL2HG
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        -DCMAKE_INSTALL_PREFIX=${CMAKE_BINARY_DIR}
        -DSNDIO=OFF
        -DSDL_SHARED=${SHARED}
        -DCMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
        ${SDL2_CMAKE_FPIC_FLAG}
        ${SDL2_NOWASAPI} # WASAPI, No way!
)

# Install built SDL's headers and libraries into actual installation directory
install(
    CODE "file( GLOB builtSdl2Heads \"${CMAKE_BINARY_DIR}/include/SDL2/*.h\" )"
    CODE "file( INSTALL \${builtSdl2Heads} DESTINATION \"${CMAKE_INSTALL_PREFIX}/include/SDL2\" )"
    CODE "file( GLOB builtSdlLibs \"${CMAKE_BINARY_DIR}/lib/*SDL2*\" )"
    CODE "file( INSTALL \${builtSdlLibs} DESTINATION \"${CMAKE_INSTALL_PREFIX}/lib\" )"
    CODE "file( GLOB builtSdlBins \"${CMAKE_BINARY_DIR}/bin/*\" )"
    CODE "file( INSTALL \${builtSdlBins} DESTINATION \"${CMAKE_INSTALL_PREFIX}/bin\" )"
)
