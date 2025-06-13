//
//  ColorPickerPresenterViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import "ColorPickerPresenterViewController.h"
#import "UIUserInterfaceStyle+String.h"
#include <objc/message.h>
#include <objc/runtime.h>
#include <ranges>
#include <vector>

@interface ColorPickerPresenterViewController () <UIColorPickerViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_colorPickerViewController) UIColorPickerViewController *colorPickerViewController;
@property (retain, nonatomic, readonly, getter=_button) UIButton *button;
@end

@implementation ColorPickerPresenterViewController
@synthesize colorPickerViewController = _colorPickerViewController;
@synthesize button = _button;

- (void)dealloc {
    [_colorPickerViewController release];
    [_button release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.button.configuration.baseBackgroundColor;
}

- (UIColorPickerViewController *)_colorPickerViewController {
    if (auto colorPickerViewController = _colorPickerViewController) return colorPickerViewController;
    
    UIColorPickerViewController *colorPickerViewController = [[UIColorPickerViewController alloc] init];
    colorPickerViewController.delegate = self;
    
    _colorPickerViewController = colorPickerViewController;
    return colorPickerViewController;
}

- (UIButton *)_button {
    if (auto button = _button) return button;
    
    UIButton *button = [UIButton new];
    UIButtonConfiguration *configuration = [UIButtonConfiguration borderedProminentButtonConfiguration];
    configuration.baseBackgroundColor = UIColor.orangeColor;
    configuration.title = @"Menu";
    button.configuration = configuration;
    button.showsMenuAsPrimaryAction = YES;
    button.menu = [self _makeMenu];
    
    _button = button;
    return button;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    UIColorPickerViewController *colorPickerViewController = self.colorPickerViewController;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Supports Alpha" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                colorPickerViewController.supportsAlpha = !colorPickerViewController.supportsAlpha;
            }];
            action.state = colorPickerViewController.supportsAlpha ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Supports Eyedropper" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                colorPickerViewController.supportsEyedropper = !colorPickerViewController.supportsEyedropper;
            }];
            action.state = colorPickerViewController.supportsEyedropper ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            BOOL _showsGridOnly = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_showsGridOnly"));
            
            UIAction *action = [UIAction actionWithTitle:@"Shows Grid Only" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                BOOL _showsGridOnly = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_showsGridOnly"));
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_setShowsGridOnly:"), !_showsGridOnly);
            }];
            
            action.state = _showsGridOnly ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            BOOL _allowsNoColor = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_allowsNoColor"));
            UIAction *action = [UIAction actionWithTitle:@"Allows No Color" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                BOOL _allowsNoColor = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_allowsNoColor"));
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_setAllowsNoColor:"), !_allowsNoColor);
            }];
            action.state = _allowsNoColor ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            BOOL _shouldUseDarkGridInDarkMode = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_shouldUseDarkGridInDarkMode"));
            UIAction *action = [UIAction actionWithTitle:@"Use Dark Grid in Dark Mode" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                BOOL _shouldUseDarkGridInDarkMode = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_shouldUseDarkGridInDarkMode"));
                reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_setShouldUseDarkGridInDarkMode:"), !_shouldUseDarkGridInDarkMode);
            }];
            action.state = _shouldUseDarkGridInDarkMode ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            for (CGFloat f = 0.; f <= 2.; f += 0.2) {
                UIAction *action = [UIAction actionWithTitle:@(f).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    colorPickerViewController.maximumLinearExposure = f;
                }];
                action.state = (colorPickerViewController.maximumLinearExposure == f) ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                [children addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Maximum Linear Exposure" children:children];
            [children release];
            menu.subtitle = @(colorPickerViewController.maximumLinearExposure).stringValue;
            [results addObject:menu];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            for (CGFloat f = 0.; f <= 2.; f += 0.2) {
                UIAction *action = [UIAction actionWithTitle:@(f).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(colorPickerViewController, sel_registerName("setMaxGain:"), f);
                }];
                action.state = (colorPickerViewController.maximumLinearExposure == f) ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                [children addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Max Gain" children:children];
            [children release];
            CGFloat maxGain = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("maxGain"));
            menu.subtitle = @(maxGain).stringValue;
            [results addObject:menu];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Present" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                colorPickerViewController.selectedColor = weakSelf.button.configuration.baseBackgroundColor;
                [weakSelf presentViewController:colorPickerViewController animated:YES completion:nil];
            }];
            [results addObject:action];
        }
        
        {
            NSUInteger count;
            const UIUserInterfaceStyle *allStyles = allUIUserInterfaceStyles(&count);
            UIUserInterfaceStyle _userInterfaceStyleForGrid = reinterpret_cast<UIUserInterfaceStyle (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_userInterfaceStyleForGrid"));
            
            auto actionsVec = std::views::iota(allStyles, allStyles + count)
            | std::views::transform([colorPickerViewController, _userInterfaceStyleForGrid](const UIUserInterfaceStyle *ptr) -> UIAction * {
                UIUserInterfaceStyle style = *ptr;
                UIAction *action = [UIAction actionWithTitle:NSStringFromUIUserInterfaceStyle(style) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, UIUserInterfaceStyle)>(objc_msgSend)(colorPickerViewController, sel_registerName("_setUserInterfaceStyleForGrid:"), style);
                }];
                
                action.state = (style == _userInterfaceStyleForGrid) ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"User Interface Style For Grid" children:actions];
            [actions release];
            menu.subtitle = NSStringFromUIUserInterfaceStyle(_userInterfaceStyleForGrid);
            
            [results addObject:menu];
        }
        
        {
            NSArray<UIColor *> *_suggestedColors = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(colorPickerViewController, sel_registerName("_suggestedColors"));
            
            if (_suggestedColors.count == 0) {
                UIAction *action = [UIAction actionWithTitle:@"Set Suggested Colors" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorPickerViewController, sel_registerName("_setSuggestedColors:"), @[
                        UIColor.redColor,
                        UIColor.blackColor,
                        UIColor.greenColor
                    ]);
                }];
                [results addObject:action];
            } else {
                UIAction *action = [UIAction actionWithTitle:@"Remove Suggested Colors" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorPickerViewController, sel_registerName("_setSuggestedColors:"), @[]);
                }];
                action.attributes = UIMenuElementAttributesDestructive;
                [results addObject:action];
            }
        }
        
        completion(results);
        [results release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

- (void)colorPickerViewController:(UIColorPickerViewController *)viewController didSelectColor:(UIColor *)color continuously:(BOOL)continuously {
    UIButtonConfiguration *configuration = [self.button.configuration copy];
    configuration.baseBackgroundColor = color;
    self.view.backgroundColor = color;
    self.button.configuration = configuration;
    [configuration release];
}

- (void)_colorPickerViewControllerDidDeselectColor:(UIColorPickerViewController *)viewController {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)_colorPickerViewControllerDidHideEyedropper:(UIColorPickerViewController *)viewController {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)_colorPickerViewControllerDidShowEyedropper:(UIColorPickerViewController *)viewController {
    NSLog(@"%s", sel_getName(_cmd));
}

//- (BOOL)respondsToSelector:(SEL)aSelector {
//    BOOL responds = [super respondsToSelector:aSelector];
//    
//    if (!responds) {
//        NSLog(@"%s", sel_getName(aSelector));
//    }
//    
//    return responds;
//}

@end

