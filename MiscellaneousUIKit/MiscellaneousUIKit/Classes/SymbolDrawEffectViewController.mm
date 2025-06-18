//
//  SymbolDrawEffectViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import "SymbolDrawEffectViewController.h"
#include <vector>
#include <ranges>
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
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"stop.circle" withConfiguration:configuration]];
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
                    NSSymbolEffectOptions *options = [NSSymbolEffectOptions optionsWithRepeating];
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
                    NSSymbolEffectOptions *options = [NSSymbolEffectOptions optionsWithRepeating];
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
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
