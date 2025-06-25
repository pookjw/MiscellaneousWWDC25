//
//  NSStringFromNSTintProminence.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/25/25.
//

#import "NSStringFromNSTintProminence.h"

NSString * NSStringFromNSTintProminence(NSTintProminence prominence) {
    switch (prominence) {
        case NSTintProminenceAutomatic:
            return @"Automatic";
        case NSTintProminenceNone:
            return @"None";
        case NSTintProminencePrimary:
            return @"Primary";
        case NSTintProminenceSecondary:
            return @"Secondary";
        default:
            abort();
    }
}

NSTintProminence NSTintProminenceFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return NSTintProminenceAutomatic;
    } else if ([string isEqualToString:@"None"]) {
        return NSTintProminenceNone;
    } else if ([string isEqualToString:@"Primary"]) {
        return NSTintProminencePrimary;
    } else if ([string isEqualToString:@"Secondary"]) {
        return NSTintProminenceSecondary;
    } else {
        abort();
    }
}

const NSTintProminence * allNSTintProminences(NSUInteger * _Nullable count) {
    static const NSTintProminence values[] = {
        NSTintProminenceAutomatic,
        NSTintProminenceNone,
        NSTintProminencePrimary,
        NSTintProminenceSecondary
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSTintProminence);
    }
    return values;
}
