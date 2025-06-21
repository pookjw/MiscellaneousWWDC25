//
//  NSStringFromNSFontWeight.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/22/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSFontWeight(NSFontWeight weight);
MA_EXTERN NSFontWeight NSFontWeightFromString(NSString *string);
MA_EXTERN const NSFontWeight * allNSFontWeights(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
