//
//  SliderDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import "SliderDemoViewController.h"
#import "ConfigurationView.h"
#import "NSStringFromNSTickMarkPosition.h"
#include <objc/message.h>
#include <objc/runtime.h>
#include <vector>
#include <ranges>

@interface SliderDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_slider) NSSlider *slider;
@property (retain, nonatomic, readonly, getter=_sliderContainerView) NSView *sliderContainerView;
@property (copy, nonatomic, nullable, getter=_sliderContainerConstraints, setter=_setsliderContainerConstraints:) NSArray<NSLayoutConstraint *> *sliderContainerConstraints;
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
    [_sliderContainerView release];
    [_sliderContainerConstraints release];
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
    slider.minValue = 0.;
    slider.maxValue = 1.;
    slider.doubleValue = 0.5;
    slider.target = self;
    slider.action = @selector(_sliderDidTrigger:);
    
    _slider = slider;
    return slider;
}

- (void)_sliderDidTrigger:(NSSlider *)sender {
//    [self _reload];
}

- (NSView *)_sliderContainerView {
    if (auto sliderContainerView = _sliderContainerView) return sliderContainerView;
    
    NSView *sliderContainerView = [NSView new];
    
    self.slider.translatesAutoresizingMaskIntoConstraints = NO;
    [sliderContainerView addSubview:self.slider];
    
    _sliderContainerView = sliderContainerView;
    return sliderContainerView;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (auto sliderContainerConstraints = self.sliderContainerConstraints) {
        [NSLayoutConstraint deactivateConstraints:sliderContainerConstraints];
    }
    
    if (self.slider.vertical) {
        self.sliderContainerConstraints = @[
            [self.slider.centerXAnchor constraintEqualToAnchor:self.sliderContainerView.safeAreaLayoutGuide.centerXAnchor],
            [self.slider.topAnchor constraintEqualToAnchor:self.sliderContainerView.safeAreaLayoutGuide.topAnchor],
            [self.slider.bottomAnchor constraintEqualToAnchor:self.sliderContainerView.safeAreaLayoutGuide.bottomAnchor]
        ];
    } else {
        self.sliderContainerConstraints = @[
            [self.slider.centerYAnchor constraintEqualToAnchor:self.sliderContainerView.safeAreaLayoutGuide.centerYAnchor],
            [self.slider.leadingAnchor constraintEqualToAnchor:self.sliderContainerView.safeAreaLayoutGuide.leadingAnchor],
            [self.slider.trailingAnchor constraintEqualToAnchor:self.sliderContainerView.safeAreaLayoutGuide.trailingAnchor]
        ];
    }
    
    [NSLayoutConstraint activateConstraints:self.sliderContainerConstraints];
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    NSMutableArray<ConfigurationItemModel *> *itemModels = [NSMutableArray new];
    
    NSSlider *slider = self.slider;
    
    ConfigurationItemModel<ConfigurationSliderDescription *> *neutralValueItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                                                                                                          label:@"Neutral Value"
                                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationSliderDescription descriptionWithSliderValue:slider.neutralValue
                                                             minimumValue:slider.minValue
                                                             maximumValue:slider.maxValue
                                                               continuous:YES];
    }];
    [itemModels addObject:neutralValueItemModel];
    
    ConfigurationItemModel<ConfigurationSliderDescription *> *altIncrementValueItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                                                                                                          label:@"Alt Increment Value"
                                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationSliderDescription descriptionWithSliderValue:slider.altIncrementValue
                                                             minimumValue:0.
                                                             maximumValue:slider.maxValue - slider.minValue
                                                               continuous:YES];
    }];
    [itemModels addObject:altIncrementValueItemModel];
    
    ConfigurationItemModel<NSNull *> *knobThicknessItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                                                                                   identifier:@"Knob Thickness"
                                                                                                userInfo:nil
                                                                                           labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Knob Thickness : %lf", slider.knobThickness];
    }
                                                                                           valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
    [itemModels addObject:knobThicknessItemModel];
    
    ConfigurationItemModel<NSNumber *> *verticalItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                                label:@"Vertical"
                                                                                        valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(slider.vertical);
    }];
    [itemModels addObject:verticalItemModel];
    
    ConfigurationItemModel<NSColor *> *trackFillColorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeColorWell
                                                                                                     label:@"Track Fill Color"
                                                                                             valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        if (NSColor *trackFillColor = slider.trackFillColor) {
            return trackFillColor;
        } else {
            return NSColor.clearColor;
        }
    }];
    [itemModels addObject:trackFillColorItemModel];
    
    ConfigurationItemModel<ConfigurationStepperDescription *> *numberOfTickMarksItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeStepper
                                                                                                                           identifier:@"Number Of Tick Marks"
                                                                                                                             userInfo:nil
                                                                                                                        labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Number Of Tick Marks : %ld", slider.numberOfTickMarks];
    }
                                                                                                                        valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationStepperDescription descriptionWithStepperValue:slider.numberOfTickMarks
                                                               minimumValue:0.
                                                               maximumValue:10.
                                                                  stepValue:1.
                                                                 continuous:YES
                                                                 autorepeat:NO
                                                                 valueWraps:NO];
    }];
    [itemModels addObject:numberOfTickMarksItemModel];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *tickMarkPositionItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                                   label:@"Tick Mark Position"
                                                                                                                           valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSTickMarkPosition *allPositions = allNSTickMarkPositions(&count);
        
        auto titlesVec = std::views::iota(allPositions, allPositions + count)
        | std::views::transform([](const NSTickMarkPosition *ptr) { return *ptr; })
        | std::views::transform([](const NSTickMarkPosition position) {
            return NSStringFromNSTickMarkPosition(position);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSTickMarkPosition(slider.tickMarkPosition)]
                                                                                                 selectedDisplayTitle:NSStringFromNSTickMarkPosition(slider.tickMarkPosition)];
        [titles release];
        
        return description;
    }];
    [itemModels addObject:tickMarkPositionItemModel];
    
