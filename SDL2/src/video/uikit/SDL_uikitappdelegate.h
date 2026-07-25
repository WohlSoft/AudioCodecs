/*
  Simple DirectMedia Layer
  Copyright (C) 1997-2026 Sam Lantinga <slouken@libsdl.org>

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

#import <UIKit/UIKit.h>
#include <AvailabilityVersions.h>

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000) || (defined(__TV_OS_VERSION_MAX_ALLOWED) && __TV_OS_VERSION_MAX_ALLOWED >= 130000)
# ifndef SDL_UIKIT_HAS_UISCENE
#   define SDL_UIKIT_HAS_UISCENE
# endif
#endif

@interface SDLLaunchScreenController : UIViewController

- (instancetype)init;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)loadView;

@end

#ifdef SDL_UIKIT_HAS_UISCENE
API_AVAILABLE(ios(13.0))
@interface SDLUIKitSceneDelegate : NSObject <UIApplicationDelegate, UIWindowSceneDelegate>

+ (NSString *)getSceneDelegateClassName;

- (void)hideLaunchScreen;

@end
#endif

@interface SDLUIKitDelegate : NSObject <UIApplicationDelegate>

+ (id)sharedAppDelegate;
+ (NSString *)getAppDelegateClassName;

- (void)hideLaunchScreen;

/* This property is marked as optional, and is only intended to be used when
 * the app's UI is storyboard-based. SDL is not storyboard-based, however
 * several major third-party ad APIs (e.g. Google admob) incorrectly assume this
 * property always exists, and will crash if it doesn't. */
@property (nonatomic, strong) UIWindow *window;

@end

/* vi: set ts=4 sw=4 expandtab: */
