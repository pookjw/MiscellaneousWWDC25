//
//  NSStringFromNSButtonType.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import "NSStringFromNSButtonType.h"

NSString * NSStringFromNSButtonType(NSButtonType type) {
    switch (type) {
        case NSButtonTypeMomentaryLight:
            return @"Momentary Light";
        case NSButtonTypePushOnPushOff:
            return @"Push On Push Off";
        case NSButtonTypeToggle:
            return @"Toggle";
        case NSButtonTypeSwitch:
            return @"Switch";
        case NSButtonTypeRadio:
            return @"Radio";
        case NSButtonTypeMomentaryChange:
            return @"Momentary Change";
        case NSButtonTypeOnOff:
            return @"On Off";
        case NSButtonTypeMomentaryPushIn:
            return @"Momentary Push In";
        case NSButtonTypeAccelerator:
            return @"Accelerator";
        case NSButtonTypeMultiLevelAccelerator:
            return @"Multi-Level Accelerator";
        case -1:
            return @"Unknown";
        default:
            abort();
    }
}

NSButtonType NSButtonTypeFromString(NSString *string) {
    if ([string isEqualToString:@"Momentary Light"]) {
        return NSButtonTypeMomentaryLight;
    } else if ([string isEqualToString:@"Push On Push Off"]) {
        return NSButtonTypePushOnPushOff;
    } else if ([string isEqualToString:@"Toggle"]) {
        return NSButtonTypeToggle;
    } else if ([string isEqualToString:@"Switch"]) {
        return NSButtonTypeSwitch;
    } else if ([string isEqualToString:@"Radio"]) {
        return NSButtonTypeRadio;
    } else if ([string isEqualToString:@"Momentary Change"]) {
        return NSButtonTypeMomentaryChange;
    } else if ([string isEqualToString:@"On Off"]) {
        return NSButtonTypeOnOff;
    } else if ([string isEqualToString:@"Momentary Push In"]) {
        return NSButtonTypeMomentaryPushIn;
    } else if ([string isEqualToString:@"Accelerator"]) {
        return NSButtonTypeAccelerator;
    } else if ([string isEqualToString:@"Multi-Level Accelerator"]) {
        return NSButtonTypeMultiLevelAccelerator;
    } else if ([string isEqualToString:@"Unknown"]) {
        return -1;
    } else {
        abort();
    }
}

const NSButtonType * allNSButtonTypes(NSUInteger * _Nullable count) {
    static const NSButtonType values[] = {
        NSButtonTypeMomentaryLight,
        NSButtonTypePushOnPushOff,
        NSButtonTypeToggle,
        NSButtonTypeSwitch,
        NSButtonTypeRadio,
        NSButtonTypeMomentaryChange,
        NSButtonTypeOnOff,
        NSButtonTypeMomentaryPushIn,
        NSButtonTypeAccelerator,
        NSButtonTypeMultiLevelAccelerator,
        -1
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSButtonType);
    }
    return values;
}
