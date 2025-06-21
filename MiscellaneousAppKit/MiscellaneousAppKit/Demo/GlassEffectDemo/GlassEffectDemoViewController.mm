//
//  GlassEffectDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/21/25.
//

#import "GlassEffectDemoViewController.h"
#import "ConfigurationView.h"
#import "ImageView.h"
#import "VibrantView.h"
#import "VibrantTextField.h"
#include <objc/runtime.h>
#include <objc/message.h>

@interface GlassEffectDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_imageView) ImageView *imageView;
@property (retain, nonatomic, readonly, getter=_glassEffectContainerView) NSGlassEffectContainerView *glassEffectContainerView;
@property (retain, nonatomic, readonly, getter=_glassEffectView_1) NSGlassEffectView *glassEffectView_1;
@property (retain, nonatomic, readonly, getter=_textField_1) VibrantTextField *textField_1;
@property (retain, nonatomic, readonly, getter=_glassEffectView_2) NSGlassEffectView *glassEffectView_2;
@end

@implementation GlassEffectDemoViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize imageView = _imageView;
@synthesize glassEffectContainerView = _glassEffectContainerView;
@synthesize glassEffectView_1 = _glassEffectView_1;
@synthesize textField_1 = _textField_1;
@synthesize glassEffectView_2 = _glassEffectView_2;

- (void)dealloc {
    [_splitView release];
    [_configurationView release];
    [_imageView release];
    [_glassEffectContainerView release];
    [_glassEffectView_1 release];
    [_glassEffectView_2 release];
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
    [splitView addArrangedSubview:self.imageView];
    
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

- (NSGlassEffectContainerView *)_glassEffectContainerView {
    if (auto glassEffectContainerView = _glassEffectContainerView) return glassEffectContainerView;
    
    NSGlassEffectContainerView *glassEffectContainerView = [NSGlassEffectContainerView new];
    [glassEffectContainerView addSubview:self.glassEffectView_1];
    [glassEffectContainerView addSubview:self.glassEffectView_2];
    self.glassEffectView_1.translatesAutoresizingMaskIntoConstraints = NO;
    self.glassEffectView_2.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.glassEffectView_1.topAnchor constraintEqualToAnchor:glassEffectContainerView.topAnchor],
        [self.glassEffectView_1.leadingAnchor constraintEqualToAnchor:glassEffectContainerView.leadingAnchor],
        [self.glassEffectView_1.bottomAnchor constraintEqualToAnchor:glassEffectContainerView.bottomAnchor],
        
        [self.glassEffectView_2.topAnchor constraintEqualToAnchor:glassEffectContainerView.topAnchor],
        [self.glassEffectView_2.trailingAnchor constraintEqualToAnchor:glassEffectContainerView.trailingAnchor],
        [self.glassEffectView_2.bottomAnchor constraintEqualToAnchor:glassEffectContainerView.bottomAnchor],
        
        [self.glassEffectView_2.leadingAnchor constraintEqualToAnchor:self.glassEffectView_1.trailingAnchor constant:8],
        [self.glassEffectView_1.widthAnchor constraintEqualToAnchor:self.glassEffectView_2.widthAnchor]
    ]];
    
    _glassEffectContainerView = glassEffectContainerView;
    return glassEffectContainerView;
}

- (NSGlassEffectView *)_glassEffectView_1 {
    if (auto glassEffectView_1 = _glassEffectView_1) return glassEffectView_1;
    
    NSGlassEffectView *glassEffectView_1 = [NSGlassEffectView new];
    
    VibrantView *contentView = [VibrantView new];
    [contentView addSubview:self.textField_1];
    self.textField_1.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.textField_1.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor],
        [self.textField_1.centerYAnchor constraintEqualToAnchor:contentView.centerYAnchor]
    ]];
    glassEffectView_1.contentView = contentView;
    [contentView release];
    
    _glassEffectView_1 = glassEffectView_1;
    return glassEffectView_1;
}

- (VibrantTextField *)_textField_1 {
    if (auto textField_1 = _textField_1) return textField_1;
    
    VibrantTextField *textField_1 = [VibrantTextField wrappingLabelWithString:@"Label"];
    textField_1.font = [NSFont preferredFontForTextStyle:NSFontTextStyleLargeTitle options:@{}];
    textField_1.textColor = NSColor.systemGrayColor;
    
    _textField_1 = [textField_1 retain];
    return textField_1;
}

- (NSGlassEffectView *)_glassEffectView_2 {
    if (auto glassEffectView_2 = _glassEffectView_2) return glassEffectView_2;
    
    NSGlassEffectView *glassEffectView_2 = [NSGlassEffectView new];
    
    _glassEffectView_2 = glassEffectView_2;
    return glassEffectView_2;
}

