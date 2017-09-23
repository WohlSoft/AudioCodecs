LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := smpeg2

LOCAL_C_INCLUDES := $(LOCAL_PATH)
LOCAL_CFLAGS := -DSTDC_HEADERS=1 -DHAVE_SYS_TYPES_H=1 -DHAVE_SYS_STAT_H=1 -DHAVE_STDLIB_H=1 -DHAVE_STRING_H=1 -DHAVE_MEMORY_H=1 -DHAVE_STRINGS_H=1 -DHAVE_INTTYPES_H=1 -DHAVE_STDINT_H=1 -DHAVE_UNISTD_H=1 -DHAVE_DLFCN_H=1 -D_THREAD_SAFE -DTHREADED_AUDIO -DNOCONTROLS

LOCAL_SRC_FILES := \
    src/smpeg.cpp \
    src/MPEG.cpp \
    src/MPEGlist.cpp \
    src/MPEGring.cpp \
    src/MPEGstream.cpp \
    src/MPEGsystem.cpp \
    src/audio/MPEGaudio.cpp \
    src/audio/bitwindow.cpp \
    src/audio/filter.cpp \
    src/audio/filter_2.cpp \
    src/audio/hufftable.cpp \
    src/audio/mpeglayer1.cpp \
    src/audio/mpeglayer2.cpp \
    src/audio/mpeglayer3.cpp \
    src/audio/mpegtable.cpp \
    src/audio/mpegtoraw.cpp \
    src/video/MPEGvideo.cpp \
    src/video/decoders.cpp \
    src/video/floatdct.cpp \
    src/video/gdith.cpp \
    src/video/jrevdct.cpp \
    src/video/motionvec.cpp \
    src/video/parseblock.cpp \
    src/video/readfile.cpp \
    src/video/util.cpp \
    src/video/video.cpp

LOCAL_LDLIBS :=
LOCAL_STATIC_LIBRARIES :=
LOCAL_SHARED_LIBRARIES := SDL2

LOCAL_EXPORT_C_INCLUDES += $(LOCAL_C_INCLUDES)

include $(BUILD_SHARED_LIBRARY)
