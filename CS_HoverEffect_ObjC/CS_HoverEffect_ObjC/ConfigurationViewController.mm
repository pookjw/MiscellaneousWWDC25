//
//  ConfigurationViewController.mm
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import "ConfigurationViewController.h"
#include <objc/message.h>
#include <objc/runtime.h>
#import "Configuration.h"
#import "UIControl+Category.h"
#import <CompositorServices/CompositorServices.h>

OBJC_EXTERN id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */
CP_EXTERN UISceneSessionRole const CPSceneSessionRoleImmersiveSpaceApplication;

@interface ConfigurationViewController ()
@property (class, nonatomic, readonly, nullable, getter=_cpScene) __kindof UIScene *cpScene;
@property (retain, nonatomic, readonly, getter=_menuButton) UIButton *menuButton;
@property (retain, nonatomic, readonly, getter=_openImmersiveBarButtonItem) UIBarButtonItem *openImmersiveBarButtonItem;
@property (copy, nonatomic, getter=_configuration, setter=_setConfiguration:) Configuration *configuration;
@end

@implementation ConfigurationViewController
@synthesize menuButton = _menuButton;
@synthesize openImmersiveBarButtonItem = _openImmersiveBarButtonItem;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _configuration = [Configuration new];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_menuButton release];
    [_openImmersiveBarButtonItem release];
    [_configuration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.menuButton];
    self.menuButton.frame = self.view.bounds;
    self.menuButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.navigationItem.rightBarButtonItem = self.openImmersiveBarButtonItem;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_sceneConnectionDidChange:) name:UISceneWillConnectNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_sceneConnectionDidChange:) name:UISceneDidDisconnectNotification object:nil];
    
    [self _updateOpenImmersiveBarButtonItem];
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    [self.menuButton he_presentMenu];
}

- (UIButton *)_menuButton {
    if (auto menuButton = _menuButton) return menuButton;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedGlassButtonConfiguration];
    configuration.cornerStyle = UIButtonConfigurationCornerStyleFixed;
    configuration.title = @"Menu";
    configuration.image = [UIImage systemImageNamed:@"filemenu.and.selection"];
    
    UIButton *menuButton = [UIButton new];
    menuButton.configuration = configuration;
    menuButton.menu = [self _makeMenu];
    menuButton.showsMenuAsPrimaryAction = YES;
    menuButton.preferredMenuElementOrder = UIContextMenuConfigurationElementOrderFixed;
    
    _menuButton = menuButton;
    return menuButton;
}

