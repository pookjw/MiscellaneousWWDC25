//
//  NSStringFromNSTickMarkPosition.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import "NSStringFromNSTickMarkPosition.h"

NSString * NSStringFromNSTickMarkPosition(NSTickMarkPosition position) {
    switch (position) {
        case NSTickMarkPositionBelow:
            return @"Below";
        case NSTickMarkPositionAbove:
            return @"Above";
        default:
            abort();
    }
}

NSTickMarkPosition NSTickMarkPositionFromString(NSString *string) {
    if ([string isEqualToString:@"Leading"]) {
        return NSTickMarkPositionLeading;
    } else if ([string isEqualToString:@"Trailing"]) {
        return NSTickMarkPositionTrailing;
    } else if ([string isEqualToString:@"Below"]) {
        return NSTickMarkPositionBelow;
    } else if ([string isEqualToString:@"Above"]) {
        return NSTickMarkPositionAbove;
    } else {
        abort();
    }
}

const NSTickMarkPosition * allNSTickMarkPositions(NSUInteger * _Nullable count) {
    static const NSTickMarkPosition values[] = {
        NSTickMarkPositionBelow,
        NSTickMarkPositionAbove,
//        NSTickMarkPositionLeading,
//        NSTickMarkPositionTrailing
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSTickMarkPosition);
    }
    return values;
}
