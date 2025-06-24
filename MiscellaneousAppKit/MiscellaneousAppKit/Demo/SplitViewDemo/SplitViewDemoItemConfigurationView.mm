//
//  SplitViewDemoItemConfigurationView.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import "SplitViewDemoItemConfigurationView.h"
#import "ConfigurationView.h"
#import "NSStringFromNSSplitViewItemBehavior.h"

@interface SplitViewDemoItemConfigurationView () <ConfigurationViewDelegate>
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
//        [self _reload];
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

- (void)_reload {
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
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itmeModels intoSectionWithIdentifier:[NSNull null]];
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
