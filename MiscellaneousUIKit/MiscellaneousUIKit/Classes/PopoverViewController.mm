//
//  PopoverViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import "PopoverViewController.h"

@interface PopoverViewController ()
@property (retain, nonatomic, readonly, getter=_barButtonItem) UIBarButtonItem *barButtonItem;
@end

@implementation PopoverViewController
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
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Button" image:[UIImage systemImageNamed:@"apple.intelligence"] target:self action:@selector(_barButtonItemDidTrigger:) menu:nil];
    
    _barButtonItem = barButtonItem;
    return barButtonItem;
}

- (void)_barButtonItemDidTrigger:(UIBarButtonItem *)sender {
    UIColorPickerViewController *colorPickerViewController = [UIColorPickerViewController new];
    colorPickerViewController.modalPresentationStyle = UIModalPresentationPopover;
    colorPickerViewController.popoverPresentationController.sourceItem = sender;
//    colorPickerViewController.popoverPresentationController.sourceView = self.view;
    [self presentViewController:colorPickerViewController animated:YES completion:nil];
    [colorPickerViewController release];
}

@end
