//
//  HighlightingViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "HighlightingViewController.h"
#import <UIKit/UIKit.h>
#include <objc/message.h>
#include <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation HighlightingViewController

+ (void)load {
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_HighlightingViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP _gestureRecognizerDidTrigger_ = class_getMethodImplementation(self, @selector(_gestureRecognizerDidTrigger:));
        assert(class_addMethod(_isa, @selector(_gestureRecognizerDidTrigger:), _gestureRecognizerDidTrigger_, NULL));
        
        assert(class_addIvar(_isa, "_highlightingView", sizeof(id), sizeof(id), NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _highlightingView;
    assert(object_getInstanceVariable(self, "_highlightingView", reinterpret_cast<void **>(&_highlightingView)));
    [_highlightingView release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (void)loadView {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), [self _highlightingView]);
}

- (void)_gestureRecognizerDidTrigger:(id)sender {
    id _highlightingView = [self _highlightingView];
    BOOL isHighlighted = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(_highlightingView, sel_registerName("isHighlighted"));
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_highlightingView, sel_registerName("setHighlighted:"), !isHighlighted);
    
//    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(_highlightingView, sel_registerName("updateBackgroundColor"));
}

- (id)_highlightingView __attribute__((objc_direct)) {
    id _highlightingView;
    assert(object_getInstanceVariable(self, "_highlightingView", reinterpret_cast<void **>(&_highlightingView)));
    if (_highlightingView != nil) return _highlightingView;
    
    _highlightingView = [objc_lookUpClass("PUICHighlightingView") new];
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_highlightingView, sel_registerName("setUserInteractionEnabled:"), YES);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_highlightingView, sel_registerName("setHighlightedBackgroundColor:"), UIColor.greenColor);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_highlightingView, sel_registerName("setUnhighlightedBackgroundColor:"), UIColor.grayColor);
    
    id gestureRecognizer = reinterpret_cast<id (*)(id, SEL, id, SEL)>(objc_msgSend)([objc_lookUpClass("UITapGestureRecognizer") alloc], sel_registerName("initWithTarget:action:"), self, @selector(_gestureRecognizerDidTrigger:));
    reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(_highlightingView, sel_registerName("addGestureRecognizer:"), gestureRecognizer);
    [gestureRecognizer release];
    
    assert(object_setInstanceVariable(self, "_highlightingView", reinterpret_cast<void *>(_highlightingView)) != NULL);
    return _highlightingView;
}

@end
