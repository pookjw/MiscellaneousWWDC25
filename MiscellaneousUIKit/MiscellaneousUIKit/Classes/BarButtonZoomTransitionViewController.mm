//
//  BarButtonZoomTransitionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "BarButtonZoomTransitionViewController.h"

@interface BarButtonZoomTransitionViewController ()
@property (retain, nonatomic, readonly, getter=_barButtonItem) UIBarButtonItem *barButtonItem;
@end

@implementation BarButtonZoomTransitionViewController
@synthesize barButtonItem = _barButtonItem;

- (void)dealloc {
    [_barButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    self.navigationItem.rightBarButtonItem = self.barButtonItem;
}

- (UIBarButtonItem *)_barButtonItem {
    if (auto barButtonItem = _barButtonItem) return barButtonItem;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Present" image:[UIImage systemImageNamed:@"apple.intelligence"] target:self action:@selector(_barButtonItemDidTrigger:) menu:nil];
    
    _barButtonItem = barButtonItem;
    return barButtonItem;
}

- (void)_barButtonItemDidTrigger:(UIBarButtonItem *)sender {
    UIViewController *viewController = [UIViewController new];
    viewController.preferredTransition = [UIViewControllerTransition zoomWithOptions:nil sourceBarButtonItemProvider:^UIBarButtonItem * _Nullable(UIZoomTransitionSourceViewProviderContext * _Nonnull) {
        return sender;
    }];
    
    [self presentViewController:viewController animated:YES completion:nil];
    [viewController release];
}

@end
