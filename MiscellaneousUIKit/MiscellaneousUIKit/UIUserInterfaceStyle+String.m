//
//  UIUserInterfaceStyle+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import "UIUserInterfaceStyle+String.h"

NSString * NSStringFromUIUserInterfaceStyle(UIUserInterfaceStyle style) {
    switch (style) {
        case UIUserInterfaceStyleUnspecified:
            return @"Unspecified";
        case UIUserInterfaceStyleLight:
            return @"Light";
        case UIUserInterfaceStyleDark:
            return @"Dark";
        default:
            abort();
    }
}

UIUserInterfaceStyle UIUserInterfaceStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Unspecified"]) {
        return UIUserInterfaceStyleUnspecified;
    } else if ([string isEqualToString:@"Light"]) {
        return UIUserInterfaceStyleLight;
    } else if ([string isEqualToString:@"Dark"]) {
        return UIUserInterfaceStyleDark;
    } else {
        abort();
    }
}

const UIUserInterfaceStyle * allUIUserInterfaceStyles(NSUInteger * _Nullable count) {
    static const UIUserInterfaceStyle values[] = {
        UIUserInterfaceStyleUnspecified,
        UIUserInterfaceStyleLight,
        UIUserInterfaceStyleDark
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(UIUserInterfaceStyle);
    }
    return values;
}
