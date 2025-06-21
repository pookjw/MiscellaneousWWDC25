//
//  ImageDemoViewController.mm
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/22/25.
//

#import "ImageDemoViewController.h"
#import "ConfigurationView.h"
#import "NSStringFromNSFontWeight.h"
#import "NSStringFromNSImageSymbolScale.h"
#import "allNSFontTextStyles.h"
#include <objc/runtime.h>
#include <objc/message.h>
#include <vector>
#include <ranges>

@interface ImageDemoViewController () <ConfigurationViewDelegate>
@property (retain, nonatomic, readonly, getter=_splitView) NSSplitView *splitView;
@property (retain, nonatomic, readonly, getter=_configurationView) ConfigurationView *configurationView;
@property (retain, nonatomic, readonly, getter=_imageView) NSImageView *imageView;
@end

@implementation ImageDemoViewController
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
    
    NSImageSymbolConfiguration *symbolConfiguration = self.imageView.image.symbolConfiguration;
    if (symbolConfiguration != nil) {
        ConfigurationItemModel<ConfigurationSliderDescription *> *pointSizeItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypeSlider
                                                                                                                           label:@"Point Size"
                                                                                                                   valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
            CGFloat pointSize = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("pointSize"));
            return [ConfigurationSliderDescription descriptionWithSliderValue:pointSize minimumValue:0. maximumValue:300. continuous:YES];
        }];
        
        ConfigurationItemModel<ConfigurationPopUpButtonDescription *> *weightItemModel = [ConfigurationItemModel itemModelWithType:ConfigurationItemModelTypePopUpButton
                                                                                                                             label:@"Weight"
                                                                                                                     valueResolver:^id<NSCopying> _Nonnull(ConfigurationItemModel * _Nonnull itemModel) {
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
        
        [itemModels addObjectsFromArray:@[
            pointSizeItemModel,
            weightItemModel,
            scaleItemModel,
            textStyleItemModel
        ]];
    }
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:[NSNull null]];
    [itemModels release];
    
    [self.configurationView applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (BOOL)configurationView:(ConfigurationView *)configurationView didTriggerActionWithItemModel:(ConfigurationItemModel *)itemModel newValue:(id<NSCopying>)newValue {
    if ([itemModel.identifier isEqualToString:@"Point Size"]) {
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
    } else {
        abort();
    }
    
    return NO;
}

- (void)didTriggerReloadButtonWithConfigurationView:(ConfigurationView *)configurationView {
    [self _reload];
}

@end
