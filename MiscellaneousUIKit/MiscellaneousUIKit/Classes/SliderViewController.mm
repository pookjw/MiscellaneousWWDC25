//
//  SliderViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/12/25.
//

#import "SliderViewController.h"
#import "UISliderStyle+String.h"
#include <ranges>
#include <vector>
#include <objc/message.h>
#include <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface MySliderTrackConfiguration : UISliderTrackConfiguration
@end

@implementation MySliderTrackConfiguration

- (BOOL)adjustPositionForTargetPosition:(float)position adjustedPosition:(float *)adjustedPosition startPosition:(float * _Nullable)startPosition endPosition:(float * _Nullable)endPosition {
//    objc_super superInfo = { self, [self class] };
//    BOOL original = reinterpret_cast<BOOL (*)(objc_super *, SEL, float, float *, float *, float *)>(objc_msgSendSuper2)(&superInfo, _cmd, position, adjustedPosition, startPosition, endPosition);
//    
//    float _adjustedPosition;
//    if (adjustedPosition != NULL) {
//        _adjustedPosition = *adjustedPosition;
//    } else {
//        _adjustedPosition = -999.f;
//    }
//    
//    float _startPosition;
//    if (startPosition != NULL) {
//        _startPosition = *startPosition;
//    } else {
//        _startPosition = -999.f;
//    }
//    
//    float _endPosition;
//    if (endPosition != NULL) {
//        _endPosition = *endPosition;
//    } else {
//        _endPosition = -999.f;
//    }
//    
//    NSLog(@"%d %lf %lf %lf %lf", original, position, _adjustedPosition, _startPosition, _endPosition);
//    
//    return original;
    
    if ((position <= 0.3f)) {
        *adjustedPosition = 0.25f;
        if (startPosition != NULL) {
            *startPosition = 0.2f;
        }
        if (endPosition != NULL) {
            *endPosition = 0.3f;
        }
        return YES;
    } else {
        *adjustedPosition = 1.f;
        if (startPosition != NULL) {
            *startPosition = 1.f;
        }
        if (endPosition != NULL) {
            *endPosition = 1.f;
        }
        return YES;
    }
}

@end


@interface SliderViewController ()
@property (retain, nonatomic, readonly, getter=_slider) UISlider *slider;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation SliderViewController
@synthesize slider = _slider;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_slider release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
    
    [self.view addSubview:self.slider];
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.slider.centerYAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.centerYAnchor],
        [self.slider.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.slider.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor]
    ]];
}

