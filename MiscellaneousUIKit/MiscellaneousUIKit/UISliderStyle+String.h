//
//  UISliderStyle+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/12/25.
//

#import <UIKit/UIKit.h>
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUISliderStyle(UISliderStyle style);
MUK_EXTERN UISliderStyle UISliderStyleFromString(NSString *string);
MUK_EXTERN const UISliderStyle * allUISliderStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
