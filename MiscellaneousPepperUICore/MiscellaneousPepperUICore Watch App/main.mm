//
//  main.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/31/24.
//

#import <UIKit/UIKit.h>
#import <WatchKit/WatchKit.h>
#import "AppDelegate.h"
#include <dlfcn.h>

WKI_EXTERN void spUtils_setRunningExtensionlessWKApp(BOOL);
UIKIT_EXTERN int UIApplicationMain(int argc, char * _Nullable argv[_Nonnull], NSString * _Nullable principalClassName, NSString * _Nullable delegateClassName);

int main(int argc, char * argv[]) {
    spUtils_setRunningExtensionlessWKApp(YES);
    
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    
    @autoreleasepool {
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"UIStateRestorationDebugLogging"];
    }
    
    void *handle = dlopen("/System/Library/PrivateFrameworks/UIKitCore.framework/UIKitCore", RTLD_NOW);
    void *symbol = dlsym(handle, "UIApplicationMain");
    
    int (*casted)(int argc, char * _Nullable argv[_Nonnull], NSString * _Nullable principalClassName, NSString * _Nullable delegateClassName) = (int (*)(int, char * _Nullable [_Nonnull], NSString * _Nullable, NSString * _Nullable))symbol;
    
    int result = casted(argc, argv, @"SPApplication", NSStringFromClass(AppDelegate.class));
    [pool release];
    return result;
}
