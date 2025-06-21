//
//  NSStringFromNSFontWeight.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/22/25.
//

#import "NSStringFromNSFontWeight.h"

NSString * NSStringFromNSFontWeight(NSFontWeight weight) {
    if (weight == NSFontWeightUltraLight) {
        return @"Ultra Light";
    } else if (weight == NSFontWeightThin) {
        return @"Thin";
    } else if (weight == NSFontWeightLight) {
        return @"Light";
    } else if (weight == NSFontWeightRegular) {
        return @"Regular";
    } else if (weight == NSFontWeightMedium) {
        return @"Medium";
    } else if (weight == NSFontWeightSemibold) {
        return @"Semibold";
    } else if (weight == NSFontWeightBold) {
        return @"Bold";
    } else if (weight == NSFontWeightHeavy) {
        return @"Heavy";
    } else if (weight == NSFontWeightBlack) {
        return @"Black";
    } else {
        abort();
    }
}

NSFontWeight NSFontWeightFromString(NSString *string) {
    if ([string isEqualToString:@"Ultra Light"]) {
        return NSFontWeightUltraLight;
    } else if ([string isEqualToString:@"Thin"]) {
        return NSFontWeightThin;
    } else if ([string isEqualToString:@"Light"]) {
        return NSFontWeightLight;
    } else if ([string isEqualToString:@"Regular"]) {
        return NSFontWeightRegular;
    } else if ([string isEqualToString:@"Medium"]) {
        return NSFontWeightMedium;
    } else if ([string isEqualToString:@"Semibold"]) {
        return NSFontWeightSemibold;
    } else if ([string isEqualToString:@"Bold"]) {
        return NSFontWeightBold;
    } else if ([string isEqualToString:@"Heavy"]) {
        return NSFontWeightHeavy;
    } else if ([string isEqualToString:@"Black"]) {
        return NSFontWeightBlack;
    } else {
        abort();
    }
}

const NSFontWeight * allNSFontWeights(NSUInteger * _Nullable count) {
    static const NSFontWeight values[] = {
        NSFontWeightUltraLight,
        NSFontWeightThin,
        NSFontWeightLight,
        NSFontWeightRegular,
        NSFontWeightMedium,
        NSFontWeightSemibold,
        NSFontWeightBold,
        NSFontWeightHeavy,
        NSFontWeightBlack
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSFontWeight);
    }
    return values;
}
