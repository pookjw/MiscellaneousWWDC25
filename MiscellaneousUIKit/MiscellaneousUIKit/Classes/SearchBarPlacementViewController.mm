//
//  SearchBarPlacementViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "SearchBarPlacementViewController.h"
#import "UINavigationItemSearchBarPlacement+String.h"
#include <ranges>
#include <vector>

@interface SearchBarPlacementViewController ()
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation SearchBarPlacementViewController
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.searchController = searchController;
    [searchController release];
    
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
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
            NSUInteger count;
            const UINavigationItemSearchBarPlacement *allPlacements = allUINavigationItemSearchBarPlacements(&count);
            
            auto actionsVec = std::views::iota(allPlacements, allPlacements + count)
            | std::views::transform([weakSelf](const UINavigationItemSearchBarPlacement *ptr) -> UIAction * {
                UINavigationItemSearchBarPlacement placement = *ptr;
                UIAction *action = [UIAction actionWithTitle:NSStringFromUINavigationItemSearchBarPlacement(placement) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    weakSelf.navigationItem.preferredSearchBarPlacement = placement;
                }];
                
                if (weakSelf.navigationItem.searchBarPlacement == placement) {
                    action.state = UIMenuElementStateMixed;
                } else if (weakSelf.navigationItem.preferredSearchBarPlacement == placement) {
                    action.state = UIMenuElementStateOn;
                } else {
                    action.state = UIMenuElementStateOff;
                }
                
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Search Bar Placement" children:actions];
            [actions release];
            menu.subtitle = NSStringFromUINavigationItemSearchBarPlacement(weakSelf.navigationItem.searchBarPlacement);
            [results addObject:menu];
        }
        
        completion(results);
        [results release];
    }];
    
    UIMenu *menu = [UIMenu menuWithChildren:@[element]];
    return menu;
}

@end
