//
//  BackgroundExtensionDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import "BackgroundExtensionDemoViewController.h"
#import "ConfigurationView.h"
#import "ImageView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface BackgroundExtensionDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_backgroundExtensionView) NSBackgroundExtensionView *backgroundExtensionView;
@property (retain, nonatomic, readonly, getter=_imageView) ImageView *imageView;
@end

@implementation BackgroundExtensionDemoViewController
@synthesize splitViewController = _splitViewController;
@synthesize configurationView = _configurationView;
@synthesize backgroundExtensionView = _backgroundExtensionView;
@synthesize imageView = _imageView;

- (void)dealloc {
    [_splitViewController release];
    [_configurationView release];
    [_backgroundExtensionView release];
    [_imageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildViewController:self.splitViewController];
    [self.view addSubview:self.splitViewController.view];
    self.splitViewController.view.frame = self.view.bounds;
    self.splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [self _reload];
}

- (void)_reload {
    NSDiffableDataSourceSnapshot *snapshot = [NSDiffableDataSourceSnapshot new];
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
    NSBackgroundExtensionView *backgroundExtensionView = self.backgroundExtensionView;
    
    ConfigurationItemModel<NSNumber *> *disableBlurEffectsItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                                     identifier:@"disableBlurEffects"
                                                                                                          label:@"disableBlurEffects"
                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(backgroundExtensionView, sel_registerName("disableBlurEffects")));
    }];
    
    ConfigurationItemModel<NSNumber *> *disableAutomaticLayoutItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                                     identifier:@"disableAutomaticLayout"
                                                                                                          label:@"disableAutomaticLayout"
                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(backgroundExtensionView, sel_registerName("disableAutomaticLayout")));
    }];
    
    [snapshot appendItemsWithIdentifiers:@[
        disableBlurEffectsItemModel,
        disableAutomaticLayoutItemModel
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    
    NSViewController *configurationViewController = [NSViewController new];
    configurationViewController.view = self.configurationView;
    NSSplitViewItem *configurationItem = [NSSplitViewItem sidebarWithViewController:configurationViewController];
    [configurationViewController release];
    [splitViewController addSplitViewItem:configurationItem];
    
    NSViewController *contentListViewController = [NSViewController new];
    contentListViewController.view = self.backgroundExtensionView;
    NSSplitViewItem *contentListItem = [NSSplitViewItem contentListWithViewController:contentListViewController];
    [contentListViewController release];
    contentListItem.automaticallyAdjustsSafeAreaInsets = YES;
    [splitViewController addSplitViewItem:contentListItem];
    
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (NSBackgroundExtensionView *)_backgroundExtensionView {
    if (auto backgroundExtensionView = _backgroundExtensionView) return backgroundExtensionView;
    
    NSBackgroundExtensionView *backgroundExtensionView = [NSBackgroundExtensionView new];
    backgroundExtensionView.automaticallyPlacesContentView = YES;
    backgroundExtensionView.contentView = self.imageView;
    
    _backgroundExtensionView = backgroundExtensionView;
    return backgroundExtensionView;
}

- (ImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    ImageView *imageView = [ImageView new];
    imageView.image = [NSImage imageNamed:@"image"];
    imageView.contentMode = ImageViewContentModeAspectFill;
    
    _imageView = imageView;
    return imageView;
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"disableBlurEffects"]) {
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self.backgroundExtensionView, sel_registerName("setDisableBlurEffects:"), static_cast<NSNumber *>(newValue).boolValue);
    } else if ([itemModel.identifier isEqualToString:@"disableAutomaticLayout"]) {
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self.backgroundExtensionView, sel_registerName("setDisableAutomaticLayout:"), static_cast<NSNumber *>(newValue).boolValue);
    } else {
        abort();
    }
    
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
