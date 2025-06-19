//
//  NSStringFromNSControlSize.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSControlSize(NSControlSize size);
MA_EXTERN NSControlSize NSControlSizeFromString(NSString *string);
MA_EXTERN const NSControlSize * allNSControlSizes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
