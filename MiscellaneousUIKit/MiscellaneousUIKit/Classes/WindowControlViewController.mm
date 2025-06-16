//
//  WindowControlViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/16/25.
//

#import "WindowControlViewController.h"
#include <objc/runtime.h>
#include <objc/message.h>

UIKIT_EXTERN NSString *_NSStringFromUIWindowingControlStyleType(NSInteger);

@interface WindowControlViewController ()
@property (retain, nonatomic, readonly, getter=_backBarButtonItem) UIBarButtonItem *backBarButtonItem;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;

@property (retain, nonatomic, readonly, getter=_topView) UIView *topView;
@property (retain, nonatomic, readonly, getter=_leadingView) UIView *leadingView;
@end

@implementation WindowControlViewController
@synthesize backBarButtonItem = _backBarButtonItem;
@synthesize menuBarButtonItem = _menuBarButtonItem;
@synthesize topView = _topView;
@synthesize leadingView = _leadingView;

- (void)dealloc {
    [_backBarButtonItem release];
    [_menuBarButtonItem release];
    [_topView release];
    [_leadingView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.toolbarItems = @[
        self.backBarButtonItem,
        self.menuBarButtonItem
    ];
    
    UILayoutGuide *horizontalGuide = [self.view layoutGuideForLayoutRegion:[UIViewLayoutRegion marginsLayoutRegionWithCornerAdaptation:UIViewLayoutRegionAdaptivityAxisHorizontal]];
    UILayoutGuide *verticalGuide = [self.view layoutGuideForLayoutRegion:[UIViewLayoutRegion marginsLayoutRegionWithCornerAdaptation:UIViewLayoutRegionAdaptivityAxisVertical]];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.leadingView];
    
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.leadingView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.topView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.topView.leadingAnchor constraintEqualToAnchor:horizontalGuide.leadingAnchor],
        [self.topView.trailingAnchor constraintEqualToAnchor:horizontalGuide.trailingAnchor],
        [self.topView.bottomAnchor constraintEqualToAnchor:verticalGuide.topAnchor],
        
        [self.leadingView.topAnchor constraintEqualToAnchor:verticalGuide.topAnchor],
        [self.leadingView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.leadingView.trailingAnchor constraintEqualToAnchor:horizontalGuide.leadingAnchor],
        [self.leadingView.bottomAnchor constraintEqualToAnchor:verticalGuide.bottomAnchor]
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UIBarButtonItem *)_backBarButtonItem {
    if (auto backBarButtonItem = _backBarButtonItem) return backBarButtonItem;
    
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" image:[UIImage systemImageNamed:@"chevron.backward"] target:self action:@selector(_backBarButtonItemDidTrigger:) menu:nil];
    
    _backBarButtonItem = backBarButtonItem;
    return backBarButtonItem;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIView *)_topView {
    if (auto topView = _topView) return topView;
    
    UIView *topView = [UIView new];
    topView.backgroundColor = UIColor.systemOrangeColor;
    
    _topView = topView;
    return topView;
}

- (UIView *)_leadingView {
    if (auto leadingView = _leadingView) return leadingView;
    UIView *leadingView = [UIView new];
    leadingView.backgroundColor = UIColor.systemRedColor;
    _leadingView = leadingView;
    return leadingView;
}

- (void)_backBarButtonItemDidTrigger:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            id scene = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(weakSelf.view.window.windowScene, sel_registerName("_FBSScene"));
            id clientSettings = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(scene, sel_registerName("clientSettings"));
            NSNumber *preferredWindowingControlStyleType = reinterpret_cast<id (*)(id, SEL, SEL, Class)>(objc_msgSend)(clientSettings, sel_registerName("valueForProperty:expectedClass:"), sel_registerName("preferredWindowingControlStyleType"), [NSNumber class]);
            
            for (NSInteger i = 0; i < 3; i++) {
                UIAction *action = [UIAction actionWithTitle:_NSStringFromUIWindowingControlStyleType(i) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    // Not working...
                    reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(scene, sel_registerName("updateClientSettings:"), ^(id mutableClientSettings) {
                        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(mutableClientSettings, sel_registerName("setPreferredWindowingControlStyleType:"), i);
                    });
                }];
                
                action.state = (preferredWindowingControlStyleType.integerValue == i) ? UIMenuElementStateOn : UIMenuElementStateOff;
                [children addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Windowing Control Style" children:children];
            [children release];
            menu.subtitle = _NSStringFromUIWindowingControlStyleType(preferredWindowingControlStyleType.integerValue);
            [results addObject:menu];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
