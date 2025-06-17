//
//  UIMenuSystemElementGroupPreference+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import <UIKit/UIKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUIMenuSystemElementGroupPreference(UIMenuSystemElementGroupPreference preference);
MUK_EXTERN UIMenuSystemElementGroupPreference UIMenuSystemElementGroupPreferenceFromString(NSString *string);
MUK_EXTERN const UIMenuSystemElementGroupPreference * allUIMenuSystemElementGroupPreferences(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
