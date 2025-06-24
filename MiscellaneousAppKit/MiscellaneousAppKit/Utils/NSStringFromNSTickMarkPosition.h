//
//  NSStringFromNSTickMarkPosition.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSTickMarkPosition(NSTickMarkPosition position);
MA_EXTERN NSTickMarkPosition NSTickMarkPositionFromString(NSString *string);
MA_EXTERN const NSTickMarkPosition * allNSTickMarkPositions(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
