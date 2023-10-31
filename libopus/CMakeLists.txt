cmake_minimum_required(VERSION 3.2...3.5)
project(libOPUS VERSION 1.3.1.158 LANGUAGES C)

set(CMAKE_C_STANDARD 99)

include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckLibraryExists)

set(AUDIO_CODECS_KEEP_SSE ON)
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
    ac_disable_c_warning_flag("stringop-overread" STRINGGOP_OVERREAD)
endif()

if(MSVC)
    set(CMAKE_STATIC_LINKER_FLAGS "${CMAKE_STATIC_LINKER_FLAGS} /ignore:4221")
endif()

include(${CMAKE_CURRENT_SOURCE_DIR}/config.tests/TargetArch.cmake)

target_architecture(TARGET_PROCESSOR)

message("System processor is [${CMAKE_SYSTEM_PROCESSOR}]")
message("Target processor is [${TARGET_PROCESSOR}]")
if(TARGET_PROCESSOR MATCHES "x86_64|AMD64" OR TARGET_PROCESSOR MATCHES "^i.86$")
    message("X86/X86_64 detected")
    set(OPUS_X86_ARCHITECTURE 1)
elseif(${TARGET_PROCESSOR} MATCHES "arm.*")
    message("ARM detected")
    set(OPUS_ARM_ARCHITECTURE 1)
elseif(${TARGET_PROCESSOR} MATCHES "ppc")
    message("-- Assembly will be disabled on architecture [${TARGET_PROCESSOR}]")
else()
    message(WARNING "Unsupported CPU architecture detected! [${TARGET_PROCESSOR}] Assembly optimisations will be disabled.")
endif()

set(PACKAGE_NAME "Opus")
set(PACKAGE_VERSION "1.3-rc-2-gc1c247d")

set(PACKAGE_STRING "\"${PACKAGE_NAME} v.${PACKAGE_VERSION}\"")
set(PACKAGE_NAME "\"${PACKAGE_NAME}\"")
set(PACKAGE_VERSION "\"${PACKAGE_VERSION}\"")

option(ENABLE_ASSERTIONS "enable additional software error checking" OFF)
if(ENABLE_ASSERTIONS)
    set(ENABLE_ASSERTIONS 1)
endif()

option(ENABLE_HARDENING "enable run-time checks that are cheap and safe for use in production" OFF)
if(ENABLE_HARDENING)
    set(ENABLE_HARDENING 1)
endif()

option(ENABLE_FUZZING "causes the encoder to make random decisions" OFF)
if(ENABLE_FUZZING)
    set(FUZZING 1)
endif()

option(ENABLE_CUSTOM_MODES "Custom modes" OFF)
if(ENABLE_CUSTOM_MODES)
    set(CUSTOM_MODES 1)
endif()

option(ENABLE_FIXED_POINT "Compile as fixed-point (for machines without a fast enough FPU)" OFF)
if(ENABLE_FIXED_POINT)
    set(FIXED_POINT 1)
else()
    set(FLOAT_POINT 1)
endif()

option(ENABLE_FIXED_POINT_DEBUG "debug fixed-point implementation" OFF)
if(ENABLE_FIXED_POINT_DEBUG)
    set(FIXED_DEBUG 1)
endif()

option(ENABLE_FLOAT_APPROX "enable fast approximations for floating point" OFF)
if(ENABLE_FLOAT_APPROX)
    set(FLOAT_APPROX 1)
endif()

option(DISABLE_FLOAT_API "compile without the floating point API (for machines with no float library)" OFF)
if(DISABLE_FLOAT_API)
    set(DISABLE_FLOAT_API 1)
endif()

option(DISABLE_UPDATE_DRAFT "Disable bitstream fixes from RFC 8251" OFF)
if(DISABLE_UPDATE_DRAFT)
    set(DISABLE_UPDATE_DRAFT 1)
endif()

