//
//  SideBySideButtonsViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "SideBySideButtonsViewController.h"
#import <UIKit/UIKit.h>
#include <objc/message.h>
#include <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation SideBySideButtonsViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_SideBySideButtonsViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (void)loadView {
    id view = [objc_lookUpClass("PUICSideBySideButtonsView") new];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setPrimaryButtonTitle:"), @"Primary");
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setSecondaryButtonTitle:"), @"Secondary");
    /*
     0 : Secondary - Primary
     1 : Primary - Secondary
     2 : 자동?
     */
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(view, sel_registerName("setStyle:"), 1);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setPrimaryActionBlock:"), ^{
        NSLog(@"Primary");
    });
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setSecondaryActionBlock:"), ^{
        NSLog(@"Secondary");
    });
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), view);
    [view release];
}

@end
