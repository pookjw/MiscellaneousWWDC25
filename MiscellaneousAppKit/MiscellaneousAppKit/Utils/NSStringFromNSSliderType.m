//
//  NSStringFromNSSliderType.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import "NSStringFromNSSliderType.h"

NSString * NSStringFromNSSliderType(NSSliderType type) {
    switch (type) {
        case NSSliderTypeLinear:
            return @"Linear";
        case NSSliderTypeCircular:
            return @"Circular";
        default:
            abort();
    }
}

NSSliderType NSSliderTypeFromString(NSString *string) {
    if ([string isEqualToString:@"Linear"]) {
        return NSSliderTypeLinear;
    } else if ([string isEqualToString:@"Circular"]) {
        return NSSliderTypeCircular;
    } else {
        abort();
    }
}

const NSSliderType * allNSSliderTypes(NSUInteger * _Nullable count) {
    static const NSSliderType values[] = {
        NSSliderTypeLinear,
        NSSliderTypeCircular
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSSliderType);
    }
    return values;
}
