//
//  LiveWidgetSceneDelegate.mm
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/5/25.
//

#import "LiveWidgetSceneDelegate.h"

#if TARGET_OS_VISION

#import "VideoViewController.h"

@implementation LiveWidgetSceneDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:static_cast<UIWindowScene *>(scene)];
    VideoViewController *viewController = [VideoViewController new];
    window.rootViewController = viewController;
    [viewController release];
    self.window = window;
    [window makeKeyAndVisible];
    [window release];
}

@end

#endif
