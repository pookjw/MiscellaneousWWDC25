//
//  WheelsOfTimeEditTimeViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "WheelsOfTimeEditTimeViewController.h"
#import <UIKit/UIKit.h>
#include <objc/message.h>
#include <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation WheelsOfTimeEditTimeViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_WheelsOfTimeEditTimeViewController", 0);
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP editTimeViewIsEditingHours_ = class_getMethodImplementation(self, @selector(editTimeViewIsEditingHours:));
        assert(class_addMethod(_isa, @selector(editTimeViewIsEditingHours:), editTimeViewIsEditingHours_, NULL));
        
        IMP editTimeViewIsEditingMinutes_ = class_getMethodImplementation(self, @selector(editTimeViewIsEditingMinutes:));
        assert(class_addMethod(_isa, @selector(editTimeViewIsEditingMinutes:), editTimeViewIsEditingMinutes_, NULL));
        
        IMP editTimeView_hasUpdatedHour_ = class_getMethodImplementation(self, @selector(editTimeView:hasUpdatedHour:));
        assert(class_addMethod(_isa, @selector(editTimeView:hasUpdatedHour:), editTimeView_hasUpdatedHour_, NULL));
        
        IMP editTimeView_hasUpdatedMinute_ = class_getMethodImplementation(self, @selector(editTimeView:hasUpdatedHour:));
        assert(class_addMethod(_isa, @selector(editTimeView:hasUpdatedMinute:), editTimeView_hasUpdatedMinute_, NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    objc_super superInfo = { self, [self class] };
    BOOL responds = reinterpret_cast<BOOL (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    
    return responds;
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id view = reinterpret_cast<id (*)(id, SEL, CGRect, id)>(objc_msgSend)([objc_lookUpClass("PUICWheelsOfTimeEditTimeView") alloc], sel_registerName("initWithFrame:delegate:"), CGRectNull, self);
    
//    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(view, sel_registerName("setHour:"), 3);
//    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(view, sel_registerName("setMinute:"), 3);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), view);
    [view release];
}

- (BOOL)editTimeViewIsEditingHours:(id)editTimeView {
    NSLog(@"%s", sel_getName(_cmd));
    return YES;
}

- (BOOL)editTimeViewIsEditingMinutes:(id)editTimeView {
    NSLog(@"%s", sel_getName(_cmd));
    return YES;
}

- (void)editTimeView:(id)editTimeView hasUpdatedHour:(NSUInteger)hour {
    NSLog(@"%s (%ld)", sel_getName(_cmd), hour);
}

- (void)editTimeView:(id)editTimeView hasUpdatedMinute:(NSUInteger)minute {
    NSLog(@"%s (%ld)", sel_getName(_cmd), minute);
}

@end
