//
//  NavigationItemViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/12/25.
//

#import "NavigationItemViewController.h"

#if !TARGET_OS_VISION

@interface NavigationItemViewController ()

@end

@implementation NavigationItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{
        NSForegroundColorAttributeName: UIColor.systemPinkColor
    }];
    self.navigationItem.attributedTitle = attributedTitle;
    [attributedTitle release];
    
    NSAttributedString *attributedSubtitle = [[NSAttributedString alloc] initWithString:@"Subtitle" attributes:@{
        NSForegroundColorAttributeName: UIColor.systemGreenColor
    }];
    self.navigationItem.attributedSubtitle = attributedSubtitle;
    [attributedSubtitle release];
}

@end

#endif
