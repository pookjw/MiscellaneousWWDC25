//
//  SceneDelegate.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "SceneDelegate.h"
#import "HomeViewController.h"
#import <TargetConditionals.h>

// _NSStringFromUIWindowingControlStyleType

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [homeViewController release];
    navigationController.toolbarHidden = NO;
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
    window.rootViewController = navigationController;
    [navigationController release];
    
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

- (void)windowScene:(UIWindowScene *)windowScene didUpdateEffectiveGeometry:(UIWindowSceneGeometry *)previousEffectiveGeometry {
#if TARGET_OS_VISION
    NSLog(@"%@", windowScene.effectiveGeometry);
#else
    NSLog(@"%@, interfaceOrientationLocked: %d", windowScene.effectiveGeometry, windowScene.effectiveGeometry.interfaceOrientationLocked);
#endif
}

- (UISceneWindowingControlStyle *)preferredWindowingControlStyleForScene:(UIWindowScene *)windowScene {
#if TARGET_OS_VISION
    return UISceneWindowingControlStyle.automaticStyle;
#else
    return UISceneWindowingControlStyle.unifiedStyle;
#endif
}

@end
