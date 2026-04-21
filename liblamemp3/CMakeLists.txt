cmake_minimum_required(VERSION 3.2...3.10)
project(libLAME VERSION 3.100 LANGUAGES C)

set(CMAKE_C_STANDARD 99)

if(POLICY CMP0075) # Include file check macros honor CMAKE_REQUIRED_LIBRARIES.
    cmake_policy(SET CMP0075 NEW)
endif()

include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckLibraryExists)
include(CheckTypeSize)
include(TestBigEndian)
include(CheckLanguage)

#set(AUDIO_CODECS_KEEP_SSE ON)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

if(NOT MSVC)
    ac_add_c_warning_flag("all" ALL)
    ac_add_c_warning_flag("extra" EXTRA)
    ac_add_c_warning_flag("strict-prototypes" STRICT_PROTOTYPES)
    ac_disable_c_warning_flag("unused-variable" UNUSED_VARIABLE)
    ac_disable_c_warning_flag("unused-parameter" UNUSED_PARAMETER)
    ac_disable_c_warning_flag("absolute-value" ABSOLUTE_VALUE)
    ac_disable_c_warning_flag("unused-but-set-variable" UNUSED_BUT_SET_VARIABLE)
    ac_disable_c_warning_flag("shift-negative-value" SHIFT_NEGATIVE_VALUE)
    ac_disable_c_warning_flag("shadow" SHADOW)
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/config.tests/TargetArch.cmake)

target_architecture(TARGET_PROCESSOR)

message("System processor is [${CMAKE_SYSTEM_PROCESSOR}]")
message("Target processor is [${TARGET_PROCESSOR}]")
if(TARGET_PROCESSOR MATCHES "x86_64|AMD64" OR TARGET_PROCESSOR MATCHES "^i.86$")
    message("X86/X86_64 detected")
endif()

set(PACKAGE_NAME "mp3lame")
set(PACKAGE_VERSION "3.100")

set(PACKAGE_STRING "\"${PACKAGE_NAME} v.${PACKAGE_VERSION}\"")
set(PACKAGE_NAME "\"${PACKAGE_NAME}\"")
set(PACKAGE_VERSION "\"${PACKAGE_VERSION}\"")

option(DECODE_ON_THE_FLY "Allow to compute a more accurate replaygain value" ON)
if(DECODE_ON_THE_FLY)
    set(DECODE_ON_THE_FLY 1)
endif()

check_include_files(alloca.h HAVE_ALLOCA_H)
if(HAVE_ALLOCA_H)
    add_definitions(-DUSE_ALLOCA=1)
endif()
check_include_file(dlfcn.h HAVE_DLFCN_H)
# FIXME: Add libefence detection!
check_include_file(errno.h HAVE_ERRNO_H)
check_include_file(fcntl.h HAVE_FCNTL_H)
check_symbol_exists(gettimeofday "sys/time.h" HAVE_GETTIMEOFDAY)
check_include_file(iconv.h HAVE_ICONV)
check_include_file(stdint.h HAVE_STDINT_H)
if(HAVE_STDINT_H)
    set(HAVE_INT8_T 1)
    set(HAVE_INT16_T 1)
    set(HAVE_INT32_T 1)
    set(HAVE_INT64_T 1)
    set(HAVE_UINT8_T 1)
    set(HAVE_UINT16_T 1)
    set(HAVE_UINT32_T 1)
    set(HAVE_UINT64_T 1)
