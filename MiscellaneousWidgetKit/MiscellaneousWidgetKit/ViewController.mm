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

OBJC_EXTERN id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface ViewController ()
@property (retain, nonatomic, readonly, getter=_menuButton) UIButton *menuButton;
@property (retain, nonatomic, readonly, getter=_widgetCenterConnection) NSXPCConnection *widgetCenterConnection;
@end

@implementation ViewController
@synthesize menuButton = _menuButton;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _widgetCenterConnection = reinterpret_cast<id (*)(id, SEL, id, NSXPCConnectionOptions)>(objc_msgSend)([NSXPCConnection alloc], sel_registerName("initWithMachServiceName:options:"), @"com.apple.chrono.widgetcenterconnection", 0);
        _widgetCenterConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"WidgetKit.WidgetCenterConnection_Remote")];
        
        NSXPCInterface *remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:NSProtocolFromString(@"WidgetKit.WidgetCenterConnection_Host")];
        [remoteObjectInterface setClasses:[NSSet setWithObjects:objc_lookUpClass("CHSWidget"), [NSArray class], nil] forSelector:sel_registerName("_loadCurrentConfigurations:") argumentIndex:0 ofReply:YES];
        _widgetCenterConnection.remoteObjectInterface = remoteObjectInterface;
        
        _widgetCenterConnection.invalidationHandler = ^{
            abort();
        };
        [_widgetCenterConnection activate];
    }
    
    return self;
}

- (void)dealloc {
    [_widgetCenterConnection invalidate];
    [_widgetCenterConnection release];
    [_menuButton release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.menuButton;
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
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(weakSelf.widgetCenterConnection.remoteObjectProxy, sel_registerName("_loadCurrentConfigurations:"), ^(NSArray *configurations, NSError * _Nullable error) {
            assert(error == nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
                
                {
                    NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
                    
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
                    [results addObject:menu];
                }
                
                {
                    NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
                    
                    {
                        UIAction *action = [UIAction actionWithTitle:@"_reloadAllTimelines:" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                            WidgetCenter_reloadAllTimelines();
                            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(weakSelf.widgetCenterConnection.remoteObjectProxy, sel_registerName("_reloadAllTimelines:"), ^(NSError * _Nullable error) {
                                assert(error == nil);
                            });
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
                                    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(weakSelf.widgetCenterConnection.remoteObjectProxy, sel_registerName("_reloadTimelinesOfKind:completion:"), kind, ^(NSError * _Nullable error) {
                                        assert(error == nil);
                                    });
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
                                    NSURL *url = [NSBundle.mainBundle.builtInPlugInsURL URLByAppendingPathComponent:@"MiscellaneousWidgetKit_WidgetExtensionExtension.appex" isDirectory:YES];
                                    NSBundle *bundle = [NSBundle bundleWithURL:url];
                                    assert(bundle != nil);
                                    
                                    NSLog(@"%@", url.path);
                                    
                                    reinterpret_cast<void (*)(id, SEL, id, id, id)>(objc_msgSend)(weakSelf.widgetCenterConnection.remoteObjectProxy, sel_registerName("_reloadTimelinesOfKind:inBundle:completion:"), kind, @"com.pookjw.MiscellaneousWidgetKit.WidgetExtension", ^(NSError * _Nullable error) {
                                        NSLog(@"%@", error);
                                        assert(error == nil);
                                    });
                                }];
                                [elements addObject:action];
                            }
                            
                            UIMenu *menu = [UIMenu menuWithTitle:@"Reload Specific Widget (With Bundle)" children:elements];
                            [elements release];
                            [children addObject:menu];
                        }
                    }
                    
                    UIMenu *menu = [UIMenu menuWithTitle: @"com.apple.chrono.widgetcenterconnection" children:children];
                    [children release];
                    [results addObject:menu];
                }
                
                completion(results);
                [results release];
            });
        });
    }];
    
    return [UIMenu menuWithChildren:@[element]];
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
