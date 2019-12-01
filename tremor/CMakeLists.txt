cmake_minimum_required(VERSION 3.2)
project(Tremor VERSION 1.2.1 LANGUAGES C)

include(TestBigEndian)
include(${CMAKE_CURRENT_SOURCE_DIR}/../audio_codec_common.cmake)

# add_definitions(-DFLOAT_LOOKUP -DINT_LOOKUP)

TEST_BIG_ENDIAN(WORDS_BIGENDIAN)
if(WORDS_BIGENDIAN)
    add_definitions(-DWORDS_BIGENDIAN=1)
endif()

if(MSVC)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /wd4244 /wd4267 /wd4305")
endif()

add_library(vorbisidec STATIC
    block.c
    floor0.c
    info.c
    mdct.c
    res012.c
    synthesis.c
    window.c
    codebook.c
    floor1.c
    mapping0.c
    registry.c
    sharedbook.c
    vorbisfile.c
)

target_include_directories(vorbisidec PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake
    ${CMAKE_CURRENT_SOURCE_DIR}/../libogg/include
)

target_compile_definitions(vorbisidec PRIVATE
    -DHAVE_CONFIG_H=1
    -DHAVE_MEMORY_H=1
)
if(WIN32)
    target_compile_definitions(vorbisidec PRIVATE -DVAR_ARRAYS)
else()
    target_compile_definitions(vorbisidec PRIVATE -DHAVE_ALLOCA)
endif()

install(TARGETS vorbisidec
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        config_types.h
        ivorbiscodec.h
        ivorbisfile.h
        DESTINATION include/tremor)
