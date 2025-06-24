//
//  NSStringFromNSSliderType.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSSliderType(NSSliderType type);
MA_EXTERN NSSliderType NSSliderTypeFromString(NSString *string);
MA_EXTERN const NSSliderType * allNSSliderTypes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
