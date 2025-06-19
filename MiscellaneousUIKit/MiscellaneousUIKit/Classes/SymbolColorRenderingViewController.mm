//
//  SymbolColorRenderingViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import "SymbolColorRenderingViewController.h"
#import "UIImageSymbolColorRenderingMode+String.h"
#include <vector>
#include <ranges>
#include <objc/message.h>
#include <objc/runtime.h>

@interface SymbolColorRenderingViewController ()
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation SymbolColorRenderingViewController
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
    
    UIImageSymbolConfiguration *configuration = [[UIImageSymbolConfiguration configurationPreferringMulticolor] configurationByApplyingConfiguration:[UIImageSymbolConfiguration configurationWithColorRenderingMode:UIImageSymbolColorRenderingModeGradient]];
    UIImage *image = [UIImage systemImageNamed:@"tree.fill" withConfiguration:configuration];
    
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
        
        UIImageSymbolConfiguration *symbolConfiguration = imageView.image.symbolConfiguration;
        UIImageSymbolColorRenderingMode colorRenderingMode = reinterpret_cast<UIImageSymbolColorRenderingMode (*)(id, SEL)>(objc_msgSend)(symbolConfiguration, sel_registerName("colorRenderingMode"));
        
        {
            NSUInteger count;
            const UIImageSymbolColorRenderingMode *modes = allUIImageSymbolColorRenderingModes(&count);
            
            auto actionsVec = std::views::iota(modes, modes + count)
            | std::views::transform([](const UIImageSymbolColorRenderingMode *ptr) -> const UIImageSymbolColorRenderingMode {
                return *ptr;
            })
            | std::views::transform([imageView, colorRenderingMode](const UIImageSymbolColorRenderingMode mode) -> UIAction * {
                UIAction *action = [UIAction actionWithTitle:NSStringFromUIImageSymbolColorRenderingMode(mode) image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    id imageAsset = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(imageView.image, sel_registerName("imageAsset"));
                    NSString *assetName = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(imageAsset, sel_registerName("assetName"));
                    imageView.image = [UIImage systemImageNamed:assetName withConfiguration:[imageView.image.symbolConfiguration configurationByApplyingConfiguration:[UIImageSymbolConfiguration configurationWithColorRenderingMode:mode]]];
                }];
                action.state = (colorRenderingMode == mode) ? UIMenuElementStateOn : UIMenuElementStateOff;
                return action;
            })
            | std::ranges::to<std::vector<UIAction *>>();
            
            NSArray<UIAction *> *actions = [[NSArray alloc] initWithObjects:actionsVec.data() count:actionsVec.size()];
            UIMenu *menu = [UIMenu menuWithTitle:@"Color Rendering Mode" children:actions];
            [actions release];
            menu.subtitle = NSStringFromUIImageSymbolColorRenderingMode(colorRenderingMode);
            [results addObject:menu];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
