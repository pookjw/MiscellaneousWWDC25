//
//  UIHDRHeadroomUsageLimit+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import <UIKit/UIKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUIHDRHeadroomUsageLimit(UIHDRHeadroomUsageLimit limit);
MUK_EXTERN UIHDRHeadroomUsageLimit UIHDRHeadroomUsageLimitFromString(NSString *string);
MUK_EXTERN const UIHDRHeadroomUsageLimit * allUIHDRHeadroomUsageLimits(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
