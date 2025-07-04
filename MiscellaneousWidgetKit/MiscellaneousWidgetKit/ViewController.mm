//
//  ViewController.mm
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "ViewController.h"
#import "UIControl+Category.h"
#import "MiscellaneousWidgetKit-Swift.h"
#include <objc/message.h>
#include <objc/runtime.h>
#import "MyWidgetCenter.h"

OBJC_EXTERN id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface ViewController ()
@property (retain, nonatomic, readonly, getter=_menuButton) UIButton *menuButton;
@end

@implementation ViewController
@synthesize menuButton = _menuButton;

- (void)dealloc {
    [_menuButton release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.menuButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    [self.menuButton he_presentMenu];
}

- (UIButton *)_menuButton {
    if (auto menuButton = _menuButton) return menuButton;
    
    UIButton *menuButton = [UIButton new];
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration borderedProminentButtonConfiguration];
    configuration.title = @"Menu";
    menuButton.configuration = configuration;
    
    menuButton.showsMenuAsPrimaryAction = YES;
    menuButton.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    menuButton.menu = [self _makeMenu];
    
    _menuButton = menuButton;
    return menuButton;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        [weakSelf _makeMyWidgetCenterMenuWithCompletion:^(UIMenu *myWidgetCenterMenu) {
            [weakSelf _makeCHSChronoServicesConnectionMenuWithCompletion:^(UIMenu *chronoServicesConnectionMenu) {
                UIMenu *widgetCenterMenu = [weakSelf _makeWidgetCenterMenu];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(@[widgetCenterMenu, myWidgetCenterMenu, chronoServicesConnectionMenu]);
                });
            }];
        }];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (UIMenu *)_makeWidgetCenterMenu {
    NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
    __weak auto weakSelf = self;
    
    {
        UIAction *action = [UIAction actionWithTitle:@"reloadAllTimelines" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            WidgetCenter_reloadAllTimelines();
            [weakSelf.menuButton he_presentMenu];
        }];
        [children addObject:action];
    }
    
    {
        UIAction *action = [UIAction actionWithTitle:@"currentConfigurations" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            WidgetCenter_currentConfigurations();
            [weakSelf.menuButton he_presentMenu];
        }];
        [children addObject:action];
    }
    
    UIMenu *menu = [UIMenu menuWithTitle:@"WidgetCenter" children:children];
    [children release];
    
    return menu;
}

- (void)_makeMyWidgetCenterMenuWithCompletion:(void (^)(UIMenu *myWidgetCenterMenu))completion {
    __weak auto weakSelf = self;
    
    [MyWidgetCenter.sharedInstance loadCurrentConfigurations:^(NSArray * _Nullable configurations, NSError * _Nullable error) {
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        {
            UIAction *action = [UIAction actionWithTitle:@"_reloadAllTimelines:" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                WidgetCenter_reloadAllTimelines();
                [MyWidgetCenter.sharedInstance reloadAllTimelines:^(NSError * _Nullable error) {
                    assert(error == nil);
                }];
                [weakSelf.menuButton he_presentMenu];
            }];
            [children addObject:action];
        }
        
        if (configurations.count > 0) {
            {
                NSMutableArray<__kindof UIMenuElement *> *elements = [NSMutableArray new];
                
                for (id configuration in configurations) {
                    NSString *kind = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(configuration, sel_registerName("kind"));
                    UIAction *action = [UIAction actionWithTitle:kind image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        [MyWidgetCenter.sharedInstance reloadAllTimelinesOfKind:kind completion:^(NSError * _Nullable error) {
                            assert(error == nil);
                        }];
                    }];
                    [elements addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Reload Specific Widget" children:elements];
                [elements release];
                [children addObject:menu];
            }
            
            {
                NSMutableArray<__kindof UIMenuElement *> *elements = [NSMutableArray new];
                
                for (id configuration in configurations) {
                    NSString *kind = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(configuration, sel_registerName("kind"));
                    UIAction *action = [UIAction actionWithTitle:kind image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        [MyWidgetCenter.sharedInstance reloadAllTimelinesOfKind:kind inBundle:@"com.pookjw.MiscellaneousWidgetKit.WidgetExtension" completion:^(NSError * _Nullable error) {
                            assert(error == nil);
                        }];
                    }];
                    [elements addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Reload Specific Widget (With Bundle)" children:elements];
                [elements release];
                [children addObject:menu];
            }
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"invalidateConfigurationRecommendationsInBundle" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [MyWidgetCenter.sharedInstance invalidateConfigurationRecommendationsInBundle:@"com.pookjw.MiscellaneousWidgetKit.WidgetExtension" completion:^(NSError * _Nullable error) {
                    assert(error == nil);
                }];
                [weakSelf.menuButton he_presentMenu];
            }];
            [children addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"widgetPushTokenWithCompletionHandler" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [MyWidgetCenter.sharedInstance widgetPushTokenWithCompletionHandler:^(NSData * _Nullable pushInfo, NSError * _Nullable error) {
                    assert(error == nil);
                }];
            }];
            [children addObject:action];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *elements = [NSMutableArray new];
            
            for (id configuration in configurations) {
                NSString *kind = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(configuration, sel_registerName("kind"));
                UIAction *action = [UIAction actionWithTitle:kind image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    [MyWidgetCenter.sharedInstance widgetRelevanceArchiveForKind:kind inBundle:@"com.pookjw.MiscellaneousWidgetKit.WidgetExtension" handler:^(NSError * _Nullable error, NSFileHandle * _Nullable handle) {
                        assert(error == nil);
                    }];
                }];
                [elements addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"widgetRelevanceArchiveForKind" children:elements];
            [elements release];
            [children addObject:menu];
        }
        
        UIMenu *menu = [UIMenu menuWithTitle: @"MyWidgetCenter" children:children];
        [children release];
        completion(menu);
    }];
}

