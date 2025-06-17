//
//  SplitLayoutEnvironmentViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "SplitLayoutEnvironmentViewController.h"
#import "UISplitViewControllerLayoutEnvironment+String.h"

@interface SplitLayoutEnvironmentViewController ()
@property (retain, nonatomic, readonly, getter=_label) UILabel *label;
@property (retain, nonatomic, nullable, getter=_registration, setter=_setRegistration:) id<UITraitChangeRegistration> registration;
@end

@implementation SplitLayoutEnvironmentViewController
@synthesize label = _label;

- (void)dealloc {
    [_label release];
    [_registration release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.registration = [self registerForTraitChanges:@[[UITraitSplitViewControllerLayoutEnvironment class]] withTarget:self action:@selector(_splitLayoutDidChange:)];
    [self _splitLayoutDidChange:self];
}

- (void)_splitLayoutDidChange:(SplitLayoutEnvironmentViewController *)sender {
    self.label.text = NSStringFromUISplitViewControllerLayoutEnvironment(sender.traitCollection.splitViewControllerLayoutEnvironment);
}

- (UILabel *)_label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    label.textAlignment = NSTextAlignmentCenter;
    
    _label = label;
    return label;
}

@end
