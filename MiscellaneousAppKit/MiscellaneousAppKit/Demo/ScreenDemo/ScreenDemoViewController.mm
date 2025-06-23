//
//  ScreenDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/25.
//

#warning TODO

#import "ScreenDemoViewController.h"
#import "ConfigurationView.h"

@interface ScreenDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, nullable, getter=_selectedScreen, setter=_setSelectedScreen:) NSScreen *selectedScreen;
@end

@implementation ScreenDemoViewController
@synthesize configurationView = _configurationView;

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_configurationView release];
    [_selectedScreen release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.configurationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
    
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(_screenParametersDidChange:)
                                               name:NSApplicationDidChangeScreenParametersNotification
                                             object:NSApp];
}

- (void)_screenParametersDidChange:(NSNotification *)notification {
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
    NSMutableArray<ConfigurationItemModel *> *itemModels = [NSMutableArray new];
    
    //
    
    __block auto unretained = self;
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *screensItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                          label:@"Screens"
                                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSArray<NSScreen *> *screens = NSScreen.screens;
        NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] initWithCapacity:screens.count];
        for (NSScreen *screen in screens) {
            [titles addObject:@(screen.CGDirectDisplayID).stringValue];
        }
        
        NSArray<NSString *> *selectedTitles;
        NSString * _Nullable selectedDisplayTitle;
        if (NSScreen *selectedScreen = unretained.selectedScreen) {
            selectedTitles = @[@(selectedScreen.CGDirectDisplayID).stringValue];
            selectedDisplayTitle = @(selectedScreen.CGDirectDisplayID).stringValue;
        } else {
            selectedTitles = @[];
            selectedDisplayTitle = nil;
        }
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:selectedTitles
                                                                                                 selectedDisplayTitle:selectedDisplayTitle];
        
        return description;
    }];
    [itemModels addObject:screensItemModel];
    
    //
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:[NSNull null]];
    [snapshot reloadItemsWithIdentifiers:itemModels];
    [itemModels release];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"Screens"]) {
        for (NSScreen *screen in NSScreen.screens) {
            if (screen.CGDirectDisplayID == static_cast<NSNumber *>(newValue).integerValue) {
                self.selectedScreen = screen;
                break;
            }
        }
    } else {
        abort();
    }
    
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
