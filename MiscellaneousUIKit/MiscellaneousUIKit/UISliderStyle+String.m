//
//  UISliderStyle+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/12/25.
//

#import "UISliderStyle+String.h"

NSString * NSStringFromUISliderStyle(UISliderStyle style) {
    switch (style) {
        case UISliderStyleDefault:
            return @"Default";
        case UISliderStyleThumbless:
            return @"Thumbless";
        default:
            abort();
    }
}

UISliderStyle UISliderStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Default"]) {
        return UISliderStyleDefault;
    } else if ([string isEqualToString:@"Thumbless"]) {
        return UISliderStyleThumbless;
    } else {
        abort();
    }
}

const UISliderStyle * allUISliderStyles(NSUInteger * _Nullable count) {
    static const UISliderStyle styles[] = {
        UISliderStyleDefault,
        UISliderStyleThumbless
    };
    if (count != NULL) {
        *count = sizeof(styles) / sizeof(UISliderStyle);
    }
    return styles;
}
