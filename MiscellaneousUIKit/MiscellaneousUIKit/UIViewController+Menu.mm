//
//  UIViewController+Menu.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "UIViewController+Menu.h"
#import "KeyValueObserver.h"
#import "WindowObservingInteraction.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface UIViewController (MenuPrivate)
@property (class, nonatomic, readonly) void *muk_menuObserverKey;
@property (retain, nonatomic, nullable, getter=_muk_menuObserver, setter=_muk_setMenuObserver:) KeyValueObserver *muk_menuObserver;
@end

@implementation UIViewController (Menu)

+ (void *)muk_menuObserverKey {
    static void *key = &key;
    return key;
}

- (KeyValueObserver *)_muk_menuObserver {
    return objc_getAssociatedObject(self, UIViewController.muk_menuObserverKey);
}

- (void)_muk_setMenuObserver:(KeyValueObserver *)muk_menuObserver {
    objc_setAssociatedObject(self, UIViewController.muk_menuObserverKey, muk_menuObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)muk_presentMenuForBarButtonItem:(UIBarButtonItem *)barButtonItem {
    __kindof UIControl * _Nullable buttonView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(barButtonItem, sel_registerName("view"));
    
    auto handler_1 = ^{
        __kindof UIControl * _Nullable buttonView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(barButtonItem, sel_registerName("view"));
        assert(buttonView != nil);
        
        auto handler_2 = ^{
            for (id<UIInteraction> interaction in buttonView.interactions) {
                if ([interaction isKindOfClass:objc_lookUpClass("_UIClickPresentationInteraction")]) {
                    UIContextMenuInteraction *contextMenuInteraction = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(interaction, sel_registerName("delegate"));
                    
                    auto handler_3 = ^{
                        reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(contextMenuInteraction, sel_registerName("_presentMenuAtLocation:"), CGPointZero);
                    };
                    
                    id _Nullable outgoingPresentation = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(contextMenuInteraction, sel_registerName("outgoingPresentation"));
                    
                    if (outgoingPresentation != nil) {
                        KeyValueObserver *observer = [[KeyValueObserver alloc] initWithObject:contextMenuInteraction forKeyPath:@"outgoingPresentation" options:NSKeyValueObservingOptionNew handler:^(KeyValueObserver * _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull object, NSDictionary * _Nonnull change) {
                            if ([change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
                                handler_3();
                                [observer invalidate];
                            }
                        }];
                        
                        self.muk_menuObserver = observer;
                        [observer release];
                    } else {
                        handler_3();
                    }
                    
                    break;
                }
            }
        };
        
        
        if (buttonView.window == nil) {
            WindowObservingInteraction *interaction = [WindowObservingInteraction new];
            
            interaction.didMoveToWindow = ^(WindowObservingInteraction * _Nonnull interaction, UIWindow * _Nullable oldWindow, UIWindow * _Nullable newWindow) {
                if (newWindow != nil) {
                    [interaction.view removeInteraction:interaction];
                    handler_2();
                }
            };
            
            [buttonView addInteraction:interaction];
            [interaction release];
        } else {
            handler_2();
        }
    };
    
    if (buttonView == nil) {
        KeyValueObserver *observer = [[KeyValueObserver alloc] initWithObject:barButtonItem forKeyPath:@"view" options:NSKeyValueObservingOptionNew handler:^(KeyValueObserver * _Nonnull observer, NSString * _Nonnull keyPath, id _Nonnull object, NSDictionary * _Nonnull change) {
            if (![change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
                handler_1();
                [observer invalidate];
            }
        }];
        
        self.muk_menuObserver = observer;
        [observer release];
    } else {
        handler_1();
    }
}

@end
