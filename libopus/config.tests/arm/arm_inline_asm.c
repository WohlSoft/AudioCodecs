#ifdef __GNUC_MINOR__
#if (__GNUC__ * 1000 + __GNUC_MINOR__) < 3004
#error GCC before 3.4 has critical bugs compiling inline assembly
#endif
#endif
__asm__ (""::)