- (void)_makeCHSChronoServicesConnectionMenuWithCompletion:(void (^)(UIMenu *chronoServicesConnectionMenu))completion {
    id connection = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("CHSChronoServicesConnection"), @selector(sharedInstance));
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(connection, sel_registerName("allWidgetConfigurationsByHostWithCompletion:"), ^(id box, NSError * _Nullable error) {
        NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
        
        {
            UIAction *action = [UIAction actionWithTitle:@"allPairedDevices" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                NSArray *allPairedDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(connection, sel_registerName("allPairedDevices"));
                NSLog(@"%@", allPairedDevices);
            }];
            [children addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"fetchDescriptorsForContainerBundleIdentifier:completion:" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(connection, sel_registerName("fetchDescriptorsForContainerBundleIdentifier:completion:"), @"com.pookjw.MiscellaneousWidgetKit", ^(id _Nullable result, NSError * _Nullable error) {
                    NSDictionary *descriptorsByExtensionIdentifier = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(result, sel_registerName("descriptorsByExtensionIdentifier"));
                    NSLog(@"%@", descriptorsByExtensionIdentifier);
                });
            }];
            [children addObject:action];
        }
        
        UIMenu *menu = [UIMenu menuWithTitle: @"CHSChronoServicesConnection" children:children];
        [children release];
        
        completion(menu);
    });
}

@end

/*
 <NSXPCInterface: 0x600000c400c0>
 Protocol: WidgetKit.WidgetCenterConnection_Host
 SEL: _reloadAllTimelines: (1 arguments, 0 proxies)
  Classes: [{}]
  Reply block: (arg #2, (1 arguments, 0 proxies), signature 'v@?@"NSError"') [NSError]
 SEL: _loadCurrentConfigurations: (1 arguments, 0 proxies)
  Classes: [{}]
  Reply block: (arg #2, (2 arguments, 0 proxies), signature 'v@?@"NSArray"@"NSError"') [{NSArray, CHSWidget}, {NSError}]
 
 <WidgetKit.WidgetCenterConnection_Host: 0x1f2bd4808> :
 in WidgetKit.WidgetCenterConnection_Host:
     Instance Methods:
         - (void) _reloadAllTimelines:(^block)arg1;
         - (void) _loadCurrentConfigurations:(^block)arg1;
         - (void) _reloadTimelinesOfKind:(id)arg1 completion:(^block)arg2;
         - (void) _reloadTimelinesOfKind:(id)arg1 inBundle:(id)arg2 completion:(^block)arg3;
         - (void) invalidateConfigurationRecommendationsInBundle:(id)arg1 completion:(^block)arg2;
         - (void) invalidateConfigurationRecommendationsWithCompletion:(^block)arg1;
         - (void) invalidateRelevancesOfKind:(id)arg1 completionHandler:(^block)arg2;
         - (void) invalidateRelevancesOfKind:(id)arg1 inBundle:(id)arg2 completionHandler:(^block)arg3;
         - (void) widgetPushTokenWithCompletionHandler:(^block)arg1;
         - (void) widgetRelevanceArchiveForKind:(id)arg1 inBundle:(id)arg2 handler:(^block)arg3;
 */

