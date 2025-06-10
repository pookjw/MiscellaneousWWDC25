//
//  UITabBarMinimizeBehavior+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import <UIKit/UIKit.h>
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUITabBarMinimizeBehavior(UITabBarMinimizeBehavior behavior);
MUK_EXTERN UITabBarMinimizeBehavior UITabBarMinimizeBehaviorFromString(NSString *string);
MUK_EXTERN const UITabBarMinimizeBehavior * allUITabBarMinimizeBehaviors(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
