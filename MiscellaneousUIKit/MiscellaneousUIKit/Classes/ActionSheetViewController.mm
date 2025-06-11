//
//  ActionSheetViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "ActionSheetViewController.h"

@interface ActionSheetViewController ()
@property (retain, nonatomic, readonly, getter=_barButtonItem) UIBarButtonItem *barButtonItem;
@end

@implementation ActionSheetViewController
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title" message:@"Message" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action_1 = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancelled");
    }];
    [alertController addAction:action_1];
    
    UIAlertAction *action_2 = [UIAlertAction actionWithTitle:@"Action" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action_2];
    
    UIAlertAction *action_3 = [UIAlertAction actionWithTitle:@"Action" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action_3];
    
    UIAlertAction *action_4 = [UIAlertAction actionWithTitle:@"Destructive" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action_4];
    
    alertController.popoverPresentationController.sourceItem = sender;
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
