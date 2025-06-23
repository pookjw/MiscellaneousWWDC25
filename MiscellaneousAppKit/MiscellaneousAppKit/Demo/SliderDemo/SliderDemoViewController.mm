//
//  SliderDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import "SliderDemoViewController.h"
#import "ConfigurationView.h"

@interface SliderDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_slider) NSSlider *slider;
@property (retain, nonatomic, readonly, getter=_sliderContainerView) NSView *sliderContainerView;
@end

@implementation SliderDemoViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize slider = _slider;
@synthesize sliderContainerView = _sliderContainerView;

- (void)dealloc {
    [_splitView release];
    [_configurationView release];
    [_slider release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.splitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
}

- (NSSplitView *)_splitView {
    if (auto splitView = _splitView) return splitView;
    
    NSSplitView *splitView = [NSSplitView new];
    splitView.vertical = YES;
    [splitView addArrangedSubview:self.configurationView];
    [splitView addArrangedSubview:self.sliderContainerView];
    
    _splitView = splitView;
    return splitView;
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (NSSlider *)_slider {
    if (auto slider = _slider) return slider;
    
    NSSlider *slider = [NSSlider new];
    
    _slider = slider;
    return slider;
}

- (NSView *)_sliderContainerView {
    if (auto sliderContainerView = _sliderContainerView) return sliderContainerView;
    
    NSView *sliderContainerView = [NSView new];
    
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [sliderContainerView addSubview:self.slider];
    [NSLayoutConstraint activateConstraints:@[
        [self.slider.centerYAnchor constraintEqualToAnchor:sliderContainerView.safeAreaLayoutGuide.centerYAnchor],
        [self.slider.leadingAnchor constraintEqualToAnchor:sliderContainerView.safeAreaLayoutGuide.leadingAnchor],
        [self.slider.trailingAnchor constraintEqualToAnchor:sliderContainerView.safeAreaLayoutGuide.trailingAnchor]
    ]];
    
    _sliderContainerView = sliderContainerView;
    return sliderContainerView;
}

- (void)_reload {
    
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
