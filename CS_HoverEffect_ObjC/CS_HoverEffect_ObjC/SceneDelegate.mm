//
//  SceneDelegate.m
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import "SceneDelegate.h"
#import "ConfigurationViewController.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindowScene *windowScene = static_cast<UIWindowScene *>(scene);
    windowScene.sizeRestrictions.maximumSize = CGSizeMake(300., 300.);
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    ConfigurationViewController *configurationViewController = [ConfigurationViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:configurationViewController];
    [configurationViewController release];
    window.rootViewController = navigationController;
    [navigationController release];
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
