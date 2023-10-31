cmake_minimum_required(VERSION 3.2...3.5)
project(libmodplug VERSION 0.8.10.0 LANGUAGES C CXX)

set(VERSION "0.8.10.0")

if(POLICY CMP0077) # Cache variables override since 3.12
    cmake_policy(SET CMP0077 NEW)
endif()

option(MODPLUG_BUILD_SHARED "Build ModPlug Shared Library (DLL)" OFF)
option(MODPLUG_BUILD_STATIC "Build ModPlug Static Library" ON)
option(MODPLUG_EXPORT_CXX "Export C++ interface from library" ON)
option(MODPLUG_MIDIFMT_SUPPORT "Enable midi formats support" OFF)
option(MODPLUG_WAV_SUPPORT "Enable wav formats support" OFF)
option(MODPLUG_MMCMP_SUPPORT "Enable mmcmp and pp20 decompression support" OFF)

set(MODPLUG_DEFINITIONS)

# CMP0075: The NEW behavior of this policy is to honor CMAKE_REQUIRED_LIBRARIES in the include file check macros.
if(NOT CMAKE_VERSION VERSION_LESS 3.12.0)
    cmake_policy(SET CMP0075 NEW)
endif()

add_definitions(-DMODPLUG_BUILD)
if(MIDIFMT_SUPPORT)
    list(APPEND MODPLUG_DEFINITIONS -DMIDIFMT_SUPPORT)
endif()
if(WAV_SUPPORT)
    list(APPEND MODPLUG_DEFINITIONS -DWAV_SUPPORT)
endif()
if(MMCMP_SUPPORT)
    list(APPEND MODPLUG_DEFINITIONS -DMMCMP_SUPPORT)
endif()
if(NOT EXPORT_CXX)
    list(APPEND MODPLUG_DEFINITIONS -DNO_CXX_EXPORTS)
else()
    set(HEADERS_CXX
        src/libmodplug/it_defs.h
        src/libmodplug/sndfile.h
        src/libmodplug/stdafx.h)
endif()

include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckCCompilerFlag)
include(CheckCSourceCompiles)
include(TestBigEndian)
set(AUDIO_CODECS_KEEP_SSE ON)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

TEST_BIG_ENDIAN(WORDS_BIGENDIAN)
if(WORDS_BIGENDIAN)
    add_definitions(-DWORDS_BIGENDIAN=1)
endif()

if(NOT MSVC)
    ac_add_c_warning_flag("all" ALL)
    ac_add_cxx_warning_flag("all" ALL)
    ac_disable_c_warning_flag("pedantic" PEDANTIC)
    ac_disable_cxx_warning_flag("pedantic" PEDANTIC)
    ac_disable_cxx_warning_flag("sequence-point" SEQUENCE_POINT)
    ac_disable_cxx_warning_flag("unused-but-set-variable" UNUSED_BUT_SET_VARIABLE)
endif()

if(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=gnu99")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++98")

    # check symbol visibility attributes
    set(OLD_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS}")
    if(NOT WIN32 AND NOT CYGWIN)
        set(CMAKE_REQUIRED_FLAGS "${OLD_REQUIRED_FLAGS} -Werror")
        check_c_source_compiles("int foo(void) __attribute__((visibility(\"default\")));
        int main(void) {return 0;}" HAVE_VISIBILITY_DEFAULT)
        if(HAVE_VISIBILITY_DEFAULT)
            check_c_compiler_flag(-fvisibility=hidden HAVE_VISIBILITY_HIDDEN)
        endif()
    endif()
    set(CMAKE_REQUIRED_FLAGS "-Wl,--no-undefined")
    check_c_compiler_flag("" HAVE_NO_UNDEFINED)
    set(CMAKE_REQUIRED_FLAGS "${OLD_REQUIRED_FLAGS}")
endif()

if(MSVC)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /wd4100 /wd4244 /wd4267 /wd4996 /wd4702 /wd4706 /wd4456")
endif()

foreach(_FN
        setenv putenv
        )
    string(TOUPPER ${_FN} _UPPER)
    set(_HAVEVAR "HAVE_${_UPPER}")
    CHECK_FUNCTION_EXISTS("${_FN}" ${_HAVEVAR})
endforeach()

if(UNIX AND NOT APPLE)
    find_library(MATH_LIB m)
    if(MATH_LIB)
        set(CMAKE_REQUIRED_LIBRARIES m)
    endif()
endif()

if(WIN32)
    list(APPEND MODPLUG_DEFINITIONS -D_USE_MATH_DEFINES)
    list(APPEND MODPLUG_DEFINITIONS -DNOMINMAX)
endif()

check_include_file("stdint.h" HAVE_STDINT)
if(HAVE_STDINT)
    list(APPEND MODPLUG_DEFINITIONS -DHAVE_STDINT_H)
endif()

check_function_exists("sinf" HAVE_SINF)
if(HAVE_SINF)
    list(APPEND MODPLUG_DEFINITIONS -DHAVE_SINF)
endif()

check_include_file("malloc.h" HAVE_MALLOC_H)
if(HAVE_MALLOC_H)
    list(APPEND MODPLUG_DEFINITIONS -DHAVE_MALLOC_H)
endif()

check_include_file("memory.h" HAVE_MEMORY_H)
if(HAVE_MEMORY_H)
    list(APPEND MODPLUG_DEFINITIONS -DHAVE_MEMORY_H)
endif()

check_include_file("inttypes.h" HAVE_INTTYPES_H)
if(HAVE_INTTYPES_H)
    list(APPEND MODPLUG_DEFINITIONS -DHAVE_INTTYPES_H)
endif()

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/src/cmake_config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config/cmake_config.h)

