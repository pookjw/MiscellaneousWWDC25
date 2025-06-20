//
//  ResponderDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#warning TODO

#import "ResponderDemoViewController.h"
#import "ConfigurationView.h"
#import "ResponderDemoEventView.h"

@interface ResponderDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@end

@implementation ResponderDemoViewController
@synthesize configurationView = _configurationView;

- (void)dealloc {
    [_configurationView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.configurationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
    ConfigurationItemModel<ConfigurationViewPresentationDescription *> *eventItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeViewPresentation
                                                                                                              identifier:@"Event"
                                                                                                                   label:@"Event"
                                                                                                           valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationViewPresentationDescription descriptorWithStyle:ConfigurationViewPresentationStyleAlert
                                                                 viewBuilder:^__kindof NSView * _Nonnull(void (^ _Nonnull layout)(), __kindof NSView * _Nullable reloadingView) {
            return [[[ResponderDemoEventView alloc] initWithFrame:NSMakeRect(0., 0., 300., 300.)] autorelease];
        }
                                                             didCloseHandler:nil];
    }];
    
    [snapshot appendItemsWithIdentifiers:@[
        eventItemModel
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
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
