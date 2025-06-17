//
//  UIMenuSystemFindElementGroupConfigurationStyle+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "UIMenuSystemFindElementGroupConfigurationStyle+String.h"

NSString * NSStringFromUIMenuSystemFindElementGroupConfigurationStyle(UIMenuSystemFindElementGroupConfigurationStyle style) {
    switch (style) {
        case UIMenuSystemFindElementGroupConfigurationStyleAutomatic:
            return @"Automatic";
        case UIMenuSystemFindElementGroupConfigurationStyleSearch:
            return @"Search";
        case UIMenuSystemFindElementGroupConfigurationStyleNonEditableText:
            return @"Non-Editable Text";
        case UIMenuSystemFindElementGroupConfigurationStyleEditableText:
            return @"Editable Text";
        default:
            abort();
    }
}

UIMenuSystemFindElementGroupConfigurationStyle UIMenuSystemFindElementGroupConfigurationStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return UIMenuSystemFindElementGroupConfigurationStyleAutomatic;
    } else if ([string isEqualToString:@"Search"]) {
        return UIMenuSystemFindElementGroupConfigurationStyleSearch;
    } else if ([string isEqualToString:@"Non-Editable Text"]) {
        return UIMenuSystemFindElementGroupConfigurationStyleNonEditableText;
    } else if ([string isEqualToString:@"Editable Text"]) {
        return UIMenuSystemFindElementGroupConfigurationStyleEditableText;
    } else {
        abort();
    }
}

const UIMenuSystemFindElementGroupConfigurationStyle * allUIMenuSystemFindElementGroupConfigurationStyles(NSUInteger * _Nullable count) {
    static const UIMenuSystemFindElementGroupConfigurationStyle values[] = {
        UIMenuSystemFindElementGroupConfigurationStyleAutomatic,
        UIMenuSystemFindElementGroupConfigurationStyleSearch,
        UIMenuSystemFindElementGroupConfigurationStyleNonEditableText,
        UIMenuSystemFindElementGroupConfigurationStyleEditableText
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(UIMenuSystemFindElementGroupConfigurationStyle);
    }
    return values;
}
