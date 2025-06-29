//
//  WolfScrollEventView.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/29/25.
//

#import "WolfScrollEventView.h"

#if TARGET_OS_VISION

#include <objc/message.h>
#include <objc/runtime.h>
#include <dlfcn.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface _WolfScrollEventGestureRecognizer : UIPanGestureRecognizer
@end

@implementation _WolfScrollEventGestureRecognizer

- (BOOL)shouldReceiveEvent:(UIEvent *)event {
    if (event.type == UIEventTypeScroll) {
        return YES;
    }
    
    objc_super superInfo = { self, [self class] };
    return reinterpret_cast<BOOL (*)(objc_super *, SEL, id)>(objc_msgSendSuper2)(&superInfo, _cmd, event);
}

@end

@interface WolfScrollEventView () {
    id _wolfScrollGroup;
}
@property (class, readonly, getter=_muk_REEntityGetLocalId) unsigned long long (*REEntityGetLocalId)(const void *);
@property (retain, nonatomic, readonly, getter=_label) UILabel *label;
@property (assign, nonatomic, getter=_lastLocation, setter=_setLastLocation:) CGPoint lastLocation;
@end

@implementation WolfScrollEventView
@synthesize label = _label;

+ (unsigned long long (*)(const void *))_muk_REEntityGetLocalId {
    static unsigned long long (*result)(const void *);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void *handle = dlopen("/System/Library/PrivateFrameworks/CoreRE.framework/CoreRE", RTLD_NOW);
        void *symbol = dlsym(handle, "REEntityGetLocalId");
        result = reinterpret_cast<decltype(result)>(symbol);
    });
    return result;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self _muk_setPreferredAutoScrollWithWolfAxes:UIAxisBoth];
        }];
        
        _WolfScrollEventGestureRecognizer *gesture = [[_WolfScrollEventGestureRecognizer alloc] initWithTarget:self action:@selector(_panGestureRecognizerDidTrigger:)];
        [self addGestureRecognizer:gesture];
        [gesture release];
        
        UILabel *label = self.label;
        [self addSubview:label];
        label.frame = self.bounds;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)dealloc {
    [_wolfScrollGroup release];
    [_label release];
    [super dealloc];;
}

- (UILabel *)_label {
    if (auto label = _label) return label;
    
    UILabel *label = [UILabel new];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleExtraLargeTitle];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.userInteractionEnabled = NO;
    
    _label = label;
    return label;
}

- (void)_panGestureRecognizerDidTrigger:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self];
    
    NSMutableString *text = [NSMutableString stringWithFormat:@"%@\n", NSStringFromCGPoint(location)];
    
    CGPoint lastLocation = self.lastLocation;
    self.lastLocation = location;
    
    if (lastLocation.x < location.x) {
        [text appendString:@"Left\n"];
    } else if (lastLocation.x > location.x) {
        [text appendString:@"Right\n"];
    }
    
    if (lastLocation.y < location.y) {
        [text appendString:@"Top"];
    } else if (lastLocation.y > location.y) {
        [text appendString:@"Bottom"];
    }
    
    self.label.text = text;
}

- (void)_muk_setPreferredAutoScrollWithWolfAxes:(UIAxis)axes {
    // original : -[UIScrollView setPreferredAutoScrollWithWolfAxes:]
    /*
     self = x19
     axes = x20
     */
    
    if (axes == UIAxisNeither) {
        // <+316>
        [_wolfScrollGroup release];
        _wolfScrollGroup = nil;
        
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self.layer, sel_registerName("setHitTestsAsOpaque:"), NO);
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("_removeRemoteEffectsForKey:"), @"wolfScroll");
        reinterpret_cast<void (*)(id, SEL, NSUInteger, id)>(objc_msgSend)(self, sel_registerName("_requestSeparatedState:withReason:"), 0, @"_UIViewSeparatedStateRequestReasonLookToScroll");
    } else {
        if (_wolfScrollGroup == nil) {
            _wolfScrollGroup = [[self _muk_defaultWolfScrollGroup] retain];
        }
        
        // <+160>
        [self _muk_updateWolfScrollGroupForcingUpdate:NO];
        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(self.layer, sel_registerName("setHitTestsAsOpaque:"), YES);
        reinterpret_cast<void (*)(id, SEL, NSUInteger, id)>(objc_msgSend)(self, sel_registerName("_requestSeparatedState:withReason:"), 2, @"_UIViewSeparatedStateRequestReasonLookToScroll");
    }
}

- (void)_muk_updateWolfScrollGroupForcingUpdate:(BOOL)force {
    // original : -[UIScrollView _updateWolfScrollGroupForcingUpdate:]
    /*
     self = x19
     force = x22
     */
    
    id group = _wolfScrollGroup;
    if (group == nil) return;
    
    // x21
    NSArray *effects = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(group, sel_registerName("effects"));
    // x20
    id effect = effects.firstObject;
    if (effect == nil) return;
    
    const void *_reEntity = reinterpret_cast<const void * (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_reEntity"));
    unsigned long long rID;
    if (_reEntity == NULL) {
        rID = 0ULL;
    } else {
        rID = WolfScrollEventView.REEntityGetLocalId(_reEntity);   
    }
    
    NSDictionary * _Nullable userInfo = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(effect, sel_registerName("userInfo"));
    // x21
    NSMutableDictionary *anotherUserInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    unsigned int _serverHitTestIdentifier = reinterpret_cast<unsigned int (*)(id, SEL)>(objc_msgSend)(self, sel_registerName("_serverHitTestIdentifier"));
    anotherUserInfo[@"hit-test-identifier"] = @(_serverHitTestIdentifier);
    anotherUserInfo[@"allowed-axes"] = @(UIAxisBoth);
    anotherUserInfo[@"allowed-edge"] = @(UIRectEdgeAll);
    anotherUserInfo[@"entity-id"] = @(rID);
    anotherUserInfo[@"exclusion-regions-version"] = @(3);
    anotherUserInfo[@"server-delay"] = @(1);
    
    if (!force) {
        if ([anotherUserInfo isEqualToDictionary:userInfo]) {
            return;
        }
    }
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(effect, sel_registerName("setUserInfo:"), anotherUserInfo);
    
    reinterpret_cast<void (*)(id, SEL, id, id)>(objc_msgSend)(self, sel_registerName("_requestRemoteEffects:forKey:"), @[
        group
    ], @"wolfScroll");
}

- (id)_muk_defaultWolfScrollGroup {
    // original : -[UIScrollView _defaultWolfScrollGroup]
    
    // x22
    id effect = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemoteExternalEffect"), sel_registerName("effectWithName:"), @"wolfScrollGroup");
    
    // x19
    id group = reinterpret_cast<id (*)(Class, SEL, id)>(objc_msgSend)(objc_lookUpClass("CARemoteEffectGroup"), sel_registerName("groupWithEffects:"), @[effect]);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(group, sel_registerName("setGroupName:"), [self _muk_wolfScrollingGroupName]);
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(group, sel_registerName("setMatched:"), YES);
    
    return group;
}

- (NSString *)_muk_wolfScrollingGroupName {
    return [NSString stringWithFormat:@"%@-%p", @"wolfScrollGroup", self];
}

@end

#endif
