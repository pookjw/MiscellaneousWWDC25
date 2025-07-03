//
//  PlatterBackgroundViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "PlatterBackgroundViewController.h"
#import <UIKit/UIKit.h>
#include <objc/message.h>
#include <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation PlatterBackgroundViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_PlatterBackgroundViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        assert(class_addIvar(_isa, "_platterBackgroundView", sizeof(id), sizeof(id), NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _platterBackgroundView;
    assert(object_getInstanceVariable(self, "_platterBackgroundView", reinterpret_cast<void **>(&_platterBackgroundView)));
    [_platterBackgroundView release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop


- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
//    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setBackgroundColor:"), UIColor.grayColor);
    id platterBackgroundView = [self _platterBackgroundView];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), platterBackgroundView);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(platterBackgroundView, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    id platterBackgroundView_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(platterBackgroundView, sel_registerName("centerXAnchor"));
    id platterBackgroundView_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(platterBackgroundView, sel_registerName("centerYAnchor"));
    id platterBackgroundView_widthAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(platterBackgroundView, sel_registerName("widthAnchor"));
    id platterBackgroundView_heightAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(platterBackgroundView, sel_registerName("heightAnchor"));
    
    id view_safeAreaLayoutGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("safeAreaLayoutGuide"));
    id view_safeAreaLayoutGuide_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("centerXAnchor"));
    id view_safeAreaLayoutGuide_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("centerYAnchor"));
    id view_safeAreaLayoutGuide_widthAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("widthAnchor"));
    id view_safeAreaLayoutGuide_heightAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("heightAnchor"));
    
    id centerXConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(platterBackgroundView_centerXAnchor, sel_registerName("constraintEqualToAnchor:"), view_safeAreaLayoutGuide_centerXAnchor);
    id centerYConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(platterBackgroundView_centerYAnchor, sel_registerName("constraintEqualToAnchor:"), view_safeAreaLayoutGuide_centerYAnchor);
    id widthConstraint = reinterpret_cast<id (*)(id, SEL, id, CGFloat)>(objc_msgSend)(platterBackgroundView_widthAnchor, sel_registerName("constraintEqualToAnchor:multiplier:"), view_safeAreaLayoutGuide_widthAnchor, 0.5);
    id heightConstraint = reinterpret_cast<id (*)(id, SEL, id, CGFloat)>(objc_msgSend)(platterBackgroundView_heightAnchor, sel_registerName("constraintEqualToAnchor:multiplier:"), view_safeAreaLayoutGuide_heightAnchor, 0.5);
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[centerXConstraint, centerYConstraint, widthConstraint, heightConstraint]);
}

- (id)_platterBackgroundView __attribute__((objc_direct)) {
    id _platterBackgroundView;
    assert(object_getInstanceVariable(self, "_platterBackgroundView", reinterpret_cast<void **>(&_platterBackgroundView)));
    if (_platterBackgroundView != nil) return _platterBackgroundView;
    
    _platterBackgroundView = [objc_lookUpClass("PUICPlatterBackgroundView") new];
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(_platterBackgroundView, sel_registerName("setPlatterStyle:"), 0); // 0, 1
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_platterBackgroundView, sel_registerName("setPillShaped:"), YES);
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(_platterBackgroundView, sel_registerName("setDarkeningFactor:"), 0.); // 0~100
    
    assert(object_setInstanceVariable(self, "_platterBackgroundView", reinterpret_cast<void *>(_platterBackgroundView)) != NULL);
    return _platterBackgroundView;
}

@end
