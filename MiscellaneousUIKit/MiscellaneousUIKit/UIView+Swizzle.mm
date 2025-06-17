//
//  UIView+Swizzle.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "UIView+Swizzle.h"
#include <objc/runtime.h>
#include <objc/message.h>

namespace muk_UIKeyShortcutHUDService {
 
    namespace _isHUDSupportedOnPlatform {
        BOOL (*original)(id self, SEL _cmd);
        BOOL custom(id self, SEL _cmd) {
            return YES;
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("UIKeyShortcutHUDService"), sel_registerName("_isHUDSupportedOnPlatform"));
            assert(method != NULL);
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
    
    namespace _isHUDAllowedForConfiguration_ {
        BOOL (*original)(id self, SEL _cmd, id configuration);
        BOOL custom(id self, SEL _cmd, id configuration) {
            if (objc_getAssociatedObject(configuration, UIView._UIKeyShortcutHUDConfiguration_customKey) != nil) {
                return YES;
            } else {
                return original(self, _cmd, configuration);
            }
        }
        void swizzle() {
            Method method = class_getInstanceMethod(objc_lookUpClass("UIKeyShortcutHUDService"), sel_registerName("_isHUDAllowedForConfiguration:"));
            assert(method != NULL);
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
    
}

namespace muk_TIKeyboardShortcut {
    namespace localizedKeyboardShortcut_forKeyboardLayout_usingKeyboardType {
        id (*original)(id self, SEL _cmd, id shortcut, NSString *layout, NSUInteger type);
        id custom(id self, SEL _cmd, id shortcut, NSString *layout, NSUInteger type) {
            /*
             KANA
             Arabic-AZERTY
             */
            id result = original(self, _cmd, shortcut, @"KANA", type);
            return result;
        }
        void swizzle() {
            Method method = class_getClassMethod(objc_lookUpClass("TIKeyboardShortcut"), sel_registerName("localizedKeyboardShortcut:forKeyboardLayout:usingKeyboardType:"));
            assert(method != NULL);
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@implementation UIView (Swizzle)

+ (void *)_UIKeyShortcutHUDConfiguration_customKey {
    static void *key = &key;
    return key;
}

+ (void)load {
    muk_UIKeyShortcutHUDService::_isHUDSupportedOnPlatform::swizzle();
    muk_UIKeyShortcutHUDService::_isHUDAllowedForConfiguration_::swizzle();
//    muk_TIKeyboardShortcut::localizedKeyboardShortcut_forKeyboardLayout_usingKeyboardType::swizzle();
}

@end
