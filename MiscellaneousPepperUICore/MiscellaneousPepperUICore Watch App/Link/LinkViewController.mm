//
//  LinkViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "LinkViewController.h"
#import <UIKit/UIKit.h>
#include <objc/message.h>
#include <objc/runtime.h>
#include <dlfcn.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation LinkViewController

+ (void)load {
    void *handle = dlopen("/System/Library/Frameworks/LinkPresentation.framework/LinkPresentation", RTLD_NOW);
    assert(handle != NULL);
    [self class];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] allocWithZone:zone];
}

+ (Class)class {
    static Class isa;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_LinkViewController", 0);
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        assert(class_addIvar(_isa, "_linkView", sizeof(id), sizeof(id), NULL));
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _linkView;
    assert(object_getInstanceVariable(self, "_linkView", reinterpret_cast<void **>(&_linkView)));
    [_linkView release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop


- (void)viewDidLoad {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
    
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    id linkView = [self _linkView];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), linkView);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(linkView, sel_registerName("setTranslatesAutoresizingMaskIntoConstraints:"), NO);
    
    id platterBackgroundView_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(linkView, sel_registerName("centerXAnchor"));
    id platterBackgroundView_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(linkView, sel_registerName("centerYAnchor"));
    id platterBackgroundView_widthAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(linkView, sel_registerName("widthAnchor"));
    id platterBackgroundView_heightAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(linkView, sel_registerName("heightAnchor"));
    
    id view_safeAreaLayoutGuide = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("safeAreaLayoutGuide"));
    id view_safeAreaLayoutGuide_centerXAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("centerXAnchor"));
    id view_safeAreaLayoutGuide_centerYAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("centerYAnchor"));
    id view_safeAreaLayoutGuide_widthAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("widthAnchor"));
    id view_safeAreaLayoutGuide_heightAnchor = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(view_safeAreaLayoutGuide, sel_registerName("heightAnchor"));
    
    id centerXConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(platterBackgroundView_centerXAnchor, sel_registerName("constraintEqualToAnchor:"), view_safeAreaLayoutGuide_centerXAnchor);
    id centerYConstraint = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)(platterBackgroundView_centerYAnchor, sel_registerName("constraintEqualToAnchor:"), view_safeAreaLayoutGuide_centerYAnchor);
    id widthConstraint = reinterpret_cast<id (*)(id, SEL, id, CGFloat)>(objc_msgSend)(platterBackgroundView_widthAnchor, sel_registerName("constraintEqualToAnchor:multiplier:"), view_safeAreaLayoutGuide_widthAnchor, 1.);
    id heightConstraint = reinterpret_cast<id (*)(id, SEL, id, CGFloat)>(objc_msgSend)(platterBackgroundView_heightAnchor, sel_registerName("constraintEqualToAnchor:multiplier:"), view_safeAreaLayoutGuide_heightAnchor, 0.5);
    
    reinterpret_cast<void (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("NSLayoutConstraint"), sel_registerName("activateConstraints:"), @[centerXConstraint, centerYConstraint, widthConstraint, heightConstraint]);
}

- (id)_linkView __attribute__((objc_direct)) {
    id _linkView;
    assert(object_getInstanceVariable(self, "_linkView", reinterpret_cast<void **>(&_linkView)));
    if (_linkView != nil) return _linkView;
    
    _linkView = [objc_lookUpClass("PUICLinkView") new];
    
    NSURL *url = [NSURL URLWithString:@"https://developer.apple.com/documentation/linkpresentation/lplinkmetadata"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(_linkView, sel_registerName("setMetadataValues:urlRequests:"), @[], @[request]);
    [request release];
    
    assert(object_setInstanceVariable(self, "_linkView", reinterpret_cast<void *>(_linkView)) != NULL);
    return _linkView;
}

@end
