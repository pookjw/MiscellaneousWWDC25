//
//  TabViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "TabViewController.h"
#import "ListViewController.h"
#import "UITabBarMinimizeBehavior+String.h"
#include <objc/runtime.h>
#include <objc/message.h>
#include <vector>
#include <ranges>

@interface TabViewController () <UITabBarControllerDelegate>
@property (retain, nonatomic, readonly, getter=_tabBarController) UITabBarController *tabBarController;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation TabViewController
@synthesize tabBarController = _tabBarController;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_tabBarController release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.tabBarController];
    self.tabBarController.view.frame = self.view.bounds;
    self.tabBarController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tabBarController.view];
    [self.tabBarController didMoveToParentViewController:self];
    
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.searchController = searchController;
    [searchController release];
}

- (UITabBarController *)_tabBarController {
    if (auto tabBarController = _tabBarController) return tabBarController;
    
    UITabBarController *tabBarController = [UITabBarController new];
    tabBarController.mode = UITabBarControllerModeTabSidebar;
    tabBarController.delegate = self;
    
    {
        UIButtonConfiguration *configuration = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)([UIButtonConfiguration class], sel_registerName("_posterSwitcherGlassButtonConfiguration"));
        configuration.title = @"Title";
        configuration.image = [UIImage systemImageNamed:@"apple.intelligence"];
        
        UIButton *button = [UIButton new];
        button.configuration = configuration;
        
        UITabAccessory *bottomTabAccessory = [[UITabAccessory alloc] initWithContentView:button];
        [button release];
        
        tabBarController.bottomAccessory = bottomTabAccessory;
        [bottomTabAccessory release];
    }
    
    UITab *listTab = [[UITab alloc] initWithTitle:@"List" image:[UIImage systemImageNamed:@"apple.intelligence"] identifier:@"0" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        return [[ListViewController new] autorelease];
    }];
    
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
    
    UITab *childTab = [[UITab alloc] initWithTitle:@"Child" image:[UIImage systemImageNamed:@"apple.intelligence"] identifier:@"3" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        return [viewController autorelease];
    }];
    
    UITab *pinkTab = [[UITab alloc] initWithTitle:@"Pink" image:[UIImage systemImageNamed:@"apple.intelligence"] identifier:@"4" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemPinkColor;
        return [viewController autorelease];
    }];
    
    UISearchTab *searchTab = [[UISearchTab alloc] initWithTitle:@"Search" image:[UIImage systemImageNamed:@"magnifyingglass"] identifier:@"4" viewControllerProvider:^UIViewController * _Nonnull(__kindof UITab * _Nonnull) {
        UIViewController *viewController = [UIViewController new];
        viewController.view.backgroundColor = UIColor.systemPinkColor;
        
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        viewController.navigationItem.searchController = searchController;
        [searchController release];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [viewController release];
        
        return [navigationController autorelease];
    }];
    searchTab.automaticallyActivatesSearch = YES;
    
    tabBarController.tabs = @[listTab, orangeTab, childTab, searchTab, greenTab, pinkTab];
    [listTab release];
    [orangeTab release];
    [greenTab release];
    [childTab release];
    [searchTab release];
    [pinkTab release];
    
    _tabBarController = tabBarController;
    return tabBarController;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    UITabBarController *tabBarController = self.tabBarController;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            NSUInteger count;
            const UITabBarMinimizeBehavior *allBehaviors = allUITabBarMinimizeBehaviors(&count);
            
            auto actionsVec = std::views::iota(allBehaviors, allBehaviors + count)
            | std::views::transform([tabBarController](const UITabBarMinimizeBehavior *ptr) -> UIAction * {
                UITabBarMinimizeBehavior behavior = *ptr;
                UIAction *action = [UIAction actionWithTitle:NSStringFromUITabBarMinimizeBehavior(behavior) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    tabBarController.tabBarMinimizeBehavior = behavior;
                }];
                action.state = (tabBarController.tabBarMinimizeBehavior == behavior) ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Tab Bar Minimize Behavior" children:actions];
            [actions release];
            menu.subtitle = NSStringFromUITabBarMinimizeBehavior(tabBarController.tabBarMinimizeBehavior);
            [results addObject:menu];
        }
        
        completion(results);
        [results release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    return responds;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectTab:(UITab *)selectedTab previousTab:(UITab *)previousTab {
    if ([selectedTab.identifier isEqualToString:@"3"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *viewController = selectedTab.viewController;
            for (UIView *subview in viewController.view.subviews) {
                [subview removeFromSuperview];
            }
             
             UIView *fullView = [UIView new];
             fullView.backgroundColor = UIColor.systemGreenColor;
             
             UIView *safeAreaView = [UIView new];
             safeAreaView.backgroundColor = UIColor.systemOrangeColor;
             
             UIView *tabContentView = [UIView new];
             tabContentView.backgroundColor = UIColor.systemBlueColor;
             
             fullView.translatesAutoresizingMaskIntoConstraints = NO;
             safeAreaView.translatesAutoresizingMaskIntoConstraints = NO;
             tabContentView.translatesAutoresizingMaskIntoConstraints = NO;
             
             [viewController.view addSubview:fullView];
             [viewController.view addSubview:safeAreaView];
             [viewController.view addSubview:tabContentView];
             
             [NSLayoutConstraint activateConstraints:@[
             [fullView.topAnchor constraintEqualToAnchor:viewController.view.topAnchor],
             [fullView.leadingAnchor constraintEqualToAnchor:viewController.view.leadingAnchor],
             [fullView.trailingAnchor constraintEqualToAnchor:viewController.view.trailingAnchor],
             [fullView.bottomAnchor constraintEqualToAnchor:viewController.view.bottomAnchor],
             
             [safeAreaView.topAnchor constraintEqualToAnchor:viewController.view.safeAreaLayoutGuide.topAnchor],
             [safeAreaView.leadingAnchor constraintEqualToAnchor:viewController.view.safeAreaLayoutGuide.leadingAnchor],
             [safeAreaView.trailingAnchor constraintEqualToAnchor:viewController.view.safeAreaLayoutGuide.trailingAnchor],
             [safeAreaView.bottomAnchor constraintEqualToAnchor:viewController.view.safeAreaLayoutGuide.bottomAnchor],
             
             [tabContentView.topAnchor constraintEqualToAnchor:tabBarController.contentLayoutGuide.topAnchor],
             [tabContentView.leadingAnchor constraintEqualToAnchor:tabBarController.contentLayoutGuide.leadingAnchor],
             [tabContentView.trailingAnchor constraintEqualToAnchor:tabBarController.contentLayoutGuide.trailingAnchor],
             [tabContentView.bottomAnchor constraintEqualToAnchor:tabBarController.contentLayoutGuide.bottomAnchor]
             ]];
             
             [fullView release];
             [safeAreaView release];
             [tabContentView release];
        });
    }
}

@end
