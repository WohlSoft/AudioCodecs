/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2022 Sam Lantinga <slouken@libsdl.org>

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
#include "../../SDL_internal.h"

#ifdef SDL_THREAD_N3DS

/* Thread management routines for SDL */

#include "../SDL_systhread.h"

/* N3DS has very limited RAM (128MB), so we put a limit on thread stack size. */
#define N3DS_THREAD_STACK_SIZE_MAX     (16 * 1024)
#define N3DS_THREAD_STACK_SIZE_DEFAULT (4 * 1024)

#define N3DS_THREAD_PRIORITY_LOW           0x3F /**< Minimum priority */
#define N3DS_THREAD_PRIORITY_MEDIUM        0x2F /**< Slightly higher than main thread (0x30) */
#define N3DS_THREAD_PRIORITY_HIGH          0x19 /**< High priority for non-video work */
#define N3DS_THREAD_PRIORITY_TIME_CRITICAL 0x18 /**< Highest priority */

static size_t GetStackSize(size_t requested_size);

static void
ThreadEntry(void *arg)
{
    SDL_RunThread((SDL_Thread *) arg);
    threadExit(0);
}

#ifdef SDL_PASSED_BEGINTHREAD_ENDTHREAD
#error "SDL_PASSED_BEGINTHREAD_ENDTHREAD is not supported on N3DS"
#endif

int
SDL_SYS_CreateThread(SDL_Thread *thread)
{
    s32 priority = N3DS_THREAD_PRIORITY_MEDIUM;
    size_t stack_size = GetStackSize(thread->stacksize);
    int cpu = -1;
    bool detatched = false;

    if (SDL_strcmp(thread->name, "SDLAudioP0") == 0 ||
        SDL_strcmp(thread->name, "SDLAudioP1") == 0 ||
        SDL_strcmp(thread->name, "SDLAudioP2") == 0) {
        /* stack_size = 32 * 1024;*/
        detatched = true;
        cpu = 0; /* application core */
        if (R_SUCCEEDED(APT_SetAppCpuTimeLimit(30))) {
            cpu = 1; /* system core */
        }
        /*
        // Set the thread priority to the main thread's priority ...
        priority = 0x30;
        svcGetThreadPriority(&priority, CUR_THREAD_HANDLE);
        // ... then subtract 1, as lower number => higher actual priority ...
        priority -= 1;
        // ... finally, clamp it between 0x18 and 0x3F to guarantee that it's valid.
        priority = SDL_clamp(priority, 0x19, 0x3F);
        */
    }

    thread->handle = threadCreate(ThreadEntry,
                                  thread,
                                  stack_size,
                                  priority,
                                  cpu,
                                  detatched);

    if (thread->handle == NULL) {
        return SDL_SetError("Couldn't create thread");
    }

    return 0;
}

static size_t
GetStackSize(size_t requested_size)
{
    if (requested_size == 0) {
        return N3DS_THREAD_STACK_SIZE_DEFAULT;
    }

    if (requested_size > N3DS_THREAD_STACK_SIZE_MAX) {
        SDL_LogWarn(SDL_LOG_CATEGORY_SYSTEM,
                    "Requested a thread size of %zu,"
                    " falling back to the maximum supported of %zu\n",
                    requested_size,
                    N3DS_THREAD_STACK_SIZE_MAX);
        requested_size = N3DS_THREAD_STACK_SIZE_MAX;
    }
    return requested_size;
}

void
SDL_SYS_SetupThread(const char *name)
{
    return;
}

SDL_threadID
SDL_ThreadID(void)
{
    u32 thread_ID = 0;
    svcGetThreadId(&thread_ID, CUR_THREAD_HANDLE);
    return (SDL_threadID) thread_ID;
}

int
SDL_SYS_SetThreadPriority(SDL_ThreadPriority sdl_priority)
{
    s32 svc_priority;
    switch (sdl_priority) {
    case SDL_THREAD_PRIORITY_LOW:
        svc_priority = N3DS_THREAD_PRIORITY_LOW;
        break;
    case SDL_THREAD_PRIORITY_NORMAL:
        svc_priority = N3DS_THREAD_PRIORITY_MEDIUM;
        break;
    case SDL_THREAD_PRIORITY_HIGH:
        svc_priority = N3DS_THREAD_PRIORITY_HIGH;
        break;
    case SDL_THREAD_PRIORITY_TIME_CRITICAL:
        svc_priority = N3DS_THREAD_PRIORITY_TIME_CRITICAL;
        break;
    default:
        svc_priority = N3DS_THREAD_PRIORITY_MEDIUM;
    }
    return (int) svcSetThreadPriority(CUR_THREAD_HANDLE, svc_priority);
}

void
SDL_SYS_WaitThread(SDL_Thread *thread)
{
    Result res = threadJoin(thread->handle, U64_MAX);

    /*
      Detached threads can be waited on, but should NOT be cleaned manually
      as it would result in a fatal error.
    */
    if (R_SUCCEEDED(res) && SDL_AtomicGet(&thread->state) != SDL_THREAD_STATE_DETACHED) {
        threadFree(thread->handle);
    }
}

void
SDL_SYS_DetachThread(SDL_Thread *thread)
{
    threadDetach(thread->handle);
}

#endif /* SDL_THREAD_N3DS */

/* vi: set sts=4 ts=4 sw=4 expandtab: */