option(ENABLE_EXPERIMENTAL_AMBISONICS "enable experimental ambisonic encoding and decoding support" OFF)
if(ENABLE_EXPERIMENTAL_AMBISONICS)
    set(ENABLE_EXPERIMENTAL_AMBISONICS 1)
endif()

option(ENABLE_CHECK_ASM "enable bit-exactness checks between optimized and c implementations" OFF)
if(ENABLE_CHECK_ASM)
    set(OPUS_CHECK_ASM 1)
endif()

if(VITA OR NINTENDO_SWITCH OR NINTENDO_3DS OR NINTENDO_WII)
    set(DEFAULT_DISABLE_RTCD ON)
else()
    set(DEFAULT_DISABLE_RTCD OFF)
endif()

option(DISABLE_RTCD "Disable run-time CPU capabilities detection" ${DEFAULT_DISABLE_RTCD})
if(NOT DISABLE_RTCD)
    set(OPUS_HAVE_RTCD 1)
endif()

# TODO: By unknown reason, it's not linkable, fix this, and then change default to OFF
option(DISABLE_SSE_BUILD "Disable SSE on x86 architecture" ON)

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
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(unistd.h HAVE_UNISTD_H)
check_include_files("stdlib.h;time.h;math.h;sys/stat.h;signal.h" HAVE_STDC_HEADERS)
if(HAVE_STDC_HEADERS)
    set(STDC_HEADERS 1)
endif()

if(NOT MSVC)
    set(CMAKE_REQUIRED_LIBRARIES m)
endif()
check_symbol_exists(lrint "math.h;tgmath.h" HAVE_LRINT)
check_symbol_exists(lrintf "math.h;tgmath.h" HAVE_LRINTF)
check_function_exists(__malloc_hook HAVE___MALLOC_HOOK)

try_compile(VAR_ARRAYS
    ${CMAKE_BINARY_DIR}/compile_tests
    ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/c99/var_size_arrays.c
)
if(VAR_ARRAYS)
    set(VAR_ARRAYS 1)
    set(USE_ALLOCA 0)
endif()

if(NOT VAR_ARRAYS AND NOT MSVC)
    try_compile(USE_ALLOCA
        ${CMAKE_BINARY_DIR}/compile_tests
        ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/c99/alloca.c
    )
    if(USE_ALLOCA)
        set(USE_ALLOCA 1)
    endif()
endif()

if(MSVC)
    set(USE_ALLOCA 1)
endif()

foreach(RESTRICT_KEYWORD "__restrict" "__restrict__" "_Restrict" "restrict")
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.tests/c99/restrict.c.in ${CMAKE_BINARY_DIR}/compile_tests/restrict_${RESTRICT_KEYWORD}.c @ONLY)
    unset(HAS_RESTRICTC)
    try_compile(HAS_RESTRICTC
        ${CMAKE_BINARY_DIR}/compile_tests
        ${CMAKE_BINARY_DIR}/compile_tests/restrict_${RESTRICT_KEYWORD}.c
    )
    unset(restrict)
    if(HAS_RESTRICTC)
        if(NOT RESTRICT_KEYWORD STREQUAL "restrict")
            set(restrict "${RESTRICT_KEYWORD}")
        endif()
        message("HAS \"${RESTRICT_KEYWORD}\"")
        break()
    endif()
endforeach()

foreach(INLINE_KEYWORD "inline" "__inline__" "__inline")
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.tests/c99/inline.c.in ${CMAKE_BINARY_DIR}/compile_tests/inline_${INLINE_KEYWORD}.c @ONLY)
    unset(HAS_RESTRICTC)
    try_compile(HAS_INLINEC
        ${CMAKE_BINARY_DIR}/compile_tests
        ${CMAKE_BINARY_DIR}/compile_tests/inline_${INLINE_KEYWORD}.c
    )
    unset(inline)
    if(HAS_INLINEC)
        if(NOT INLINE_KEYWORD STREQUAL "inline")
            set(inline "${INLINE_KEYWORD}")
        endif()
        message("HAS \"${INLINE_KEYWORD}\"")
        break()
    endif()