- (UISlider *)_slider {
    if (auto slider = _slider) return slider;
    
    UISlider *slider = [UISlider new];
    slider.minimumValue = -2.f;
    slider.maximumValue = 2.f;
    slider.value = 0.f;
    
    [slider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    _slider = slider;
    return slider;
}

- (void)_sliderValueDidChange:(UISlider *)sender {
    self.navigationItem.title = @(sender.value).stringValue;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            NSUInteger count;
            const UISliderStyle *allStyles = allUISliderStyles(&count);
            
            auto actionsVec = std::views::iota(allStyles, allStyles + count)
            | std::views::transform([weakSelf](const UISliderStyle *ptr) -> UIAction * {
                UISliderStyle style = *ptr;
                UIAction *action = [UIAction actionWithTitle:NSStringFromUISliderStyle(style) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    weakSelf.slider.sliderStyle = style;
                }];
                
                action.state = (weakSelf.slider.sliderStyle == style) ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Slider Style" children:actions];
            [actions release];
            [results addObject:menu];
        }
        
        UISliderTrackConfiguration * _Nullable trackConfiguration = weakSelf.slider.trackConfiguration;
        
        if (trackConfiguration == nil) {
            {
                UIAction *action = [UIAction actionWithTitle:@"Use Track Configuration (+configurationWithTicks:)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    NSMutableArray<UISliderTick *> *ticks = [[NSMutableArray alloc] init];
                    for (CGFloat value = -2.f; value <= 2.f + 0.001f; value += 0.2f) {
                        NSString *title = [NSString stringWithFormat:@"%.1f", value];
                        UISliderTick *tick = [UISliderTick tickWithPosition:value title:title image:[UIImage systemImageNamed:@"apple.intelligence"]];
                        [ticks addObject:tick];
                    }
                    
                    weakSelf.slider.trackConfiguration = [UISliderTrackConfiguration configurationWithTicks:ticks];
                    [ticks release];
                    
                    __kindof UIView *_visualElement;
                    assert(object_getInstanceVariable(weakSelf.slider, "_visualElement", (void **)&_visualElement) != NULL);
                    _visualElement.frame = _visualElement.frame;
                }];
                
                [results addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Use Track Configuration (+configurationWithNumberOfTicks:)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    weakSelf.slider.trackConfiguration = [UISliderTrackConfiguration configurationWithNumberOfTicks:30];
                    
                    __kindof UIView *_visualElement;
                    assert(object_getInstanceVariable(weakSelf.slider, "_visualElement", (void **)&_visualElement) != NULL);
                    _visualElement.frame = _visualElement.frame;
                }];
                
                [results addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Use Track Configuration (-initWithTicks:number:evenlySpaced:)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    NSMutableArray<UISliderTick *> *ticks = [[NSMutableArray alloc] init];
                    for (CGFloat value = -2.f; value <= 2.f + 0.001f; value += 0.2f) {
                        NSString *title = [NSString stringWithFormat:@"%.1f", value];
                        UISliderTick *tick = [UISliderTick tickWithPosition:value title:title image:[UIImage systemImageNamed:@"apple.intelligence"]];
                        [ticks addObject:tick];
                    }
                    
                    UISliderTrackConfiguration *trackConfiguration = reinterpret_cast<id (*)(id, SEL, id, NSInteger, BOOL)>(objc_msgSend)([UISliderTrackConfiguration alloc], sel_registerName("initWithTicks:number:evenlySpaced:"), ticks, 21, YES);
                    [ticks release];
                    
                    weakSelf.slider.trackConfiguration = trackConfiguration;
                    [trackConfiguration release];
                    
                    __kindof UIView *_visualElement;
                    assert(object_getInstanceVariable(weakSelf.slider, "_visualElement", (void **)&_visualElement) != NULL);
                    _visualElement.frame = _visualElement.frame;
                }];
                
                [results addObject:action];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Use Track Configuration (MySliderTrackConfiguration)" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    NSMutableArray<UISliderTick *> *ticks = [[NSMutableArray alloc] init];
                    for (CGFloat value = -2.f; value <= 2.f + 0.001f; value += 0.2f) {
                        NSString *title = [NSString stringWithFormat:@"%.1f", value];
                        UISliderTick *tick = [UISliderTick tickWithPosition:value title:title image:[UIImage systemImageNamed:@"apple.intelligence"]];
                        [ticks addObject:tick];
                    }
                    
                    MySliderTrackConfiguration *trackConfiguration = reinterpret_cast<id (*)(id, SEL, id, NSInteger, BOOL)>(objc_msgSend)([MySliderTrackConfiguration alloc], sel_registerName("initWithTicks:number:evenlySpaced:"), ticks, 21, YES);
                    [ticks release];
                    weakSelf.slider.trackConfiguration = trackConfiguration;
                    [trackConfiguration release];
                    
                    __kindof UIView *_visualElement;
                    assert(object_getInstanceVariable(weakSelf.slider, "_visualElement", (void **)&_visualElement) != NULL);
                    _visualElement.frame = _visualElement.frame;
                }];
                
                [results addObject:action];
            }
        } else {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Allows Tick Values Only" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    UISliderTrackConfiguration *copy = [trackConfiguration copy];
                    copy.allowsTickValuesOnly = !copy.allowsTickValuesOnly;
                    weakSelf.slider.trackConfiguration = copy;
                    [copy release];
                }];
                
                action.state = (trackConfiguration.allowsTickValuesOnly) ? UIMenuElementStateOn : UIMenuElementStateOff;
                [children addObject:action];
            }
            
            {
                NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] init];
                for (CGFloat value = -2.f; value <= 2.f + 0.001f; value += 0.2f) {
                    NSString *title = [NSString stringWithFormat:@"%.1f", value];
                    UIAction *action = [UIAction actionWithTitle:title image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        UISliderTrackConfiguration *copy = [trackConfiguration copy];
                        copy.neutralValue = value;
                        weakSelf.slider.trackConfiguration = copy;
                        [copy release];
                    }];
                    
                    action.state = (trackConfiguration.neutralValue == value) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [actions addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Neutral Value" children:actions];
                [actions release];
                [children addObject:menu];
            }
            
            {
                NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] init];
                for (CGFloat value = -2.f; value <= 2.f + 0.001f; value += 0.2f) {
                    NSString *title = [NSString stringWithFormat:@"%.1f", value];
                    UIAction *action = [UIAction actionWithTitle:title image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        UISliderTrackConfiguration *copy = [trackConfiguration copy];
                        copy.minimumEnabledValue = value;
                        weakSelf.slider.trackConfiguration = copy;
                        [copy release];
                    }];
                    
                    action.state = (trackConfiguration.minimumEnabledValue == value) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [actions addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Minimum Enabled Value" children:actions];
                [actions release];
                menu.subtitle = @(trackConfiguration.minimumEnabledValue).stringValue;
                [children addObject:menu];
            }
            
            {
                NSMutableArray<UIAction *> *actions = [[NSMutableArray alloc] init];
                for (CGFloat value = -2.f; value <= 2.f + 0.001f; value += 0.2f) {
                    NSString *title = [NSString stringWithFormat:@"%.1f", value];
                    UIAction *action = [UIAction actionWithTitle:title image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                        UISliderTrackConfiguration *copy = [trackConfiguration copy];
                        copy.maximumEnabledValue = value;
                        weakSelf.slider.trackConfiguration = copy;
                        [copy release];
                    }];
                    
                    action.state = (trackConfiguration.maximumEnabledValue == value) ? UIMenuElementStateOn : UIMenuElementStateOff;
                    [actions addObject:action];
                }
                
                UIMenu *menu = [UIMenu menuWithTitle:@"Maximum Enabled Value" children:actions];
                [actions release];
                menu.subtitle = @(trackConfiguration.maximumEnabledValue).stringValue;
                [children addObject:menu];
            }
            
            {
                UIAction *action = [UIAction actionWithTitle:@"Remove Track Configuration" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    weakSelf.slider.trackConfiguration = nil;
                    weakSelf.slider.minimumValue = -2.f;
                    weakSelf.slider.maximumValue = 2.f;
                    weakSelf.slider.value = 0.f;
                    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(weakSelf.slider, sel_registerName("_setMinimumEnabledValue:"), -2.f);
                    reinterpret_cast<void (*)(id, SEL, float)>(objc_msgSend)(weakSelf.slider, sel_registerName("_setMaximumEnabledValue:"), 2.f);
                    
                    __kindof UIView *_visualElement;
                    assert(object_getInstanceVariable(weakSelf.slider, "_visualElement", (void **)&_visualElement) != NULL);
                    _visualElement.frame = _visualElement.frame;
                }];
                action.attributes = UIMenuElementAttributesDestructive;
                [children addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Track Configuration" children:children];
            [children release];
            [results addObject:menu];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end

