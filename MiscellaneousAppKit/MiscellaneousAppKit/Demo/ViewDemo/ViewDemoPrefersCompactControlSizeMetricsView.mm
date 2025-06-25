//
//  ViewDemoPrefersCompactControlSizeMetricsView.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/26/25.
//

#import "ViewDemoPrefersCompactControlSizeMetricsView.h"

@interface ViewDemoPrefersCompactControlSizeMetricsView ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_demoView) NSView *demoView;
@property (retain, nonatomic, readonly, getter=_demoSwitch) NSSwitch *demoSwitch;
@property (retain, nonatomic, readonly, getter=_toggle) NSSwitch *toggle;
@end

@implementation ViewDemoPrefersCompactControlSizeMetricsView
@synthesize stackView = _stackView;
@synthesize demoView = _demoView;
@synthesize demoSwitch = _demoSwitch;
@synthesize toggle = _toggle;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.stackView];
        self.stackView.frame = self.bounds;
        self.stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_demoView release];
    [_demoSwitch release];
    [_toggle release];
    [super dealloc];
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    [stackView addArrangedSubview:self.demoView];
    [stackView addArrangedSubview:self.toggle];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFill;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSView *)_demoView {
    if (auto demoView = _demoView) return demoView;
    
    NSView *demoView = [NSView new];
    [demoView addSubview:self.demoSwitch];
    self.demoSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.demoSwitch.centerXAnchor constraintEqualToAnchor:demoView.centerXAnchor],
        [self.demoSwitch.centerYAnchor constraintEqualToAnchor:demoView.centerYAnchor]
    ]];
    
    _demoView = demoView;
    return demoView;
}

- (NSSwitch *)_demoSwitch {
    if (auto demoSwitch = _demoSwitch) return demoSwitch;
    
    NSSwitch *demoSwitch = [NSSwitch new];
    
    _demoSwitch = demoSwitch;
    return demoSwitch;
}

- (NSSwitch *)_toggle {
    if (auto toggle = _toggle) return toggle;
    
    NSSwitch *toggle = [NSSwitch new];
    toggle.target = self;
    toggle.action = @selector(_toggleDidTrigger:);
    toggle.state = (self.demoView.prefersCompactControlSizeMetrics ? NSControlStateValueOn : NSControlStateValueOff);
    
    _toggle = toggle;
    return toggle;
}

- (void)_toggleDidTrigger:(NSSwitch *)sender {
    self.demoView.prefersCompactControlSizeMetrics = (sender.state == NSControlStateValueOn);
}

@end
