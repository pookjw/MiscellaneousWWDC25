//
//  SceneDelegate.mm
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "SceneDelegate.h"
#import "ViewController.h"

@interface SceneDelegate ()
@end

@implementation SceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:static_cast<UIWindowScene *>(scene)];
    ViewController *viewController = [ViewController new];
    window.rootViewController = viewController;
    [viewController release];
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end
