set(COMPAT_TARGET compat)

#AudioCodecs: Don't enable PIC when no support for it
if(NOT VITA AND NOT NINTENDO_3DS AND NOT NINTENDO_WII AND NOT NINTENDO_WIIU AND NOT XTECH_MACOSX_TIGER)
    set(HAS_PIC_SUPPORT ON)
endif()


add_library(${COMPAT_TARGET} OBJECT
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../src/compat/compat.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../src/compat/compat_str.c")
if(HAS_PIC_SUPPORT) #AudioCodecs: Don't enable PIC when no support for it
    set_target_properties(${COMPAT_TARGET} PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()

add_library(${COMPAT_TARGET}_dl OBJECT
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../src/compat/compat_dl.c")
if(HAS_PIC_SUPPORT) #AudioCodecs: Don't enable PIC when no support for it
    set_target_properties(${COMPAT_TARGET}_dl PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()

add_library(${COMPAT_TARGET}_str OBJECT
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../src/compat/compat_str.c")
if(HAS_PIC_SUPPORT) #AudioCodecs: Don't enable PIC when no support for it
    set_target_properties(${COMPAT_TARGET}_dl PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()