endforeach()

try_compile(HAS_CONST_TYPE
    ${CMAKE_BINARY_DIR}/compile_tests
    ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/c99/const.c
)
if(NOT HAS_CONST_TYPE)
    set(const 1)
else()
    message("HAS const")
endif()

set(SUMMARY_RTCD "no")

if(NOT DISABLE_RTCD)
    set(SUMMARY_RTCD "")
    list(APPEND SUMMARY_RTCD "x86")

    try_compile(CPU_INFO_BY_ASM
        ${CMAKE_BINARY_DIR}/compile_tests
        ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/cpuid/cpuid_asm.c
    )
    if(CPU_INFO_BY_ASM)
        set(CPU_INFO_BY_ASM 1)
        list(APPEND SUMMARY_RTCD "ASM")
    endif()

    try_compile(CPU_INFO_BY_C
        ${CMAKE_BINARY_DIR}/compile_tests
        ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/cpuid/cpuid_c.c
    )
    if(CPU_INFO_BY_C)
        set(CPU_INFO_BY_C 1)
        list(APPEND SUMMARY_RTCD "C")
    endif()
endif()

set(SUMMARY_INLINE_ASM "No inline ASM for your platform")
set(SUMMARY_EXTERNAL_ASM_OPTIMIZATIONS "")

set(SUMMARY_INTRUISTIC "no")

if(OPUS_X86_ARCHITECTURE)
    if(NOT DISABLE_RTCD)
        set(SUMMARY_RTCD "")
        list(APPEND SUMMARY_RTCD "x86")
    endif()

    set(SUMMARY_INTRUISTIC "")
    list(APPEND SUMMARY_INTRUISTIC "x86")

    if(NOT DISABLE_RTCD AND NOT MSVC AND NOT DISABLE_SSE_BUILD) #Do CPU tests on non-MSVC compilers
        # === Detect SSE ===
        try_compile(HAVE_X86_SSE
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/x86/have_sse.c
        )
        try_compile(HAVE_X86_SSE_WITH_FLAG
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/x86/have_sse.c
            COMPILE_DEFINITIONS "-msse"
        )
        if(HAVE_X86_SSE OR HAVE_X86_SSE_WITH_FLAG)
            set(OPUS_X86_MAY_HAVE_SSE 1)
            set(OPUS_X86_PRESUME_SSE 1)
            set(HAVE_X86_SSE 1)
            if(HAVE_X86_SSE_WITH_FLAG)
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -msse")
            endif()
            list(APPEND SUMMARY_INTRUISTIC "SSE")
        endif()

        # === Detect SSE2 ===
        try_compile(HAVE_X86_SSE2
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/x86/have_sse2.c
        )
        try_compile(HAVE_X86_SSE2_WITH_FLAG
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/x86/have_sse2.c
            COMPILE_DEFINITIONS "-msse2"
        )
        if(HAVE_X86_SSE2 OR HAVE_X86_SSE2_WITH_FLAG)
            set(OPUS_X86_MAY_HAVE_SSE2 1)
            set(OPUS_X86_PRESUME_SSE2 1)
            set(HAVE_X86_SSE2 1)
            if(HAVE_X86_SSE2_WITH_FLAG)
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -msse2")
            endif()
            list(APPEND SUMMARY_INTRUISTIC "SSE2")
        endif()

        # === Detect SSE4.1 ===
        try_compile(HAVE_X86_SSE4_1
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/x86/have_sse4-1.c
        )
        try_compile(HAVE_X86_SSE4_1_WITH_FLAG
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/x86/have_sse4-1.c
        )
        if(HAVE_X86_SSE4_1 OR HAVE_X86_SSE4_1_WITH_FLAG)
            set(OPUS_X86_MAY_HAVE_SSE4_1 1)
            set(OPUS_X86_PRESUME_SSE4_1 1)
            set(HAVE_X86_SSE4_1 1)
            if(HAVE_X86_SSE4_1_WITH_FLAG)
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -msse4.1")
            endif()
            list(APPEND SUMMARY_INTRUISTIC "SSE4.1")
            if(NOT DISABLE_RTCD)
                list(APPEND SUMMARY_RTCD "SSE4.1")
            endif()
        endif()

        # === Detect AVX ===
        try_compile(HAVE_X86_AVX
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/x86/have_avx.c
        )
        try_compile(HAVE_X86_AVX_WITH_FLAG
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/x86/have_avx.c
            COMPILE_DEFINITIONS "-mavx"
        )
        if(HAVE_X86_AVX OR HAVE_X86_AVX_WITH_FLAG)
            set(OPUS_X86_MAY_HAVE_AVX 1)
            set(OPUS_X86_PRESUME_AVX 1)
            if(HAVE_X86_AVX_WITH_FLAG)
                set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -mavx")
            endif()
            list(APPEND SUMMARY_INTRUISTIC "AVX")
            if(NOT DISABLE_RTCD)
                list(APPEND SUMMARY_RTCD "AVX")
            endif()
        endif()
    endif()#Not-MSVC
