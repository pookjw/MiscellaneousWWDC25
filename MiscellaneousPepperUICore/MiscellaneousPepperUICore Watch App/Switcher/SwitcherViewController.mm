//
//  SwitcherViewController.mm
//  MiscellaneousPepperUICore Watch App
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "SwitcherViewController.h"
#import <UIKit/UIKit.h>
#include <objc/message.h>
#include <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void);

@implementation SwitcherViewController

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
        Class _isa = objc_allocateClassPair(objc_lookUpClass("SPViewController"), "_SwitcherViewController", 0);
        
        IMP initWithNibName_bundle = class_getMethodImplementation(self, @selector(initWithNibName:bundle:));
        assert(class_addMethod(_isa, @selector(initWithNibName:bundle:), initWithNibName_bundle, NULL));
        
        IMP dealloc = class_getMethodImplementation(self, @selector(dealloc));
        assert(class_addMethod(_isa, @selector(dealloc), dealloc, NULL));
        
        IMP respondsToSelector = class_getMethodImplementation(self, @selector(respondsToSelector:));
        assert(class_addMethod(_isa, @selector(respondsToSelector:), respondsToSelector, NULL));
        
        IMP viewDidLoad = class_getMethodImplementation(self, @selector(viewDidLoad));
        assert(class_addMethod(_isa, @selector(viewDidLoad), viewDidLoad, NULL));
        
        IMP pageScrollViewControllerNumberOfPages_ = class_getMethodImplementation(self, @selector(pageScrollViewControllerNumberOfPages:));
        assert(class_addMethod(_isa, @selector(pageScrollViewControllerNumberOfPages:), pageScrollViewControllerNumberOfPages_, NULL));
        
        IMP pageScrollViewController_viewControllerForPageAtIndex_ = class_getMethodImplementation(self, @selector(pageScrollViewController:viewControllerForPageAtIndex:));
        assert(class_addMethod(_isa, @selector(pageScrollViewController:viewControllerForPageAtIndex:), pageScrollViewController_viewControllerForPageAtIndex_, NULL));
        
        IMP pageScrollViewController_canDeletePageAtIndex_ = class_getMethodImplementation(self, @selector(pageScrollViewController:canDeletePageAtIndex:));
        assert(class_addMethod(_isa, @selector(pageScrollViewController:canDeletePageAtIndex:), pageScrollViewController_canDeletePageAtIndex_, NULL));
        
        IMP _toggleBarButtonItemDidTrigger_ = class_getMethodImplementation(self, @selector(_toggleBarButtonItemDidTrigger:));
        assert(class_addMethod(_isa, @selector(_toggleBarButtonItemDidTrigger:), _toggleBarButtonItemDidTrigger_, NULL));
        
        assert(class_addIvar(_isa, "_switcherViewController", sizeof(id), sizeof(id), NULL));
        assert(class_addIvar(_isa, "_pages", sizeof(id), sizeof(id), NULL));
        
        if (Protocol *PUICPageScrollViewControllerDataSource = NSProtocolFromString(@"PUICPageScrollViewControllerDataSource")) {
            assert(class_addProtocol(_isa, PUICPageScrollViewControllerDataSource));
        }
        
        if (Protocol *PUICPageScrollViewControllerDelegate = NSProtocolFromString(@"PUICPageScrollViewControllerDelegate")) {
            assert(class_addProtocol(_isa, PUICPageScrollViewControllerDelegate));
        }
        
        //
        
        objc_registerClassPair(_isa);
        
        isa = _isa;
    });
    
    return isa;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    objc_super superInfo = { self, [self class] };
    self = reinterpret_cast<id (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, nibNameOrNil, nibBundleOrNil);
    
    if (self) {
        assert(object_setInstanceVariable(self, "_pages", [NSMutableArray new]) != NULL);
    }
    
    return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"
