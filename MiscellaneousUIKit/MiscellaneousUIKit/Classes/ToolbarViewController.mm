//
//  ToolbarViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "ToolbarViewController.h"
#import "UINavigationItemSearchBarPlacement+String.h"
#include <ranges>
#include <vector>

@interface ToolbarViewController ()
@property (retain, nonatomic, readonly, getter=_barButtonItem_1) UIBarButtonItem *barButtonItem_1;
@property (retain, nonatomic, readonly, getter=_barButtonItem_2) UIBarButtonItem *barButtonItem_2;
@property (retain, nonatomic, readonly, getter=_barButtonItem_3) UIBarButtonItem *barButtonItem_3;
@property (retain, nonatomic, readonly, getter=_barButtonItem_4) UIBarButtonItem *barButtonItem_4;
@property (retain, nonatomic, readonly, getter=_barButtonItem_5) UIBarButtonItem *barButtonItem_5;
@property (retain, nonatomic, readonly, getter=_barButtonItem_6) UIBarButtonItem *barButtonItem_6;
@property (retain, nonatomic, readonly, getter=_barButtonItem_7) UIBarButtonItem *barButtonItem_7;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation ToolbarViewController
@synthesize barButtonItem_1 = _barButtonItem_1;
@synthesize barButtonItem_2 = _barButtonItem_2;
@synthesize barButtonItem_3 = _barButtonItem_3;
@synthesize barButtonItem_4 = _barButtonItem_4;
@synthesize barButtonItem_5 = _barButtonItem_5;
@synthesize barButtonItem_6 = _barButtonItem_6;
@synthesize barButtonItem_7 = _barButtonItem_7;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_barButtonItem_1 release];
    [_barButtonItem_2 release];
    [_barButtonItem_3 release];
    [_barButtonItem_4 release];
    [_barButtonItem_5 release];
    [_barButtonItem_6 release];
    [_barButtonItem_7 release];
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
    
    UIBarButtonItem *flex_1 = [UIBarButtonItem flexibleSpaceItem];
    UIBarButtonItem *flex_2 = [UIBarButtonItem flexibleSpaceItem];
    flex_2.hidesSharedBackground = NO;
    UIBarButtonItem *flex_3 = [UIBarButtonItem flexibleSpaceItem];
    UIBarButtonItem *flex_4 = [UIBarButtonItem flexibleSpaceItem];
    
    
    UIBarButtonItem *fixed_1 = [UIBarButtonItem fixedSpaceItemOfWidth:40];
    UIBarButtonItem *fixed_2 = [UIBarButtonItem fixedSpaceItem];
    
    self.toolbarItems = @[
        self.navigationItem.searchBarPlacementBarButtonItem,
        flex_1,
        self.barButtonItem_1,
        flex_2,
        self.barButtonItem_2,
        flex_3,
        self.barButtonItem_3,
        flex_4,
        self.barButtonItem_4,
        self.barButtonItem_5,
        fixed_1,
        self.barButtonItem_6,
        fixed_2,
        self.barButtonItem_7
    ];
}

- (UIBarButtonItem *)_barButtonItem_1 {
    if (auto barButtonItem_1 = _barButtonItem_1) return barButtonItem_1;
    
    UIBarButtonItem *barButtonItem_1 = [[UIBarButtonItem alloc] initWithTitle:@"1" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:nil];
    
    _barButtonItem_1 = barButtonItem_1;
    return barButtonItem_1;
}

- (UIBarButtonItem *)_barButtonItem_2 {
    if (auto barButtonItem_2 = _barButtonItem_2) return barButtonItem_2;
    
    UIBarButtonItem *barButtonItem_2 = [[UIBarButtonItem alloc] initWithTitle:@"2" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:nil];
    
    _barButtonItem_2 = barButtonItem_2;
    return barButtonItem_2;
}

- (UIBarButtonItem *)_barButtonItem_3 {
    if (auto barButtonItem_3 = _barButtonItem_3) return barButtonItem_3;
    
    UIBarButtonItem *barButtonItem_3 = [[UIBarButtonItem alloc] initWithTitle:@"3" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:nil];
    
    _barButtonItem_3 = barButtonItem_3;
    return barButtonItem_3;
}

- (UIBarButtonItem *)_barButtonItem_4 {
    if (auto barButtonItem_4 = _barButtonItem_4) return barButtonItem_4;
    UIBarButtonItem *barButtonItem_4 = [[UIBarButtonItem alloc] initWithTitle:@"4" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:nil];
    _barButtonItem_4 = barButtonItem_4;
    return barButtonItem_4;
}

- (UIBarButtonItem *)_barButtonItem_5 {
    if (auto barButtonItem_5 = _barButtonItem_5) return barButtonItem_5;
    UIBarButtonItem *barButtonItem_5 = [[UIBarButtonItem alloc] initWithTitle:@"5" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:nil];
    _barButtonItem_5 = barButtonItem_5;
    return barButtonItem_5;
}

- (UIBarButtonItem *)_barButtonItem_6 {
    if (auto barButtonItem_6 = _barButtonItem_6) return barButtonItem_6;
    UIBarButtonItem *barButtonItem_6 = [[UIBarButtonItem alloc] initWithTitle:@"6" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:nil];
    _barButtonItem_6 = barButtonItem_6;
    return barButtonItem_6;
}

- (UIBarButtonItem *)_barButtonItem_7 {
    if (auto barButtonItem_7 = _barButtonItem_7) return barButtonItem_7;
    UIBarButtonItem *barButtonItem_7 = [[UIBarButtonItem alloc] initWithTitle:@"7" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:nil];
    _barButtonItem_7 = barButtonItem_7;
    return barButtonItem_7;
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
            UIAction *action = [UIAction actionWithTitle:@"searchBarPlacementAllowsToolbarIntegration" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                weakSelf.navigationItem.searchBarPlacementAllowsToolbarIntegration = !weakSelf.navigationItem.searchBarPlacementAllowsToolbarIntegration;
            }];
            action.state = weakSelf.navigationItem.searchBarPlacementAllowsToolbarIntegration ? UIMenuElementStateOn : UIMenuElementStateOff;
            
            [results addObject:action];
        }
        
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
    
    return [UIMenu menuWithChildren:@[element]];
}

@end