endif()#Is X86 architecture

if(OPUS_ARM_ARCHITECTURE)
    if(NOT DISABLE_RTCD)
        set(SUMMARY_RTCD "")
        list(APPEND SUMMARY_RTCD "ARM")
    endif()

    set(SUMMARY_INTRUISTIC "")
    list(APPEND SUMMARY_INTRUISTIC "arm")

    if(MSVC)
        set(OPUS_ARM_PRESUME_EDSP 0)
    else()
        set(OPUS_ARM_PRESUME_EDSP 1)
    endif()

    if(NOT DISABLE_RTCD)
        ac_add_c_compiler_flag(-mfpu=neon MFPU_NEON)
        ac_add_c_compiler_flag(-mfloat-abi=softfp FLOATABI_SOFTFP)

        try_compile(HAVE_ARM_INLINE_NEON
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/arm/neon_inline.c
        )
        if(HAVE_ARM_INLINE_NEON)
            set(OPUS_ARM_INLINE_NEON 1)
            set(OPUS_ARM_MAY_HAVE_NEON 1)
            set(OPUS_ARM_PRESUME_NEON 1)
            message("-- Has inline NEON: YES")
        else()
            set(OPUS_ARM_MAY_HAVE_NEON 0)
            message("-- Has inline NEON: NO")
        endif()


        try_compile(HAVE_ARM_INLINE_MEDIA
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/arm/arm_inline_media.c
        )
        if(HAVE_ARM_INLINE_MEDIA)
            set(OPUS_ARM_INLINE_MEDIA 1)
            set(OPUS_ARM_MAY_HAVE_MEDIA 1)
            set(OPUS_ARM_PRESUME_MEDIA 1)
            message("-- Has inline Media: YES")
        else()
            set(OPUS_ARM_MAY_HAVE_MEDIA 0)
            message("-- Has inline Media: NO")
        endif()


        try_compile(HAVE_ARM_INLINE_ASM
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/arm/arm_inline_asm.c
        )
        if(HAVE_ARM_INLINE_ASM)
            set(OPUS_ARM_INLINE_ASM 1)
            message("-- Has inline ASM: YES")
        else()
            message("-- Has inline ASM: NO")
        endif()

        try_compile(HAVE_ARM_NEON_EDSP
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/arm/neon_edsp.c
        )
        if(HAVE_ARM_NEON_EDSP)
            set(OPUS_ARM_INLINE_EDSP 1)
            set(OPUS_ARM_MAY_HAVE_EDSP 1)
            message("-- Has NEON EDSP: YES")
        else()
            set(OPUS_ARM_MAY_HAVE_EDSP 0)
            message("-- Has NEON EDSP: NO")
        endif()

        #m4_define([DEFAULT_ARM_NEON_INTR_CFLAGS], [-mfpu=neon])
        #m4_define([DEFAULT_ARM_NEON_SOFTFP_INTR_CFLAGS], [-mfpu=neon -mfloat-abi=softfp])
        try_compile(HAVE_ARM_NE10
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/arm/has_ne10.c
        )
        if(HAVE_ARM_NE10)
            set(HAVE_ARM_NE10 1)
            message("-- Has ARM NE10: YES")
        else()
            message("-- Has ARM NE10: NO")
        endif()

        try_compile(HAVE_ARM_NEON_INTR
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/arm/neon_intr.c
        )
        if(HAVE_ARM_NEON_INTR)
            set(OPUS_ARM_MAY_HAVE_NEON_INTR 1)
            set(OPUS_ARM_PRESUME_NEON_INTR 1)
            message("-- Has NEON INTR: YES")
        else()
            message("-- Has NEON INTR: NO")
        endif()

        try_compile(HAVE_ARM_ARCH64_NEON_INTR
            ${CMAKE_BINARY_DIR}/compile_tests
            ${CMAKE_CURRENT_SOURCE_DIR}/config.tests/arm/neon_intr_arch64.c
        )
        if(HAVE_ARM_ARCH64_NEON_INTR)
            set(OPUS_ARM_MAY_HAVE_AARCH64_NEON_INTR 1)
            set(OPUS_ARM_PRESUME_AARCH64_NEON_INTR 1)
            message("-- Has AARCH_NEON_INTR: YES")
        else()
            message("-- Has AARCH_NEON_INTR: NO")
        endif()

        if(FLOAT_POINT)
            set(OPUS_ARM_ASM 1)
        endif()

        configure_file(celt/arm/armopts.s.in ${CMAKE_CURRENT_BINARY_DIR}/config/celt/arm/armopts.s)

    endif()
