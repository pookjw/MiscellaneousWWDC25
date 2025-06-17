//
//  SceneDelegate.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "SceneDelegate.h"
#import "HomeViewController.h"

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
    NSLog(@"%@, interfaceOrientationLocked: %d", windowScene.effectiveGeometry, windowScene.effectiveGeometry.interfaceOrientationLocked);
}

- (UISceneWindowingControlStyle *)preferredWindowingControlStyleForScene:(UIWindowScene *)windowScene {
    return UISceneWindowingControlStyle.unifiedStyle;
}

@end
