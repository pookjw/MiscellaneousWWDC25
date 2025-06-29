//
//  InteractiveGlassEffectViewController.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/27/25.
//

#import "InteractiveGlassEffectViewController.h"

#if !TARGET_OS_VISION

@interface InteractiveGlassEffectViewController ()

@end

@implementation InteractiveGlassEffectViewController

//- (void)loadView {
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    imageView.userInteractionEnabled = YES;
//    
//    self.view = imageView;
//    [imageView release];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIGlassEffect *effect = [UIGlassEffect new];
    effect.interactive = YES;
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    [effect release];
    
    [self.view addSubview:visualEffectView];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [visualEffectView.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [visualEffectView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [visualEffectView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.5],
        [visualEffectView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5],
    ]];
    
    [visualEffectView release];
}

@end

#endif