endif()#Is ARM architecture

add_definitions(
    -DHAVE_CONFIG_H
)

configure_file(config.h.in ${CMAKE_CURRENT_BINARY_DIR}/config/config.h)

set(OPUS_SRC)

list(APPEND OPUS_SRC
    src/opus.c
    src/opus_decoder.c
    src/opus_encoder.c
    src/opus_multistream.c
    src/opus_multistream_decoder.c
    src/opus_multistream_encoder.c
    src/opus_projection_decoder.c
    src/opus_projection_encoder.c
    src/repacketizer.c
)

if(ENABLE_EXPERIMENTAL_AMBISONICS)
    list(APPEND OPUS_SRC
        src/mapping_matrix.c
    )
endif()

list(APPEND OPUS_SRC
    celt/bands.c
    celt/celt.c
    celt/celt_decoder.c
    celt/celt_encoder.c
    celt/celt_lpc.c
    celt/cwrs.c
    celt/entcode.c
    celt/entdec.c
    celt/entenc.c
    celt/kiss_fft.c
    celt/laplace.c
    celt/mathops.c
    celt/mdct.c
    celt/modes.c
    celt/pitch.c
    celt/quant_bands.c
    celt/rate.c
    celt/vq.c
)

if(FLOAT_POINT)
    list(APPEND OPUS_SRC
        src/analysis.c
        src/mlp.c
        src/mlp_data.c
    )
endif()

if(OPUS_X86_ARCHITECTURE)
    if(HAVE_SSE OR MSVC)
        list(APPEND OPUS_SRC
            celt/x86/x86cpu.c
            celt/x86/x86_celt_map.c
            celt/x86/pitch_sse.c
        )
    endif()

    if(HAVE_SSE2 OR MSVC)
        list(APPEND OPUS_SRC
            celt/x86/pitch_sse2.c
            celt/x86/vq_sse2.c
        )
    endif()

    if(HAVE_SSE4_1 OR MSVC)
        list(APPEND OPUS_SRC
            celt/x86/pitch_sse4_1.c
            celt/x86/celt_lpc_sse4_1.c

            silk/x86/NSQ_sse4_1.c
            silk/x86/NSQ_del_dec_sse4_1.c
            silk/x86/x86_silk_map.c
            silk/x86/VAD_sse4_1.c
            silk/x86/VQ_WMat_EC_sse4_1.c
        )
        if(FIXED_POINT)
            list(APPEND OPUS_SRC
                silk/fixed/x86/burg_modified_FIX_sse4_1.c
                silk/fixed/x86/vector_ops_FIX_sse4_1.c
            )
        endif()
    endif()

