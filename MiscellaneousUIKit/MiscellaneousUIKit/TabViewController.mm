//
//  TabViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "TabViewController.h"

@interface TabViewController ()
@property (retain, nonatomic, readonly, getter=_tabBarController) UITabBarController *tabBarController;
@end

@implementation TabViewController
@synthesize tabBarController = _tabBarController;

- (void)dealloc {
    [_tabBarController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.tabBarController];
    self.tabBarController.view.frame = self.view.bounds;
    self.tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tabBarController.view];
    [self.tabBarController didMoveToParentViewController:self];
}

- (UITabBarController *)_tabBarController {
    if (auto tabBarController = _tabBarController) return tabBarController;
    
    UITabBarController *tabBarController = [UITabBarController new];
    
    UITab *orangeTab = [[UITab alloc] initWithTitle:@"Yellow" image:[UIImage systemImageNamed:@"apple.intelligence"] identifier:@"1" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemYellowColor;
        return [viewController autorelease];
    }];
    
    UITab *greenTab = [[UITab alloc] initWithTitle:@"Green" image:[UIImage systemImageNamed:@"apple.intelligence"] identifier:@"2" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemGreenColor;
        return [viewController autorelease];
    }];
    
    UITab *blueTab = [[UITab alloc] initWithTitle:@"Blue" image:[UIImage systemImageNamed:@"apple.intelligence"] identifier:@"3" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemBlueColor;
        return [viewController autorelease];
    }];
    
    tabBarController.tabs = @[orangeTab, greenTab, blueTab];
    [orangeTab release];
    [greenTab release];
    [blueTab release];
    
    _tabBarController = tabBarController;
    return tabBarController;
}

@end
