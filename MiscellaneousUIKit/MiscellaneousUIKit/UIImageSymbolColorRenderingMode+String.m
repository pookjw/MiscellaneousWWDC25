//
//  UIImageSymbolColorRenderingMode+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import "UIImageSymbolColorRenderingMode+String.h"

NSString * NSStringFromUIImageSymbolColorRenderingMode(UIImageSymbolColorRenderingMode mode) {
    switch (mode) {
        case UIImageSymbolColorRenderingModeAutomatic:
            return @"Automatic";
        case UIImageSymbolColorRenderingModeFlat:
            return @"Flat";
        case UIImageSymbolColorRenderingModeGradient:
            return @"Gradient";
        default:
            abort();
    }
}

UIImageSymbolColorRenderingMode UIImageSymbolColorRenderingModeFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return UIImageSymbolColorRenderingModeAutomatic;
    } else if ([string isEqualToString:@"Flat"]) {
        return UIImageSymbolColorRenderingModeFlat;
    } else if ([string isEqualToString:@"Gradient"]) {
        return UIImageSymbolColorRenderingModeGradient;
    } else {
        abort();
    }
}

const UIImageSymbolColorRenderingMode * allUIImageSymbolColorRenderingModes(NSUInteger * _Nullable count) {
    static const UIImageSymbolColorRenderingMode values[] = {
        UIImageSymbolColorRenderingModeAutomatic,
        UIImageSymbolColorRenderingModeFlat,
        UIImageSymbolColorRenderingModeGradient
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(UIImageSymbolColorRenderingMode);
    }
    return values;
}
