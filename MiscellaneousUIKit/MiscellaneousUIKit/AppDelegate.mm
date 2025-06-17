//
//  AppDelegate.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "AssistiveAccessSceneDelegate.h"
#import <Accessibility/Accessibility.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    if ([connectingSceneSession.role isEqualToString:UIWindowSceneSessionRoleApplication]) {
        UISceneConfiguration *configuration = [[UISceneConfiguration alloc] initWithName:nil sessionRole:UIWindowSceneSessionRoleApplication];
        configuration.delegateClass = [SceneDelegate class];
        return [configuration autorelease];
    } else if ([connectingSceneSession.role isEqualToString:UIWindowSceneSessionRoleAssistiveAccessApplication]) {
        UISceneConfiguration *configuration = [[UISceneConfiguration alloc] initWithName:nil sessionRole:UIWindowSceneSessionRoleApplication];
        configuration.delegateClass = [AssistiveAccessSceneDelegate class];
        return [configuration autorelease];
    } else {
        UISceneConfiguration *configuration = [[UISceneConfiguration alloc] initWithName:nil sessionRole:UIWindowSceneSessionRoleApplication];
        configuration.delegateClass = [SceneDelegate class];
        return [configuration autorelease];
    }
}

- (BOOL)applicationShouldAutomaticallyLocalizeKeyCommands:(UIApplication *)application {
    return YES;
}

- (void)buildMenuWithBuilder:(id<UIMenuBuilder>)builder {
    [super buildMenuWithBuilder:builder];
    
    if ([builder.system isEqual:UIMainMenuSystem.sharedSystem]) {
        [builder insertSiblingMenu:[self _testMenu] beforeMenuForIdentifier:UIMenuFile];
        
        {
            UIMenu *menu = [UIMenu menuWithTitle:@"" image:nil identifier:nil options:UIMenuOptionsDisplayInline children:@[
                [UICommand commandWithTitle:@"Share" image:nil action:@selector(share:) propertyList:UICommandTagShare]
            ]];
            [builder insertSiblingMenu:menu beforeMenuForIdentifier:UIMenuClose];
        }
    }
}

- (UIMenu *)_testMenu {
    UIAction *rebuildAction = [UIAction actionWithTitle:@"Rebuild" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        NSLog(@"Rebuild!");
        [UIMainMenuSystem.sharedSystem setNeedsRebuild];
    }];
    
    UIDeferredMenuElement *deferredElement = [UIDeferredMenuElement elementUsingFocusWithIdentifier:@"Deferred Element" shouldCacheItems:NO];
    
    return [UIMenu menuWithTitle:@"Test" children:@[rebuildAction, deferredElement]];
}

- (void)share:(UIEvent *)sender {
    NSLog(@"%s", sel_getName(_cmd));
}

@end
