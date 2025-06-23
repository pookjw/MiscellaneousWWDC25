//
//  NSStringFromNSImageSymbolColorRenderingMode.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSImageSymbolColorRenderingMode(NSImageSymbolColorRenderingMode mode);
MA_EXTERN NSImageSymbolColorRenderingMode NSImageSymbolColorRenderingModeFromString(NSString *string);
MA_EXTERN const NSImageSymbolColorRenderingMode * allNSImageSymbolColorRenderingModes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
