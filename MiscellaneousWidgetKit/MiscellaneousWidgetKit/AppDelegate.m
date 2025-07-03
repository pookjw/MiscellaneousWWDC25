//
//  AppDelegate.m
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    UISceneConfiguration *configuration = [connectingSceneSession.configuration copy];
    configuration.delegateClass = [SceneDelegate class];
    return [configuration autorelease];
}

@end