endif()
check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(memory.h HAVE_MEMORY_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(limits.h HAVE_LIMITS_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/time.h HAVE_SYS_TIME_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_files("sys/time.h;time.h" TIME_WITH_SYS_TIME)
check_include_files("stdlib.h;time.h;math.h;sys/stat.h;signal.h" HAVE_STDC_HEADERS)
if(HAVE_STDC_HEADERS)
    set(STDC_HEADERS 1)
endif()

if(NOT MSVC)
    check_library_exists(m sin "" HAVE_LIBM)
    set(CMAKE_REQUIRED_LIBRARIES m)
endif()

set(LAME_LIBRARY_BUILD 1)
check_type_size(double SIZEOF_DOUBLE)
check_type_size(float SIZEOF_FLOAT)
check_type_size(int SIZEOF_INT)
check_type_size(long SIZEOF_LONG)
check_type_size("long double" SIZEOF_LONG_DOUBLE)
check_type_size("long long" SIZEOF_LONG_LONG)
check_type_size(short SIZEOF_SHORT)
check_type_size("unsigned int" SIZEOF_UNSIGNED_INT)
check_type_size("unsigned long" SIZEOF_UNSIGNED_LONG)
check_type_size("unsigned long long" SIZEOF_UNSIGNED_LONG_LONG)
check_type_size("unsigned short" SIZEOF_UNSIGNED_SHORT)
test_big_endian(WORDS_BIGENDIAN)

if(CMAKE_BUILD_TYPE_LOWER STREQUAL "debug")
    check_include_file(dmalloc.h WITH_DMALLOC)
endif()

set(HAVE_LONG_DOUBLE 1)
if(SIZEOF_LONG_DOUBLE GREATER SIZEOF_DOUBLE)
    set(HAVE_LONG_DOUBLE_WIDER 1)
endif()

check_include_files(alloca.h HAVE_ALLOCA_H)
if(HAVE_ALLOCA_H)
    set(HAVE_ALLOCA 1)
endif()

if(NOT MSVC)
    try_compile(HAVE_ALLOCA
        ${CMAKE_BINARY_DIR}/compile_tests
        ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/c99/alloca.c
    )
else()
    set(HAVE_ALLOCA 1)
endif()

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

configure_file(config.h.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/config/config.h)

set(LIBLAME_SRC
    libmp3lame/bitstream.c
    libmp3lame/bitstream.h
    libmp3lame/encoder.c
    libmp3lame/encoder.h
    libmp3lame/fft.c
    libmp3lame/fft.h
    libmp3lame/gain_analysis.c
    libmp3lame/gain_analysis.h
    libmp3lame/id3tag.c
    libmp3lame/id3tag.h
    libmp3lame/l3side.h
    libmp3lame/lame-analysis.h
    libmp3lame/lame.c
    libmp3lame/lameerror.h
    libmp3lame/lame_global_flags.h
    libmp3lame/machine.h
    libmp3lame/mpglib_interface.c
    libmp3lame/newmdct.c
    libmp3lame/newmdct.h
    libmp3lame/presets.c
    libmp3lame/psymodel.c
    libmp3lame/psymodel.h
    libmp3lame/quantize.c
    libmp3lame/quantize.h
    libmp3lame/quantize_pvt.c
    libmp3lame/quantize_pvt.h
    libmp3lame/reservoir.c
    libmp3lame/reservoir.h
    libmp3lame/set_get.c
    libmp3lame/set_get.h
    libmp3lame/tables.c
    libmp3lame/tables.h
    libmp3lame/takehiro.c
    libmp3lame/util.c
    libmp3lame/util.h
    libmp3lame/vbrquantize.c
    libmp3lame/vbrquantize.h
    libmp3lame/VbrTag.c
    libmp3lame/VbrTag.h
    libmp3lame/version.c
    libmp3lame/version.h
    libmp3lame/vbrquantize.h
    include/lame.h
)

if(WIN32)
    list(APPEND LIBLAME_SRC libmp3lame/lame.rc libmp3lame/logoe.ico)
endif()

add_library(mp3lame STATIC ${LIBLAME_SRC})
target_compile_definitions(mp3lame PRIVATE -DHAVE_CONFIG_H)
target_include_directories(mp3lame PUBLIC include ${CMAKE_CURRENT_BINARY_DIR}/config/)

install(TARGETS mp3lame
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/lame.h
        DESTINATION include/lame)

