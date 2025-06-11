//
//  SplitContentViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "SplitContentViewController.h"
#include <objc/message.h>
#include <objc/runtime.h>
#import "UISplitViewControllerColumn+String.h"

@interface SplitContentViewController ()
@property (retain, nonatomic, readonly, getter=_ownSplitViewController) UISplitViewController *ownSplitViewController;
@property (retain, nonatomic, readonly, getter=_primaryViewController) UIViewController *primaryViewController;
@property (retain, nonatomic, readonly, getter=_secondaryViewController) UINavigationController *secondaryViewController;
@property (retain, nonatomic, readonly, getter=_supplementaryViewController) UIViewController *supplementaryViewController;
@property (retain, nonatomic, readonly, getter=_compactViewController) UIViewController *compactViewController;
@property (retain, nonatomic, readonly, getter=_inspectorViewController) UIViewController *inspectorViewController;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation SplitContentViewController
@synthesize ownSplitViewController = _ownSplitViewController;
@synthesize primaryViewController = _primaryViewController;
@synthesize secondaryViewController = _secondaryViewController;
@synthesize supplementaryViewController = _supplementaryViewController;
@synthesize compactViewController = _compactViewController;
@synthesize inspectorViewController = _inspectorViewController;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_ownSplitViewController release];
    [_primaryViewController release];
    [_secondaryViewController release];
    [_supplementaryViewController release];
    [_compactViewController release];
    [_inspectorViewController release];
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
    
    UISplitViewController *ownSplitViewController = [[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleTripleColumn];
    
    [ownSplitViewController setViewController:self.primaryViewController forColumn:UISplitViewControllerColumnPrimary];
    [ownSplitViewController setViewController:self.secondaryViewController forColumn:UISplitViewControllerColumnSupplementary];
    [ownSplitViewController setViewController:self.supplementaryViewController forColumn:UISplitViewControllerColumnSecondary];
    [ownSplitViewController setViewController:self.compactViewController forColumn:UISplitViewControllerColumnCompact];
    [ownSplitViewController setViewController:self.inspectorViewController forColumn:UISplitViewControllerColumnInspector];
    
    _ownSplitViewController = ownSplitViewController;
    return ownSplitViewController;
}

- (UIViewController *)_primaryViewController {
    if (auto primaryViewController = _primaryViewController) return primaryViewController;
    UIViewController *primaryViewController = [UIViewController new];
    primaryViewController.view.backgroundColor = UIColor.systemOrangeColor;
    _primaryViewController = primaryViewController;
    return primaryViewController;
}

- (UINavigationController *)_secondaryViewController {
    if (auto secondaryViewController = _secondaryViewController) return secondaryViewController;
    
    UIViewController *viewController = [UIViewController new];
    viewController.view.backgroundColor = UIColor.systemBlueColor;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    viewController.navigationItem.searchController = searchController;
    [searchController release];
    
    viewController.navigationItem.searchBarPlacementAllowsExternalIntegration = YES;
    
    UINavigationController *secondaryViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [viewController release];
    
    _secondaryViewController = secondaryViewController;
    return secondaryViewController;
}

- (UIViewController *)_supplementaryViewController {
    if (auto supplementaryViewController = _supplementaryViewController) return supplementaryViewController;
    UIViewController *supplementaryViewController = [UIViewController new];
    supplementaryViewController.view.backgroundColor = UIColor.systemGreenColor;
    _supplementaryViewController = supplementaryViewController;
    return supplementaryViewController;
}

- (UIViewController *)_compactViewController {
    if (auto compactViewController = _compactViewController) return compactViewController;
    UIViewController *compactViewController = [UIViewController new];
    compactViewController.view.backgroundColor = UIColor.systemYellowColor;
    _compactViewController = compactViewController;
    return compactViewController;
}

- (UIViewController *)_inspectorViewController {
    if (auto inspectorViewController = _inspectorViewController) return inspectorViewController;
    UIViewController *inspectorViewController = [UIViewController new];
    inspectorViewController.view.backgroundColor = UIColor.systemPurpleColor;
    _inspectorViewController = inspectorViewController;
    return inspectorViewController;
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
        
        {
            NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] initWithCapacity:weakSelf.ownSplitViewController.viewControllers.count];
            
            for (UIViewController *viewController in weakSelf.ownSplitViewController.viewControllers) {
                UISplitViewControllerColumn column = reinterpret_cast<UISplitViewControllerColumn (*)(id, SEL, id)>(objc_msgSend)(weakSelf.ownSplitViewController, sel_registerName("_columnForViewController:"), viewController);
                // Swap supplementary and secondary columns for logic consistency:
                if (column == UISplitViewControllerColumnSupplementary) {
                    column = UISplitViewControllerColumnSecondary;
                } else if (column == UISplitViewControllerColumnSecondary) {
                    column = UISplitViewControllerColumnSupplementary;
                }
                UIAction *action = [UIAction actionWithTitle:NSStringFromUISplitViewControllerColumn(column)
                                                       image:nil
                                                  identifier:nil
                                                     handler:^(__kindof UIAction * _Nonnull action) {
                    if ([weakSelf.ownSplitViewController isShowingColumn:column]) {
                        [weakSelf.ownSplitViewController hideColumn:column];
                    } else {
                        [weakSelf.ownSplitViewController showViewController:viewController sender:action.sender];
                    }
                }];
                
                action.state = ([weakSelf.ownSplitViewController isShowingColumn:column]) ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                [actions addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Show" children:actions];
            [actions release];
            [results addObject:menu];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"searchBarPlacementAllowsExternalIntegration" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                weakSelf.secondaryViewController.topViewController.navigationItem.searchBarPlacementAllowsExternalIntegration = !weakSelf.secondaryViewController.topViewController.navigationItem.searchBarPlacementAllowsExternalIntegration;
                [weakSelf.secondaryViewController.view setNeedsLayout];
                for (UIViewController *viewController in weakSelf.ownSplitViewController.viewControllers) {
                    [viewController.navigationController.navigationBar setNeedsLayout];
                }
            }];
            
            action.state = (weakSelf.secondaryViewController.topViewController.navigationItem.searchBarPlacementAllowsExternalIntegration) ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end