/*
 (lldb) po [NSObject _fd__protocolDescriptionForProtocol:(Protocol *)NSProtocolFromString(@"CHSChronoWidgetServiceServerInterface")]
 <CHSChronoWidgetServiceServerInterface: 0x1f2bee1e8> (NSObject) :
 in CHSChronoWidgetServiceServerInterface:
     Instance Methods:
         - (id) allPairedDevices;
         - (void) invalidateRelevancesOfKind:(id)arg1 inBundle:(id)arg2 completion:(^block)arg3;
         - (id) _URLSessionDidCompleteForExtensionWithBundleIdentifier:(id)arg1 info:(id)arg2;
         - (void) removeWidgetHostWithIdentifier:(id)arg1;
         - (void) getAppIntentsXPCListenerEndpointForBundleIdentifier:(id)arg1 completion:(^block)arg2;
         - (id) acquireKeepAliveAssertionForExtensionBundleIdentifier:(id)arg1 reason:(id)arg2 error:(o^@)arg3;
         - (void) acquireLifetimeAssertionForWidget:(id)arg1 metrics:(id)arg2 completion:(^block)arg3;
         - (void) allWidgetConfigurationsByHostWithCompletion:(^block)arg1;
         - (void) fetchDescriptorsForContainerBundleIdentifier:(id)arg1 completion:(^block)arg2;
         - (void) flushPowerlog;
         - (void) launchLiveActivityWithID:(id)arg1 deviceID:(id)arg2 url:(id)arg3;
         - (void) loadSuggestedWidget:(id)arg1 metrics:(id)arg2 stackIdentifier:(id)arg3 reason:(id)arg4 completion:(^block)arg5;
         - (void) modifyDescriptorEnablement:(id)arg1 completion:(^block)arg2;
         - (void) pairDeviceWith:(id)arg1 completion:(^block)arg2;
         - (void) performDescriptorDiscoveryForHost:(id)arg1;
         - (void) reloadDescriptorsForContainerBundleIdentifier:(id)arg1 completion:(^block)arg2;
         - (_Bool) reloadRemoteWidgetsWithError:(id*)arg1;
         - (void) reloadTimeline:(id)arg1 error:(id*)arg2;
         - (void) reloadWidgetRelevanceForExtensionIdentifier:(id)arg1 kind:(id)arg2 completion:(^block)arg3;
         - (_Bool) remoteWidgetsEnabled;
         - (void) retryStuckRemotePairings;
         - (void) setActivationState:(id)arg1 forWidgetHostWithIdentifier:(id)arg2;
         - (void) setWidgetConfiguration:(id)arg1 activationState:(id)arg2 forWidgetHostWithIdentifier:(id)arg3;
         - (void) subscribeToActivityPayloadUpdates:(^block)arg1;
         - (void) subscribeToExtensionsWithProviderOptions:(id)arg1 completion:(^block)arg2;
         - (void) subscribeToRemoteDevices:(^block)arg1;
         - (void) subscribeToTimelineEntryRelevance:(^block)arg1;
         - (void) subscribeToWidgetRelevance:(^block)arg1;
         - (void) suggestionBudgetsForStackIdentifiers:(id)arg1 completion:(^block)arg2;
         - (_Bool) toggleRemoteWidgetsEnabled:(id)arg1 error:(id*)arg2;
         - (_Bool) unpairDeviceWith:(id)arg1 error:(id*)arg2;
         - (id) widgetEnvironmentDataForBundleIdentifier:(id)arg1;
 */
