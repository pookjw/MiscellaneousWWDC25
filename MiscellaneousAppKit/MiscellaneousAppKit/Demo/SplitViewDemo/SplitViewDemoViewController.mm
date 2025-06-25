//
//  SplitViewDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#warning TODO

#import "SplitViewDemoViewController.h"
#import "ConfigurationView.h"
#import "SplitViewDemoItemConfigurationView.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface SplitViewDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;

@property (retain, nonatomic, readonly, getter=_itemConfigurationsSplitView) NSSplitView *itemConfigurationsSplitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_sidebarConfigurationView) SplitViewDemoItemConfigurationView *sidebarConfigurationView;
@property (retain, nonatomic, readonly, getter=_contentListConfigurationView) SplitViewDemoItemConfigurationView *contentListConfigurationView;
@property (retain, nonatomic, readonly, getter=_inspectorConfigurationView) SplitViewDemoItemConfigurationView *inspectorConfigurationView;

@property (retain, nonatomic, readonly, getter=_managedSplitViewController) NSSplitViewController *managedSplitViewController;
@property (retain, nonatomic, readonly, getter=_sidebarSplitViewItem) NSSplitViewItem *sidebarSplitViewItem;
@property (retain, nonatomic, readonly, getter=_contentListSplitViewItem) NSSplitViewItem *contentListSplitViewItem;
@property (retain, nonatomic, readonly, getter=_inspectorSplitViewItem) NSSplitViewItem *inspectorSplitViewItem;
@end

@implementation SplitViewDemoViewController
@synthesize splitView = _splitView;
@synthesize itemConfigurationsSplitView = _itemConfigurationsSplitView;
@synthesize configurationView = _configurationView;
@synthesize sidebarConfigurationView = _sidebarConfigurationView;
@synthesize contentListConfigurationView = _contentListConfigurationView;
@synthesize inspectorConfigurationView = _inspectorConfigurationView;
@synthesize managedSplitViewController = _managedSplitViewController;
@synthesize sidebarSplitViewItem = _sidebarSplitViewItem;
@synthesize contentListSplitViewItem = _contentListSplitViewItem;
@synthesize inspectorSplitViewItem = _inspectorSplitViewItem;

