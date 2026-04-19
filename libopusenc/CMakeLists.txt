cmake_minimum_required(VERSION 3.2...3.10)
project(libOpusEnc VERSION 0.12.39 LANGUAGES C)

include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckLibraryExists)

include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

if(NOT MSVC)
    ac_add_c_warning_flag("all" ALL)
    ac_add_c_warning_flag("extra" EXTRA)
    ac_add_c_warning_flag("cast-align" CAST_ALIGN)
    ac_add_c_warning_flag("nested-externs" NESTED_EXTERNS)
    ac_add_c_warning_flag("shadow" SHADOW)
    ac_add_c_warning_flag("strict-prototypes" STRICT_PROTOTYPES)
    ac_disable_c_warning_flag("unused-variable" UNUSED_VARIABLE)
    ac_disable_c_warning_flag("unused-parameter" UNUSED_PARAMETER)
    ac_disable_c_warning_flag("unused-but-set-variable" UNUSED_BUT_SET_VARIABLE)
    ac_disable_c_warning_flag("incompatible-pointer-types" INCOMPATIBLE_POINTER_TYPES)
    ac_disable_c_warning_flag("implicit-fallthrough" IMPLICIT_FALLTHROUGH)
endif()

set(PACKAGE_NAME "OpusEnc")
set(PACKAGE_VERSION "0.3-4-g440e35f")

set(PACKAGE_STRING "\"${PACKAGE_NAME} v.${PACKAGE_VERSION}\"")
set(PACKAGE_NAME "\"${PACKAGE_NAME}\"")
set(PACKAGE_VERSION "\"${PACKAGE_VERSION}\"")

option(ENABLE_ASSERTIONS "Enable assertions in code" OFF)
if(ENABLE_ASSERTIONS)
    set(OP_ENABLE_ASSERTIONS 1)
endif()

option(ENABLE_HTTP "Enable HTTP support" OFF)
if(ENABLE_HTTP)
    set(ENABLE_HTTP 1)
    if(WIN32)
        check_include_file(winsock2.h HAVE_WINSOCK2)
        if(NOT HAVE_WINSOCK2)
            unset(ENABLE_HTTP)
            message(WARNING "HTTP support requires a Winsock socket library.")
        endif()
    else()
        check_include_file(sys/socket.h HAVE_POSIX_SOCKET)
        if(NOT HAVE_POSIX_SOCKET)
            unset(ENABLE_HTTP)
            message(WARNING "HTTP support requires a POSIX socket library.")
        endif()
    endif()
endif()

if(NINTENDO_3DS)
    set(ENABLE_FIXED_POINT ON)
endif()

option(ENABLE_FIXED_POINT "Enable fixed-point calculation)" OFF)
if(ENABLE_FIXED_POINT)
    set(OP_FIXED_POINT 1)
else()
    set(OP_FLOAT_POINT 1)
endif()

option(DISABLE_FLOAT_API "Disable floating-point API" OFF)
if(DISABLE_FLOAT_API)
    set(OP_DISABLE_FLOAT_API 1)
endif()

check_include_files(alloca.h HAVE_ALLOCA_H)
if(HAVE_ALLOCA_H)
    add_definitions(-DUSE_ALLOCA=1)
endif()
check_include_file(dlfcn.h HAVE_DLFCN_H)
check_include_file(inttypes.h HAVE_INTTYPES_H)
check_include_file(minix/config.h HAVE_MINIX_CONFIG_H)
check_include_file(stdint.h HAVE_STDINT_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(stdio.h HAVE_STDIO_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(sys/stat.h HAVE_SYS_TYPES_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_file(wchar.h HAVE_WCHAR_H)
check_include_files("stdlib.h;time.h;math.h;sys/stat.h;signal.h" HAVE_STDC_HEADERS)
if(HAVE_STDC_HEADERS)
    set(STDC_HEADERS 1)
endif()
set(OPE_BUILD 1)

if(NOT MSVC)
    set(CMAKE_REQUIRED_LIBRARIES m)
endif()
check_symbol_exists(lrintf "math.h;tgmath.h" OP_HAVE_LRINTF)
check_function_exists(__malloc_hook HAVE___MALLOC_HOOK)

configure_file(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config/config.h)

set(OPUSENC_SRC)

list(APPEND OPUSENC_SRC
    include/opusenc.h
    src/ogg_packer.c
    src/opusenc.c
    src/opus_header.c
    src/picture.c
    src/resample.c
    src/unicode_support.c
    src/arch.h
    src/ogg_packer.h
    src/opus_header.h
    src/picture.h
    src/resample_sse.h
    src/speex_resampler.h
    src/unicode_support.h
)

add_library(opusenc STATIC ${OPUSENC_SRC})

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_BINARY_DIR}/config
    ${CMAKE_CURRENT_SOURCE_DIR}/../libopus/include
)

target_compile_definitions(opusenc PRIVATE -DHAVE_CONFIG_H -DRANDOM_PREFIX=libopusenc -DOUTSIDE_SPEEX)

target_include_directories(opusenc PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
if(ENABLE_HTTP)
    if(WIN32)
        target_link_libraries(opusenc ws2_32 crypt32)
    endif()
endif()

install(TARGETS opusenc
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/opusenc.h
        DESTINATION include/opus)

function(bool_to_yesno INBOOL OUTSTRING)
    if(${INBOOL})
        set("${OUTSTRING}" yes PARENT_SCOPE)
    else()
        set("${OUTSTRING}" no PARENT_SCOPE)
    endif()
endfunction()

bool_to_yesno(VAR_ARRAYS    SUMMARY_C99_VARARRAYS)
bool_to_yesno(OP_HAVE_LRINTF   SUMMARY_C99_LRINTF)
bool_to_yesno(USE_ALLOCA    SUMMARY_ALLOCA)
if(NOT USE_ALLOCA AND VAR_ARRAYS)
    set(SUMMARY_ALLOCA "no (using var arrays)")
endif()
bool_to_yesno(OP_FIXED_POINT    SUMMARY_FIXED_POINT)
bool_to_yesno(ENABLE_FLOAT_APPROX   SUMMARY_FLOAT_APPROX)
bool_to_yesno(ENABLE_ASSERTIONS     SUMMARY_ASSERTIONS)

message(
"------------------------------------------------------------------------
  ${PACKAGE_NAME} ${PACKAGE_VERSION} CMake configuration OK.

    Assertions ................... ${SUMMARY_ASSERTIONS}

    Fixed-point .................. ${SUMMARY_FIXED_POINT}
    Floating-point API ........... ${SUMMARY_C99_LRINTF}
------------------------------------------------------------------------
")
#Hidden visibility ............ ${cc_cv_flag_visibility}
#API documentation: ........... ${enable_doc}
#Extra programs: .............. ${enable_extra_programs}
