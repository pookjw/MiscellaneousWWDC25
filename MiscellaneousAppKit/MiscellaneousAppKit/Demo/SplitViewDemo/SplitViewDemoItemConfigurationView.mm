//
//  SplitViewDemoItemConfigurationView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#warning TODO

#import "SplitViewDemoItemConfigurationView.h"
#import "ConfigurationView.h"
#import "NSStringFromNSSplitViewItemBehavior.h"
#import "SplitViewItemAccessoryViewController.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface SplitViewDemoItemConfigurationView () <ConfigurationViewDelegate> {
    BOOL _initialLoad;
}
@property (retain, nonatomic, readonly, getter=_splitViewItem) NSSplitViewItem *splitViewItem;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@end

@implementation SplitViewDemoItemConfigurationView
@synthesize configurationView = _configurationView;

- (instancetype)initWithSplitViewItem:(NSSplitViewItem *)splitViewItem {
    if (self = [super initWithFrame:NSZeroRect]) {
        _splitViewItem = [splitViewItem retain];
        self.configurationView.frame = self.bounds;
        self.configurationView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:self.configurationView];
    }
    
    return self;
}

- (void)dealloc {
    [_splitViewItem release];
    [_configurationView release];
    [super dealloc];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    configurationView.searchEnabled = NO;
    
    _configurationView = configurationView;
    return configurationView;
}

