//
//  UIHDRHeadroomUsageLimit+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import "UIHDRHeadroomUsageLimit+String.h"

typedef NS_ENUM(NSInteger, _UIHDRHeadroomUsageLimit) {
    /// Headroom usage limits are not defined
    _UIHDRHeadroomUsageLimitUnspecified = -1,
    /// Headroom usage limits are in effect, HDR headroom usage should be restricted
    _UIHDRHeadroomUsageLimitEnabled,
    /// Headroom usage limits are disabled, HDR headroom usage is unrestricted.
    _UIHDRHeadroomUsageLimitDisabled,
};

NSString * NSStringFromUIHDRHeadroomUsageLimit(UIHDRHeadroomUsageLimit limit) {
    switch (limit) {
        case UIHDRHeadroomUsageLimitUnspecified:
            return @"Unspecified";
//#ifdef __APPLE_BLEACH_SDK__
        case _UIHDRHeadroomUsageLimitEnabled:
            return @"Enabled";
        case _UIHDRHeadroomUsageLimitDisabled:
            return @"Disabled";
//#endif
        default:
            abort();
    }
}

UIHDRHeadroomUsageLimit UIHDRHeadroomUsageLimitFromString(NSString *string) {
    if ([string isEqualToString:@"Unspecified"]) {
        return UIHDRHeadroomUsageLimitUnspecified;
//#ifdef __APPLE_BLEACH_SDK__
    } else if ([string isEqualToString:@"Enabled"]) {
        return _UIHDRHeadroomUsageLimitDisabled;
    } else if ([string isEqualToString:@"Disabled"]) {
        return _UIHDRHeadroomUsageLimitDisabled;
//#endif
    } else {
        abort();
    }
}

const UIHDRHeadroomUsageLimit * allUIHDRHeadroomUsageLimits(NSUInteger * _Nullable count) {
    static const UIHDRHeadroomUsageLimit limits[] = {
        UIHDRHeadroomUsageLimitUnspecified,
//#ifdef __APPLE_BLEACH_SDK__
        _UIHDRHeadroomUsageLimitDisabled,
        _UIHDRHeadroomUsageLimitDisabled,
//#endif
    };
    if (count != NULL) {
        *count = sizeof(limits) / sizeof(UIHDRHeadroomUsageLimit);
    }
    return limits;
}
