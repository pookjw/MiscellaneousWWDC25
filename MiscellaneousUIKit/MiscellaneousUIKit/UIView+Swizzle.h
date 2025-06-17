//
//  UIView+Swizzle.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Swizzle)
@property (class, nonatomic, readonly) void *_UIKeyShortcutHUDConfiguration_customKey;
@end

NS_ASSUME_NONNULL_END