elseif(OPUS_ARM_ARCHITECTURE)
    list(APPEND OPUS_SRC
        celt/arm/armcpu.c
        celt/arm/arm_celt_map.c
    )

    if(OPUS_ARM_ASM)
        list(APPEND OPUS_SRC
            celt/arm/celt_pitch_xcorr_arm.s
        )
    endif()

    if(HAVE_ARM_NEON_INTR)
        list(APPEND OPUS_SRC
            celt/arm/celt_neon_intr.c
            celt/arm/pitch_neon_intr.c

            silk/arm/arm_silk_map.c
            silk/arm/biquad_alt_neon_intr.c
            silk/arm/LPC_inv_pred_gain_neon_intr.c
            silk/arm/NSQ_del_dec_neon_intr.c
            silk/arm/NSQ_neon.c
        )
        if(FIXED_POINT)
            list(APPEND OPUS_SRC
                silk/fixed/arm/warped_autocorrelation_FIX_neon_intr.c
            )
        endif()
    endif()

    if(HAVE_ARM_NE10)
        list(APPEND OPUS_SRC
            celt/arm/celt_fft_ne10.c
            celt/arm/celt_mdct_ne10.c
        )
    endif()
endif()

list(APPEND OPUS_SRC
    silk/A2NLSF.c
    silk/ana_filt_bank_1.c
    silk/biquad_alt.c
    silk/bwexpander_32.c
    silk/bwexpander.c
    silk/check_control_input.c
    silk/CNG.c
    silk/code_signs.c
    silk/control_audio_bandwidth.c
    silk/control_codec.c
    silk/control_SNR.c
    # silk/debug.c #Useless due no symbols inside because of zeroed in-code macros
    silk/dec_API.c
    silk/decode_core.c
    silk/decode_frame.c
    silk/decode_indices.c
    silk/decode_parameters.c
    silk/decode_pitch.c
    silk/decode_pulses.c
    silk/decoder_set_fs.c
    silk/enc_API.c
    silk/encode_indices.c
    silk/encode_pulses.c
    silk/gain_quant.c
    silk/HP_variable_cutoff.c
    silk/init_decoder.c
    silk/init_encoder.c
    silk/inner_prod_aligned.c
    silk/interpolate.c
    silk/lin2log.c
    silk/log2lin.c
    silk/LPC_analysis_filter.c
    silk/LPC_fit.c
    silk/LPC_inv_pred_gain.c
    silk/LP_variable_cutoff.c
    silk/NLSF2A.c
    silk/NLSF_decode.c
    silk/NLSF_del_dec_quant.c
    silk/NLSF_encode.c
    silk/NLSF_stabilize.c
    silk/NLSF_unpack.c
    silk/NLSF_VQ.c
    silk/NLSF_VQ_weights_laroia.c
    silk/NSQ.c
    silk/NSQ_del_dec.c
    silk/pitch_est_tables.c
    silk/PLC.c
    silk/process_NLSFs.c
    silk/quant_LTP_gains.c
    silk/resampler.c
    silk/resampler_down2_3.c
    silk/resampler_down2.c
    silk/resampler_private_AR2.c
    silk/resampler_private_down_FIR.c
    silk/resampler_private_IIR_FIR.c
    silk/resampler_private_up2_HQ.c
    silk/resampler_rom.c
    silk/shell_coder.c
    silk/sigm_Q15.c
    silk/sort.c
    silk/stereo_decode_pred.c
    silk/stereo_encode_pred.c
    silk/stereo_find_predictor.c
    silk/stereo_LR_to_MS.c
    silk/stereo_MS_to_LR.c
    silk/stereo_quant_pred.c
    silk/sum_sqr_shift.c
    silk/table_LSF_cos.c
    silk/tables_gain.c
    silk/tables_LTP.c
    silk/tables_NLSF_CB_NB_MB.c
    silk/tables_NLSF_CB_WB.c
    silk/tables_other.c
    silk/tables_pitch_lag.c
    silk/tables_pulses_per_block.c
    silk/VAD.c
    silk/VQ_WMat_EC.c
)

