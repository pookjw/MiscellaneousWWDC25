//
//  AnimationState.mm
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "AnimationState.h"

@implementation AnimationState

- (void)animateWithDeltaTime:(NSTimeInterval)deltaTime {
    switch (_value) {
        case AnimationStateValueIdle:
        case AnimationStateValueFloating:
            break;
        case AnimationStateValueExpanding: {
            NSTimeInterval newProgress = _progress.value() + deltaTime / 1.;
            if (newProgress > 1.) {
                _value = AnimationStateValueFloating;
                _progress = std::nullopt;
            } else {
                _value = AnimationStateValueExpanding;
                _progress = newProgress;
            }
            break;
        }
        case AnimationStateValueContracting: {
            NSTimeInterval newProgress = _progress.value() + deltaTime / 1.;
            if (newProgress > 1.) {
                _value = AnimationStateValueIdle;
                _progress = std::nullopt;
            } else {
                _value = AnimationStateValueContracting;
                _progress = newProgress;
            }
            break;
        }
    }
}

- (float)transformBlend {
    switch (_value) {
        case AnimationStateValueIdle:
            return 0.f;
        case AnimationStateValueExpanding:
            return 1.f;
        case AnimationStateValueFloating:
            return _progress.value();
        case AnimationStateValueContracting:
            return 1.f - _progress.value();
    }
}

- (BOOL)hasHover {
    return _value == AnimationStateValueIdle;
}

@end
