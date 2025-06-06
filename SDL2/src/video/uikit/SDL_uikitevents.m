/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2025 Sam Lantinga <slouken@libsdl.org>

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

#ifdef SDL_VIDEO_DRIVER_UIKIT

#include "../../events/SDL_events_c.h"

#include "SDL_system.h"
#include "SDL_uikitevents.h"
#include "SDL_uikitopengles.h"
#include "SDL_uikitvideo.h"
#include "SDL_uikitwindow.h"

#import <Foundation/Foundation.h>

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 140000) || (__APPLETV_OS_VERSION_MAX_ALLOWED >= 140000) || (__MAC_OS_VERSION_MAX_ALLOWED > 1500000)
#import <GameController/GameController.h>

#define ENABLE_GCKEYBOARD
#define ENABLE_GCMOUSE
#endif

static BOOL UIKit_EventPumpEnabled = YES;


@interface SDL_LifecycleObserver : NSObject
@property (nonatomic, assign) BOOL isObservingNotifications;
@end

@implementation SDL_LifecycleObserver

- (void)eventPumpChanged
{
    NSNotificationCenter *notificationCenter = NSNotificationCenter.defaultCenter;
    if (UIKit_EventPumpEnabled && !self.isObservingNotifications) {
        self.isObservingNotifications = YES;
        [notificationCenter addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(applicationWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(applicationDidReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
#if !TARGET_OS_TV
        [notificationCenter addObserver:self selector:@selector(applicationDidChangeStatusBarOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
#endif
    } else if (!UIKit_EventPumpEnabled && self.isObservingNotifications) {
        self.isObservingNotifications = NO;
        [notificationCenter removeObserver:self];
    }
}

- (void)applicationDidBecomeActive
{
    SDL_OnApplicationDidBecomeActive();
}

- (void)applicationWillResignActive
{
    SDL_OnApplicationWillResignActive();
}

- (void)applicationDidEnterBackground
{
    SDL_OnApplicationDidEnterBackground();
}

- (void)applicationWillEnterForeground
{
    SDL_OnApplicationWillEnterForeground();
}

- (void)applicationWillTerminate
{
    SDL_OnApplicationWillTerminate();
}

- (void)applicationDidReceiveMemoryWarning
{
    SDL_OnApplicationDidReceiveMemoryWarning();
}

#if !TARGET_OS_TV
- (void)applicationDidChangeStatusBarOrientation
{
    SDL_OnApplicationDidChangeStatusBarOrientation();
}
#endif

@end


void SDL_iPhoneSetEventPump(SDL_bool enabled)
{
    static SDL_LifecycleObserver *lifecycleObserver;
    static dispatch_once_t onceToken;

    UIKit_EventPumpEnabled = enabled;

    dispatch_once(&onceToken, ^{
        lifecycleObserver = [SDL_LifecycleObserver new];
    });
    [lifecycleObserver eventPumpChanged];
}

void UIKit_PumpEvents(_THIS)
{
    /* Let the run loop run for a short amount of time: long enough for
       touch events to get processed (which is important to get certain
       elements of Game Center's GKLeaderboardViewController to respond
       to touch input), but not long enough to introduce a significant
       delay in the rest of the app.
    */
    const CFTimeInterval seconds = 0.000002;
    SInt32 result;
    if (!UIKit_EventPumpEnabled) {
        return;
    }

    /* Pump most event types. */
    do {
        result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, seconds, TRUE);
    } while (result == kCFRunLoopRunHandledSource);

    /* Make sure UIScrollView objects scroll properly. */
    do {
        result = CFRunLoopRunInMode((CFStringRef)UITrackingRunLoopMode, seconds, TRUE);
    } while(result == kCFRunLoopRunHandledSource);

    /* See the comment in the function definition. */
#if defined(SDL_VIDEO_OPENGL_ES) || defined(SDL_VIDEO_OPENGL_ES2)
    UIKit_GL_RestoreCurrentContext();
#endif
}

#ifdef ENABLE_GCKEYBOARD

static SDL_bool keyboard_connected = SDL_FALSE;
static id keyboard_connect_observer = nil;
static id keyboard_disconnect_observer = nil;

static void OnGCKeyboardConnected(GCKeyboard *keyboard) API_AVAILABLE(macos(11.0), ios(14.0), tvos(14.0))
{
    dispatch_queue_t queue;
    keyboard_connected = SDL_TRUE;
    keyboard.keyboardInput.keyChangedHandler = ^(GCKeyboardInput *kbrd, GCControllerButtonInput *key, GCKeyCode keyCode, BOOL pressed)
    {
        SDL_SendKeyboardKey(pressed ? SDL_PRESSED : SDL_RELEASED, (SDL_Scancode)keyCode);
    };

    queue = dispatch_queue_create( "org.libsdl.input.keyboard", DISPATCH_QUEUE_SERIAL );
    dispatch_set_target_queue( queue, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0 ) );
    keyboard.handlerQueue = queue;
}

static void OnGCKeyboardDisconnected(GCKeyboard *keyboard) API_AVAILABLE(macos(11.0), ios(14.0), tvos(14.0))
{
    keyboard.keyboardInput.keyChangedHandler = nil;
    keyboard_connected = SDL_FALSE;
}

void SDL_InitGCKeyboard(void)
{
    @autoreleasepool {
        if (@available(iOS 14.0, tvOS 14.0, *)) {
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

            keyboard_connect_observer = [center addObserverForName:GCKeyboardDidConnectNotification
                                                            object:nil
                                                             queue:nil
                                                        usingBlock:^(NSNotification *note) {
                                                            GCKeyboard *keyboard = note.object;
                                                            OnGCKeyboardConnected(keyboard);
                                                        }];

            keyboard_disconnect_observer = [center addObserverForName:GCKeyboardDidDisconnectNotification
                                                               object:nil
                                                                queue:nil
                                                           usingBlock:^(NSNotification *note) {
                                                                GCKeyboard *keyboard = note.object;
                                                                OnGCKeyboardDisconnected(keyboard);
                                                           }];

            if (GCKeyboard.coalescedKeyboard != nil) {
                OnGCKeyboardConnected(GCKeyboard.coalescedKeyboard);
            }
        }
    }
}

SDL_bool SDL_HasGCKeyboard(void)
{
    return keyboard_connected;
}

void SDL_QuitGCKeyboard(void)
{
    @autoreleasepool {
        if (@available(iOS 14.0, tvOS 14.0, *)) {
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

            if (keyboard_connect_observer) {
                [center removeObserver:keyboard_connect_observer name:GCKeyboardDidConnectNotification object:nil];
                keyboard_connect_observer = nil;
            }

            if (keyboard_disconnect_observer) {
                [center removeObserver:keyboard_disconnect_observer name:GCKeyboardDidDisconnectNotification object:nil];
                keyboard_disconnect_observer = nil;
            }

            if (GCKeyboard.coalescedKeyboard != nil) {
                OnGCKeyboardDisconnected(GCKeyboard.coalescedKeyboard);
            }
        }
    }
}

#else

void SDL_InitGCKeyboard(void)
{
}

SDL_bool SDL_HasGCKeyboard(void)
{
    return SDL_FALSE;
}

void SDL_QuitGCKeyboard(void)
{
}

#endif /* ENABLE_GCKEYBOARD */


#ifdef ENABLE_GCMOUSE

static int mice_connected = 0;
static id mouse_connect_observer = nil;
static id mouse_disconnect_observer = nil;
static bool mouse_relative_mode = SDL_FALSE;
static SDL_MouseWheelDirection mouse_scroll_direction = SDL_MOUSEWHEEL_NORMAL;

static void UpdateScrollDirection(void)
{
#if 0 /* This code doesn't work for some reason */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"com.apple.swipescrolldirection"]) {
        mouse_scroll_direction = SDL_MOUSEWHEEL_FLIPPED;
    } else {
        mouse_scroll_direction = SDL_MOUSEWHEEL_NORMAL;
    }
#else
    Boolean keyExistsAndHasValidFormat = NO;
    Boolean naturalScrollDirection = CFPreferencesGetAppBooleanValue(CFSTR("com.apple.swipescrolldirection"), kCFPreferencesAnyApplication, &keyExistsAndHasValidFormat);
    if (!keyExistsAndHasValidFormat) {
        /* Couldn't read the preference, assume natural scrolling direction */
        naturalScrollDirection = YES;
    }
    if (naturalScrollDirection) {
        mouse_scroll_direction = SDL_MOUSEWHEEL_FLIPPED;
    } else {
        mouse_scroll_direction = SDL_MOUSEWHEEL_NORMAL;
    }
#endif
}

static void UpdatePointerLock(void)
{
    SDL_VideoDevice *_this = SDL_GetVideoDevice();
    SDL_Window *window;

    for (window = _this->windows; window != NULL; window = window->next) {
        UIKit_UpdatePointerLock(_this, window);
    }
}

static int SetGCMouseRelativeMode(SDL_bool enabled)
{
    mouse_relative_mode = enabled;
    UpdatePointerLock();
    return 0;
}

static void OnGCMouseButtonChanged(SDL_MouseID mouseID, Uint8 button, BOOL pressed)
{
    SDL_SendMouseButton(SDL_GetMouseFocus(), mouseID, pressed ? SDL_PRESSED : SDL_RELEASED, button);
}

static void OnGCMouseConnected(GCMouse *mouse) API_AVAILABLE(macos(11.0), ios(14.0), tvos(14.0))
{
    int auxiliary_button;
    dispatch_queue_t queue;
    SDL_MouseID mouseID = mice_connected;

    mouse.mouseInput.leftButton.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
    {
        OnGCMouseButtonChanged(mouseID, SDL_BUTTON_LEFT, pressed);
    };
    mouse.mouseInput.middleButton.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
    {
        OnGCMouseButtonChanged(mouseID, SDL_BUTTON_MIDDLE, pressed);
    };
    mouse.mouseInput.rightButton.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
    {
        OnGCMouseButtonChanged(mouseID, SDL_BUTTON_RIGHT, pressed);
    };

    auxiliary_button = SDL_BUTTON_X1;
    for (GCControllerButtonInput *btn in mouse.mouseInput.auxiliaryButtons) {
        btn.pressedChangedHandler = ^(GCControllerButtonInput *button, float value, BOOL pressed)
        {
            OnGCMouseButtonChanged(mouseID, auxiliary_button, pressed);
        };
        ++auxiliary_button;
    }

    mouse.mouseInput.mouseMovedHandler = ^(GCMouseInput *mouseInput, float deltaX, float deltaY)
    {
        if (SDL_GCMouseRelativeMode()) {
            SDL_SendMouseMotion(SDL_GetMouseFocus(), mouseID, 1, (int)deltaX, -(int)deltaY);
        }
    };

    mouse.mouseInput.scroll.valueChangedHandler = ^(GCControllerDirectionPad *dpad, float xValue, float yValue) {
        /* Raw scroll values come in here, vertical values in the first axis, horizontal values in the second axis.
         * The vertical values are negative moving the mouse wheel up and positive moving it down.
         * The horizontal values are negative moving the mouse wheel left and positive moving it right.
         * The vertical values are inverted compared to SDL, and the horizontal values are as expected.
         */
        float vertical = -xValue;
        float horizontal = yValue;
        if (mouse_scroll_direction == SDL_MOUSEWHEEL_FLIPPED) {
            /* Since these are raw values, we need to flip them ourselves */
            vertical = -vertical;
            horizontal = -horizontal;
        }
        SDL_SendMouseWheel(SDL_GetMouseFocus(), mouseID, horizontal, vertical, mouse_scroll_direction);
    };
    UpdateScrollDirection();

    queue = dispatch_queue_create( "org.libsdl.input.mouse", DISPATCH_QUEUE_SERIAL );
    dispatch_set_target_queue( queue, dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0 ) );
    mouse.handlerQueue = queue;

    ++mice_connected;

    UpdatePointerLock();
}

static void OnGCMouseDisconnected(GCMouse *mouse) API_AVAILABLE(macos(11.0), ios(14.0), tvos(14.0))
{
    --mice_connected;

    mouse.mouseInput.mouseMovedHandler = nil;

    mouse.mouseInput.leftButton.pressedChangedHandler = nil;
    mouse.mouseInput.middleButton.pressedChangedHandler = nil;
    mouse.mouseInput.rightButton.pressedChangedHandler = nil;

    for (GCControllerButtonInput *button in mouse.mouseInput.auxiliaryButtons) {
        button.pressedChangedHandler = nil;
    }

    UpdatePointerLock();
}

void SDL_InitGCMouse(void)
{
    @autoreleasepool {
        /* There is a bug where mouse accumulates duplicate deltas over time in iOS 14.0 */
        if (@available(iOS 14.1, tvOS 14.1, *)) {
            /* iOS will not send the new pointer touch events if you don't have this key,
             * and we need them to differentiate between mouse events and real touch events.
             */
            BOOL indirect_input_available = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIApplicationSupportsIndirectInputEvents"] boolValue];
            if (indirect_input_available) {
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

                mouse_connect_observer = [center addObserverForName:GCMouseDidConnectNotification
                                                             object:nil
                                                              queue:nil
                                                         usingBlock:^(NSNotification *note) {
                                                             GCMouse *mouse = note.object;
                                                             OnGCMouseConnected(mouse);
                                                         }];

                mouse_disconnect_observer = [center addObserverForName:GCMouseDidDisconnectNotification
                                                                object:nil
                                                                 queue:nil
                                                            usingBlock:^(NSNotification *note) {
                                                                GCMouse *mouse = note.object;
                                                                OnGCMouseDisconnected(mouse);
                                                           }];

                for (GCMouse *mouse in [GCMouse mice]) {
                    OnGCMouseConnected(mouse);
                }

                SDL_GetMouse()->SetRelativeMouseMode = SetGCMouseRelativeMode;
            } else {
                NSLog(@"You need UIApplicationSupportsIndirectInputEvents in your Info.plist for mouse support");
            }
        }
    }
}

SDL_bool SDL_HasGCMouse(void)
{
    return (mice_connected > 0);
}

SDL_bool SDL_GCMouseRelativeMode(void)
{
    return mouse_relative_mode;
}

void SDL_QuitGCMouse(void)
{
    @autoreleasepool {
        if (@available(iOS 14.1, tvOS 14.1, *)) {
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

            if (mouse_connect_observer) {
                [center removeObserver:mouse_connect_observer name:GCMouseDidConnectNotification object:nil];
                mouse_connect_observer = nil;
            }

            if (mouse_disconnect_observer) {
                [center removeObserver:mouse_disconnect_observer name:GCMouseDidDisconnectNotification object:nil];
                mouse_disconnect_observer = nil;
            }

            for (GCMouse *mouse in [GCMouse mice]) {
                OnGCMouseDisconnected(mouse);
            }

            SDL_GetMouse()->SetRelativeMouseMode = NULL;
        }
    }
}

#else

void SDL_InitGCMouse(void)
{
}

SDL_bool SDL_HasGCMouse(void)
{
    return SDL_FALSE;
}

SDL_bool SDL_GCMouseRelativeMode(void)
{
    return SDL_FALSE;
}

void SDL_QuitGCMouse(void)
{
}

#endif /* ENABLE_GCMOUSE */

#endif /* SDL_VIDEO_DRIVER_UIKIT */

/* vi: set ts=4 sw=4 expandtab: */
