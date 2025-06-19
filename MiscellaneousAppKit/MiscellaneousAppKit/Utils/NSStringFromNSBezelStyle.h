//
//  NSStringFromNSBezelStyle.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSBezelStyle(NSBezelStyle style);
MA_EXTERN NSBezelStyle NSBezelStyleFromString(NSString *string);
MA_EXTERN const NSBezelStyle * allNSBezelStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
