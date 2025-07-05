//
//  main.m
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <dlfcn.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        void *handle = dlopen("/System/Library/PrivateFrameworks/RealityWidgetsServices.framework/RealityWidgetsServices", RTLD_NOW);
        assert(handle != NULL);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
