//
//  FlexInteractionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/28/25.
//

#import "FlexInteractionViewController.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface FlexInteractionViewController ()

@end

@implementation FlexInteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIView *flexView = [UIView new];
    flexView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    
    id<UIInteraction> flexInteraction = [objc_lookUpClass("_UIFlexInteraction") new];
    [flexView addInteraction:flexInteraction];
    [flexInteraction release];
    
    [self.view addSubview:flexView];
    flexView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [flexView.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [flexView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [flexView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.5],
        [flexView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5],
    ]];
    
    [flexView release];
}

@end
