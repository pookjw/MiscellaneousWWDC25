//
 //  GlassEffectViewController.mm
 //  MiscellaneousUIKit
 //
 //  Created by Jinwoo Kim on 6/10/25.
 //

#import "GlassEffectViewController.h"
#import "UIViewController+Menu.h"
#include <objc/runtime.h>
#include <objc/message.h>
#include <vector>
#include <ranges>

@interface GlassEffectViewController () <UIColorPickerViewControllerDelegate>
@property (class, nonatomic, readonly, getter=_tintColorKey) void *tintColorKey;
@property (class, nonatomic, readonly, getter=_controlTintColorKey) void *controlTintColorKey;
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_containerView) UIVisualEffectView *containerView;
@property (retain, nonatomic, readonly, getter=_visualEffectView_1) UIVisualEffectView *visualEffectView_1;
@property (retain, nonatomic, readonly, getter=_visualEffectView_2) UIVisualEffectView *visualEffectView_2;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@property (retain, nonatomic, getter=_glass, setter=_setGlass:) id glass;
@end

@implementation GlassEffectViewController
@synthesize imageView = _imageView;
@synthesize containerView = _containerView;
@synthesize visualEffectView_1 = _visualEffectView_1;
@synthesize visualEffectView_2 = _visualEffectView_2;
@synthesize menuBarButtonItem = _menuBarButtonItem;

+ (void *)_tintColorKey {
    static void *key = &key;
    return key;
}

+ (void *)_controlTintColorKey {
    static void *key = &key;
    return key;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _glass = [objc_lookUpClass("_UIViewGlass") new];
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_glass, sel_registerName("setBackdropGroupName:"), @"Test");
    }
    
    return self;
}

- (void)dealloc {
    [_imageView release];
    [_containerView release];
    [_visualEffectView_1 release];
    [_visualEffectView_2 release];
    [_menuBarButtonItem release];
    [_glass release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.containerView];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.containerView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.containerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.containerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.containerView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
    [self muk_presentMenuForBarButtonItem:self.menuBarButtonItem];
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    
    _imageView = imageView;
    return imageView;
}

- (UIVisualEffectView *)_containerView {
    if (auto containerView = _containerView) return containerView;
    
    UIGlassContainerEffect *effect = [UIGlassContainerEffect new];
    UIVisualEffectView *containerView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [effect release];
    
    [containerView.contentView addSubview:self.visualEffectView_1];
    [containerView.contentView addSubview:self.visualEffectView_2];
    
    self.visualEffectView_1.translatesAutoresizingMaskIntoConstraints = NO;
    self.visualEffectView_2.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.visualEffectView_1.centerXAnchor constraintEqualToAnchor:containerView.contentView.safeAreaLayoutGuide.centerXAnchor],
        [self.visualEffectView_1.centerYAnchor constraintEqualToAnchor:containerView.contentView.safeAreaLayoutGuide.centerYAnchor],
        [self.visualEffectView_1.widthAnchor constraintEqualToAnchor:containerView.contentView.safeAreaLayoutGuide.widthAnchor multiplier:0.5],
        [self.visualEffectView_1.heightAnchor constraintEqualToAnchor:containerView.contentView.safeAreaLayoutGuide.heightAnchor multiplier:0.5],
        
        [self.visualEffectView_2.leadingAnchor constraintEqualToAnchor:containerView.contentView.safeAreaLayoutGuide.leadingAnchor],
        [self.visualEffectView_2.trailingAnchor constraintEqualToAnchor:containerView.contentView.safeAreaLayoutGuide.trailingAnchor],
        [self.visualEffectView_2.centerYAnchor constraintEqualToAnchor:containerView.contentView.safeAreaLayoutGuide.centerYAnchor],
        [self.visualEffectView_2.heightAnchor constraintEqualToAnchor:self.visualEffectView_1.heightAnchor multiplier:0.5]
    ]];
    
    _containerView = containerView;
    return containerView;
}

- (UIVisualEffectView *)_visualEffectView_1 {
    if (auto visualEffectView_2 = _visualEffectView_1) return visualEffectView_2;
    
    UIGlassEffect *effect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)([UIGlassEffect class], sel_registerName("effectWithGlass:"), self.glass);
    UIVisualEffectView *visualEffectView_1 = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    visualEffectView_1.layer.cornerRadius = 30.;
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(visualEffectView_1, sel_registerName("_setGroupName:"), @"Test");
    
    _visualEffectView_1 = visualEffectView_1;
    return visualEffectView_1;
}

