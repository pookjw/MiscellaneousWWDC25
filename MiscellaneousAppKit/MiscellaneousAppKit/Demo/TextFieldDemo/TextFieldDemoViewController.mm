//
 //  TextFieldDemoViewController.mm
 //  MiscellaneousAppKit
 //
 //  Created by Jinwoo Kim on 6/25/25.
 //

#import "TextFieldDemoViewController.h"
#import "ConfigurationView.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface TextFieldDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_textContainerView) NSView *textContainerView;
@property (retain, nonatomic, readonly, getter=_textField) NSTextField *textField;
@end

@implementation TextFieldDemoViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize textContainerView = _textContainerView;
@synthesize textField = _textField;

- (void)dealloc {
    [_splitView release];
    [_configurationView release];
    [_textContainerView release];
    [_textField release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.splitView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _reload];
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    NSMutableArray<ConfigurationItemModel *> *itemModels = [NSMutableArray new];
    NSTextField *textField = self.textField;
    
    ConfigurationItemModel<NSColor *> *backgroundColorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeColorWell
                                                                                                 identifier:@"backgroundColor"
                                                                                              valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        if (NSColor *backgroundColor = textField.backgroundColor) {
            return backgroundColor;
        } else {
            return NSColor.clearColor;
        }
    }];
    [itemModels addObject:backgroundColorItemModel];
    
    ConfigurationItemModel<NSNumber *> *drawsBackgroundItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                                  identifier:@"drawsBackground"
                                                                                               valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return @(textField.drawsBackground);
    }];
    [itemModels addObject:drawsBackgroundItemModel];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:[NSNull null]];
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (NSSplitView *)_splitView {
    if (auto splitView = _splitView) return splitView;
    
    NSSplitView *splitView = [NSSplitView new];
    [splitView addArrangedSubview:self.configurationView];
    [splitView addArrangedSubview:self.textContainerView];
    splitView.vertical = YES;
    
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

- (NSView *)_textContainerView {
    if (auto textContainerView = _textContainerView) return textContainerView;
    
    NSView *textContainerView = [NSView new];
    [textContainerView addSubview:self.textField];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.textField.leadingAnchor constraintEqualToAnchor:textContainerView.safeAreaLayoutGuide.leadingAnchor],
        [self.textField.trailingAnchor constraintEqualToAnchor:textContainerView.safeAreaLayoutGuide.trailingAnchor],
        [self.textField.centerYAnchor constraintEqualToAnchor:textContainerView.safeAreaLayoutGuide.centerYAnchor]
    ]];
    
    _textContainerView = textContainerView;
    return textContainerView;
}

- (NSTextField *)_textField {
    if (auto textField = _textField) return textField;
    
    NSTextField *textField = [NSTextField wrappingLabelWithString:@"Test"];
    
//    _textField = textField;
    _textField = [textField retain];
    return textField;
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"backgroundColor"]) {
        self.textField.backgroundColor = static_cast<NSColor *>(newValue);
        
        // https://x.com/_silgen_name/status/1937815172271460719
        id visualProvider = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.textField, sel_registerName("_visualProvider"));
        __kindof NSView *labelView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(visualProvider, sel_registerName("labelView"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(labelView, sel_registerName("setBackgroundColor:"), newValue);
    } else if ([itemModel.identifier isEqualToString:@"drawsBackground"]) {
        self.textField.drawsBackground = static_cast<NSNumber *>(newValue).boolValue;
    } else {
        abort();
    }
    
    return YES;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
