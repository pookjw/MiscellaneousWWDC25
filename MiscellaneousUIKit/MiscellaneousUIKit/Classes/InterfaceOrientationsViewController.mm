//
//  InterfaceOrientationsViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import "InterfaceOrientationsViewController.h"
#import "UIInterfaceOrientationMask+String.h"
#include <objc/message.h>
#include <objc/runtime.h>
#include <ranges>
#include <vector>

UIKIT_EXTERN NSString * _UIInterfaceOrientationMaskDebugDescription(UIInterfaceOrientationMask);
//UIKIT_EXTERN BOOL _UIInterfaceOrientationMaskContainsOrientation(UIInterfaceOrientationMask, UIInterfaceOrientationMask);

@interface InterfaceOrientationsViewController () {
    UIInterfaceOrientationMask _supportedInterfaceOrientations;
    BOOL _prefersInterfaceOrientationLocked;
}
@property (retain, nonatomic, readonly, getter=_button) UIButton *button;
@end

@implementation InterfaceOrientationsViewController
@synthesize button = _button;

- (void)dealloc {
    [_button release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.button;
}

// Does not work on child...
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _supportedInterfaceOrientations;
}

- (BOOL)prefersInterfaceOrientationLocked {
    return _prefersInterfaceOrientationLocked;
}

- (UIButton *)_button {
    if (auto button = _button) return button;
    
    UIButton *button = [UIButton new];
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedGlassButtonConfiguration];
    configuration.title = @"Menu";
    button.configuration = configuration;
    button.showsMenuAsPrimaryAction = YES;
    button.menu = [self _makeMenu];
    button.backgroundColor = UIColor.systemBackgroundColor;
    
    _button = button;
    return button;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        auto loaded = weakSelf;
        if (loaded == nil) {
            completion(@[]);
            return;
        }
        
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            UIAction *dismissAction = [UIAction actionWithTitle:@"Dismiss" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
            [results addObject:dismissAction];
        }
        
        {
            NSUInteger count;
            const UIInterfaceOrientationMask *allMasks = allUIInterfaceOrientationMasks(&count);
            
            auto actionsVec = std::views::iota(allMasks, allMasks + count)
            | std::views::transform([](const UIInterfaceOrientationMask *ptr) { return *ptr; })
            | std::views::transform([loaded, weakSelf](UIInterfaceOrientationMask mask) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:_UIInterfaceOrientationMaskDebugDescription(mask) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    auto loaded = weakSelf;
                    if (loaded == nil) return;
                        
                    if (loaded->_supportedInterfaceOrientations & mask) {
                        loaded->_supportedInterfaceOrientations &= ~mask;
                    } else {
                        loaded->_supportedInterfaceOrientations |= mask;
                    }
                    
                    [loaded setNeedsUpdateOfSupportedInterfaceOrientations];
                }];
                
                action.state = (((mask & loaded->_supportedInterfaceOrientations) == mask) && (loaded->_supportedInterfaceOrientations != 0)) ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"supportedInterfaceOrientations" children:actions];
            [actions release];
            menu.subtitle = _UIInterfaceOrientationMaskDebugDescription(loaded->_supportedInterfaceOrientations);
            [results addObject:menu];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"prefersInterfaceOrientationLocked" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                auto loaded = weakSelf;
                if (loaded == nil) return;
                
                loaded->_prefersInterfaceOrientationLocked = !loaded->_prefersInterfaceOrientationLocked;
                [loaded setNeedsUpdateOfPrefersInterfaceOrientationLocked];
            }];
            
            action.state = loaded->_prefersInterfaceOrientationLocked ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        completion(results);
        [results release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