- (void)dealloc {
    [_splitView release];
    [_itemConfigurationsSplitView release];
    [_configurationView release];
    [_sidebarConfigurationView release];
    [_contentListConfigurationView release];
    [_inspectorConfigurationView release];
    [_managedSplitViewController release];
    [_sidebarSplitViewItem release];
    [_contentListSplitViewItem release];
    [_inspectorSplitViewItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.splitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = NSMakeSize(1280, 720);
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [self.splitView setPosition:NSHeight(self.splitView.bounds) / 3.0 ofDividerAtIndex:0];
    [self.splitView setPosition:(NSHeight(self.splitView.bounds) / 3.0) * 2.0 ofDividerAtIndex:1];
    
    [self.itemConfigurationsSplitView setPosition:NSWidth(self.itemConfigurationsSplitView.bounds) / 3.0 ofDividerAtIndex:0];
    [self.itemConfigurationsSplitView setPosition:(NSWidth(self.itemConfigurationsSplitView.bounds) / 3.0) * 2.0 ofDividerAtIndex:1];
    
    [self.sidebarConfigurationView reload];
    [self.contentListConfigurationView reload];
    [self.inspectorConfigurationView reload];
}

- (NSSplitView *)_splitView {
    if (auto splitView = _splitView) return splitView;
    
    NSSplitView *splitView = [NSSplitView new];
    [splitView addArrangedSubview:self.configurationView];
    [splitView addArrangedSubview:self.itemConfigurationsSplitView];
    [self addChildViewController:self.managedSplitViewController];
    [splitView addSubview:self.managedSplitViewController.view];
    splitView.vertical = NO;
    
    _splitView = splitView;
    return splitView;
}

- (NSSplitView *)_itemConfigurationsSplitView {
    if (auto itemConfigurationsSplitView = _itemConfigurationsSplitView) return itemConfigurationsSplitView;
    
    NSSplitView *itemConfigurationsSplitView = [NSSplitView new];
    [itemConfigurationsSplitView addArrangedSubview:self.sidebarConfigurationView];
    [itemConfigurationsSplitView addArrangedSubview:self.contentListConfigurationView];
    [itemConfigurationsSplitView addArrangedSubview:self.inspectorConfigurationView];
    itemConfigurationsSplitView.vertical = YES;
    
    _itemConfigurationsSplitView = itemConfigurationsSplitView;
    return itemConfigurationsSplitView;
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    configurationView.searchEnabled = NO;
    
    _configurationView = configurationView;
    return configurationView;
}

- (SplitViewDemoItemConfigurationView *)_sidebarConfigurationView {
    if (auto sidebarConfigurationView = _sidebarConfigurationView) return sidebarConfigurationView;
    
    SplitViewDemoItemConfigurationView *sidebarConfigurationView = [[SplitViewDemoItemConfigurationView alloc] initWithSplitViewItem:self.sidebarSplitViewItem];
    
    _sidebarConfigurationView = sidebarConfigurationView;
    return sidebarConfigurationView;
}

- (SplitViewDemoItemConfigurationView *)_contentListConfigurationView {
    if (auto contentListConfigurationView = _contentListConfigurationView) return contentListConfigurationView;
    
    SplitViewDemoItemConfigurationView *contentListConfigurationView = [[SplitViewDemoItemConfigurationView alloc] initWithSplitViewItem:self.contentListSplitViewItem];
    _contentListConfigurationView = contentListConfigurationView;
    
    return contentListConfigurationView;
}

- (SplitViewDemoItemConfigurationView *)_inspectorConfigurationView {
    if (auto inspectorConfigurationView = _inspectorConfigurationView) return inspectorConfigurationView;
    
    SplitViewDemoItemConfigurationView *inspectorConfigurationView = [[SplitViewDemoItemConfigurationView alloc] initWithSplitViewItem:self.inspectorSplitViewItem];
    _inspectorConfigurationView = inspectorConfigurationView;
    
    return inspectorConfigurationView;
}

- (NSSplitViewController *)_managedSplitViewController {
    if (auto managedSplitViewController = _managedSplitViewController) return managedSplitViewController;
    
    NSSplitViewController *managedSplitViewController = [NSSplitViewController new];
    [managedSplitViewController addSplitViewItem:self.sidebarSplitViewItem];
    [managedSplitViewController addSplitViewItem:self.contentListSplitViewItem];
    [managedSplitViewController addSplitViewItem:self.inspectorSplitViewItem];
    
    _managedSplitViewController = managedSplitViewController;
    return managedSplitViewController;
}

- (NSSplitViewItem *)_sidebarSplitViewItem {
    if (auto sidebarSplitViewItem = _sidebarSplitViewItem) return sidebarSplitViewItem;
    
    NSViewController *viewController = [NSViewController new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController.view, sel_registerName("setBackgroundColor:"), NSColor.systemOrangeColor);
    NSSplitViewItem *sidebarSplitViewItem = [NSSplitViewItem sidebarWithViewController:viewController];
    [viewController release];
    
    _sidebarSplitViewItem = [sidebarSplitViewItem retain];
    return sidebarSplitViewItem;
}

- (NSSplitViewItem *)_contentListSplitViewItem {
    if (auto contentListSplitViewItem = _contentListSplitViewItem) return contentListSplitViewItem;
    
    NSViewController *viewController = [NSViewController new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController.view, sel_registerName("setBackgroundColor:"), NSColor.systemBlueColor);
    NSSplitViewItem *contentListSplitViewItem = [NSSplitViewItem contentListWithViewController:viewController];
    [viewController release];
    
    _contentListSplitViewItem = [contentListSplitViewItem retain];
    return contentListSplitViewItem;
}

- (NSSplitViewItem *)_inspectorSplitViewItem {
    if (auto inspectorSplitViewItem = _inspectorSplitViewItem) return inspectorSplitViewItem;
    
    NSViewController *viewController = [NSViewController new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(viewController.view, sel_registerName("setBackgroundColor:"), NSColor.systemGreenColor);
    NSSplitViewItem *inspectorSplitViewItem = [NSSplitViewItem inspectorWithViewController:viewController];
    [viewController release];
    
    _inspectorSplitViewItem = [inspectorSplitViewItem retain];
    return inspectorSplitViewItem;
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    
}

@end


