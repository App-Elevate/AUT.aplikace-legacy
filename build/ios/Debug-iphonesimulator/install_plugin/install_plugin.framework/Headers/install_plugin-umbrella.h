#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "InstallPlugin.h"

FOUNDATION_EXPORT double install_pluginVersionNumber;
FOUNDATION_EXPORT const unsigned char install_pluginVersionString[];

