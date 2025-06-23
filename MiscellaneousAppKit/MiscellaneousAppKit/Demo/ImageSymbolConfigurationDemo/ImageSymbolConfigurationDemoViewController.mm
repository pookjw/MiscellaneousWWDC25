//
//  ImageDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/22/25.
//

#import "ImageSymbolConfigurationDemoViewController.h"
#import "ConfigurationView.h"
#import "NSStringFromNSFontWeight.h"
#import "NSStringFromNSImageSymbolScale.h"
#import "allNSFontTextStyles.h"
#import "NSStringFromNSImageSymbolVariableValueMode.h"
#import "NSStringFromNSImageSymbolColorRenderingMode.h"
#include <objc/runtime.h>
#include <objc/message.h>
#include <vector>
#include <ranges>

@interface ImageSymbolConfigurationDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_imageView) NSImageView *imageView;
@end

@implementation ImageSymbolConfigurationDemoViewController
@synthesize splitView = _splitView;
@synthesize configurationView = _configurationView;
@synthesize imageView = _imageView;

- (void)dealloc {
    [_splitView release];
    [_configurationView release];
    [_imageView release];
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

- (NSImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    NSImageView *imageView = [NSImageView new];
    
    NSImageSymbolConfiguration *configuration = [NSImageSymbolConfiguration configurationWithPointSize:300 weight:NSFontWeightUltraLight];
    imageView.image = [[NSImage imageWithSystemSymbolName:@"stop.circle" accessibilityDescription:nil] imageWithSymbolConfiguration:configuration];
    
    _imageView = imageView;
    return imageView;
}

- (void)_reload {
    NSDiffableDataSourceSnapshot<NSNull *, ConfigurationItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    NSMutableArray<ConfigurationItemModel *> *itemModels = [NSMutableArray new];
    NSImageView *imageView = self.imageView;
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *symbolNameItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                             label:@"Symbol Name"
                                                                                                                     valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        id _reps = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(imageView.image, sel_registerName("_reps"));
        NSString *symbolName = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_reps, sel_registerName("symbolName"));
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[
            @"stop.circle",
            @"tree.circle",
            @"rectangle.and.pencil.and.ellipsis"
        ]
                                                           selectedTitles:@[symbolName]
                                                     selectedDisplayTitle:symbolName];
    }];
    
    ConfigurationItemModel<ConfigurationSliderDescription *> *variableValueItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                                                                                                           label:@"Variable Value"
                                                                                                                   valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSImage *image = [NSImage imageWithSystemSymbolName:@"tree.circle" variableValue:0.5 accessibilityDescription:nil];
        id _reps = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(image, sel_registerName("_reps"));
        Ivar ivar = object_getInstanceVariable(_reps, "_variableValue", NULL);
        ptrdiff_t offset = ivar_getOffset(ivar);
        double variableValue = *reinterpret_cast<double *>(reinterpret_cast<uintptr_t>(_reps) + offset);
        
        return [ConfigurationSliderDescription descriptionWithSliderValue:variableValue
                                                             minimumValue:0.
                                                             maximumValue:1.
                                                               continuous:YES];
    }];
    
    ConfigurationItemModel<ConfigurationSliderDescription *> *pointSizeItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                                                                                                       label:@"Point Size"
                                                                                                               valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
        CGFloat pointSize = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("pointSize"));
        return [ConfigurationSliderDescription descriptionWithSliderValue:pointSize minimumValue:0. maximumValue:300. continuous:YES];
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *weightItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                         label:@"Weight"
                                                                                                                 valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
        NSFontWeight weight = reinterpret_cast<NSFontWeight (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("weight"));
        
        NSUInteger count;
        const NSFontWeight *allWeights = allNSFontWeights(&count);
        
        auto titlesVec = std::views::iota(allWeights, allWeights + count)
        | std::views::transform([](const NSFontWeight *ptr) { return *ptr; })
        | std::views::transform([](const NSFontWeight weight) {
            return NSStringFromNSFontWeight(weight);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSFontWeight(weight)]
                                                                                                 selectedDisplayTitle:NSStringFromNSFontWeight(weight)];
        [titles release];
        
        return description;
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *scaleItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                        label:@"Scale"
                                                                                                                valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
        NSImageSymbolScale scale = reinterpret_cast<NSImageSymbolScale (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("scale"));
        
        NSUInteger count;
        const NSImageSymbolScale *allScales = allNSImageSymbolScales(&count);
        
        auto titlesVec = std::views::iota(allScales, allScales + count)
        | std::views::transform([](const NSImageSymbolScale *ptr) { return *ptr; })
        | std::views::transform([](const NSImageSymbolScale scale) {
            return NSStringFromNSImageSymbolScale(scale);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSImageSymbolScale(scale)]
                                                                                                 selectedDisplayTitle:NSStringFromNSImageSymbolScale(scale)];
        [titles release];
        
        return description;
    }];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *textStyleItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                            label:@"Text Style"
                                                                                                                    valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:allNSFontTextStyles
                                                           selectedTitles:@[]
                                                     selectedDisplayTitle:nil];
    }];
    
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *renderingStyleItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                                 label:@"Rendering Style"
                                                                                                                         valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
        NSInteger renderingStyle = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("renderingStyle"));
        
        NSString *string;
        if (renderingStyle == 0) {
            string = @"None";
        } else if (renderingStyle == 1) {
            string = @"Monochrome";
        } else if (renderingStyle == 2) {
            string = @"Hierarchical";
        } else if (renderingStyle == 3) {
            string = @"Palette";
        } else {
            abort();
        }
        
        return [ConfigurationPopUpButtonDescription descriptionWithTitles:@[@"None", @"Monochrome", @"Hierarchical", @"Palette"]
                                                           selectedTitles:@[string]
                                                     selectedDisplayTitle:string];
    }];
    
    [itemModels addObjectsFromArray:@[
        symbolNameItemModel,
        variableValueItemModel,
        pointSizeItemModel,
        weightItemModel,
        scaleItemModel,
        textStyleItemModel,
        renderingStyleItemModel
    ]];
    
    NSImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
    NSInteger renderingStyle = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("renderingStyle"));
    
    if (renderingStyle == 2) {
        ConfigurationItemModel<NSColor *> *hierarchicalColorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeColorWell
                                                                                                            label:@"Hierarchical Color"
                                                                                                    valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
            NSImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
            NSArray<NSColor *> * _Nullable colors = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("colors"));
            NSColor * _Nullable firstColor = colors.firstObject;
            if (firstColor != nil) {
                return firstColor;
            } else {
                return NSColor.clearColor;
            }
        }];
        
        [itemModels addObject:hierarchicalColorItemModel];
    } else if (renderingStyle == 3) {
        for (NSUInteger i = 0; i < 3; i++) {
            ConfigurationItemModel<NSColor *> *paletteColorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeColorWell
                                                                                                           label:[NSString stringWithFormat:@"Palette (%ld)", i]
                                                                                                   valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
                NSImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
                NSArray<NSColor *> * _Nullable colors = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("colors"));
                if (colors.count > i) {
                    return colors[i];
                } else {
                    return NSColor.clearColor;
                }
            }];
            
            [itemModels addObject:paletteColorItemModel];
        }
    }
    
    ConfigurationItemModel<NSNumber *> *prefersMulticolorItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSwitch
                                                                                                         label:@"Prefers Multicolor"
                                                                                                 valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
        BOOL prefersMulticolor = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("prefersMulticolor"));
        return @(prefersMulticolor);
    }];
    [itemModels addObject:prefersMulticolorItemModel];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *variableValueModeItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                                    label:@"Variable Value Mode"
                                                                                                                            valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSUInteger count;
        const NSImageSymbolVariableValueMode *allModes = allNSImageSymbolVariableValueModes(&count);
        
        auto titlesVec = std::views::iota(allModes, allModes + count)
        | std::views::transform([](const NSImageSymbolVariableValueMode *ptr) { return *ptr; })
        | std::views::transform([](const NSImageSymbolVariableValueMode mode) {
            return NSStringFromNSImageSymbolVariableValueMode(mode);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        NSImageSymbolVariableValueMode _variableValueMode = reinterpret_cast<NSImageSymbolVariableValueMode (*)(id, SEL)>(objc_msgSend)(imageView.image.symbolConfiguration, sel_registerName("variableValueMode"));
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSImageSymbolVariableValueMode(_variableValueMode)]
                                                                                                 selectedDisplayTitle:NSStringFromNSImageSymbolVariableValueMode(_variableValueMode)];
        [titles release];
        
        return description;
    }];
    [itemModels addObject:variableValueModeItemModel];
    
    ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *colorRenderingModeItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                                     label:@"Color Rendering Mode"
                                                                                                                             valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
        NSImageSymbolColorRenderingMode colorRenderingMode = reinterpret_cast<NSImageSymbolColorRenderingMode (*)(id, SEL)>(objc_msgSend)(imageView.image.symbolConfiguration, sel_registerName("colorRenderingMode"));
        
        NSUInteger count;
        const NSImageSymbolColorRenderingMode *allModes = allNSImageSymbolColorRenderingModes(&count);
        
        auto titlesVec = std::views::iota(allModes, allModes + count)
        | std::views::transform([](const NSImageSymbolColorRenderingMode *ptr) { return *ptr; })
        | std::views::transform([](const NSImageSymbolColorRenderingMode mode) {
            return NSStringFromNSImageSymbolColorRenderingMode(mode);
        })
        | std::ranges::to<std::vector<NSString *>>();
        
        NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVec.data() count:titlesVec.size()];
        
        ConfigurationPopUpButtonDescription *description = [ConfigurationPopUpButtonDescription descriptionWithTitles:titles
                                                                                                       selectedTitles:@[NSStringFromNSImageSymbolColorRenderingMode(colorRenderingMode)]
                                                                                                 selectedDisplayTitle:NSStringFromNSImageSymbolColorRenderingMode(colorRenderingMode)];
        
        [titles release];
        
        return description;
    }];
    [itemModels addObject:colorRenderingModeItemModel];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:[NSNull null]];
    [itemModels release];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"Symbol Name"]){
        double variableValue;
        {
            id _reps = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.imageView.image, sel_registerName("_reps"));
            Ivar ivar = object_getInstanceVariable(_reps, "_variableValue", NULL);
            ptrdiff_t offset = ivar_getOffset(ivar);
            variableValue = *reinterpret_cast<double *>(reinterpret_cast<uintptr_t>(_reps) + offset);
        }
        
        NSImageSymbolConfiguration *symbolConfiguration;
        {
            symbolConfiguration = self.imageView.image.symbolConfiguration;
            Ivar ivar = object_getInstanceVariable(symbolConfiguration, "_variableValueMode", NULL);
            ptrdiff_t offset = ivar_getOffset(ivar);
            *reinterpret_cast<NSImageSymbolVariableValueMode *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) = NSImageSymbolVariableValueModeAutomatic;
        }
        
        self.imageView.image = [[NSImage imageWithSystemSymbolName:static_cast<NSString *>(newValue) variableValue:variableValue accessibilityDescription:nil] imageWithSymbolConfiguration:symbolConfiguration];
        return YES;
    } else if ([itemModel.identifier isEqualToString:@"Variable Value"]) {
        id _reps = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.imageView.image, sel_registerName("_reps"));
        NSString *symbolName = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_reps, sel_registerName("symbolName"));
        
        self.imageView.image = [[NSImage imageWithSystemSymbolName:symbolName variableValue:static_cast<NSNumber *>(newValue).doubleValue accessibilityDescription:nil] imageWithSymbolConfiguration:self.imageView.image.symbolConfiguration];
    } else if ([itemModel.identifier isEqualToString:@"Point Size"]) {
        NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
        assert(symbolConfiguration != nil);
        Ivar ivar = object_getInstanceVariable(symbolConfiguration, "_pointSize", NULL);
        assert(ivar != NULL);
        ptrdiff_t offset = ivar_getOffset(ivar);
        CGFloat cgFloatValue;
#if CGFLOAT_IS_DOUBLE
        cgFloatValue = static_cast<NSNumber *>(newValue).doubleValue;
#else
        cgFloatValue = static_cast<NSNumber *>(newValue).floatValue;
#endif
        *reinterpret_cast<CGFloat *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) = cgFloatValue;
        
        self.imageView.image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
    } else if ([itemModel.identifier isEqualToString:@"Weight"]) {
        NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
        assert(symbolConfiguration != nil);
        Ivar ivar = object_getInstanceVariable(symbolConfiguration, "_weight", NULL);
        assert(ivar != NULL);
        ptrdiff_t offset = ivar_getOffset(ivar);
        NSFontWeight weight = NSFontWeightFromString(static_cast<NSString *>(newValue));
        *reinterpret_cast<NSFontWeight *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) = weight;
        
        self.imageView.image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
    } else if ([itemModel.identifier isEqualToString:@"Scale"]) {
        NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
        assert(symbolConfiguration != nil);
        Ivar ivar = object_getInstanceVariable(symbolConfiguration, "_scale", NULL);
        assert(ivar != NULL);
        ptrdiff_t offset = ivar_getOffset(ivar);
        NSImageSymbolScale scale = NSImageSymbolScaleFromString(static_cast<NSString *>(newValue));
        *reinterpret_cast<NSImageSymbolScale *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) = scale;
        
        self.imageView.image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
    } else if ([itemModel.identifier isEqualToString:@"Text Style"]) {
        NSImage *image = [self.imageView.image imageWithSymbolConfiguration:[self.imageView.image.symbolConfiguration configurationByApplyingConfiguration:[NSImageSymbolConfiguration configurationWithTextStyle:static_cast<NSFontTextStyle>(newValue)]]];
        self.imageView.image = image;
        [self _reload];
    } else if ([itemModel.identifier isEqualToString:@"Rendering Style"]) {
        NSString *string = static_cast<NSString *>(newValue);
        if ([string isEqualToString:@"None"]) {
            NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
            assert(symbolConfiguration != nil);
            Ivar ivar = object_getInstanceVariable(symbolConfiguration, "_renderingStyle", NULL);
            assert(ivar != NULL);
            ptrdiff_t offset = ivar_getOffset(ivar);
            *reinterpret_cast<NSInteger *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) = 0;
            
            self.imageView.image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
        } else if ([string isEqualToString:@"Monochrome"]) {
            NSImage *image = [self.imageView.image imageWithSymbolConfiguration:[self.imageView.image.symbolConfiguration configurationByApplyingConfiguration:[NSImageSymbolConfiguration configurationPreferringMonochrome]]];
            self.imageView.image = image;
        } else if ([string isEqualToString:@"Hierarchical"]) {
            NSImageSymbolConfiguration *symbolConfiguration = [self.imageView.image.symbolConfiguration configurationByApplyingConfiguration:[NSImageSymbolConfiguration configurationPreferringHierarchical]];
            assert(symbolConfiguration != nil);
            Ivar ivar = object_getInstanceVariable(symbolConfiguration, "_colors", NULL);
            assert(ivar != NULL);
            ptrdiff_t offset = ivar_getOffset(ivar);
            [*reinterpret_cast<id *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) release];
            *reinterpret_cast<id *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) = [@[NSColor.orangeColor] retain]; // or nil
            
            NSImage *image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
            self.imageView.image = image;
        } else if ([string isEqualToString:@"Palette"]) {
            NSImageSymbolConfiguration *symbolConfiguration = [self.imageView.image.symbolConfiguration configurationByApplyingConfiguration:[NSImageSymbolConfiguration configurationWithPaletteColors:@[NSColor.blueColor, NSColor.greenColor, NSColor.orangeColor]]];
            NSImage *image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
            self.imageView.image = image;
        } else {
            abort();
        }
        
        [self _reload];
    } else if ([itemModel.identifier isEqualToString:@"Hierarchical Color"]) {
        NSColor *color = static_cast<NSColor *>(newValue);
        NSImageSymbolConfiguration *symbolConfiguration = [self.imageView.image.symbolConfiguration configurationByApplyingConfiguration:[NSImageSymbolConfiguration configurationWithHierarchicalColor:color]];
        NSImage *image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
        self.imageView.image = image;
    } else if ([itemModel.identifier hasPrefix:@"Palette "]) {
        NSInteger index = [[[itemModel.identifier componentsSeparatedByString:@"Palette "][1] componentsSeparatedByString:@"("][1] componentsSeparatedByString:@")"][0].integerValue;
        NSColor *color = static_cast<NSColor *>(newValue);
        
        NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
        assert(symbolConfiguration != nil);
        Ivar ivar = object_getInstanceVariable(symbolConfiguration, "_colors", NULL);
        assert(ivar != NULL);
        ptrdiff_t offset = ivar_getOffset(ivar);
        
        NSMutableArray<NSColor *> *colors = [*reinterpret_cast<id *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) mutableCopy];
        colors[index] = color;
        
        [*reinterpret_cast<id *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) release];
        *reinterpret_cast<id *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + offset) = [colors copy]; // or nil
        [colors release];
        
        NSImage *image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
        self.imageView.image = image;
        [self _reload];
    } else if ([itemModel.identifier isEqualToString:@"Prefers Multicolor"]) {
        BOOL boolValue = static_cast<NSNumber *>(newValue).boolValue;
        
        NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
        assert(symbolConfiguration != nil);
        Ivar _prefersMulticolor_ivar = object_getInstanceVariable(symbolConfiguration, "_prefersMulticolor", NULL);
        assert(_prefersMulticolor_ivar != NULL);
        ptrdiff_t _prefersMulticolor_offset = ivar_getOffset(_prefersMulticolor_ivar);
        *reinterpret_cast<BOOL *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + _prefersMulticolor_offset) = boolValue;
        
        Ivar _colors_ivar = object_getInstanceVariable(symbolConfiguration, "_colors", NULL);
        assert(_colors_ivar != NULL);
        ptrdiff_t _colors_offset = ivar_getOffset(_colors_ivar);
        [*reinterpret_cast<id *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + _colors_offset) release];
        *reinterpret_cast<id *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + _colors_offset) = nil;
        
        Ivar _renderingStyle_ivar = object_getInstanceVariable(symbolConfiguration, "_renderingStyle", NULL);
        assert(_renderingStyle_ivar != NULL);
        ptrdiff_t _renderingStyle_offset = ivar_getOffset(_renderingStyle_ivar);
        *reinterpret_cast<NSInteger *>(reinterpret_cast<uintptr_t>(symbolConfiguration) + _renderingStyle_offset) = 0;
        
        NSImage *image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
        self.imageView.image = image;
        
        [self _reload];
    } else if ([itemModel.identifier isEqualToString:@"Variable Value Mode"]) {
        NSString *title = static_cast<NSString *>(newValue);
        
        NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
        symbolConfiguration = [symbolConfiguration configurationByApplyingConfiguration:[NSImageSymbolConfiguration configurationWithVariableValueMode:NSImageSymbolVariableValueModeFromString(title)]];
        
        self.imageView.image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
        return NO;
    } else if ([itemModel.identifier isEqualToString:@"Color Rendering Mode"]) {
        NSString *title = static_cast<NSString *>(newValue);
        
        NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
        symbolConfiguration = [symbolConfiguration configurationByApplyingConfiguration:[NSImageSymbolConfiguration configurationWithColorRenderingMode:NSImageSymbolColorRenderingModeFromString(title)]];
        
        self.imageView.image = [self.imageView.image imageWithSymbolConfiguration:symbolConfiguration];
        return NO;
    } else {
        abort();
    }
    
    return NO;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
