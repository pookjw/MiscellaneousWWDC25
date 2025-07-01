//
//  UIControl+Category.m
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import "UIControl+Category.h"
#include <objc/message.h>
#include <objc/runtime.h>

@interface UIControl (Category_Private)
- (NSMutableArray<void (^)(void)> *)_he_completions;
- (void)_he_setCompletions:(NSMutableArray<void (^)(void)> *)completions;
@end

namespace he_UIControl {
    static void *completionsKey = &completionsKey;
    
    namespace contextMenuInteraction_willEndForConfiguration_animator_ {
        void (*original)(UIControl *self, SEL _cmd, UIContextMenuInteraction *contextMenuInteraction, UIContextMenuConfiguration *configuration, id<UIContextMenuInteractionAnimating> animator);
        void custom(UIControl *self, SEL _cmd, UIContextMenuInteraction *contextMenuInteraction, UIContextMenuConfiguration *configuration, id<UIContextMenuInteractionAnimating> animator) {
            original(self, _cmd, contextMenuInteraction, configuration, animator);
            
            for (void (^completion)(void) in [self _he_completions]) {
                [animator addCompletion:completion];
            }
            
            [self _he_setCompletions:nil];
        }
        
        void swizzle() {
            Method method = class_getInstanceMethod([UIControl class], @selector(contextMenuInteraction:willEndForConfiguration:animator:));
            original = reinterpret_cast<decltype(original)>(method_getImplementation(method));
            method_setImplementation(method, reinterpret_cast<IMP>(custom));
        }
    }
}

@implementation UIControl (Category)

+ (void)load {
    he_UIControl::contextMenuInteraction_willEndForConfiguration_animator_::swizzle();
}

- (void)he_presentMenu {
    if (self.window != nil) {
        for (id<UIInteraction> interaction in self.interactions) {
            if ([interaction isKindOfClass:[UIContextMenuInteraction class]]) {
                id outgoingPresentation = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(interaction, sel_registerName("outgoingPresentation"));
                if (outgoingPresentation != nil) {
                    NSMutableArray<void (^)()> *completions = [self _he_completions];
                    if (completions == nil) {
                        completions = [NSMutableArray array];
                        [self _he_setCompletions:completions];
                    }
                    
                    void (^completion)(void) = [^{
                        reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(interaction, sel_registerName("_presentMenuAtLocation:"), CGPointZero);
                    } copy];
                    [completions addObject:completion];
                    [completion release];
                } else {
                    reinterpret_cast<void (*)(id, SEL, CGPoint)>(objc_msgSend)(interaction, sel_registerName("_presentMenuAtLocation:"), CGPointZero);
                }
                
                break;
            }
        }
    }
}

@end

@implementation UIControl (Category_Private)

- (NSMutableArray<void (^)()> *)_he_completions {
    return objc_getAssociatedObject(self, he_UIControl::completionsKey);
}

- (void)_he_setCompletions:(NSMutableArray<void (^)()> *)completions {
    objc_setAssociatedObject(self, he_UIControl::completionsKey, completions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