- (void)dealloc {
    id _switcherViewController;
    assert(object_getInstanceVariable(self, "_switcherViewController", reinterpret_cast<void **>(&_switcherViewController)));
    [_switcherViewController release];
    
    id _pages;
    assert(object_getInstanceVariable(self, "_pages", reinterpret_cast<void **>(&_pages)));
    [_pages release];
    
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL)>(objc_msgSendSuper2)(&superInfo, _cmd);
}
#pragma clang diagnostic pop

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
    
    id _switcherViewController = [self _switcherViewController];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("addChildViewController:"), _switcherViewController);
    id switcherView = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(_switcherViewController, sel_registerName("view"));
    id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("view"));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("addSubview:"), switcherView);
    CGRect bounds = reinterpret_cast<CGRect (*)(id, SEL)>(objc_msgSend)(view, sel_registerName("bounds"));
    reinterpret_cast<void (*)(id, SEL, CGRect)>(objc_msgSend)(switcherView, sel_registerName("setFrame:"), bounds);
    reinterpret_cast<void (*)(id, SEL, NSUInteger)>(objc_msgSend)(switcherView, sel_registerName("setAutoresizingMask:"), (1 << 1) | (1 << 4));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_switcherViewController, sel_registerName("didMoveToParentViewController:"), self);
    
    
    {
        id viewController = [objc_lookUpClass("SPViewController") new];
        id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(viewController, sel_registerName("view"));
        UIColor *systemPinkColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemGreenColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setBackgroundColor:"), systemPinkColor);
        [[self _pages] addObject:viewController];
        [viewController release];
    }
    
    {
        id viewController = [objc_lookUpClass("SPViewController") new];
        id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(viewController, sel_registerName("view"));
        UIColor *systemPinkColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemPinkColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setBackgroundColor:"), systemPinkColor);
        [[self _pages] addObject:viewController];
        [viewController release];
    }
    
    {
        id viewController = [objc_lookUpClass("SPViewController") new];
        id view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(viewController, sel_registerName("view"));
        UIColor *systemPinkColor = reinterpret_cast<id (*)(Class, SEL)>(objc_msgSend)(UIColor.class, sel_registerName("systemOrangeColor"));
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(view, sel_registerName("setBackgroundColor:"), systemPinkColor);
        [[self _pages] addObject:viewController];
        [viewController release];
    }
    
    id navigationItem = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("navigationItem"));
    id toggleBarButtonItem = reinterpret_cast<id (*)(id, SEL, id, NSInteger, id, SEL)>(objc_msgSend)([objc_lookUpClass("UIBarButtonItem") alloc], sel_registerName("initWithImage:style:target:action:"), [UIImage systemImageNamed:@"poweroutlet.type.a"], 0, self, @selector(_toggleBarButtonItemDidTrigger:));
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(navigationItem, sel_registerName("setRightBarButtonItems:"), @[
        toggleBarButtonItem
    ]);
    [toggleBarButtonItem release];
}

- (void)_toggleBarButtonItemDidTrigger:(id)sender {
    id _switcherViewController = [self _switcherViewController];
    BOOL zoomedOut = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(_switcherViewController, sel_registerName("zoomedOut"));
    
    if (zoomedOut) {
        reinterpret_cast<void (*)(id, SEL, NSUInteger, BOOL, id)>(objc_msgSend)(_switcherViewController, sel_registerName("zoomInPageAtIndex:animated:completion:"), 0, YES, nil);
    } else {
        reinterpret_cast<void (*)(id, SEL, BOOL, id)>(objc_msgSend)(_switcherViewController, sel_registerName("zoomOutAnimated:completion:"), YES, nil);
    }
}

- (id)_switcherViewController __attribute__((objc_direct)) {
    id _switcherViewController;
    assert(object_getInstanceVariable(self, "_switcherViewController", reinterpret_cast<void **>(&_switcherViewController)));
    if (_switcherViewController != nil) return _switcherViewController;
    
    _switcherViewController = reinterpret_cast<id (*)(id, SEL, NSInteger)>(objc_msgSend)([objc_lookUpClass("PUICSwitcherViewController") alloc], sel_registerName("initWithScrollOrientation:"), 0);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_switcherViewController, sel_registerName("setDataSource:"), self);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_switcherViewController, sel_registerName("setDelegate:"), self);
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(_switcherViewController, sel_registerName("setPageWidthWhenZoomedOut:"), 100.);
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(_switcherViewController, sel_registerName("setInterpageSpacing:"), 10.);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(_switcherViewController, sel_registerName("setAllowsDeletionWhenZoomedIn:"), YES);
    
    assert(object_setInstanceVariable(self, "_switcherViewController", reinterpret_cast<void *>(_switcherViewController)) != NULL);
    return _switcherViewController;
}

- (NSMutableArray *)_pages __attribute__((objc_direct)) {
    id _pages;
    assert(object_getInstanceVariable(self, "_pages", reinterpret_cast<void **>(&_pages)));
    return _pages;
}

- (NSUInteger)pageScrollViewControllerNumberOfPages:(id)pageScrollViewController {
    return [self _pages].count;
}

- (id)pageScrollViewController:(id)pageScrollViewController viewControllerForPageAtIndex:(NSUInteger)index {
    return [self _pages][index];
}


- (BOOL)pageScrollViewController:(id)pageScrollViewController canDeletePageAtIndex:(NSUInteger)index {
    return YES;
}

@end
