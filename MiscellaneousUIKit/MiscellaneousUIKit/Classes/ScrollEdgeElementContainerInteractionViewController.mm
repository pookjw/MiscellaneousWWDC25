//
//  ScrollEdgeElementContainerInteractionViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "ScrollEdgeElementContainerInteractionViewController.h"

@interface ScrollEdgeElementContainerInteractionViewController ()
@property (retain, nonatomic, readonly, getter=_scrollView) UIScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_stackView) UIStackView *stackView;
@end

@implementation ScrollEdgeElementContainerInteractionViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;
@synthesize stackView = _stackView;

- (void)dealloc {
    [_scrollView release];
    [_imageView release];
    [_stackView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor],
        [self.stackView.heightAnchor constraintEqualToConstant:200],
    ]];
}

- (UIScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    UIScrollView *scrollView = [UIScrollView new];
    [scrollView addSubview:self.imageView];
    CGSize imageSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0., 0., imageSize.width, imageSize.height);
    scrollView.contentSize = imageSize;
    
    scrollView.backgroundColor = UIColor.systemBackgroundColor;
    scrollView.bottomEdgeEffect.style = UIScrollEdgeEffectStyle.softStyle;
    
    _scrollView = scrollView;
    return scrollView;
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = NO;
    
    _imageView = imageView;
    return imageView;
}

- (UIStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    UIButtonConfiguration *configuration = [UIButtonConfiguration tintedGlassButtonConfiguration];
    configuration.title = @"Button";
    
    UIButton *button_1 = [UIButton new];
    UIButton *button_2 = [UIButton new];
    button_1.configuration = configuration;
    button_2.configuration = configuration;
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentFill;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.spacing = 8.;
    
    UIScrollEdgeElementContainerInteraction *interaction = [UIScrollEdgeElementContainerInteraction new];
    interaction.scrollView = self.scrollView;
    interaction.edge = UIRectEdgeBottom;
    [stackView addInteraction:interaction];
    [interaction release];
    
    [stackView addArrangedSubview:button_1];
    [stackView addArrangedSubview:button_2];
    
    [button_1 release];
    [button_2 release];
    
    _stackView = stackView;
    return stackView;
}

@end
