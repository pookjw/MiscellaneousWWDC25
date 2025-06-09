//
//  GlassEffectViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "GlassEffectViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface GlassEffectViewController ()
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_visualEffectView) UIVisualEffectView *visualEffectView;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation GlassEffectViewController
@synthesize imageView = _imageView;
@synthesize visualEffectView = _visualEffectView;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_imageView release];
    [_visualEffectView release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.visualEffectView];
    self.visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.visualEffectView.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [self.visualEffectView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [self.visualEffectView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.5],
        [self.visualEffectView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5]
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

- (UIVisualEffectView *)_visualEffectView {
    if (auto visualEffectView = _visualEffectView) return visualEffectView;
    
    UIGlassEffect *effect = [[UIGlassEffect alloc] init];
    effect.interactive = YES;
    effect.tintColor = UIColor.clearColor;
    
    id glass = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(effect, sel_registerName("glass"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(glass, sel_registerName("setTintColor:"), UIColor.clearColor);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(glass, sel_registerName("setControlTintColor:"), UIColor.clearColor);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setContentLensing:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setExcludingForeground:"), YES);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(glass, sel_registerName("setExcludingPlatter:"), YES);
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [effect release];
    
    visualEffectView.layer.cornerRadius = 30.;
    
    _visualEffectView = visualEffectView;
    return visualEffectView;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
