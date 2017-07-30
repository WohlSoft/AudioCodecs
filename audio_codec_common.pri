# ========= library Intsalling properties ============
exists($$PWD/../../_common/strip_garbage.pri):{
    include($$PWD/../../_common/strip_garbage.pri)
} else {
    include($$PWD/_common/strip_garbage.pri)
}
exists($$PWD/../../_common/lib_destdir.pri):{
    include($$PWD/../../_common/lib_destdir.pri)
    DESTDIR = $$PWD/../_builds/$$TARGETOS/lib
} else {
    DESTDIR = $$PWD/build/lib/
}
exists($$PWD/../../_common/build_props.pri):{
    include($$PWD/../../_common/build_props.pri)
}

# ================ Includes to install ===============
LibIncludes.path =  $$PWD/../_builds/$$TARGETOS/include/$$INSTALLINCLUDESTO
LibIncludes.files += $$INSTALLINCLUDES
INSTALLS += LibIncludes
# ====================================================

release: DEFINES += NDEBUG
!win32:{
    QMAKE_CFLAGS   += -fPIC
    QMAKE_CXXFLAGS += -fPIC
}
