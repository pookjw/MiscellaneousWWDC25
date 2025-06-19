//
//  RequestHostingSceneObjCViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import "RequestHostingSceneObjCViewController.h"
#include <objc/runtime.h>
#include <objc/message.h>
#import "MiscellaneousUIKit-Swift.h"

@interface RequestHostingSceneObjCViewController ()
@property (retain, nonatomic, readonly, getter=_button) UIButton *button;
@end

@implementation RequestHostingSceneObjCViewController
@synthesize button = _button;

- (void)dealloc {
    [_button release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.button.frame = self.view.bounds;
    self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.button];
    
    self.view.backgroundColor = UIColor.systemBackgroundColor;
}

- (UIButton *)_button {
    if (auto button = _button) return button;
    
    UIButton *button = [UIButton new];
    UIButtonConfiguration *configuration = UIButtonConfiguration.tintedGlassButtonConfiguration;
    configuration.title = @"Menu";
    button.configuration = configuration;
    button.showsMenuAsPrimaryAction = YES;
    button.menu = [self _makeMenu];
    
    _button = button;
    return button;
}

- (UIMenu *)_makeMenu {
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        UISceneSessionActivationRequest *swift_activationRequest = HostingSceneDelegate.activationRequest;
        NSString *bridingID = static_cast<NSNumber *>(swift_activationRequest.userActivity.userInfo[@"com.apple.SwiftUI.sceneNamespace"]).stringValue;
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Request Activation" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                UISceneConfiguration *configuration =  reinterpret_cast<id (*)(Class, SEL, id, id, Class)>(objc_msgSend)([UISceneConfiguration class], sel_registerName("_configurationWithRole:bridgingID:sceneDelegateWrapper:"), UIWindowSceneSessionRoleApplication, bridingID, objc_lookUpClass("SwiftUI.AppSceneDelegate"));
                configuration.delegateClass = [HostingSceneDelegate class];
                
                UISceneSessionActivationRequest *request = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)([UISceneSessionActivationRequest class], sel_registerName("_requestWithConfiguration:"), configuration);
                
                [UIApplication.sharedApplication activateSceneSessionForRequest:request errorHandler:^(NSError * _Nonnull error) {
                    abort();
                }];
            }];
            
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Request Activation (Custom Text)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                UISceneConfiguration *configuration =  reinterpret_cast<id (*)(Class, SEL, id, id, Class)>(objc_msgSend)([UISceneConfiguration class], sel_registerName("_configurationWithRole:bridgingID:sceneDelegateWrapper:"), UIWindowSceneSessionRoleApplication, bridingID, objc_lookUpClass("SwiftUI.AppSceneDelegate"));
                configuration.delegateClass = [HostingSceneDelegate class];
                
                UISceneSessionActivationRequest *request = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)([UISceneSessionActivationRequest class], sel_registerName("_requestWithConfiguration:"), configuration);
                
                NSUserActivity *userActivity = request.userActivity;
                if (userActivity == nil) {
                    userActivity = [[[NSUserActivity alloc] initWithActivityType:@"com.pookjw.MiscellaneousUIKit.openWindowByID"] autorelease];
                }
                NSData *sceneValue = [@"From Objective-C!" dataUsingEncoding:NSUTF8StringEncoding];
                [userActivity addUserInfoEntriesFromDictionary:@{
                    @"com.apple.SwiftUI.sceneValue": sceneValue,
                    @"com.apple.SwiftUI.sceneID": @"Custom Text",
                    @"com.apple.SwiftUI.sceneNamespace": bridingID
                }];
                request.userActivity = userActivity;
                
                [UIApplication.sharedApplication activateSceneSessionForRequest:request errorHandler:^(NSError * _Nonnull error) {
                    abort();
                }];
            }];
            
            [results addObject:action];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end

/*
 (lldb) po [0x1024977f0 _ivarDescription]
 <UISceneConfiguration: 0x1024977f0>:
 in UISceneConfiguration:
     _hadResolutionErrorsOnLoad (BOOL): NO
     _isDefault (BOOL): NO
     _fromPlist (BOOL): NO
     _name (NSString*): nil
     _role (NSString*): @"UIWindowSceneSessionRoleApplication"
     _sceneClass (Class): (null)
     _delegateClass (Class): MiscellaneousUIKit.HostingSceneDelegate
     _storyboard (UIStoryboard*): nil
     _canBeAppliedToInternalScenes (BOOL): NO
     _bridgingID (NSString*): @"4324271880"
     _sceneDelegateWrapper (Class): SwiftUI.AppSceneDelegate
 in NSObject:
     isa (Class): UISceneConfiguration (isa, 0x1000001f2e63829)
 */
