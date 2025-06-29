//
//  UITabBarMinimizeBehavior+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import "UITabBarMinimizeBehavior+String.h"

#if !TARGET_OS_VISION

NSString * NSStringFromUITabBarMinimizeBehavior(UITabBarMinimizeBehavior behavior) {
    switch (behavior) {
        case UITabBarMinimizeBehaviorAutomatic:
            return @"Automatic";
        case UITabBarMinimizeBehaviorNever:
            return @"Never";
        case UITabBarMinimizeBehaviorOnScrollDown:
            return @"On Scroll Down";
        case UITabBarMinimizeBehaviorOnScrollUp:
            return @"On Scroll Up";
        default:
            abort();
    }
}

UITabBarMinimizeBehavior UITabBarMinimizeBehaviorFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return UITabBarMinimizeBehaviorAutomatic;
    } else if ([string isEqualToString:@"Never"]) {
        return UITabBarMinimizeBehaviorNever;
    } else if ([string isEqualToString:@"On Scroll Down"]) {
        return UITabBarMinimizeBehaviorOnScrollDown;
    } else if ([string isEqualToString:@"On Scroll Up"]) {
        return UITabBarMinimizeBehaviorOnScrollUp;
    } else {
        abort();
    }
}

const UITabBarMinimizeBehavior * allUITabBarMinimizeBehaviors(NSUInteger * _Nullable count) {
    static const UITabBarMinimizeBehavior behaviors[] = {
        UITabBarMinimizeBehaviorAutomatic,
        UITabBarMinimizeBehaviorNever,
        UITabBarMinimizeBehaviorOnScrollDown,
        UITabBarMinimizeBehaviorOnScrollUp
    };
    
    if (count != NULL) {
        *count = sizeof(behaviors) / sizeof(UITabBarMinimizeBehavior);
    }
    
    return behaviors;
}

#endif