set(MODPLUG_SRCS
    src/libmodplug/it_defs.h
    src/libmodplug/sndfile.h
    src/libmodplug/stdafx.h

    src/fastmix.cpp
    src/load_669.cpp
    src/load_abc.cpp
    src/load_amf.cpp
    src/load_ams.cpp
    src/load_dbm.cpp
    src/load_dmf.cpp
    src/load_dsm.cpp
    src/load_far.cpp
    src/load_gdm.cpp
    src/load_it.cpp
    src/load_mdl.cpp
    src/load_med.cpp
    src/load_mid.cpp
    src/load_mod.cpp
    src/load_mt2.cpp
    src/load_mtm.cpp
    src/load_okt.cpp
    src/load_pat.cpp
    src/load_pat.h
    src/load_psm.cpp
    src/load_ptm.cpp
    src/load_s3m.cpp
    src/load_stm.cpp
    src/load_ult.cpp
    src/load_umx.cpp
    src/load_wav.cpp
    src/load_xm.cpp
    src/mmcmp.cpp
    src/modplug.cpp
    src/modplug.h
    src/snd_dsp.cpp
    src/snd_flt.cpp
    src/snd_fx.cpp
    src/sndfile.cpp
    src/sndmix.cpp
    src/tables.h
)

list(APPEND MODPLUG_DEFINITIONS
    -DHAVE_CONFIG_H
    -DHAVE_CMAKE_CONFIG_H
    -DMODPLUG_STATIC
    -DMODPLUG_BUILD=1
    -D_REENTRANT
    -D_USE_MATH_DEFINES
)

set(MODPLUG_INCLUDES
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src/libmodplug
    ${CMAKE_CURRENT_BINARY_DIR}/config/
)

set(MODPLUG_INSTALS)

if(MODPLUG_BUILD_STATIC)
    add_library(modplug_static STATIC ${MODPLUG_SRCS})
    list(APPEND MODPLUG_INSTALS modplug_static)
    if(WIN32 AND MODPLUG_BUILD_SHARED)
        set_target_properties(modplug_static PROPERTIES OUTPUT_NAME modplug-static)
    else()
        set_target_properties(modplug_static PROPERTIES OUTPUT_NAME modplug)
    endif()

    target_compile_definitions(modplug_static PRIVATE ${MODPLUG_DEFINITIONS} -DMODPLUG_STATIC)
    target_include_directories(modplug_static PRIVATE ${MODPLUG_INCLUDES})

endif()

if(MODPLUG_BUILD_SHARED)
    add_library(modplug_shared SHARED ${MODPLUG_SRCS})
    list(APPEND MODPLUG_INSTALS modplug_shared)
    set_target_properties(modplug_shared PROPERTIES OUTPUT_NAME modplug)

    if(WIN32 OR CYGWIN)
        target_compile_definitions(modplug_shared PRIVATE ${MODPLUG_DEFINITIONS} -DDLL_EXPORT)
    elseif(HAVE_VISIBILITY_HIDDEN)
        target_compile_definitions(modplug_shared PRIVATE ${MODPLUG_DEFINITIONS} -DSYM_VISIBILITY)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden")
    endif()

    target_include_directories(modplug_shared PRIVATE ${MODPLUG_INCLUDES})

    if(APPLE)
        target_link_libraries(modplug_shared -Wl,-undefined,error)
        target_link_libraries(modplug_shared -Wl,-compatibility_version,2.0.0)
        target_link_libraries(modplug_shared -Wl,-current_version,2.0.0)
    else()
        if(HAVE_NO_UNDEFINED)
            target_link_libraries(modplug_shared -Wl,--no-undefined)
        endif()
        set_target_properties(modplug_shared PROPERTIES
        VERSION 1.0.0 SOVERSION 1)
    endif()
    if(MATH_LIB)
        target_link_libraries(modplug_shared m)
    endif()
endif()



install(TARGETS ${MODPLUG_INSTALS}
    LIBRARY DESTINATION "lib"
    ARCHIVE DESTINATION "lib"
    INCLUDES DESTINATION "include"
)

# install the headers:
install(FILES
    src/modplug.h
    ${HEADERS_CXX}

    DESTINATION
    include/libmodplug/
)

if(NOT WIN32)
    set(prefix "${CMAKE_INSTALL_PREFIX}")
    set(exec_prefix "${CMAKE_INSTALL_PREFIX}")
    set(libdir "${CMAKE_INSTALL_PREFIX}/lib")
    set(includedir "${CMAKE_INSTALL_PREFIX}/include")
    configure_file(libmodplug.pc.in libmodplug.pc)

    # install pkg-config file:
    install(FILES "${PROJECT_BINARY_DIR}/libmodplug.pc" DESTINATION lib/pkgconfig)
endif(NOT WIN32)
