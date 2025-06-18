//
//  FlushUpdatesViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import "FlushUpdatesViewController.h"

@interface FlushUpdatesViewController ()
@property (retain, nonatomic, readonly, getter=_containerView) UIView *containerView;
@property (retain, nonatomic, getter=_timer, setter=_setTimer:) NSTimer *timer;
@end

@implementation FlushUpdatesViewController
@synthesize containerView = _containerView;

- (void)dealloc {
    [_containerView release];
    [_timer invalidate];
    [_timer release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    
    [self.view addSubview:self.containerView];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray<NSLayoutConstraint *> *constraints = @[
        [self.containerView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.5],
        [self.containerView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5],
        [self.containerView.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [self.containerView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor]
    ];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2. target:self selector:@selector(_timerDidTrigger:) userInfo:nil repeats:YES];
}

- (void)_timerDidTrigger:(NSTimer *)sender {
    [UIView animateWithDuration:1. delay:0. options:UIViewAnimationOptionFlushUpdates animations:^{
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if ((constraint.firstAttribute == NSLayoutAttributeCenterX) && ([constraint.firstItem isEqual:self.containerView])) {
                if (constraint.constant > 0) {
                    constraint.constant = -100.;
                } else {
                    constraint.constant = 100.;
                }
                break;
            }
        }
    }
                     completion:^(BOOL finished) {
        
    }];
}

- (UIView *)_containerView {
    if (auto containerView = _containerView) return containerView;
    
    UIView *containerView = [UIView new];
    containerView.backgroundColor = UIColor.systemPinkColor;
    
    _containerView = containerView;
    return containerView;
}

@end
