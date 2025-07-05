//
//  AppDelegate.m
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "LiveWidgetSceneDelegate.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    if ([connectingSceneSession.role isEqualToString:@"RWSSceneSessionRoleLiveSceneWidget"]) {
        UISceneConfiguration *configuration = [connectingSceneSession.configuration copy];
        configuration.delegateClass = [LiveWidgetSceneDelegate class];
        return [configuration autorelease];
    } else {
        UISceneConfiguration *configuration = [connectingSceneSession.configuration copy];
        configuration.delegateClass = [SceneDelegate class];
        return [configuration autorelease];
    }
}

@end
