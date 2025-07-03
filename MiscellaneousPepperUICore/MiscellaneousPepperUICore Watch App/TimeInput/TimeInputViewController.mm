//
//  TimeInputViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "TimeInputViewController.h"
#import <UIKit/UIKit.h>
#include <objc/message.h>
#include <objc/runtime.h>

@implementation TimeInputViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_TimeInputViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP valueChanged = class_getMethodImplementation(self, @selector(valueChanged));
        assert(class_addMethod(_isa, @selector(valueChanged), valueChanged, NULL));
        
        IMP setButtonTapped = class_getMethodImplementation(self, @selector(setButtonTapped:));
        assert(class_addMethod(_isa, @selector(setButtonTapped:), setButtonTapped, NULL));
        
        IMP cancelButtonTapped = class_getMethodImplementation(self, @selector(cancelButtonTapped:));
        assert(class_addMethod(_isa, @selector(cancelButtonTapped:), cancelButtonTapped, NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (void)loadView {
    id view = [objc_lookUpClass("PUICTimeInputView") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setDelegate:"), self);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), view);
    [view release];
}

- (void)valueChanged {
    NSLog(@"%s", __func__);
}

- (void)setButtonTapped:(id)timeOffsetInputView {
    NSLog(@"%s", __func__);
}

- (void)cancelButtonTapped:(id)timeOffsetInputView {
    NSLog(@"%s", __func__);
}

@end
