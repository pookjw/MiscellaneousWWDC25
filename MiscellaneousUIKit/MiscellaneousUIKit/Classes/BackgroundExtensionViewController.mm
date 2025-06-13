//
//  BackgroundExtensionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import "BackgroundExtensionViewController.h"

@interface BackgroundExtensionViewController ()
@property (retain, nonatomic, readonly, getter=_ownSplitViewController) UISplitViewController *ownSplitViewController;
@property (retain, nonatomic, readonly, getter=_secondaryViewController) UIViewController *secondaryViewController;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation BackgroundExtensionViewController
@synthesize ownSplitViewController = _ownSplitViewController;
@synthesize secondaryViewController = _secondaryViewController;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_ownSplitViewController release];
    [_secondaryViewController release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.ownSplitViewController];
    self.ownSplitViewController.view.frame = self.view.bounds;
    self.ownSplitViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.ownSplitViewController.view];
    [self.ownSplitViewController didMoveToParentViewController:self];
    
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
}

- (UISplitViewController *)_ownSplitViewController {
    if (auto ownSplitViewController = _ownSplitViewController) return ownSplitViewController;
    
    UISplitViewController *ownSplitViewController = [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleDoubleColumn];
    
    UIViewController *primaryViewController = [UIViewController new];
    primaryViewController.view.backgroundColor = [UIColor.systemOrangeColor colorWithAlphaComponent:0.2];
    [ownSplitViewController setViewController:primaryViewController forColumn:UISplitViewControllerColumnPrimary];
    [primaryViewController release];
    
    [ownSplitViewController setViewController:self.secondaryViewController forColumn:UISplitViewControllerColumnSecondary];
    
    UIViewController *inspectorViewController = [UIViewController new];
    inspectorViewController.view.backgroundColor = [UIColor.systemGreenColor colorWithAlphaComponent:0.2];
    [ownSplitViewController setViewController:inspectorViewController forColumn:UISplitViewControllerColumnInspector];
    [inspectorViewController release];
    
    _ownSplitViewController = ownSplitViewController;
    return ownSplitViewController;
}

- (UIViewController *)_secondaryViewController {
    if (auto secondaryViewController = _secondaryViewController) return secondaryViewController;
    
    UIViewController *secondaryViewController = [UIViewController new];
    
    UIBackgroundExtensionView *backgroundExtensionView = [[UIBackgroundExtensionView alloc] init];
    backgroundExtensionView.automaticallyPlacesContentView = YES;
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image"]];
    contentView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundExtensionView.contentView = contentView;
    [contentView release];
    
    if (!backgroundExtensionView.automaticallyPlacesContentView) {
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [contentView.topAnchor constraintEqualToAnchor:backgroundExtensionView.topAnchor],
            [contentView.leadingAnchor constraintEqualToAnchor:backgroundExtensionView.leadingAnchor],
            [contentView.trailingAnchor constraintEqualToAnchor:backgroundExtensionView.trailingAnchor],
            [contentView.bottomAnchor constraintEqualToAnchor:backgroundExtensionView.bottomAnchor]
        ]];
    }
    
    secondaryViewController.view = backgroundExtensionView;
    [backgroundExtensionView release];
    
    _secondaryViewController = secondaryViewController;
    return secondaryViewController;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Toggle Inspector" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                [weakSelf.ownSplitViewController toggleInspector:action.sender];
            }];
            [results addObject:action];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
