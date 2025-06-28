//
//  GlassEffectViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 6/27/25.
//

#import "GlassEffectViewController.h"
#import <UIKit/UIKit.h>
#include <objc/message.h>
#include <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation GlassEffectViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_GlassEffectViewController", 0);
        
        IMP loadView = class_getMethodImplementation(self, @selector(loadView));
        assert(class_addMethod(_isa, @selector(loadView), loadView, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        assert(class_addIvar(_isa, "_visualEffectView", sizeof(id), sizeof(id), NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _visualEffectView;
    assert(object_getInstanceVariable(self, "_visualEffectView", reinterpret_cast<void **>(&_visualEffectView)));
    [_visualEffectView release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

- (void)loadView {
    id imageView = [objc_lookUpClass("UIImageView") new];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(imageView, sel_registerName("setImage:"), [UIImage imageNamed:@"0"]);
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(imageView, sel_registerName("setContentMode:"), 2);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(imageView, sel_registerName("setUserInteractionEnabled:"), YES);
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setView:"), imageView);
    [imageView release];
}

- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id visualEffectView = [self _visualEffectView]; 
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), visualEffectView);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(visualEffectView, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    id visualEffectView_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(visualEffectView, sel_registerName("centerXAnchor"));
    id visualEffectView_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(visualEffectView, sel_registerName("centerYAnchor"));
    id visualEffectView_widthAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(visualEffectView, sel_registerName("widthAnchor"));
    id visualEffectView_heightAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(visualEffectView, sel_registerName("heightAnchor"));
    
    id view_safeAreaLayoutGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("safeAreaLayoutGuide"));
    id view_safeAreaLayoutGuide_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("centerXAnchor"));
    id view_safeAreaLayoutGuide_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("centerYAnchor"));
    id view_safeAreaLayoutGuide_widthAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("widthAnchor"));
    id view_safeAreaLayoutGuide_heightAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("heightAnchor"));
    
    id centerXConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(visualEffectView_centerXAnchor, sel_registerName("constraintEqualToAnchor:"), view_safeAreaLayoutGuide_centerXAnchor);
    id centerYConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(visualEffectView_centerYAnchor, sel_registerName("constraintEqualToAnchor:"), view_safeAreaLayoutGuide_centerYAnchor);
    id widthConstraint = reinterpret_cast<id (*)(id, SEL, id, CGFloat)>(objc_msgSend)(visualEffectView_widthAnchor, sel_registerName("constraintEqualToAnchor:multiplier:"), view_safeAreaLayoutGuide_widthAnchor, 0.5);
    id heightConstraint = reinterpret_cast<id (*)(id, SEL, id, CGFloat)>(objc_msgSend)(visualEffectView_heightAnchor, sel_registerName("constraintEqualToAnchor:multiplier:"), view_safeAreaLayoutGuide_heightAnchor, 0.5);
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[centerXConstraint, centerYConstraint, widthConstraint, heightConstraint]);
}

- (id)_visualEffectView __attribute__((objc_direct)) {
    id _visualEffectView;
    assert(object_getInstanceVariable(self, "_visualEffectView", reinterpret_cast<void **>(&_visualEffectView)));
    if (_visualEffectView != nil) return _visualEffectView;
    
    id effect = [objc_lookUpClass("UIGlassEffect") new];
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(effect, sel_registerName("setInteractive:"), YES);
    
    _visualEffectView = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("UIVisualEffectView") alloc], sel_registerName("initWithEffect:"), effect);
    [effect release];
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_visualEffectView, sel_registerName("setUserInteractionEnabled:"), YES);
    
    assert(object_setInstanceVariable(self, "_visualEffectView", reinterpret_cast<void *>(_visualEffectView)) != NULL);
    return _visualEffectView;
}

@end