- (void)reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    NSSplitViewItem *splitViewItem = self.splitViewItem;
    NSMutableArray<ConfigurationItemModel *> *itmeModels = [NSMutableArray new];
    
    ConfigurationItemModel<NSString *> *behaviorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeLabel
                                                                                           identifier:@"Behavior"
                                                                                             userInfo:nil
                                                                                        labelResolver:^NSString * _Nonnull(ConfigurationItemModel * _Nonnull itemModel, id<NSCopying>  _Nonnull value) {
        return [NSString stringWithFormat:@"Behavior : %@", NSStringFromNSSplitViewItemBehavior(splitViewItem.behavior)];
    }
                                                                                        valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [NSNull null];
    }];
    [itmeModels addObject:behaviorItemModel];
    
    ConfigurationItemModel<NSNumber *> *automaticallyAdjustsSafeAreaInsetsItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                                                          identifier:@"automaticallyAdjustsSafeAreaInsets"
                                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(splitViewItem.automaticallyAdjustsSafeAreaInsets);
    }];
    [itmeModels addObject:automaticallyAdjustsSafeAreaInsetsItemModel];
    
    ConfigurationItemModel<ConfigurationStepperDescription *> *topAlignedAccessoriesItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeStepper
                                                                                                                               identifier:@"Top Aligned Accessories"
                                                                                                                            valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationStepperDescription descriptionWithStepperValue:splitViewItem.topAlignedAccessoryViewControllers.count
                                                               minimumValue:0.
                                                               maximumValue:10.
                                                                  stepValue:1.
                                                                 continuous:NO
                                                                 autorepeat:NO
                                                                 valueWraps:NO];
    }];
    [itmeModels addObject:topAlignedAccessoriesItemModel];
    
    ConfigurationItemModel<ConfigurationStepperDescription *> *bottomAlignedAccessoriesItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeStepper
                                                                                                                                  identifier:@"Bottom Aligned Accessories"
                                                                                                                               valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationStepperDescription descriptionWithStepperValue:splitViewItem.bottomAlignedAccessoryViewControllers.count
                                                               minimumValue:0.
                                                               maximumValue:10.
                                                                  stepValue:1.
                                                                 continuous:NO
                                                                 autorepeat:NO
                                                                 valueWraps:NO];
    }];
    [itmeModels addObject:bottomAlignedAccessoriesItemModel];
    
    if ((splitViewItem.topAlignedAccessoryViewControllers.count > 0) || (splitViewItem.bottomAlignedAccessoryViewControllers.count > 0)) {
        ConfigurationItemModel<NSNumber *> *accessoryAutomaticallyAppliesContentInsetsItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                                                                 identifier:@"Accessory - automaticallyAppliesContentInsets"
                                                                                                                              valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
            NSSplitViewItemAccessoryViewController *first = splitViewItem.topAlignedAccessoryViewControllers.firstObject;
            if (first == nil) {
                return @(NO);
            }
            
            return @(first.automaticallyAppliesContentInsets);
        }];
        [itmeModels addObject:accessoryAutomaticallyAppliesContentInsetsItemModel];
    }
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itmeModels intoSectionWithIdentifier:[NSNull null]];
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"automaticallyAdjustsSafeAreaInsets"]) {
        self.splitViewItem.automaticallyAdjustsSafeAreaInsets = static_cast<NSNumber *>(newValue).boolValue;
    } else if ([itemModel.identifier isEqualToString:@"Top Aligned Accessories"]) {
        NSUInteger unsignedIntegerValue = static_cast<NSNumber *>(newValue).unsignedIntegerValue;
        NSUInteger currentCount = self.splitViewItem.topAlignedAccessoryViewControllers.count;
        
        if (unsignedIntegerValue < currentCount) {
            NSRange range = NSMakeRange(0, unsignedIntegerValue);
            self.splitViewItem.topAlignedAccessoryViewControllers = [self.splitViewItem.topAlignedAccessoryViewControllers subarrayWithRange:range];
        } else if (currentCount < unsignedIntegerValue) {
            NSMutableArray<NSSplitViewItemAccessoryViewController *> *viewControllers = [self.splitViewItem.topAlignedAccessoryViewControllers mutableCopy];
            
            for (NSUInteger i = 0; i < (unsignedIntegerValue - currentCount); i++) {
                SplitViewItemAccessoryViewController *viewController = [SplitViewItemAccessoryViewController new];
                [viewControllers addObject:viewController];
                [viewController release];
                
                // https://x.com/_silgen_name/status/1937823157773336973
                //                SplitViewItemAccessoryViewController *viewController = [SplitViewItemAccessoryViewController new];
                //                [self.splitViewItem addTopAlignedAccessoryViewController:viewController];
                //                [viewController release];
            }
            
            self.splitViewItem.topAlignedAccessoryViewControllers = viewControllers;
            [viewControllers release];
        }
        [self reload];
        return NO;
    } else if ([itemModel.identifier isEqualToString:@"Bottom Aligned Accessories"]) {
        NSUInteger unsignedIntegerValue = static_cast<NSNumber *>(newValue).unsignedIntegerValue;
        NSUInteger currentCount = self.splitViewItem.bottomAlignedAccessoryViewControllers.count;
        
        if (unsignedIntegerValue < currentCount) {
            NSRange range = NSMakeRange(0, unsignedIntegerValue);
            self.splitViewItem.bottomAlignedAccessoryViewControllers = [self.splitViewItem.bottomAlignedAccessoryViewControllers subarrayWithRange:range];
        } else if (currentCount < unsignedIntegerValue) {
            NSMutableArray<NSSplitViewItemAccessoryViewController *> *viewControllers = [self.splitViewItem.bottomAlignedAccessoryViewControllers mutableCopy];
            
            for (NSUInteger i = 0; i < (unsignedIntegerValue - currentCount); i++) {
                SplitViewItemAccessoryViewController *viewController = [SplitViewItemAccessoryViewController new];
                [viewControllers addObject:viewController];
                [viewController release];
            }
            
            self.splitViewItem.bottomAlignedAccessoryViewControllers = viewControllers;
            [viewControllers release];
        }
        [self reload];
        return NO;
    } else if ([itemModel.identifier isEqualToString:@"Accessory - automaticallyAppliesContentInsets"]) {
        NSArray<NSSplitViewItemAccessoryViewController *> *viewControllers = [self.splitViewItem.topAlignedAccessoryViewControllers arrayByAddingObjectsFromArray:self.splitViewItem.bottomAlignedAccessoryViewControllers];
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        for (NSSplitViewItemAccessoryViewController *viewController in viewControllers) {
            viewController.automaticallyAppliesContentInsets = boolValue;
        }
    } else {
        abort();
    }
    
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self reload];
}

@end