- (ImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    ImageView *imageView = [ImageView new];
    imageView.image = [NSImage imageNamed:@"image"];
    imageView.contentMode = ImageViewContentModeAspectFill;
    
    [imageView addSubview:self.glassEffectContainerView];
    self.glassEffectContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.glassEffectContainerView.centerXAnchor constraintEqualToAnchor:imageView.centerXAnchor],
        [self.glassEffectContainerView.centerYAnchor constraintEqualToAnchor:imageView.centerYAnchor],
        [self.glassEffectContainerView.widthAnchor constraintEqualToAnchor:imageView.widthAnchor multiplier:0.5],
        [self.glassEffectContainerView.heightAnchor constraintEqualToAnchor:imageView.heightAnchor multiplier:0.5]
    ]];
    
    _imageView = imageView;
    return imageView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    NSGlassEffectContainerView *glassEffectContainerView = self.glassEffectContainerView;
    NSGlassEffectView *glassEffectView_1 = self.glassEffectView_1;
    NSGlassEffectView *glassEffectView_2 = self.glassEffectView_2;
    
    ConfigurationItemModel<ConfigurationSliderDescription *> *glassEffectContainerSpacingItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                                                                                                                         label:@"Glass Effect Container Spacing"
                                                                                                                                 valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationSliderDescription descriptionWithSliderValue:glassEffectContainerView.spacing
                                                             minimumValue:0.
                                                             maximumValue:100.
                                                               continuous:YES];
    }];
    
    ConfigurationItemModel<ConfigurationSliderDescription *> *cornerRadiusItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                                                                                                          label:@"Corner Radius"
                                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationSliderDescription descriptionWithSliderValue:glassEffectView_1.cornerRadius
                                                             minimumValue:0.
                                                             maximumValue:100.
                                                               continuous:YES]; 
    }];
    
    ConfigurationItemModel<NSColor *> *tintColorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeColorWell
                                                                                                label:@"Tint Color"
                                                                                        valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        if (NSColor *tintColor = glassEffectView_1.tintColor) {
            return tintColor;
        } else {
            return NSColor.clearColor;
        }
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *variantItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                          label:@"Variant"
                                                                                                                  valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger _variant = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(glassEffectView_1, sel_registerName("_variant"));
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"0", @"1", @"2", @"3", @"4", @"5"]
                                                           selectedTitles:@[@(_variant).stringValue]
                                                     selectedDisplayTitle:@(_variant).stringValue];
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *interactionStateItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                                   label:@"Interaction State"
                                                                                                                           valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger _interactionState = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(glassEffectView_1, sel_registerName("_interactionState"));
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"0", @"1", @"2"]
                                                           selectedTitles:@[@(_interactionState).stringValue]
                                                     selectedDisplayTitle:@(_interactionState).stringValue];
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *subduedStateItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                               label:@"Subdued State"
                                                                                                                       valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger _subduedState = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(glassEffectView_1, sel_registerName("_subduedState"));
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"0", @"1", @"2"]
                                                           selectedTitles:@[@(_subduedState).stringValue]
                                                     selectedDisplayTitle:@(_subduedState).stringValue];
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *scrimStateItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                             label:@"Scrim State"
                                                                                                                     valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger _scrimState = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(glassEffectView_1, sel_registerName("_scrimState"));
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"0", @"1", @"2"]
                                                           selectedTitles:@[@(_scrimState).stringValue]
                                                     selectedDisplayTitle:@(_scrimState).stringValue];
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *contentLensingItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                                 label:@"Content Lensing"
                                                                                                                         valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger _contentLensing = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(glassEffectView_1, sel_registerName("_contentLensing"));
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"0", @"1", @"2", @"3", @"4", @"5"]
                                                           selectedTitles:@[@(_contentLensing).stringValue]
                                                     selectedDisplayTitle:@(_contentLensing).stringValue];
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *adaptiveAppearanceItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                                     label:@"Adaptive Appearance"
                                                                                                                             valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger _adaptiveAppearance = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(glassEffectView_1, sel_registerName("_adaptiveAppearance"));
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"0", @"1", @"2"]
                                                           selectedTitles:@[@(_adaptiveAppearance).stringValue]
                                                     selectedDisplayTitle:@(_adaptiveAppearance).stringValue];
    }];
    
    ConfigurationItemModel<NSNumber *> *pathItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                            label:@"Path"
                                                                                    valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        CGPathRef _path = reinterpret_cast<CGPathRef (*)(id, SEL)>(objc_msgSend)(glassEffectView_1, sel_registerName("_path"));
        return @(_path != nil);
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *disableEmbeddingCountItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                                        label:@"Disable Embedding Count"
                                                                                                                                valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSInteger _disableEmbeddingCount = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(glassEffectView_1, sel_registerName("_disableEmbeddingCount"));
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"0", @"1", @"2", @"100"]
                                                           selectedTitles:@[@(_disableEmbeddingCount).stringValue]
                                                     selectedDisplayTitle:@(_disableEmbeddingCount).stringValue];
    }];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:@[
        glassEffectContainerSpacingItemModel,
        cornerRadiusItemModel,
        tintColorItemModel,
        variantItemModel,
        interactionStateItemModel,
        subduedStateItemModel,
        scrimStateItemModel,
        contentLensingItemModel,
        adaptiveAppearanceItemModel,
        pathItemModel,
        disableEmbeddingCountItemModel
    ]
               intoSectionWithIdentifier:[NSNull null]];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (CGPathRef)_newPath {
    CGMutablePathRef path = CGPathCreateMutable();
    
    NSRect bounds = self.glassEffectView_1.bounds;
    
    CGFloat minX = NSMinX(bounds);
    CGFloat minY = NSMinY(bounds);
    
    CGFloat maxX = NSMaxX(bounds);
    CGFloat maxY = NSMaxY(bounds);
    
    CGFloat midX = NSMidX(bounds);
    CGFloat midY = NSMidY(bounds);
    
    //    CGFloat width = NSWidth(bounds);
    //    CGFloat height = NSHeight(bounds);
    
    CGPathMoveToPoint(path, NULL, midX, minY);
    
    const CGPoint points[] = {
        CGPointMake(midX, minY),
        CGPointMake(maxX, midY),
        CGPointMake(midX, maxY),
        CGPointMake(minX, midY),
        CGPointMake(midX, minY),
    };
    CGPathAddLines(path, NULL, points, 5);
    CGPathCloseSubpath(path);
    
    CGPathRef result = CGPathCreateCopy(path);
    CGPathRelease(path);
    return result;
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"Glass Effect Container Spacing"]) {
#if CGFLOAT_IS_DOUBLE
        self.glassEffectContainerView.spacing = static_cast<NSNumber *>(newValue).doubleValue;
#else
        self.glassEffectContainerView.spacing = static_cast<NSNumber *>(newValue).floatValue;
#endif
    } else if ([itemModel.identifier isEqualToString:@"Corner Radius"]) {
#if CGFLOAT_IS_DOUBLE
        self.glassEffectView_1.cornerRadius = static_cast<NSNumber *>(newValue).doubleValue;
        self.glassEffectView_2.cornerRadius = static_cast<NSNumber *>(newValue).doubleValue;
#else
        self.glassEffectView_1.cornerRadius = static_cast<NSNumber *>(newValue).floatValue;
        self.glassEffectView_2.cornerRadius = static_cast<NSNumber *>(newValue).floatValue;
#endif
        self.glassEffectContainerView.needsLayout = YES;
    } else if ([itemModel.identifier isEqualToString:@"Tint Color"]) {
        self.glassEffectView_1.tintColor = static_cast<NSColor *>(newValue);
        self.glassEffectView_2.tintColor = static_cast<NSColor *>(newValue);
    } else if ([itemModel.identifier isEqualToString:@"Variant"]) {
        NSInteger _variant = static_cast<NSString *>(newValue).integerValue;
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_variant:"), _variant);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_variant:"), _variant);
    } else if ([itemModel.identifier isEqualToString:@"Interaction State"]) {
        NSInteger _interactionState = static_cast<NSString *>(newValue).integerValue;
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_interactionState:"), _interactionState);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_interactionState:"), _interactionState);
    } else if ([itemModel.identifier isEqualToString:@"Subdued State"]) {
        NSInteger _subduedState = static_cast<NSString *>(newValue).integerValue;
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_subduedState:"), _subduedState);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_subduedState:"), _subduedState);
    } else if ([itemModel.identifier isEqualToString:@"Scrim State"]) {
        NSInteger _scrimState = static_cast<NSString *>(newValue).integerValue;
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_scrimState:"), _scrimState);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_scrimState:"), _scrimState);
    } else if ([itemModel.identifier isEqualToString:@"Content Lensing"]) {
        NSInteger _contentLensing = static_cast<NSString *>(newValue).integerValue;
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_contentLensing:"), _contentLensing);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_contentLensing:"), _contentLensing);
    } else if ([itemModel.identifier isEqualToString:@"Adaptive Appearance"]) {
        NSInteger _adaptiveAppearance = static_cast<NSString *>(newValue).integerValue;
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_adaptiveAppearance:"), _adaptiveAppearance);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_adaptiveAppearance:"), _adaptiveAppearance);
    } else if ([itemModel.identifier isEqualToString:@"Path"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        if (boolValue) {
            CGPathRef path = [self _newPath];
            reinterpret_cast<void (*)(id, SEL, CGPathRef)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_path:"), path);
            reinterpret_cast<void (*)(id, SEL, CGPathRef)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_path:"), path);
            CGPathRelease(path);
        } else {
            reinterpret_cast<void (*)(id, SEL, CGPathRef)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_path:"), NULL);
            reinterpret_cast<void (*)(id, SEL, CGPathRef)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_path:"), NULL);
        }
        
        self.glassEffectContainerView.needsLayout = YES;
    } else if ([itemModel.identifier isEqualToString:@"Disable Embedding Count"]) {
        NSInteger _disableEmbeddingCount = static_cast<NSString *>(newValue).integerValue;
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_1, sel_registerName("set_disableEmbeddingCount:"), _disableEmbeddingCount);
        reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(self.glassEffectView_2, sel_registerName("set_disableEmbeddingCount:"), _disableEmbeddingCount);
    } else {
        abort();
    }
    
    return NO;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end

