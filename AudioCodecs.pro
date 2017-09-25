
exists($$PWD/../../_common/dest_dir.pri):{
    # As part of PGE-Project depencency set
    include($$PWD/../../_common/dest_dir.pri)
} else {
    # As independent toolchain
    DESTDIR = $$PWD/build/lib/
}

TEMPLATE = subdirs
CONFIG  -= app_bundle

SUBDIRS += zlib
SUBDIRS += libogg
SUBDIRS += libvorbis
SUBDIRS += libFLAC
libvorbis.depends = libogg
libFLAC.depends = libogg
SUBDIRS += libmad
#SUBDIRS += smpeg
SUBDIRS += libid3tag
SUBDIRS += libgme
libgme.depends = zlib
SUBDIRS += libmodplug
SUBDIRS += libADLMIDI
SUBDIRS += libOPNMIDI
SUBDIRS += libtimidity
