//
//  ToolbarItemDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/25/25.
//

#import "ToolbarItemDemoViewController.h"
#import "NSStringFromNSToolbarItemStyle.h"
#import "ConfigurationView.h"
#include <objc/message.h>
#include <objc/runtime.h>
#include <ranges>
#include <vector>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface ToolbarItemDemoViewController () <ConfigurationViewDelegate, NSToolbarDelegate>
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_toolbar) NSToolbar *toolbar;
@property (retain, nonatomic, readonly, getter=_toolbarItem) NSToolbarItem *toolbarItem;
@end

@implementation ToolbarItemDemoViewController
@synthesize configurationView = _configurationView;
@synthesize toolbar = _toolbar;
@synthesize toolbarItem = _toolbarItem;

+ (NSItemBadge *)_badgeWithCount {
    return [NSItemBadge badgeWithCount:999];
}

+ (NSItemBadge *)_badgeWithText {
    return [NSItemBadge badgeWithText:@"Text"];
}

+ (NSItemBadge *)_indicatorBadge {
    return [NSItemBadge indicatorBadge];
}

- (void)dealloc {
    [_configurationView release];
    [_toolbar release];
    [_toolbarItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.configurationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    NSMutableArray<ConfigurationItemModel *> *itemModels = [NSMutableArray new];
    NSToolbarItem *toolbarItem = self.toolbarItem;
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *styleItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                   identifier:@"Style"
                                                                                                                valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSToolbarItemStyle *allStyles = allNSToolbarItemStyles(&count);
        
        auto titlesVec = std::views::iota(allStyles, allStyles + count)
        | std::views::transform([](const NSToolbarItemStyle *ptr) { return *ptr; })
        | std::views::transform([](const NSToolbarItemStyle style) {
            return NSStringFromNSToolbarItemStyle(style);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSToolbarItemStyle(toolbarItem.style)]
                                                                                                 selectedDisplayTitle:NSStringFromNSToolbarItemStyle(toolbarItem.style)];
        [titles release];
        
        return description;
    }];
    [itemModels addObject:styleItemModel];
    
    ConfigurationItemModel<NSColor *> *backgroundTintColorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeColorWell
                                                                                                     identifier:@"backgroundTintColor"
                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        if (NSColor *backgroundTintColor = toolbarItem.backgroundTintColor) {
            return backgroundTintColor;
        } else {
            return NSColor.clearColor;
        }
    }];
    [itemModels addObject:backgroundTintColorItemModel];
    
    ConfigurationItemModel<ConfigurationButtonDescription *> *clearBackgroundTintColorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeButton
                                                                                                                                 identifier:@"Clear backgroundTintColor"
                                                                                                                              valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationButtonDescription descriptionWithTitle:@"Button"];
    }];
    [itemModels addObject:clearBackgroundTintColorItemModel];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *badgeItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                   identifier:@"Badge"
                                                                                                                valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
//        NSItemBadge * _Nullable badge = toolbarItem.badge;
//        NSArray<NSString *> *selectedTitles;
//        NSString * _Nullable selectedDisplayTitle;
//        if (badge == nil) {
//            selectedTitles = @[];
//            selectedDisplayTitle = nil;
//        } else {
//            NSString *text = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(badge, sel_registerName("text"));
//            Ivar _countIvar = object_getInstanceVariable(badge, "_count", NULL);
//            NSUInteger _count = *reinterpret_cast<NSUInteger *>(reinterpret_cast<uintptr_t>(badge) + ivar_getOffset(_countIvar));
//            
//            if (text.length > 0) {
//                selectedTitles = @[@"Text"];
//            } else if (_count > 0) {
//                selectedTitles = @[@"Count"];
//            } else {
//                selectedTitles = @[@"Indicator"];
//            }
//            selectedDisplayTitle = selectedTitles.firstObject;
//        }
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[
            @"Count", @"Text", @"Indicator"
        ]
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
    [itemModels addObject:badgeItemModel];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:[NSNull null]];
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)newWindow fromWindow:(NSWindow * _Nullable)oldWindow {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, newWindow, oldWindow);
    
    if ([oldWindow.toolbar isEqual:self.toolbar]) {
        oldWindow.toolbar = nil;
    }
    
    newWindow.toolbar = self.toolbar;
}

- (ConfigurationView *)_configurationView {
    if (auto configurationView = _configurationView) return configurationView;
    
    ConfigurationView *configurationView = [ConfigurationView new];
    configurationView.delegate = self;
    
    _configurationView = configurationView;
    return configurationView;
}

- (NSToolbar *)_toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [NSToolbar new];
    toolbar.delegate = self;
    
    _toolbar = toolbar;
    return toolbar;
}

- (NSToolbarItem *)_toolbarItem {
    if (auto toolbarItem = _toolbarItem) return toolbarItem;
    
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Identifier"];
//    toolbarItem.title = @"Title";
    toolbarItem.label = @"Label";
    toolbarItem.image = [NSImage imageWithSystemSymbolName:@"apple.intelligence" accessibilityDescription:nil];
    toolbarItem.target = self;
    toolbarItem.action = @selector(_toolbarItemDidTrigger:);
    
    _toolbarItem = toolbarItem;
    return toolbarItem;
}

- (void)_toolbarItemDidTrigger:(NSToolbarItem *)sender {
    NSLog(@"%s", sel_getName(_cmd));
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"Style"]) {
        self.toolbarItem.style = NSToolbarItemStyleFromString(static_cast<NSString *>(newValue));
    } else if ([itemModel.identifier isEqualToString:@"backgroundTintColor"]) {
        self.toolbarItem.backgroundTintColor = static_cast<NSColor *>(newValue);
    } else if ([itemModel.identifier isEqualToString:@"Clear backgroundTintColor"]) {
        self.toolbarItem.backgroundTintColor = nil;
    } else if ([itemModel.identifier isEqualToString:@"Badge"]) {
        NSString *stringValue = static_cast<NSString *>(newValue);
        if ([stringValue isEqualToString:@"Text"]) {
            self.toolbarItem.badge = [ToolbarItemDemoViewController _badgeWithText];
        } else if ([stringValue isEqualToString:@"Count"]) {
            self.toolbarItem.badge = [ToolbarItemDemoViewController _badgeWithCount];
        } else if ([stringValue isEqualToString:@"Indicator"]) {
            self.toolbarItem.badge = [ToolbarItemDemoViewController _indicatorBadge];
        } else {
            abort();
        }
    } else {
        abort();
    }
    
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[self.toolbarItem.itemIdentifier];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[self.toolbarItem.itemIdentifier];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    return self.toolbarItem;
}

@end
