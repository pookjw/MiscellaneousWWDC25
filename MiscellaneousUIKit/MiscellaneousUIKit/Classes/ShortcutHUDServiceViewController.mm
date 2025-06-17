//
//  ShortcutHUDServiceViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "ShortcutHUDServiceViewController.h"
#include <objc/runtime.h>
#include <objc/message.h>
#import "UIView+Swizzle.h"
#import "UIViewController+Menu.h"

//UIKIT_EXTERN BOOL _UIEnhancedMainMenuEnabled(void);
//UIKIT_EXTERN UIUserInterfaceIdiom _UIDeviceNativeUserInterfaceIdiomIgnoringClassic(void);
//
//BOOL old_UIKeyShortcutHUDService_isHUDSupportedOnPlatform(void) {
//    UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
//    return (idiom != UIUserInterfaceIdiomPhone) && (idiom != UIUserInterfaceIdiomCarPlay);
//}
//
//BOOL new_UIKeyShortcutHUDService_isHUDSupportedOnPlatform(void) {
//    if (_UIEnhancedMainMenuEnabled()) {
//        UIUserInterfaceIdiom idiomIgnoringClassic = _UIDeviceNativeUserInterfaceIdiomIgnoringClassic();
//        UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
//        
//        return (idiomIgnoringClassic == UIUserInterfaceIdiomVision) && (idiom != UIUserInterfaceIdiomPhone);
//    } else {
//        UIUserInterfaceIdiom idiom = UIDevice.currentDevice.userInterfaceIdiom;
//        return (idiom != UIUserInterfaceIdiomPhone) && (idiom != UIUserInterfaceIdiomCarPlay);
//    }
//}

@interface ShortcutHUDServiceViewController ()
@property (retain, nonatomic, readonly, getter=_textView) UITextView *textView;
@property (retain, nonatomic, readonly, getter=_menuBarButtonItem) UIBarButtonItem *menuBarButtonItem;
@end

@implementation ShortcutHUDServiceViewController
@synthesize textView = _textView;
@synthesize menuBarButtonItem = _menuBarButtonItem;

- (void)dealloc {
    [_textView release];
    [_menuBarButtonItem release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.menuBarButtonItem;
}

- (UITextView *)_textView {
    if (auto textView = _textView) return textView;
    
    UITextView *textView = [UITextView new];
    
    _textView = textView;
    return textView;
}

- (UIBarButtonItem *)_menuBarButtonItem {
    if (auto menuBarButtonItem = _menuBarButtonItem) return menuBarButtonItem;
    
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" image:[UIImage systemImageNamed:@"filemenu.and.selection"] target:nil action:nil menu:[self _makeMenu]];
    
    _menuBarButtonItem = menuBarButtonItem;
    return menuBarButtonItem;
}

- (UIMenu *)_makeMenu {
    __weak auto weakSelf = self;
    
    UIDeferredMenuElement *element = [UIDeferredMenuElement elementWithUncachedProvider:^(void (^ _Nonnull completion)(NSArray<UIMenuElement *> * _Nonnull)) {
        id sharedHUDService = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(objc_lookUpClass("UIKeyShortcutHUDService"), sel_registerName("sharedHUDService"));
        NSInteger hudPresentationState = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(sharedHUDService, sel_registerName("hudPresentationState"));
        
        UIAction *hudPresentationStateAction = [UIAction actionWithTitle:@"hudPresentationState" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {}];
        hudPresentationStateAction.attributes = UIMenuElementAttributesDisabled;
        hudPresentationStateAction.subtitle = @(hudPresentationState).stringValue;
        
        UIAction *scheduleHUDPresentationAction = [UIAction actionWithTitle:@"Schedule HUD Presentation" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
            UIWindowScene *_keyWindowScene = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)([UIWindowScene class], sel_registerName("_keyWindowScene"));
            id configuration = [objc_lookUpClass("_UIKeyShortcutHUDConfiguration") new];
            objc_setAssociatedObject(configuration, UIView._UIKeyShortcutHUDConfiguration_customKey, @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sharedHUDService, sel_registerName("setScheduledHUDConfiguration:"), configuration);
            [configuration release];
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(sharedHUDService, sel_registerName("setScheduledHUDKeyWindowScene:"), _keyWindowScene);
            reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(sharedHUDService, sel_registerName("scheduleHUDPresentation"));
            
//            NSArray<UIGestureRecognizer *> *scheduledHUDHoverGestureRecognizers = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sharedHUDService, sel_registerName("scheduledHUDHoverGestureRecognizers"));
//            for (UIGestureRecognizer *gesture in scheduledHUDHoverGestureRecognizers) {
//                gesture.enabled = NO;
//            }
            [weakSelf muk_presentMenuForBarButtonItem:weakSelf.menuBarButtonItem];
        }];
        
        completion(@[hudPresentationStateAction, scheduleHUDPresentationAction]);
    }];
    
    return [UIMenu menuWithChildren:@[element]];
}

@end
