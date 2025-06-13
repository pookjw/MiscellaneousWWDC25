//
//  ColorLinearExposureViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import "ColorLinearExposureViewController.h"

@interface ColorLinearExposureViewController ()
@property (retain, nonatomic, readonly, getter=_stackView) UIStackView *stackView;
@property (retain, nonatomic, readonly, getter=_standardColorView) UIView *standardColorView;
@property (retain, nonatomic, readonly, getter=_colorView) UIView *colorView;
@property (retain, nonatomic, readonly, getter=_redSlider) UISlider *redSlider;
@property (retain, nonatomic, readonly, getter=_greenSlider) UISlider *greenSlider;
@property (retain, nonatomic, readonly, getter=_blueSlider) UISlider *blueSlider;
@property (retain, nonatomic, readonly, getter=_linearExposureSlider) UISlider *linearExposureSlider;
@property (retain, nonatomic, readonly, getter=_contentHeadroomSlider) UISlider *contentHeadroomSlider;
@end

@implementation ColorLinearExposureViewController

@synthesize stackView = _stackView;
@synthesize standardColorView = _standardColorView;
@synthesize colorView = _colorView;
@synthesize redSlider = _redSlider;
@synthesize greenSlider = _greenSlider;
@synthesize blueSlider = _blueSlider;
@synthesize linearExposureSlider = _linearExposureSlider;
@synthesize contentHeadroomSlider = _contentHeadroomSlider;

- (void)dealloc {
    [_stackView release];
    [_standardColorView release];
    [_colorView release];
    [_redSlider release];
    [_greenSlider release];
    [_blueSlider release];
    [_linearExposureSlider release];
    [_contentHeadroomSlider release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30.],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-30.],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:30.],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-30.]
    ]];
}

- (UIStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
        self.standardColorView,
        self.colorView,
        self.redSlider,
        self.greenSlider,
        self.blueSlider,
        self.linearExposureSlider,
        self.contentHeadroomSlider
    ]];
    
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = 16.0;
    
    _stackView = stackView;
    return _stackView;
}

- (UIView *)_standardColorView {
    if (auto standardColorView = _standardColorView) return standardColorView;
    UIView *standardColorView = [UIView new];
    _standardColorView = standardColorView;
    return standardColorView;
}

- (UIView *)_colorView {
    if (auto colorView = _colorView) return colorView;
    
    UIView *colorView = [UIView new];
    colorView.layer.preferredDynamicRange = CADynamicRangeHigh;
    
    _colorView = colorView;
    return colorView;
}

- (UISlider *)_redSlider {
    if (auto redSlider = _redSlider) return redSlider;
    
    UISlider *redSlider = [UISlider new];
    redSlider.minimumValue = 0.f;
    redSlider.maximumValue = 1.f;
    redSlider.value = 1.f;
    
    [redSlider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _redSlider = redSlider;
    return redSlider;
}

- (UISlider *)_greenSlider {
    if (auto greenSlider = _greenSlider) return greenSlider;
    
    UISlider *greenSlider = [UISlider new];
    greenSlider.minimumValue = 0.f;
    greenSlider.maximumValue = 1.f;
    greenSlider.value = 1.f;
    
    [greenSlider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _greenSlider = greenSlider;
    return greenSlider;
}

- (UISlider *)_blueSlider {
    if (auto blueSlider = _blueSlider) return blueSlider;
    
    UISlider *blueSlider = [UISlider new];
    blueSlider.minimumValue = 0.f;
    blueSlider.maximumValue = 1.f;
    blueSlider.value = 1.f;
    
    [blueSlider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _blueSlider = blueSlider;
    return blueSlider;
}

- (UISlider *)_linearExposureSlider {
    if (auto linearExposureSlider = _linearExposureSlider) return linearExposureSlider;
    
    UISlider *linearExposureSlider = [UISlider new];
    linearExposureSlider.minimumValue = 0.f;
    linearExposureSlider.maximumValue = 2.f;
    linearExposureSlider.value = 1.f;
    
    [linearExposureSlider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _linearExposureSlider = linearExposureSlider;
    return linearExposureSlider;
}

- (UISlider *)_contentHeadroomSlider {
    if (auto contentHeadroomSlider = _contentHeadroomSlider) return contentHeadroomSlider;
    
    UISlider *contentHeadroomSlider = [UISlider new];
    contentHeadroomSlider.minimumValue = 0.f;
    contentHeadroomSlider.maximumValue = 100.f;
    contentHeadroomSlider.value = 50.f;
    
    [contentHeadroomSlider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _contentHeadroomSlider = contentHeadroomSlider;
    return _contentHeadroomSlider;
}

- (void)_sliderValueDidChange:(UISlider *)sender {
    UIColor *color = [[UIColor colorWithRed:self.redSlider.value
                                      green:self.greenSlider.value
                                       blue:self.blueSlider.value
                                      alpha:1.
                             linearExposure:self.linearExposureSlider.value] colorByApplyingContentHeadroom:self.contentHeadroomSlider.value];
    
    self.colorView.backgroundColor = color;
    self.standardColorView.backgroundColor = color.standardDynamicRangeColor;
}

@end
