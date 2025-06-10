//
//  ButtonViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "ButtonViewController.h"
#include <objc/runtime.h>
#include <objc/message.h>
#include <vector>
#include <ranges>

@interface ButtonViewController ()
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_button) UIButton *button;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation ButtonViewController
@synthesize imageView = _imageView;
@synthesize button = _button;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_imageView release];
    [_button release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.button];
    self.button.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.button.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [self.button.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [self.button.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.5],
        [self.button.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5]
    ]];
    
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    
    _imageView = imageView;
    return imageView;
}

- (UIButton *)_button {
    if (auto button = _button) return button;
    
    UIButtonConfiguration *configuration = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)([UIButtonConfiguration class], sel_registerName("_clearGlassButtonConfiguration"));
    configuration.title = @"Button";
    
    UIButton *button = [UIButton new];
    button.configuration = configuration;
    [button addTarget:self action:@selector(_buttonDidTrigger:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    _button = button;
    return button;
}

- (void)_buttonDidTrigger:(UIButton *)sender {
    
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    UIButton *button = self.button;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        auto actionsVec = std::vector<SEL> {
            sel_registerName("_tintedGlassButtonConfiguration"),
            sel_registerName("_avPlayerGlassButtonConfiguration"),
            sel_registerName("_clearGlassButtonConfiguration"),
            sel_registerName("_glassButtonConfiguration"),
            sel_registerName("_posterSwitcherGlassButtonConfiguration"),
            @selector(glassButtonConfiguration),
            @selector(tintedGlassButtonConfiguration)
        }
        | std::views::transform([button](SEL sel) -> UIAction * {
            UIAction *action = [UIAction actionWithTitle:NSStringFromSelector(sel) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                UIButtonConfiguration *configuration = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)([UIButtonConfiguration class], sel);
                configuration.title = @"Button";
                button.configuration = configuration;
            }];
            return action;
        })
        | std::ranges::to<std::vector<UIAction *>>();
        
        NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
        completion(actions);
        [actions release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
