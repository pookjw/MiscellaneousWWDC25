//
//  UIMenuSystemElementGroupPreference+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "UIMenuSystemElementGroupPreference+String.h"

NSString * NSStringFromUIMenuSystemElementGroupPreference(UIMenuSystemElementGroupPreference preference) {
    switch (preference) {
        case UIMenuSystemElementGroupPreferenceAutomatic:
            return @"Automatic";
        case UIMenuSystemElementGroupPreferenceRemoved:
            return @"Removed";
        case UIMenuSystemElementGroupPreferenceIncluded:
            return @"Included";
        default:
            abort();
    }
}

UIMenuSystemElementGroupPreference UIMenuSystemElementGroupPreferenceFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return UIMenuSystemElementGroupPreferenceAutomatic;
    } else if ([string isEqualToString:@"Removed"]) {
        return UIMenuSystemElementGroupPreferenceRemoved;
    } else if ([string isEqualToString:@"Included"]) {
        return UIMenuSystemElementGroupPreferenceIncluded;
    } else {
        abort();
    }
}

const UIMenuSystemElementGroupPreference * allUIMenuSystemElementGroupPreferences(NSUInteger * _Nullable count) {
    static const UIMenuSystemElementGroupPreference values[] = {
        UIMenuSystemElementGroupPreferenceAutomatic,
        UIMenuSystemElementGroupPreferenceRemoved,
        UIMenuSystemElementGroupPreferenceIncluded
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(UIMenuSystemElementGroupPreference);
    }
    return values;
}
