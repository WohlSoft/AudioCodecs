/* config.h.  Generated from config.h.in by configure.  */
/* config.h.in.  Generated from configure.ac by autoheader.  */

/* define if the compiler supports basic C++11 syntax */
#define HAVE_CXX11 1

/* Define to 1 if you have the <dlfcn.h> header file. */
#ifndef _WIN32
#define HAVE_DLFCN_H 1
#endif

/* Define to 1 if you have the <inttypes.h> header file. */
#define HAVE_INTTYPES_H 1

/* Define to 1 if you have the <memory.h> header file. */
#define HAVE_MEMORY_H 1

/* Define to 1 if you have the <stdint.h> header file. */
#define HAVE_STDINT_H 1

/* Define to 1 if you have the <stdlib.h> header file. */
#define HAVE_STDLIB_H 1

/* Define to 1 if you have the <strings.h> header file. */
#define HAVE_STRINGS_H 1

/* Define to 1 if you have the <string.h> header file. */
#define HAVE_STRING_H 1

/* Define to 1 if you have the <sys/stat.h> header file. */
#define HAVE_SYS_STAT_H 1

/* Define to 1 if you have the <sys/types.h> header file. */
#define HAVE_SYS_TYPES_H 1

/* Define to 1 if you have the <unistd.h> header file. */
#ifndef _WIN32
#define HAVE_UNISTD_H 1
#endif

/* Define to the sub-directory in which libtool stores uninstalled libraries.
   */
#define LT_OBJDIR ".libs/"

/* enable dlopen */
/* #undef MPT_ENABLE_DLOPEN */

/* is package */
#define MPT_PACKAGE true

/* svn date */
#define MPT_SVNDATE "2017-08-12T15:05:25.794968Z"

/* svn version */
#define MPT_SVNURL "https://source.openmpt.org/svn/openmpt/tags/libopenmpt-0.2.8760-beta27"

/* svn version */
#define MPT_SVNVERSION "8762"

/* with libflac */
/* #undef MPT_WITH_FLAC */

/* with mpg123 */
/* #undef MPT_WITH_MPG123 */

/* with ogg */
/* #undef MPT_WITH_OGG */

/* with libportaudio */
/* #undef MPT_WITH_PORTAUDIO */

/* with libportaudiocpp */
/* #undef MPT_WITH_PORTAUDIOCPP */

/* with libpulseaudio */
/* #undef MPT_WITH_PULSEAUDIO */

/* with libsdl */
/* #undef MPT_WITH_SDL */

/* with libsdl2 */
/* #undef MPT_WITH_SDL2 */

/* with libsndfile */
/* #undef MPT_WITH_SNDFILE */

/* with vorbis */
/* #undef MPT_WITH_VORBIS */

/* with vorbisfile */
/* #undef MPT_WITH_VORBISFILE */

/* with zlib */
#define MPT_WITH_ZLIB /**/

/* Name of package */
#define PACKAGE "libopenmpt"

/* Define to the address where bug reports for this package should be sent. */
#define PACKAGE_BUGREPORT "https://bugs.openmpt.org/"

/* Define to the full name of this package. */
#define PACKAGE_NAME "libopenmpt"

/* Define to the full name and version of this package. */
#define PACKAGE_STRING "libopenmpt 0.2.8762-autotools"

/* Define to the one symbol short name of this package. */
#define PACKAGE_TARNAME "libopenmpt"

/* Define to the home page for this package. */
#define PACKAGE_URL "https://lib.openmpt.org/"

/* Define to the version of this package. */
#define PACKAGE_VERSION "0.2.8762-autotools"

/* Define to 1 if you have the ANSI C header files. */
#define STDC_HEADERS 1

/* Version number of package */
#define VERSION "0.2.8762-autotools"

/* Enable large inode numbers on Mac OS X 10.5.  */
#ifndef _DARWIN_USE_64_BIT_INODE
# define _DARWIN_USE_64_BIT_INODE 1
#endif

/* Number of bits in a file offset, on hosts where this is settable. */
/* #undef _FILE_OFFSET_BITS */

/* Define for large files, on AIX-style hosts. */
/* #undef _LARGE_FILES */
