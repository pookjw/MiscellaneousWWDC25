//
//  NSStringFromNSButtonType.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSButtonType(NSButtonType type);
MA_EXTERN NSButtonType NSButtonTypeFromString(NSString *string);
MA_EXTERN const NSButtonType * allNSButtonTypes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
