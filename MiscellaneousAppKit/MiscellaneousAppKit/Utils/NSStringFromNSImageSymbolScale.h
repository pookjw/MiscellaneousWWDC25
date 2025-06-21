//
//  NSStringFromNSImageSymbolScale.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/22/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSImageSymbolScale(NSImageSymbolScale scale);
MA_EXTERN NSImageSymbolScale NSImageSymbolScaleFromString(NSString *string);
MA_EXTERN const NSImageSymbolScale * allNSImageSymbolScales(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
