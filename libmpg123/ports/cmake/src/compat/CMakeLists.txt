set(COMPAT_TARGET compat)

add_library(${COMPAT_TARGET} OBJECT
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../src/compat/compat.c"
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../src/compat/compat_str.c")
set_target_properties(${COMPAT_TARGET} PROPERTIES POSITION_INDEPENDENT_CODE ON)

add_library(${COMPAT_TARGET}_dl OBJECT
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../src/compat/compat_dl.c")
set_target_properties(${COMPAT_TARGET}_dl PROPERTIES POSITION_INDEPENDENT_CODE ON)

add_library(${COMPAT_TARGET}_str OBJECT
    "${CMAKE_CURRENT_SOURCE_DIR}/../../../../src/compat/compat_str.c")
set_target_properties(${COMPAT_TARGET}_dl PROPERTIES POSITION_INDEPENDENT_CODE ON)
