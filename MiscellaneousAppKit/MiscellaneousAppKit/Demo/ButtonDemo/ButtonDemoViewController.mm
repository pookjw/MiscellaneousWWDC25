//
//  ButtonDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import "ButtonDemoViewController.h"
#import "ConfigurationView.h"
#import "NSStringFromNSBezelStyle.h"
#import "NSStringFromNSButtonType.h"
#import "NSStringFromNSControlSize.h"
#include <vector>
#include <ranges>
#include <objc/message.h>
#include <objc/runtime.h>

@interface ButtonDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_button) NSButton *button;
@end

@implementation ButtonDemoViewController
@synthesize splitViewController = _splitViewController;
@synthesize configurationView = _configurationView;
@synthesize button = _button;

- (void)dealloc {
    [_splitViewController release];
    [_configurationView release];
    [_button release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addChildViewController:self.splitViewController];
    self.splitViewController.view.frame = self.view.bounds;
    self.splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:self.splitViewController.view];
    
    [self _reload];
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    
    {
        NSViewController *sidebarViewController = [NSViewController new];
        sidebarViewController.view = self.configurationView;
        NSSplitViewItem *sidebarItem = [NSSplitViewItem sidebarWithViewController:sidebarViewController];
        [sidebarViewController release];
        [splitViewController addSplitViewItem:sidebarItem];
    }
    
    {
        NSViewController *contentListViewController = [NSViewController new];
        [contentListViewController.view addSubview:self.button];
        self.button.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [self.button.centerXAnchor constraintEqualToAnchor:contentListViewController.view.safeAreaLayoutGuide.centerXAnchor],
            [self.button.centerYAnchor constraintEqualToAnchor:contentListViewController.view.safeAreaLayoutGuide.centerYAnchor]
        ]];
        NSSplitViewItem *contentListItem = [NSSplitViewItem contentListWithViewController:contentListViewController];
        [contentListViewController release];
        [splitViewController addSplitViewItem:contentListItem];
    }
    
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

- (NSButton *)_button {
    if (auto button = _button) return button;
    
    NSButton *button = [NSButton new];
    
    _button = button;
    return button;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    
    NSButton *button = self.button;
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *bezelStyleItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                        identifier:@"bezelStyle"
                                                                                                                             label:@"bezelStyle"
                                                                                                                     valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSBezelStyle *allStyles = allNSBezelStyles(&count);
        
        auto titlesVec = std::views::iota(allStyles, allStyles + count)
        | std::views::transform([](const NSBezelStyle *ptr) { return *ptr; })
        | std::views::transform([](const NSBezelStyle style) {
            return NSStringFromNSBezelStyle(style);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSBezelStyle(button.bezelStyle)]
                                                                                                 selectedDisplayTitle:NSStringFromNSBezelStyle(button.bezelStyle)];
        [titles release];
        
        return description;
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *buttonTypeItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                        identifier:@"buttonType"
                                                                                                                             label:@"buttonType"
                                                                                                                     valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSButtonType *allTypes = allNSButtonTypes(&count);
        
        auto titlesVec = std::views::iota(allTypes, allTypes + count)
        | std::views::transform([](const NSButtonType *ptr) { return *ptr; })
        | std::views::transform([](const NSButtonType style) {
            return NSStringFromNSButtonType(style);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        NSButtonType _buttonType = reinterpret_cast<NSButtonType (*)(id, SEL)>(objc_msgSend)(button.cell, sel_registerName("_buttonType"));
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSButtonType(_buttonType)]
                                                                                                 selectedDisplayTitle:NSStringFromNSButtonType(_buttonType)];
        [titles release];
        
        return description;
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *controlSizeIteModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                        identifier:@"controlSize"
                                                                                                                             label:@"controlSize"
                                                                                                                     valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSControlSize *allSizes = allNSControlSizes(&count);
        
        auto titlesVec = std::views::iota(allSizes, allSizes + count)
        | std::views::transform([](const NSControlSize *ptr) { return *ptr; })
        | std::views::transform([](const NSControlSize size) {
            return NSStringFromNSControlSize(size);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSControlSize(button.cell.controlSize)]
                                                                                                 selectedDisplayTitle:NSStringFromNSControlSize(button.cell.controlSize)];
        [titles release];
        
        return description;
    }];
    
    [snapshot appendItemsWithIdentifiers:@[
        bezelStyleItemModel,
        buttonTypeItemModel,
        controlSizeIteModel
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"bezelStyle"]) {
        self.button.bezelStyle = NSBezelStyleFromString(static_cast<NSString *>(newValue));
    } else if ([itemModel.identifier isEqualToString:@"buttonType"]) {
        [static_cast<NSButtonCell *>(self.button.cell) setButtonType:NSButtonTypeFromString(static_cast<NSString *>(newValue))];
    } else if ([itemModel.identifier isEqualToString:@"controlSize"]) {
        self.button.cell.controlSize = NSControlSizeFromString(static_cast<NSString *>(newValue));
    } else {
        abort();
    }
    
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
