//
//  UIInterfaceOrientationMask+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import <UIKit/UIKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUIInterfaceOrientationMask(UIInterfaceOrientationMask mask);
MUK_EXTERN UIInterfaceOrientationMask UIInterfaceOrientationMaskFromString(NSString *string);
MUK_EXTERN const UIInterfaceOrientationMask * allUIInterfaceOrientationMasks(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
