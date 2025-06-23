//
//  NSStringFromNSImageSymbolColorRenderingMode.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/25.
//

#import "NSStringFromNSImageSymbolColorRenderingMode.h"

NSString * NSStringFromNSImageSymbolColorRenderingMode(NSImageSymbolColorRenderingMode mode) {
    switch (mode) {
        case NSImageSymbolColorRenderingModeAutomatic:
            return @"Automatic";
        case NSImageSymbolColorRenderingModeFlat:
            return @"Flat";
        case NSImageSymbolColorRenderingModeGradient:
            return @"Gradient";
        default:
            abort();
    }
}

NSImageSymbolColorRenderingMode NSImageSymbolColorRenderingModeFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return NSImageSymbolColorRenderingModeAutomatic;
    } else if ([string isEqualToString:@"Flat"]) {
        return NSImageSymbolColorRenderingModeFlat;
    } else if ([string isEqualToString:@"Gradient"]) {
        return NSImageSymbolColorRenderingModeGradient;
    } else {
        abort();
    }
}

const NSImageSymbolColorRenderingMode * allNSImageSymbolColorRenderingModes(NSUInteger * _Nullable count) {
    static const NSImageSymbolColorRenderingMode values[] = {
        NSImageSymbolColorRenderingModeAutomatic,
        NSImageSymbolColorRenderingModeFlat,
        NSImageSymbolColorRenderingModeGradient
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSImageSymbolColorRenderingMode);
    }
    return values;
}
