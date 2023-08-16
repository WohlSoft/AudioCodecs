cmake_minimum_required(VERSION 3.2...3.5)
project(libOpusFile VERSION 0.12.39 LANGUAGES C)

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

set(PACKAGE_NAME "OpusFile")
set(PACKAGE_VERSION "0.10-10-g1896473")

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
check_include_file(memory.h HAVE_MEMORY_H)
check_include_file(stdint.h HAVE_STDINT_H)
check_include_file(stdlib.h HAVE_STDLIB_H)
check_include_file(string.h HAVE_STRING_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(sys/stat.h HAVE_SYS_TYPES_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_files("stdlib.h;time.h;math.h;sys/stat.h;signal.h" HAVE_STDC_HEADERS)
if(HAVE_STDC_HEADERS)
    set(STDC_HEADERS 1)
endif()

if(NOT MSVC)
    set(CMAKE_REQUIRED_LIBRARIES m)
endif()
check_symbol_exists(lrint "math.h;tgmath.h" OP_HAVE_LRINT)
check_symbol_exists(lrintf "math.h;tgmath.h" OP_HAVE_LRINTF)
check_function_exists(__malloc_hook HAVE___MALLOC_HOOK)

add_definitions(
    -DHAVE_CONFIG_H
)

configure_file(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config/config.h)

set(OPUSFILE_SRC)

list(APPEND OPUSFILE_SRC
    src/info.c
    src/internal.c
    src/opusfile.c
    src/stream.c
)
if(ENABLE_HTTP)
    list(APPEND OPUSFILE_SRC src/http.c)
    if(WIN32)
        list(APPEND OPUSFILE_SRC src/wincerts.c)
    endif()
endif()

add_library(opusfile STATIC ${OPUSFILE_SRC})

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_BINARY_DIR}/config
    ${CMAKE_CURRENT_SOURCE_DIR}/../libopus/include
)

target_include_directories(opusfile PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
if(ENABLE_HTTP)
    if(WIN32)
        target_link_libraries(opusfile ws2_32 crypt32)
    endif()
endif()

install(TARGETS opusfile
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/opusfile.h
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
bool_to_yesno(OP_FLOAT_POINT    SUMMARY_FLOAT_POINT)
bool_to_yesno(ENABLE_HTTP       SUMMARY_HTTP)
bool_to_yesno(ENABLE_FLOAT_APPROX   SUMMARY_FLOAT_APPROX)
bool_to_yesno(ENABLE_ASSERTIONS     SUMMARY_ASSERTIONS)

message(
"------------------------------------------------------------------------
  ${PACKAGE_NAME} ${PACKAGE_VERSION} CMake configuration OK.

    Assertions ................... ${SUMMARY_ASSERTIONS}

    HTTP support ................. ${SUMMARY_HTTP}
    Fixed-point .................. ${SUMMARY_FIXED_POINT}
    Floating-point API ........... ${SUMMARY_FLOAT_POINT} ${SUMMARY_C99_LRINTF}
------------------------------------------------------------------------
")
#Hidden visibility ............ ${cc_cv_flag_visibility}
#API documentation: ........... ${enable_doc}
#Extra programs: .............. ${enable_extra_programs}
