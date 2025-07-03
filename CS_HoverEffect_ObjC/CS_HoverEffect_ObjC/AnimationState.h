//
//  AnimationState.h
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import <Foundation/Foundation.h>
#include <optional>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AnimationStateValue) {
    AnimationStateValueIdle,
    AnimationStateValueExpanding,
    AnimationStateValueFloating,
    AnimationStateValueContracting
};

@interface AnimationState : NSObject
@property (assign, nonatomic) AnimationStateValue value;
@property (assign, nonatomic) std::optional<NSTimeInterval> progress;
- (void)animateWithDeltaTime:(NSTimeInterval)deltaTime;
@property (assign, nonatomic, readonly) float transformBlend;
@property (assign, nonatomic, readonly) BOOL hasHover;
@end

NS_ASSUME_NONNULL_END
