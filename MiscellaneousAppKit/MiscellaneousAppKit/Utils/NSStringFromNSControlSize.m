//
//  NSStringFromNSControlSize.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import "NSStringFromNSControlSize.h"

NSString * NSStringFromNSControlSize(NSControlSize size) {
    switch (size) {
        case NSControlSizeRegular:
            return @"Regular";
        case NSControlSizeSmall:
            return @"Small";
        case NSControlSizeMini:
            return @"Mini";
        case NSControlSizeLarge:
            return @"Large";
        case NSControlSizeExtraLarge:
            return @"Extra Large";
        default:
            abort();
    }
}

NSControlSize NSControlSizeFromString(NSString *string) {
    if ([string isEqualToString:@"Regular"]) {
        return NSControlSizeRegular;
    } else if ([string isEqualToString:@"Small"]) {
        return NSControlSizeSmall;
    } else if ([string isEqualToString:@"Mini"]) {
        return NSControlSizeMini;
    } else if ([string isEqualToString:@"Large"]) {
        return NSControlSizeLarge;
    } else if ([string isEqualToString:@"Extra Large"]) {
        return NSControlSizeExtraLarge;
    } else {
        abort();
    }
}

const NSControlSize * allNSControlSizes(NSUInteger * _Nullable count) {
    static const NSControlSize values[] = {
        NSControlSizeRegular,
        NSControlSizeSmall,
        NSControlSizeMini,
        NSControlSizeLarge,
        NSControlSizeExtraLarge
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSControlSize);
    }
    return values;
}
