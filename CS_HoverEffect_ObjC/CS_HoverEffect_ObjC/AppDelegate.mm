//
//  AppDelegate.m
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "ImmersiveSceneDelegate.h"
#import <CompositorServices/CompositorServices.h>
#include <objc/runtime.h>

CP_EXTERN UISceneSessionRole const CPSceneSessionRoleImmersiveSpaceApplication;

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *configuration = [connectingSceneSession.configuration copy];
    
    if ([configuration.role isEqualToString:CPSceneSessionRoleImmersiveSpaceApplication]) {
        configuration.delegateClass = [ImmersiveSceneDelegate class];
        configuration.sceneClass = objc_lookUpClass("CPImmersiveScene");
    } else {
        configuration.delegateClass = [SceneDelegate class];
    }
    
    return [configuration autorelease];
}

@end
