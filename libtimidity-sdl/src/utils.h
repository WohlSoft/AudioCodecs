/*
  SDL_mixer:  An audio mixer library based on the SDL library
  Copyright (C) 1997-2021 Sam Lantinga <slouken@libsdl.org>

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.
*/

#ifndef UTILS_H_
#define UTILS_H_

/* misc helper routines */

#include "SDL_stdinc.h"
#include "SDL_version.h"

#if SDL_VERSION_ATLEAST(2,0,12)
#define HAVE_SDL_STRTOKR
#else
#define SDL_strtokr _TimidityStrTok
extern char *SDL_strtokr(char *s1, const char *s2, char **saveptr);
#endif

#endif /* UTILS_H_ */

