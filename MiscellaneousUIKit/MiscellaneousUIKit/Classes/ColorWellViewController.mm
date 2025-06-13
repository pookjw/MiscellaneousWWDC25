//
//  ColorWellViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import "ColorWellViewController.h"
#include <objc/runtime.h>
#include <objc/message.h>

@interface ColorWellViewController () <UIDragInteractionDelegate>
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@property (retain, nonatomic, readonly, getter=_stackView) UIStackView *stackView;
@property (retain, nonatomic, readonly, getter=_colorWell) UIColorWell *colorWell;
@property (retain, nonatomic, readonly, getter=_colorDraggingView) UIView *colorDraggingView;
@end

@implementation ColorWellViewController
@synthesize menuBarButtonItem = _menuBarButtonItem;
@synthesize stackView = _stackView;
@synthesize colorWell = _colorWell;
@synthesize colorDraggingView = _colorDraggingView;

+ (void)load {
    if (Protocol *_UIColorWellDelegate = NSProtocolFromString(@"_UIColorWellDelegate")) {
        assert(class_addProtocol(self, _UIColorWellDelegate));
    }
}

- (void)loadView {
    self.view = self.stackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.systemBackgroundColor;
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
}

- (void)dealloc {
    [_menuBarButtonItem release];
    [_stackView release];
    [_colorWell release];
    [_colorDraggingView release];
    [super dealloc];
}

- (UIStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.colorWell, self.colorDraggingView]];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.alignment = UIStackViewAlignmentFill;
    _stackView = stackView;
    return stackView;
}

- (UIColorWell *)_colorWell {
    if (auto colorWell = _colorWell) return colorWell;
    
    UIColorWell *colorWell = [[UIColorWell alloc] init];
    colorWell.title = @"Title!";
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(colorWell, sel_registerName("set_delegate:"), self);
    
    _colorWell = colorWell;
    return colorWell;
}

- (UIView *)_colorDraggingView {
    if (auto colorDraggingView = _colorDraggingView) return colorDraggingView;
    
    UIView *colorDraggingView = [[UIView alloc] init];
    colorDraggingView.backgroundColor = UIColor.cyanColor;
    
    UIDragInteraction *dragInteraction = [[UIDragInteraction alloc] initWithDelegate:self];
    [colorDraggingView addInteraction:dragInteraction];
    [dragInteraction release];
    
    _colorDraggingView = colorDraggingView;
    return colorDraggingView;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"apple.intelligence"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    UIColorWell *colorWell = self.colorWell;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        NSMutableArray<__kindof UIMenuElement *> *results = [NSMutableArray new];
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Supports Eyedropper" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                colorWell.supportsEyedropper = !colorWell.supportsEyedropper;
            }];
            
            action.state = colorWell.supportsEyedropper ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            UIAction *action = [UIAction actionWithTitle:@"Supports Alpha" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                colorWell.supportsAlpha = !colorWell.supportsAlpha;
            }];

            action.state = colorWell.supportsAlpha ? UIMenuElementStateOn : UIMenuElementStateOff;
            [results addObject:action];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            for (CGFloat f = 0.; f <= 2.; f += 0.2) {
                UIAction *action = [UIAction actionWithTitle:@(f).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    colorWell.maximumLinearExposure = f;
                }];
                action.state = (colorWell.maximumLinearExposure == f) ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                [children addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Maximum Linear Exposure" children:children];
            [children release];
            menu.subtitle = @(colorWell.maximumLinearExposure).stringValue;
            [results addObject:menu];
        }
        
        {
            NSMutableArray<__kindof UIMenuElement *> *children = [NSMutableArray new];
            
            for (CGFloat f = 0.; f <= 2.; f += 0.2) {
                UIAction *action = [UIAction actionWithTitle:@(f).stringValue image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
                    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(colorWell, sel_registerName("setMaxGain:"), f);
                }];
                action.state = (colorWell.maximumLinearExposure == f) ? UIMenuElementStateOn : UIMenuElementStateOff;
                
                [children addObject:action];
            }
            
            UIMenu *menu = [UIMenu menuWithTitle:@"Max Gain" children:children];
            [children release];
            CGFloat maxGain = reinterpret_cast<CGFloat (*)(id, SEL)>(objc_msgSend)(colorWell, sel_registerName("maxGain"));
            menu.subtitle = @(maxGain).stringValue;
            [results addObject:menu];
        }
        
        completion(results);
        [results release];
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

- (void)_colorWell:(UIColorWell *)colorWell willPresentColorPickerViewController:(UIColorPickerViewController *)colorPickerViewController {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)_colorWellDidHideEyedropper:(UIColorWell *)colorWell {
    NSLog(@"%s", sel_getName(_cmd));
}

- (void)_colorWellDidShowEyedropper:(UIColorWell *)colorWell {
    NSLog(@"%s", sel_getName(_cmd));
}

- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session {
    NSItemProvider *provider = [[NSItemProvider alloc] initWithObject:UIColor.cyanColor];
    UIDragItem *item = [[UIDragItem alloc] initWithItemProvider:provider];
    [provider release];
    
    return @[[item autorelease]];
}

@end