if(FIXED_POINT)
    list(APPEND OPUS_SRC
        silk/fixed/apply_sine_window_FIX.c
        silk/fixed/autocorr_FIX.c
        silk/fixed/burg_modified_FIX.c
        silk/fixed/corrMatrix_FIX.c
        silk/fixed/encode_frame_FIX.c
        silk/fixed/find_LPC_FIX.c
        silk/fixed/find_LTP_FIX.c
        silk/fixed/find_pitch_lags_FIX.c
        silk/fixed/find_pred_coefs_FIX.c
        silk/fixed/k2a_FIX.c
        silk/fixed/k2a_Q16_FIX.c
        silk/fixed/LTP_analysis_filter_FIX.c
        silk/fixed/LTP_scale_ctrl_FIX.c
        silk/fixed/noise_shape_analysis_FIX.c
        silk/fixed/pitch_analysis_core_FIX.c
        silk/fixed/process_gains_FIX.c
        silk/fixed/regularize_correlations_FIX.c
        silk/fixed/residual_energy16_FIX.c
        silk/fixed/residual_energy_FIX.c
        silk/fixed/schur64_FIX.c
        silk/fixed/schur_FIX.c
        silk/fixed/vector_ops_FIX.c
        silk/fixed/warped_autocorrelation_FIX.c
    )
endif()
if(FLOAT_POINT)
    list(APPEND OPUS_SRC
        silk/float/apply_sine_window_FLP.c
        silk/float/autocorrelation_FLP.c
        silk/float/burg_modified_FLP.c
        silk/float/bwexpander_FLP.c
        silk/float/corrMatrix_FLP.c
        silk/float/encode_frame_FLP.c
        silk/float/energy_FLP.c
        silk/float/find_LPC_FLP.c
        silk/float/find_LTP_FLP.c
        silk/float/find_pitch_lags_FLP.c
        silk/float/find_pred_coefs_FLP.c
        silk/float/inner_product_FLP.c
        silk/float/k2a_FLP.c
        silk/float/LPC_analysis_filter_FLP.c
        silk/float/LPC_inv_pred_gain_FLP.c
        silk/float/LTP_analysis_filter_FLP.c
        silk/float/LTP_scale_ctrl_FLP.c
        silk/float/noise_shape_analysis_FLP.c
        silk/float/pitch_analysis_core_FLP.c
        silk/float/process_gains_FLP.c
        silk/float/regularize_correlations_FLP.c
        silk/float/residual_energy_FLP.c
        silk/float/scale_copy_vector_FLP.c
        silk/float/scale_vector_FLP.c
        silk/float/schur_FLP.c
        silk/float/sort_FLP.c
        silk/float/warped_autocorrelation_FLP.c
        silk/float/wrappers_FLP.c
    )
endif()

add_library(opus STATIC ${OPUS_SRC})

if(CMAKE_BUILD_TYPE_LOWER STREQUAL "debug")
    target_compile_definitions(opus PRIVATE "-DOPUS_WILL_BE_SLOW")
    message("WARNING!!! OPUS built without of any optimizations will be very slow!")
endif()

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/celt
    ${CMAKE_CURRENT_SOURCE_DIR}/silk
    ${CMAKE_CURRENT_SOURCE_DIR}/silk/float
    ${CMAKE_CURRENT_SOURCE_DIR}/silk/fixed
    ${CMAKE_CURRENT_BINARY_DIR}/config
)

target_include_directories(opus PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)

