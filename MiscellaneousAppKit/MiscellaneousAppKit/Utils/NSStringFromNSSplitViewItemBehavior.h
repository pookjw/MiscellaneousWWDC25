//
//  NSStringFromNSSplitViewItemBehavior.h
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import <Cocoa/Cocoa.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MA_EXTERN NSString * NSStringFromNSSplitViewItemBehavior(NSSplitViewItemBehavior behavior);
MA_EXTERN NSSplitViewItemBehavior NSSplitViewItemBehaviorFromString(NSString *string);
MA_EXTERN const NSSplitViewItemBehavior * allNSSplitViewItemBehaviors(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
