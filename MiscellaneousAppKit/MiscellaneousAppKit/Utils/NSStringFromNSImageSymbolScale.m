//
//  NSStringFromNSImageSymbolScale.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/22/25.
//

#import "NSStringFromNSImageSymbolScale.h"

NSString * NSStringFromNSImageSymbolScale(NSImageSymbolScale scale) {
    switch (scale) {
        case NSImageSymbolScaleSmall:
            return @"Small";
        case NSImageSymbolScaleMedium:
            return @"Medium";
        case NSImageSymbolScaleLarge:
            return @"Large";
        default:
            return @"Unknown";
    }
}

NSImageSymbolScale NSImageSymbolScaleFromString(NSString *string) {
    if ([string isEqualToString:@"Small"]) {
        return NSImageSymbolScaleSmall;
    } else if ([string isEqualToString:@"Medium"]) {
        return NSImageSymbolScaleMedium;
    } else if ([string isEqualToString:@"Large"]) {
        return NSImageSymbolScaleLarge;
    } else {
        abort();
    }
}

const NSImageSymbolScale * allNSImageSymbolScales(NSUInteger * _Nullable count) {
    static const NSImageSymbolScale values[] = {
        NSImageSymbolScaleSmall,
        NSImageSymbolScaleMedium,
        NSImageSymbolScaleLarge
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSImageSymbolScale);
    }
    return values;
}
