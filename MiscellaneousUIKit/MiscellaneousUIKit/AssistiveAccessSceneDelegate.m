//
//  AssistiveAccessSceneDelegate.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/16/25.
//

#import "AssistiveAccessSceneDelegate.h"
#import "HomeViewController.h"

@implementation AssistiveAccessSceneDelegate

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

@end
