//
//  UIMenuSystemFindElementGroupConfigurationStyle+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import <UIKit/UIKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUIMenuSystemFindElementGroupConfigurationStyle(UIMenuSystemFindElementGroupConfigurationStyle style);
MUK_EXTERN UIMenuSystemFindElementGroupConfigurationStyle UIMenuSystemFindElementGroupConfigurationStyleFromString(NSString *string);
MUK_EXTERN const UIMenuSystemFindElementGroupConfigurationStyle * allUIMenuSystemFindElementGroupConfigurationStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