- (UIVisualEffectView *)_visualEffectView_2 {
    if (auto visualEffectView_2 = _visualEffectView_2) return visualEffectView_2;
    
    UIGlassEffect *effect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)([UIGlassEffect class], sel_registerName("effectWithGlass:"), self.glass);
    UIVisualEffectView *visualEffectView_2 = [[UIVisualEffectView alloc] initWithEffect:effect];
    
    visualEffectView_2.layer.cornerRadius = 30.;
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(visualEffectView_2, sel_registerName("_setGroupName:"), @"Test");
    
    _visualEffectView_2 = visualEffectView_2;
    return visualEffectView_2;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        auto loaded = weakSelf;
        if (loaded == nil) {
            completion(@[]);
            return;
        }
        
        id glass = loaded.glass;
        assert(glass != nil);
        // 무조건 0 나오는듯?
        NSInteger variant = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("variant"));
        CGFloat smoothness = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("smoothness"));
        UIColor *tintColor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("tintColor"));
        UIColor *controlTintColor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("controlTintColor"));
        NSString *subvariant = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("subvariant"));
        BOOL contentLensing = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("contentLensing"));
        BOOL highlightsDisplayAngle = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("highlightsDisplayAngle"));
        BOOL excludingPlatter = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("excludingPlatter"));
        BOOL excludingForeground = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("excludingForeground"));
        BOOL excludingShadow = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("excludingShadow"));
        BOOL excludingControlLensing = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("excludingControlLensing"));
        BOOL excludingControlDisplacement = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("excludingControlDisplacement"));
        BOOL flexible = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("flexible"));
        BOOL boostWhitePoint = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("boostWhitePoint"));
        BOOL allowsGrouping = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(glass, sel_registerName("allowsGrouping"));
        
        {
            auto actionsVec = std::vector<NSInteger> { 0, 1, 2, 3, 4, 5 }
            | std::views::transform([loaded, variant](NSInteger _variant) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:@(_variant).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    id glass = reinterpret_cast<id (*)(id, SEL, NSInteger)>(objc_msgSend)([objc_lookUpClass("_UIViewGlass") alloc], sel_registerName("initWithVariant:"), _variant);
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(glass, sel_registerName("setBackdropGroupName:"), @"Test");
                    loaded.glass = glass;
                    [glass release];
                    [loaded _updateEffect];
                    [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
                }];
                
                action.state = (variant == _variant) ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Variant" children:actions];
            [actions release];
            
            [results addObject:menu];
        }
        
        {
            __kindof UIMenuElement *element = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                slider.minimumValue = -10.f;
                slider.maximumValue = 0.f;
                slider.value = smoothness;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    float value = static_cast<UISlider *>(action.sender).value;
                    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(glass, sel_registerName("setSmoothness:"), value);
                    [loaded _updateEffect];
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Smoothness" children:@[element]];
            menu.subtitle = @"Recommended: variant = 1";
            [results addObject:menu];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Tint Color" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                UIColorPickerViewController *colorPickerViewController = [UIColorPickerViewController new];
                colorPickerViewController.supportsAlpha = YES;
                colorPickerViewController.selectedColor = tintColor;
                colorPickerViewController.delegate = loaded;
                objc_setAssociatedObject(colorPickerViewController, GlassEffectViewController.tintColorKey, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                [loaded presentViewController:colorPickerViewController animated:YES completion:nil];
                [colorPickerViewController release];
            }];
            
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Control Tint Color" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                UIColorPickerViewController *colorPickerViewController = [UIColorPickerViewController new];
                colorPickerViewController.supportsAlpha = YES;
                colorPickerViewController.selectedColor = controlTintColor;
                colorPickerViewController.delegate = loaded;
                objc_setAssociatedObject(colorPickerViewController, GlassEffectViewController.controlTintColorKey, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                [loaded presentViewController:colorPickerViewController animated:YES completion:nil];
                [colorPickerViewController release];
            }];
            
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Content Lensing" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setContentLensing:"), !contentLensing);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            
            action.state = contentLensing ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Highlights Display Angle" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setHighlightsDisplayAngle:"), !highlightsDisplayAngle);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            
            action.state = highlightsDisplayAngle ? UIMenuElementStateOn : UIMenuElementStateOff;
            action.subtitle = @"Recommended: variant = 4, 5";
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Excluding Platter" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setExcludingPlatter:"), !excludingPlatter);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            
            action.state = excludingPlatter ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Excluding Foreground" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setExcludingForeground:"), !excludingForeground);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            
            action.state = excludingForeground ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Excluding Shadow" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setExcludingShadow:"), !excludingShadow);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            
            action.state = excludingShadow ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Excluding Control Lensing" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setExcludingControlLensing:"), !excludingControlLensing);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            action.state = excludingControlLensing ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        {
            UIAction *action = [UIAction actionWithTitle:@"Excluding Control Displacement" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setExcludingControlDisplacement:"), !excludingControlDisplacement);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            action.state = excludingControlDisplacement ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        {
            UIAction *action = [UIAction actionWithTitle:@"Flexible" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setFlexible:"), !flexible);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            action.state = flexible ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        {
            UIAction *action = [UIAction actionWithTitle:@"Boost White Point" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setBoostWhitePoint:"), !boostWhitePoint);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            action.state = boostWhitePoint ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        {
            UIAction *action = [UIAction actionWithTitle:@"Allows Grouping" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setAllowsGrouping:"), !allowsGrouping);
                [loaded _updateEffect];
                [loaded muk_presentMenuForBarButtonItem:loaded.menuBarButtonItem];
            }];
            action.state = allowsGrouping ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (void)_updateEffect {
    UIGlassEffect *effect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)([UIGlassEffect class], sel_registerName("effectWithGlass:"), self.glass);
    self.visualEffectView_1.effect = effect;
    self.visualEffectView_2.effect = effect;
}

- (void)colorPickerViewController:(UIColorPickerViewController *)viewController didSelectColor:(UIColor *)color continuously:(BOOL)continuously {
    if (objc_getAssociatedObject(viewController, GlassEffectViewController.tintColorKey) != nil) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.glass, sel_registerName("setTintColor:"), color);
    } else if (objc_getAssociatedObject(viewController, GlassEffectViewController.controlTintColorKey) != nil) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self.glass, sel_registerName("setControlTintColor:"), color);
    } else {
        abort();
    }
    
    [self _updateEffect];
}

@end

