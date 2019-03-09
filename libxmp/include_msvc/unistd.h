/**
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is part of the mingw-w64 runtime package.
 * No warranty is given; refer to the file DISCLAIMER.PD within this package.
 */
#ifndef _UNISTD_H
#define _UNISTD_H

#include <io.h>
#include <process.h>
#include <windows.h>

/* These are also defined in stdio.h. */
#ifndef SEEK_SET
#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2
#endif

/* These are also defined in stdio.h. */
#ifndef STDIN_FILENO
#define STDIN_FILENO  0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2
#endif

/* Used by shutdown(2). */
#ifdef _POSIX_SOURCE

/* MySql connector already defined SHUT_RDWR. */
#ifndef SHUT_RDWR
#define SHUT_RD   0x00
#define SHUT_WR   0x01
#define SHUT_RDWR 0x02
#endif

#endif

#endif /* _UNISTD_H */

