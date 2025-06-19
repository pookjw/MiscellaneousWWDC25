//
//  SymbolDrawEffectViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import "SymbolDrawEffectViewController.h"
#include <vector>
#include <ranges>
#include <utility>
#include <objc/message.h>
#include <objc/runtime.h>
#import <Symbols/Symbols.h>

@interface SymbolDrawEffectViewController ()
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation SymbolDrawEffectViewController
@synthesize imageView = _imageView;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_imageView release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithVariableValueMode:UIImageSymbolVariableValueModeDraw];
    UIImage *image = [UIImage systemImageNamed:@"stop.circle" variableValue:0.5 withConfiguration:configuration];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.backgroundColor = UIColor.systemBackgroundColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _imageView = imageView;
    return imageView;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    UIImageView *imageView = self.imageView;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            auto actionsVec = std::vector<SEL> {
                @selector(effectWithByLayer),
                @selector(effectWithWholeSymbol),
                @selector(effectWithIndividually)
            }
            | std::views::transform([imageView](SEL sel) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:NSStringFromSelector(sel) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    NSSymbolEffectOptions *options = [[NSSymbolEffectOptions optionsWithRepeating] optionsWithSpeed:0.3];
                    [imageView addSymbolEffect:reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)([NSSymbolDrawOnEffect effect], sel)
                                       options:options
                                      animated:YES
                                    completion:^(UISymbolEffectCompletionContext * _Nonnull context) {
                        
                    }];
                }];
                
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Draw On Effect" children:actions];
            [actions release];
            [results addObject:menu];
        }
        
        {
            auto actionsVec = std::vector<SEL> {
                @selector(effectWithByLayer),
                @selector(effectWithWholeSymbol),
                @selector(effectWithIndividually),
                @selector(effectWithReversed),
                @selector(effectWithNonReversed)
            }
            | std::views::transform([imageView](SEL sel) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:NSStringFromSelector(sel) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    NSSymbolEffectOptions *options = [[NSSymbolEffectOptions optionsWithRepeating] optionsWithSpeed:0.3];
                    [imageView addSymbolEffect:reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)([NSSymbolDrawOffEffect effect], sel)
                                       options:options
                                      animated:YES
                                    completion:^(UISymbolEffectCompletionContext * _Nonnull context) {
                        
                    }];
                }];
                
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Draw Off Effect" children:actions];
            [actions release];
            [results addObject:menu];
        }
        
        {
            __kindof UIMenuElement *element = ((id (*)(Class, SEL, id))objc_msgSend)(objc_lookUpClass("UICustomViewMenuElement"), sel_registerName("elementWithViewProvider:"), ^ UIView * (__kindof UIMenuElement *menuElement) {
                UISlider *slider = [UISlider new];
                slider.minimumValue = 0.f;
                slider.maximumValue = 1.f;
                slider.value = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(imageView.image, sel_registerName("variableValue"));
                slider.continuous = YES;
                
                UIAction *action = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
                    float value = static_cast<UISlider *>(action.sender).value;
                    UIImage *image = reinterpret_cast<id (*)(id, SEL, double)>(objc_msgSend)(imageView.image, sel_registerName("_imageWithVariableValue:"), value);
                    imageView.image = image;
                }];
                
                [slider addAction:action forControlEvents:UIControlEventValueChanged];
                
                return [slider autorelease];
            });
            
            [results addObject:element];
        }
        
        {
            id imageAsset = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(imageView.image, sel_registerName("imageAsset"));
            NSString *assetName = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(imageAsset, sel_registerName("assetName"));
            
            auto actionsVec = std::vector<std::pair<NSString *, UIImageSymbolVariableValueMode>> {
                { @"stop.circle", UIImageSymbolVariableValueModeDraw },
                { @"rectangle.and.pencil.and.ellipsis", UIImageSymbolVariableValueModeColor }
            }
            | std::views::transform([imageView, assetName](std::pair<NSString *, UIImageSymbolVariableValueMode> pair) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:pair.first image:[UIImage systemImageNamed:pair.first] identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithVariableValueMode:pair.second];
                    UIImage *image = [UIImage systemImageNamed:pair.first variableValue:0.5 withConfiguration:configuration];
                    imageView.image = image;
                }];
                
                action.state = [pair.first isEqualToString:assetName] ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Image" image:imageView.image identifier:nil options:0 children:actions];
            [actions release];
            [results addObject:menu];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