//    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *rectOfTickMarkItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
//                                                                                                                                 label:@"Rect Of Tick Mark"
//                                                                                                                         valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
//        auto titlesVec = std::views::iota(0, slider.numberOfTickMarks)
//        | std::views::transform([slider](NSInteger index) {
//            return NSStringFromRect([slider rectForPage:index]);
//        })
//        | std::ranges::to<std::vector<NSString *>>();
//        
//        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
//        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
//                                                                                                       selectedTitles:@[]
//                                                                                                 selectedDisplayTitle:nil];
//        [titles release];
//        
//        return description;
//    }];
//    [itemModels addObject:rectOfTickMarkItemModel];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:[NSNull null]];
    [itemModels release];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"Neutral Value"]) {
        double doubleValue = static_cast<NSNumber *>(newValue).doubleValue;
        self.slider.neutralValue = doubleValue;
    } else if ([itemModel.identifier isEqualToString:@"Alt Increment Value"]) {
        double doubleValue = static_cast<NSNumber *>(newValue).doubleValue;
        self.slider.altIncrementValue = doubleValue;
    } else if ([itemModel.identifier isEqualToString:@"Vertical"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        self.slider.vertical = boolValue;
        self.view.needsUpdateConstraints = YES;
    } else if ([itemModel.identifier isEqualToString:@"Track Fill Color"]) {
        NSColor *color = static_cast<NSColor *>(newValue);
        self.slider.trackFillColor = color;
    } else if ([itemModel.identifier isEqualToString:@"Number Of Tick Marks"]) {
        double doubleValue = static_cast<NSNumber *>(newValue).doubleValue;
        self.slider.numberOfTickMarks = doubleValue;
        return YES;
    } else if ([itemModel.identifier isEqualToString:@"Tick Mark Position"]) {
        self.slider.tickMarkPosition = NSTickMarkPositionFromString(static_cast<NSString *>(newValue));
        self.slider.needsUpdateConstraints = YES;
    } else if ([itemModel.identifier isEqualToString:@"Rect Of Tick Mark"]) {
        // nop
    } else {
        abort();
    }
    
    return NO;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
