cmake_minimum_required (VERSION 2.8.11)
project (libmpg123 C)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

set(CMAKE_C_STANDARD 99)

include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckLibraryExists)

include(${CMAKE_CURRENT_SOURCE_DIR}/config.tests/TargetArch.cmake)

target_architecture(TARGET_PROCESSOR)

message("System processor is [${CMAKE_SYSTEM_PROCESSOR}]")
message("Target processor is [${TARGET_PROCESSOR}]")
if(TARGET_PROCESSOR MATCHES "x86_64|AMD64" OR TARGET_PROCESSOR MATCHES "^i.86$")
    message("X86 detected")
    set(OPUS_X86_ARCHITECTURE 1)
elseif(${TARGET_PROCESSOR} MATCHES "arm.*")
    message("ARM detected")
    set(ABI_ALIGN_FUN 1)
    message(WARNING "BE CAREFUL, ARM SUPPORT IN CMAKE BUILD HERE IS WIP!!!")
else()
    message(WARNING "Unsupported CPU architecture detected! [${TARGET_PROCESSOR}]")
endif()

set(PACKAGE_NAME "mpg123")
set(PACKAGE_VERSION "1.25.12")

set(PACKAGE_STRING "\"${PACKAGE_NAME} v.${PACKAGE_VERSION}\"")
set(PACKAGE_NAME "\"${PACKAGE_NAME}\"")
set(PACKAGE_VERSION "\"${PACKAGE_VERSION}\"")

check_include_files(alloca.h HAVE_ALLOCA_H)
if(HAVE_ALLOCA_H)
    add_definitions(-DUSE_ALLOCA=1)
endif()
check_include_file(dlfcn.h HAVE_DLFCN_H)
check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(memory.h HAVE_MEMORY_H)
check_include_file(dirent.h HAVE_DIRENT_H)
check_include_file(stdint.h HAVE_STDINT_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_files("stdlib.h;time.h;math.h;sys/stat.h;signal.h" HAVE_STDC_HEADERS)
if(HAVE_STDC_HEADERS)
    set(STDC_HEADERS 1)
endif()
if(NOT MSVC)
    set(CMAKE_REQUIRED_LIBRARIES m)
endif()
check_symbol_exists(lrint "math.h;tgmath.h" HAVE_LRINT)
check_symbol_exists(lrintf "math.h;tgmath.h" HAVE_LRINTF)
check_function_exists(__malloc_hook HAVE___MALLOC_HOOK)
check_function_exists(strerror HAVE_STRERROR)


foreach(INLINE_KEYWORD "inline" "__inline__" "__inline")
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.tests/c99/inline.c.in ${CMAKE_BINARY_DIR}/compile_tests/inline_${INLINE_KEYWORD}.c @ONLY)
    unset(HAS_RESTRICTC)
    try_compile(HAS_INLINEC
        ${CMAKE_BINARY_DIR}/compile_tests
        ${CMAKE_BINARY_DIR}/compile_tests/inline_${INLINE_KEYWORD}.c
    )
    unset(inline)
    if(HAS_INLINEC)
        if(NOT INLINE_KEYWORD STREQUAL "inline")
            set(inline "${INLINE_KEYWORD}")
        endif()
        message("HAS \"${INLINE_KEYWORD}\"")
        break()
    endif()
endforeach()

try_compile(HAS_CONST_TYPE
    ${CMAKE_BINARY_DIR}/compile_tests
    ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/c99/const.c
)
if(NOT HAS_CONST_TYPE)
    set(const 1)
else()
    message("HAS const")
endif()

# FIXME: Make the proper detection of this!
set(LFS_ALIAS_BITS 32)
set(_FILE_OFFSET_BITS 32)
set(lfs_alias_t off_t)

set(OPT_GENERIC 1)
set(OPT_GENERIC 1)

configure_file(config.h.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/config/config.h)
configure_file(src/libmpg123/mpg123.h.in ${CMAKE_CURRENT_BINARY_DIR}/config/mpg123.h)

set(LIBMPG123_SRC)
set(LIBMPG123_DEFS)

list(APPEND LIBMPG123_DEFS
    -DOPT_GENERIC -DREAL_IS_FLOAT
)

list(APPEND LIBMPG123_SRC
    src/compat/compat.c
    src/compat/compat_str.c
)

