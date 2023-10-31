
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

set(SDL2_GIT_BRANCH "origin/main" CACHE STRING "GIT branch for SDL2 (Official Git mainstream repository)")

# Remove this workaround when the tarball is symlink-free for better Windows compatibility.
# In the meantime, use the auto-tracking SDL2 Git repo:
set(SDL2_PROJECT_BRANCH)
if(USE_LOCAL_SDL2)
    message("== SDL2 will be built from a local copy")
else()
    set(SDL_SOURCE_PATH_GIT "https://github.com/libsdl-org/SDL.git")
    message("== SDL2 will be downloaded as official GIT repository from '${SDL2_GIT_BRANCH}' revision")
    set(SDL2_PROJECT_BRANCH GIT_TAG "${SDL2_GIT_BRANCH}")
endif()

set(APPLE_FLAGS)
if(APPLE)
    set(APPLE_FLAGS
        "-DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET}"
        "-DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}"
    )
endif()

set(EMSCRIPTEN_FLAGS)
if(EMSCRIPTEN)
    set(EMSCRIPTEN_FLAGS
        "-DEXTRA_CFLAGS=-s USE_SDL=0"
    )
endif()

set(ANDROID_FLAGS)
if(ANDROID)
    set(ANDROID_FLAGS
        "-DANDROID_ABI=${ANDROID_ABI}"
        "-DANDROID_NDK=${ANDROID_NDK}"
        "-DANDROID_STL=${ANDROID_STL}"
        "-DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}"
        "-DANDROID_PLATFORM=${ANDROID_PLATFORM}"
        "-DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN}"
        "-DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL}"
        "-DCMAKE_MAKE_PROGRAM=${CMAKE_MAKE_PROGRAM}"
        "-DANDROID_ARM_NEON=${ANDROID_ARM_NEON}"
    )
endif()

set(SDL2_CMAKE_NOSIMD_FLAGS)
if(DISABLE_SIMD)
    set(SDL2_CMAKE_NOSIMD_FLAGS
        "-DSDL_SSEMATH=OFF"
        "-DSDL_SSE=OFF"
        "-DSDL_SSE2=OFF"
        "-DSDL_SSE3=OFF"
        "-DSDL_MMX=OFF"
        "-DSDL_3DNOW=OFF"
        "-DSDL_ALTIVEC=OFF"
        "-DSDL_ARMSIMD=OFF"
        "-DSDL_ARMNEON=OFF"
    )
endif()

if(USE_USE_NDK_MAKE)
    if(CMAKE_BUILD_TYPE_LOWER STREQUAL "debug")
        set(SDL2_DEBUG_SUFFIX "d")
    else()
        set(SDL2_DEBUG_SUFFIX "")
    endif()
    ExternalProject_Add(SDL2_Local_Build
        PREFIX ${CMAKE_BINARY_DIR}/external/SDL2-NDK
        DOWNLOAD_COMMAND ""
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/SDL2/
        CONFIGURE_COMMAND ""
        INSTALL_COMMAND ""
        BUILD_COMMAND ${ANDROID_NDK}/ndk-build -C ${CMAKE_SOURCE_DIR}/SDL2 SDL2 SDL2_static SDL2_main
        NDK_PROJECT_PATH=null
        APP_BUILD_SCRIPT=${CMAKE_SOURCE_DIR}/SDL2/Android.mk
        # NDK_OUT=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/../..
        NDK_OUT=${CMAKE_BINARY_DIR}/lib-ndk-out/
        # NDK_LIBS_OUT=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/..
        NDK_LIBS_OUT=${CMAKE_BINARY_DIR}/lib-ndk-libs-out/
        APP_ABI=${ANDROID_ABI}
        NDK_ALL_ABIS=${ANDROID_ABI}
        APP_PLATFORM=${ANDROID_PLATFORM}
        BUILD_BYPRODUCTS
            "${CMAKE_BINARY_DIR}/lib-ndk-out/local/${ANDROID_ABI}/libSDL2.a"
            "${CMAKE_BINARY_DIR}/lib-ndk-out/local/${ANDROID_ABI}/libSDL2main.a"
            "${CMAKE_BINARY_DIR}/lib-ndk-out/local/${ANDROID_ABI}/libSDL2.so"
            "${CMAKE_BINARY_DIR}/lib-ndk-out/local/${ANDROID_ABI}/libcpufeatures.a"
    )
    add_custom_target(SDL2HG ALL
        COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/include"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_BINARY_DIR}/include/SDL2"
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_SOURCE_DIR}/SDL2/include/*.h" "${CMAKE_BINARY_DIR}/include/SDL2"
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/lib-ndk-out/local/${ANDROID_ABI}/libSDL2.so" "${CMAKE_BINARY_DIR}/lib/libSDL2.so"
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/lib-ndk-out/local/${ANDROID_ABI}/libSDL2.a" "${CMAKE_BINARY_DIR}/lib/libSDL2${SDL2_DEBUG_SUFFIX}.a"
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/lib-ndk-out/local/${ANDROID_ABI}/libSDL2main.a" "${CMAKE_BINARY_DIR}/lib/libSDL2main${SDL2_DEBUG_SUFFIX}.a"
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/lib-ndk-out/local/${ANDROID_ABI}/libcpufeatures.a" "${CMAKE_BINARY_DIR}/lib/libcpufeatures${SDL2_DEBUG_SUFFIX}.a"
        DEPENDS SDL2_Local_Build
        BYPRODUCTS
            "${CMAKE_BINARY_DIR}/lib/libSDL2.so"
            "${CMAKE_BINARY_DIR}/lib/libSDL2${SDL2_DEBUG_SUFFIX}.a"
            "${CMAKE_BINARY_DIR}/lib/libSDL2main${SDL2_DEBUG_SUFFIX}.a"
            "${CMAKE_BINARY_DIR}/lib/libcpufeatures${SDL2_DEBUG_SUFFIX}.a"
    )

elseif(USE_LOCAL_SDL2)
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
            -DCMAKE_POSITION_INDEPENDENT_CODE=${ENABLE_FPIC}
            -DSDL_STATIC_PIC=${ENABLE_FPIC}
            -DSDL_SHARED=${BUILD_SDL2_SHARED}
            -DSDL_STATIC=${BUILD_SDL2_STATIC}
            -DSDL_CMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
            -DCMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
            ${SDL2_CMAKE_FPIC_FLAG}
            ${SDL2_WASAPI_FLAG}
            ${SDL2_CMAKE_NOSIMD_FLAGS}
            ${APPLE_FLAGS}
            ${ANDROID_FLAGS}
            ${EMSCRIPTEN_FLAGS}
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
            -DCMAKE_POSITION_INDEPENDENT_CODE=${ENABLE_FPIC}
            -DSDL_STATIC_PIC=${ENABLE_FPIC}
            -DSDL_SHARED=${BUILD_SDL2_SHARED}
            -DSDL_STATIC=${BUILD_SDL2_STATIC}
            -DSDL_CMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
            -DCMAKE_DEBUG_POSTFIX=${CMAKE_DEBUG_POSTFIX}
            ${SDL2_CMAKE_FPIC_FLAG}
            ${SDL2_WASAPI_FLAG}
            ${APPLE_FLAGS}
            ${ANDROID_FLAGS}
            ${EMSCRIPTEN_FLAGS}
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
