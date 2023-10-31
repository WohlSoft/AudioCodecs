cmake_minimum_required(VERSION 3.1...3.5)

# #### AudioCodecs CHANGES ####
# - All CMAKE_SOURCE_DIR replaced with CMAKE_CURRENT_SOURCE_DIR---
# - Added build flags set inclusion

project(fluidlite)

include(GNUInstallDirs)
include(TestBigEndian)

set(CMAKE_C_STANDARD 99)

set(AUDIO_CODECS_KEEP_SSE ON)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

test_big_endian(WORDS_BIGENDIAN)
if(WORDS_BIGENDIAN)
    add_definitions(-DWORDS_BIGENDIAN)
endif()

if(NOT MSVC)
    ac_disable_c_warning_flag("pedantic" PEDANTIC)
    ac_disable_c_warning_flag("unused-variable" UNUSED_VARIABLE)
    ac_disable_c_warning_flag("implicit-fallthrough" IMPLICIT_FALLTHROUGH)
    ac_disable_c_warning_flag("unused-but-set-variable" UNUSED_BUT_SET_VARIABLE)
    ac_disable_c_warning_flag("pointer-to-int-cast" POINTER_TO_INT_CAST)
    ac_disable_c_warning_flag("compound-token-split-by-macro" COMPOUND_TOKEN_SPLIT_BY_MACRO)
endif()

list(APPEND HEADERS
    include/fluidlite.h
)

list(APPEND SCOPED_HEADERS
    include/fluidsynth/types.h
    include/fluidsynth/settings.h
    include/fluidsynth/synth.h
    include/fluidsynth/sfont.h
    include/fluidsynth/ramsfont.h
    include/fluidsynth/log.h
    include/fluidsynth/misc.h
    include/fluidsynth/mod.h
    include/fluidsynth/gen.h
    include/fluidsynth/voice.h
    include/fluidsynth/version.h
)


list(APPEND SOURCES
    src/fluid_init.c
    src/fluid_chan.c
    src/fluid_chorus.c
    src/fluid_conv.c
    src/fluid_defsfont.c
    src/fluid_dsp_float.c
    src/fluid_gen.c
    src/fluid_hash.c
    src/fluid_list.c
    src/fluid_mod.c
    src/fluid_ramsfont.c
    src/fluid_rev.c
    src/fluid_settings.c
    src/fluid_synth.c
    src/fluid_sys.c
    src/fluid_tuning.c
    src/fluid_voice.c
)

# Dependencies:

include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

if(AUDIOCODECS_FLUIDLITE_ENABLE_SF3)
    if(AUDIOCODECS_FLUIDLITE_ENABLE_STB_VORBIS)
        list(APPEND SOURCES stb/stb_vorbis.c)
        include_directories(${CMAKE_CURRENT_SOURCE_DIR}/stb)
    else()
        include_directories(
            ${CMAKE_CURRENT_SOURCE_DIR}/../libogg/include
            ${CMAKE_CURRENT_SOURCE_DIR}/../libvorbis/include
        )
        set(LIBVORBIS_LIBRARIES vorbis)
        set(LIBVORBISFILE_LIBRARIES vorbisfile)
        set(LIBOGG_LIBRARIES ogg)
    endif()
endif()

if (ENABLE_SF3 AND STB_VORBIS)
    include_directories(${CMAKE_CURRENT_SOURCE_DIR}/stb)
endif()

option(FLUIDLITE_BUILD_STATIC "Build static library" TRUE)
if(FLUIDLITE_BUILD_STATIC)
    add_library(${PROJECT_NAME}-static STATIC ${SOURCES})
    set_target_properties(${PROJECT_NAME}-static PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
    set(FLUIDLITE_LIB_TARGET ${PROJECT_NAME}-static)
    set(FLUIDLITE_INSTALL_TARGETS ${FLUIDLITE_INSTALL_TARGETS} ";fluidlite-static")
    set_target_properties(${PROJECT_NAME}-static PROPERTIES C_STANDARD 99)
    if(WIN32)
        target_compile_definitions(${PROJECT_NAME}-static PRIVATE _CRT_SECURE_NO_WARNINGS)
    endif()
endif()

option(FLUIDLITE_BUILD_SHARED "Build shared library" TRUE)
if(FLUIDLITE_BUILD_SHARED)
    add_library(${PROJECT_NAME} SHARED ${SOURCES})

    # find the math lib
    find_library(M_LIBRARY m)
    message(STATUS "Math library: ${M_LIBRARY}")
    if(NOT M_LIBRARY)
        set(M_LIBRARY "")
    endif()

    target_link_libraries(${PROJECT_NAME}
        ${LIBVORBIS_LIBRARIES}
        ${LIBVORBISFILE_LIBRARIES}
        ${LIBOGG_LIBRARIES}
        ${M_LIBRARY}
    )
    set(FLUIDLITE_LIB_TARGET ${PROJECT_NAME})
    set(FLUIDLITE_INSTALL_TARGETS ${FLUIDLITE_INSTALL_TARGETS} ";fluidlite")
    set_target_properties(${PROJECT_NAME} PROPERTIES C_STANDARD 99)
    if(WIN32)
        target_compile_definitions(${PROJECT_NAME} PRIVATE _CRT_SECURE_NO_WARNINGS)
    endif()
endif()

if((NOT FLUIDLITE_BUILD_SHARED) AND (NOT FLUIDLITE_BUILD_STATIC))
    message(FATAL_ERROR "Neither dynamic nor static library build is selected.")
endif()

if(FLUIDLITE_BUILD_SHARED AND FLUIDLITE_BUILD_STATIC)
    set_target_properties(${PROJECT_NAME} PROPERTIES CLEAN_DIRECT_OUTPUT 1)
    set_target_properties(${PROJECT_NAME}-static PROPERTIES CLEAN_DIRECT_OUTPUT 1)
endif()

if (AUDIOCODECS_FLUIDLITE_ENABLE_SF3)
    if (AUDIOCODECS_FLUIDLITE_ENABLE_STB_VORBIS)
        set(SF3_SUPPORT "SF3_STB_VORBIS")
    else()
        set(SF3_SUPPORT "SF3_XIPH_VORBIS")
    endif()

    message("FluidLite: Enabled SF3 support: ${SF3_SUPPORT}")

    if(FLUIDLITE_BUILD_SHARED)
        target_compile_definitions(${PROJECT_NAME} PUBLIC SF3_SUPPORT=${SF3_SUPPORT})
    endif()
    if(FLUIDLITE_BUILD_STATIC)
        target_compile_definitions(${PROJECT_NAME}-static PUBLIC SF3_SUPPORT=${SF3_SUPPORT})
    endif()
endif()

configure_file(fluidlite.pc.in ${CMAKE_CURRENT_BINARY_DIR}/fluidlite.pc @ONLY)

install(TARGETS ${FLUIDLITE_INSTALL_TARGETS}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES ${HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
install(FILES ${SCOPED_HEADERS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/fluidsynth)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/fluidlite.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig)
