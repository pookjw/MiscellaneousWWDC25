//
//  ToolbarViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "ToolbarViewController.h"

// TODO: Group

@interface ToolbarViewController ()
@property (retain, nonatomic, readonly, getter=_barButtonItem_1) UIBarButtonItem *barButtonItem_1;
@property (retain, nonatomic, readonly, getter=_barButtonItem_2) UIBarButtonItem *barButtonItem_2;
@property (retain, nonatomic, readonly, getter=_barButtonItem_3) UIBarButtonItem *barButtonItem_3;
@end

@implementation ToolbarViewController
@synthesize barButtonItem_1 = _barButtonItem_1;
@synthesize barButtonItem_2 = _barButtonItem_2;
@synthesize barButtonItem_3 = _barButtonItem_3;

- (void)dealloc {
    [_barButtonItem_1 release];
    [_barButtonItem_2 release];
    [_barButtonItem_3 release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.navigationItem.searchController = searchController;
    [searchController release];
    
    self.navigationItem.searchBarPlacementAllowsExternalIntegration = YES;
    
    self.toolbarItems = @[
        self.navigationItem.searchBarPlacementBarButtonItem,
        self.barButtonItem_1,
        self.barButtonItem_2,
        self.barButtonItem_3
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

@end