install(TARGETS opus
        LIBRARY DESTINATION "lib"
        ARCHIVE DESTINATION "lib"
        INCLUDES DESTINATION "include")

install(FILES
        include/opus.h
        include/opus_custom.h
        include/opus_defines.h
        include/opus_multistream.h
        include/opus_projection.h
        include/opus_types.h
        DESTINATION include/opus)

function(bool_to_yesno INBOOL OUTSTRING)
    if(${INBOOL})
        set("${OUTSTRING}" yes PARENT_SCOPE)
    else()
        set("${OUTSTRING}" no PARENT_SCOPE)
    endif()
endfunction()

bool_to_yesno(VAR_ARRAYS    SUMMARY_C99_VARARRAYS)
bool_to_yesno(HAVE_LRINTF   SUMMARY_C99_LRINTF)
bool_to_yesno(USE_ALLOCA    SUMMARY_ALLOCA)
if(NOT USE_ALLOCA AND VAR_ARRAYS)
    set(SUMMARY_ALLOCA "no (using var arrays)")
endif()
bool_to_yesno(FLOAT_POINT   SUMMARY_FLOAT)
bool_to_yesno(ENABLE_FLOAT_APPROX   SUMMARY_FLOAT_APPROX)
bool_to_yesno(ENABLE_FIXED_POINT_DEBUG   SUMMARY_FIXED_POINT_DEBUG)
if(MSVC)
    set(SUMMARY_INTRUISTIC "<Will be detected by C preprocessor>")
else()
    string (REPLACE ";" " " SUMMARY_INTRUISTIC "${SUMMARY_INTRUISTIC}")
endif()
string (REPLACE ";" " " SUMMARY_RTCD "${SUMMARY_RTCD}")
bool_to_yesno(ENABLE_CUSTOM_MODES   SUMMARY_CUSTOM_MODES)
bool_to_yesno(ENABLE_ASSERTIONS     SUMMARY_ASSERTIONS)
bool_to_yesno(ENABLE_HARDENING      SUMMARY_HARDENING)
bool_to_yesno(ENABLE_FUZZING        SUMMARY_FUZZING)
bool_to_yesno(ENABLE_CHECK_ASM      SUMMARY_CHECK_ASM)
bool_to_yesno(ENABLE_EXPERIMENTAL_AMBISONICS    SUMMARY_EXPERIMENTAL_AMBISONICS)

message(
"------------------------------------------------------------------------
  ${PACKAGE_NAME} ${PACKAGE_VERSION} CMake configuration OK.

  Compiler support:

    C99 var arrays: ................ ${SUMMARY_C99_VARARRAYS}
    C99 lrintf: .................... ${SUMMARY_C99_LRINTF}
    Use alloca: .................... ${SUMMARY_ALLOCA}

  General configuration:

    Floating point support: ........ ${SUMMARY_FLOAT}
    Fast float approximations: ..... ${SUMMARY_FLOAT_APPROX}
    Fixed point debugging: ......... ${SUMMARY_FIXED_POINT_DEBUG}
    Inline Assembly Optimizations: . ${SUMMARY_INLINE_ASM}
    External Assembly Optimizations: ${SUMMARY_EXTERNAL_ASM_OPTIMIZATIONS}
    Intrinsics Optimizations: ...... ${SUMMARY_INTRUISTIC}
    Run-time CPU detection: ........ ${SUMMARY_RTCD}
    Custom modes: .................. ${SUMMARY_CUSTOM_MODES}
    Assertion checking: ............ ${SUMMARY_ASSERTIONS}
    Hardening: ..................... ${SUMMARY_HARDENING}
    Fuzzing: ....................... ${SUMMARY_FUZZING}
    Check ASM: ..................... ${SUMMARY_CHECK_ASM}
    Ambisonics support: ............ ${SUMMARY_EXPERIMENTAL_AMBISONICS}
------------------------------------------------------------------------
")
#API documentation: ............. ${enable_doc}
#Extra programs: ................ ${enable_extra_programs}