- (UIBarButtonItem *)_openImmersiveBarButtonItem {
    if (auto openImmersiveBarButtonItem = _openImmersiveBarButtonItem) return openImmersiveBarButtonItem;
    
    UIBarButtonItem *openImmersiveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Open" image:[UIImage systemImageNamed:@"vision.pro"] target:self action:@selector(_openImmersiveBarButtonItemDidTrigger:) menu:nil];
    
    _openImmersiveBarButtonItem = openImmersiveBarButtonItem;
    return openImmersiveBarButtonItem;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        Configuration *configuration = weakSelf.configuration;
        
        //
        
        if (Configuration.supportsMSAA) {
            UIAction *action = [UIAction actionWithTitle:@"Use MSAA" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                configuration.useMSAA = !configuration.useMSAA;
                weakSelf.configuration = configuration;
                [weakSelf.menuButton he_presentMenu];
            }];
            
            action.state = (configuration.useMSAA ? UIMenuElementStateOn : UIMenuElementStateOff);
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Hover effects" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                configuration.hoverEnabled = !configuration.hoverEnabled;
                weakSelf.configuration = configuration;
                [weakSelf.menuButton he_presentMenu];
            }];
            
            action.state = (configuration.hoverEnabled) ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"With background" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                configuration.backgroundEnabled = !configuration.backgroundEnabled;
                weakSelf.configuration = configuration;
                [weakSelf.menuButton he_presentMenu];
            }];
            
            action.state = (configuration.backgroundEnabled) ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        if (configuration.resolution == nil) {
            UIAction *action = [UIAction actionWithTitle:@"Override resolution" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                configuration.resolution = @(1.f);
                weakSelf.configuration = configuration;
                [weakSelf.menuButton he_presentMenu];
            }];
            
            [results addObject:action];
        } else {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = 0.f;
                slider.maximumValue = 1.f;
                slider.value = configuration.resolution.floatValue;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    configuration.resolution = @(static_cast<UISlider *>(action.sender).value);
                    weakSelf.configuration = configuration;
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            UIAction *action = [UIAction actionWithTitle:@"Remove resolution" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                configuration.resolution = nil;
                weakSelf.configuration = configuration;
                [weakSelf.menuButton he_presentMenu];
            }];
            action.attributes = UIMenuOptionsDestructive;
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Resolution" children:@[element, action]];
            [results addObject:menu];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Foveation" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                configuration.foveation = !configuration.foveation;
                weakSelf.configuration = configuration;
                [weakSelf.menuButton he_presentMenu];
            }];
            
            action.state = (configuration.foveation ? UIMenuElementStateOn : UIMenuElementStateOff);
            [results addObject:action];
        }
        
        {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                
                slider.minimumValue = 0.f;
                slider.maximumValue = 1.f;
                slider.value = configuration.debugFactor;
                slider.continuous = NO;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    configuration.debugFactor = static_cast<UISlider *>(action.sender).value;
                    weakSelf.configuration = configuration;
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Debug colors" children:@[element]];
            [results addObject:menu];
        }
        
        //
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

+ (__kindof UIScene * _Nullable)_cpScene {
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene.session.role isEqualToString:CPSceneSessionRoleImmersiveSpaceApplication]) {
            return scene;
        }
    }
    
    return nil;
}

- (void)_openImmersiveBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    if (__kindof UIScene *cpScene = ConfigurationViewController.cpScene) {
        [UIApplication.sharedApplication requestSceneSessionDestruction:cpScene.session options:nil errorHandler:^(NSError * _Nonnull error) {
            assert(error == nil);
        }];
    } else {
        UISceneSessionActivationRequest *request = [UISceneSessionActivationRequest requestWithRole:CPSceneSessionRoleImmersiveSpaceApplication];
        
        {
            __kindof UISceneActivationRequestOptions *options = [objc_lookUpClass("_MRUIImmersiveSpaceSceneActivationRequestOptions") new];
            
            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(options, sel_registerName("_setInternal:"), YES);
            reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, sel_registerName("setInitialImmersionStyle:"), 1 << 3);
            reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(options, sel_registerName("setAllowedImmersionStyles:"), 1 << 3);
            
            request.options = options;
            [options release];
        }
        
        {
            NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"OpenCPScene"];
            
            NSError * _Nullable error = nil;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.configuration requiringSecureCoding:YES error:&error];
            assert(data != nil);
            
            userActivity.userInfo = @{
                @"configuration": data
            };
            request.userActivity = userActivity;
            [userActivity release];
        }
        
        [UIApplication.sharedApplication activateSceneSessionForRequest:request errorHandler:^(NSError * _Nonnull error) {
            assert(error == nil);
        }];
    }
}

- (void)_sceneConnectionDidChange:(NSNotification *)notification {
    UIScene *scene = notification.object;
    if (![scene.session.role isEqualToString:CPSceneSessionRoleImmersiveSpaceApplication]) return;
    
    [self _updateOpenImmersiveBarButtonItem];
    self.menuButton.hidden = (ConfigurationViewController.cpScene != nil);
}

- (void)_updateOpenImmersiveBarButtonItem {
    if (ConfigurationViewController.cpScene != nil) {
        self.openImmersiveBarButtonItem.image = [UIImage systemImageNamed:@"vision.pro.fill"];
    } else {
        self.openImmersiveBarButtonItem.image = [UIImage systemImageNamed:@"vision.pro"];
    }
}

@end
