//
//  NSStringFromNSToolbarItemStyle.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/25/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSToolbarItemStyle(NSToolbarItemStyle style);
MA_EXTERN NSToolbarItemStyle NSToolbarItemStyleFromString(NSString *string);
MA_EXTERN const NSToolbarItemStyle * allNSToolbarItemStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
