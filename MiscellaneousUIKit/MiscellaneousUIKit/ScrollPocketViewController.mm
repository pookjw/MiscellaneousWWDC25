//
//  ScrollPocketViewController.mm
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "ScrollPocketViewController.h"
#include <objc/runtime.h>
#include <objc/message.h>

// RETIRED

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

/*
 (lldb) po [NSObject _fd__protocolDescriptionForProtocol:(Protocol *)NSProtocolFromString(@"_UIScrollPocketElement")]
 <_UIScrollPocketElement: 0x1f2961dc0> (NSObject) :
 in _UIScrollPocketElement:
     Properties:
         @property (readonly, nonatomic) long _style;
         @property (readonly, nonatomic) _Bool _requiresPocket;
         @property (readonly, nonatomic) struct UIEdgeInsets _visualInsets;
     Instance Methods:
         - (_Bool) _requiresPocket;
         - (void) _applyStyling:(id)arg1;
         - (CGRect={CGPoint=dd}{CGSize=dd}}) _frameInView:(id)arg1;
         - (void) _setupStyling:(id)arg1;
         - (long) _style;
         - (UIEdgeInsets=dddd}) _visualInsets;
 
 
 (lldb) po [NSObject _fd__protocolDescriptionForProtocol:(Protocol *)NSProtocolFromString(@"_UIGeometryChangeObserver")]
 <_UIGeometryChangeObserver: 0x1f2962a80> :
 in _UIGeometryChangeObserver:
     Instance Methods:
         - (void) _geometryChanged:(const {?=Q{CGPoint=dd}{CGPoint=dd}{CGSize=dd}{CGPoint=dd}{CATransform*)arg1 forAncestor:(D=dddddddddddddddd}q@@@@})arg2;
         - (_Bool) _geometryObserverNeedsAncestorOnly;
 */

@interface _MyScrollPocketElement : NSObject
@property (nonatomic, readonly) NSInteger _style;
@end
@implementation _MyScrollPocketElement

+ (void)load {
    if (Protocol *_UIScrollPocketElement = NSProtocolFromString(@"_UIScrollPocketElement")) {
        assert(class_addProtocol(self, _UIScrollPocketElement));
    } else {
        abort();
    }
    if (Protocol *_UIGeometryChangeObserver = NSProtocolFromString(@"_UIGeometryChangeObserver")) {
        assert(class_addProtocol(self, _UIGeometryChangeObserver));
    } else {
        abort();
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    BOOL responds = [super respondsToSelector:aSelector];
    if (!responds) {
        NSLog(@"%s", sel_getName(aSelector));
    }
    return responds;
}

- (BOOL)isKindOfClass:(Class)aClass {
    BOOL result = [super isKindOfClass:aClass];
    if (!result) {
        NSLog(@"%@", NSStringFromClass(aClass));
    }
    return result;
}

- (void)dealloc {
    [super dealloc];
}

- (NSInteger)_style {
    return 1;
}

- (void)_setupStyling:(UIView *)contentView {
    NSLog(@"%@", contentView);
}

- (CGRect)_frameInView:(UIView *)view {
    abort();
}

@end

@interface ScrollPocketViewController ()
@property (retain, nonatomic, readonly, getter=_scrollView) UIScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_imageView) UIImageView *imageView;
@end

@implementation ScrollPocketViewController
@synthesize scrollView = _scrollView;
@synthesize imageView = _imageView;

- (void)dealloc {
    [_scrollView release];
    [_imageView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.scrollView;
}

- (UIScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    UIScrollView *scrollView = [UIScrollView new];
    [scrollView addSubview:self.imageView];
    CGSize imageSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0., 0., imageSize.width, imageSize.height);
    scrollView.contentSize = imageSize;
    
//    scrollView.topEdgeEffect.hidden = YES;
//    scrollView.leftEdgeEffect.hidden = YES;
//    scrollView.bottomEdgeEffect.hidden = YES;
//    scrollView.rightEdgeEffect.hidden = YES;
    
    reinterpret_cast<void (*)(id, SEL)>(objc_msgSend)(scrollView, sel_registerName("_updatePockets"));
//    id pocket = reinterpret_cast<id (*)(id, SEL, NSUInteger, BOOL)>(objc_msgSend)(scrollView, sel_registerName("_pocketForEdge:makeIfNeeded:"), 1, YES);
//    assert(pocket != nil);
    
    
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(scrollView, sel_registerName("_setPocketsEnabled:"), YES);
    
    // 1, 2, 4, 8
//    for (NSUInteger i = 1; i <= 8; i++) {
//        id pocket = reinterpret_cast<id (*)(id, SEL, NSUInteger, BOOL)>(objc_msgSend)(scrollView, sel_registerName("_pocketForEdge:makeIfNeeded:"), i, YES);
//        if (pocket != nil) {
//            NSLog(@"%ld", i);
//            
//            _MyScrollPocketElement *pocketElement = [_MyScrollPocketElement new];
//            reinterpret_cast<void (*)(id, SEL, id, NSUInteger)>(objc_msgSend)(scrollView, sel_registerName("_addPocketElement:onEdge:"), pocketElement, i);
//            [pocketElement release];
//        }
//    }
    
    _scrollView = scrollView;
    return scrollView;
}

- (UIImageView *)_imageView {
    if (auto imageView = _imageView) return imageView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0"]];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = NO;
    
    _imageView = imageView;
    return imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