list(APPEND LIBMPG123_SRC
#    src/libmpg123/check_neon.S
    src/libmpg123/dct36_3dnowext.S
    src/libmpg123/dct36_3dnow.S
    src/libmpg123/dct36_avx.S
#    src/libmpg123/dct36_neon64.S
#    src/libmpg123/dct36_neon.S
    src/libmpg123/dct36_sse.S
    src/libmpg123/dct36_x86_64.S
    src/libmpg123/dct64_3dnowext.S
    src/libmpg123/dct64_3dnow.S
#    src/libmpg123/dct64_altivec.c
    src/libmpg123/dct64_avx_float.S
    src/libmpg123/dct64_avx.S
    src/libmpg123/dct64.c
#    src/libmpg123/dct64_i386.c
#    src/libmpg123/dct64_i486.c
    src/libmpg123/dct64_mmx.S
#    src/libmpg123/dct64_neon64_float.S
#    src/libmpg123/dct64_neon64.S
#    src/libmpg123/dct64_neon_float.S
#    src/libmpg123/dct64_neon.S
    src/libmpg123/dct64_sse_float.S
    src/libmpg123/dct64_sse.S
    src/libmpg123/dct64_x86_64_float.S
    src/libmpg123/dct64_x86_64.S
    src/libmpg123/dither.c
    src/libmpg123/equalizer_3dnow.S
    src/libmpg123/equalizer.c
    src/libmpg123/feature.c
    src/libmpg123/format.c
    src/libmpg123/frame.c
#    src/libmpg123/getcpuflags_arm.c
    src/libmpg123/getcpuflags.S
    src/libmpg123/getcpuflags_x86_64.S
    src/libmpg123/icy2utf8.c
    src/libmpg123/icy.c
    src/libmpg123/id3.c
    src/libmpg123/index.c
    src/libmpg123/layer1.c
    src/libmpg123/layer2.c
    src/libmpg123/layer3.c
    src/libmpg123/lfs_alias.c
    src/libmpg123/lfs_wrap.c
    src/libmpg123/libmpg123.c
    src/libmpg123/ntom.c
    src/libmpg123/optimize.c
    src/libmpg123/parse.c
    src/libmpg123/readers.c
    src/libmpg123/stringbuf.c
    src/libmpg123/synth_3dnowext.S
    src/libmpg123/synth_3dnow.S
    src/libmpg123/synth_8bit.c
#    src/libmpg123/synth_altivec.c
#    src/libmpg123/synth_arm_accurate.S
#    src/libmpg123/synth_arm.S
    src/libmpg123/synth.c
#    src/libmpg123/synth_i486.c
    src/libmpg123/synth_i586_dither.S
    src/libmpg123/synth_i586.S
    src/libmpg123/synth_mmx.S
#    src/libmpg123/synth_neon64_accurate.S
#    src/libmpg123/synth_neon64_float.S
#    src/libmpg123/synth_neon64.S
#    src/libmpg123/synth_neon64_s32.S
#    src/libmpg123/synth_neon_accurate.S
#    src/libmpg123/synth_neon_float.S
#    src/libmpg123/synth_neon.S
#    src/libmpg123/synth_neon_s32.S
    src/libmpg123/synth_real.c
    src/libmpg123/synth_s32.c
    src/libmpg123/synth_sse_accurate.S
    src/libmpg123/synth_sse_float.S
    src/libmpg123/synth_sse.S
    src/libmpg123/synth_sse_s32.S
    src/libmpg123/synth_stereo_avx_accurate.S
    src/libmpg123/synth_stereo_avx_float.S
    src/libmpg123/synth_stereo_avx.S
    src/libmpg123/synth_stereo_avx_s32.S
#    src/libmpg123/synth_stereo_neon64_accurate.S
#    src/libmpg123/synth_stereo_neon64_float.S
#    src/libmpg123/synth_stereo_neon64.S
#    src/libmpg123/synth_stereo_neon64_s32.S
#    src/libmpg123/synth_stereo_neon_accurate.S
#    src/libmpg123/synth_stereo_neon_float.S
#    src/libmpg123/synth_stereo_neon.S
#    src/libmpg123/synth_stereo_neon_s32.S
    src/libmpg123/synth_stereo_sse_accurate.S
    src/libmpg123/synth_stereo_sse_float.S
    src/libmpg123/synth_stereo_sse_s32.S
    src/libmpg123/synth_stereo_x86_64_accurate.S
    src/libmpg123/synth_stereo_x86_64_float.S
    src/libmpg123/synth_stereo_x86_64.S
    src/libmpg123/synth_stereo_x86_64_s32.S
    src/libmpg123/synth_x86_64_accurate.S
    src/libmpg123/synth_x86_64_float.S
    src/libmpg123/synth_x86_64.S
    src/libmpg123/synth_x86_64_s32.S
    src/libmpg123/tabinit.c
    src/libmpg123/tabinit_mmx.S
    src/libmpg123/testcpu.c
)

add_library(mpg123 STATIC ${LIBMPG123_SRC})
target_compile_definitions(mpg123 PRIVATE ${LIBMPG123_DEFS})

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/src/
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libmpg123
    ${CMAKE_CURRENT_SOURCE_DIR}/src/compat
    ${CMAKE_CURRENT_BINARY_DIR}/config
)

install(TARGETS mpg123
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/config/mpg123.h
        src/libmpg123/fmt123.h
        DESTINATION include/)

