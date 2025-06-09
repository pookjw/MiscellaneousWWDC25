//
//  LiquidLensViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "LiquidLensViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface LiquidLensViewController ()
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_liquidLensView) __kindof UIView *liquidLensView;
@end

@implementation LiquidLensViewController
@synthesize imageView = _imageView;
@synthesize liquidLensView = _liquidLensView;

- (void)dealloc {
    [_imageView release];
    [_liquidLensView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.liquidLensView];
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.liquidLensView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.imageView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [self.liquidLensView.centerXAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerXAnchor],
        [self.liquidLensView.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [self.liquidLensView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor multiplier:0.5],
        [self.liquidLensView.heightAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.heightAnchor multiplier:0.5]
    ]];
}

- (void)viewDidMoveToWindow:(UIWindow *)window shouldAppearOrDisappear:(BOOL)shouldAppearOrDisappear {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, BOOL)>(objc_msgSendSuper2)(&superInfo, _cmd, window, shouldAppearOrDisappear);
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self.liquidLensView, sel_registerName("setLifted:"), YES);
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    
    _imageView = imageView;
    return imageView;
}

- (__kindof UIView *)_liquidLensView {
    if (auto liquidLensView = _liquidLensView) return liquidLensView;
    
    __kindof UIView *liquidLensView = [objc_lookUpClass("_UILiquidLensView") new];
    liquidLensView.userInteractionEnabled = YES;
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(liquidLensView, sel_registerName("setWarpsContentBelow:"), YES);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(liquidLensView, sel_registerName("setLiftedContentView:"), self.imageView);
    
    _liquidLensView = liquidLensView;
    return liquidLensView;
}

@end
