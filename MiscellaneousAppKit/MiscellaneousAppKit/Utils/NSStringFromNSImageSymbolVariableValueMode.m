//
//  NSStringFromNSImageSymbolVariableValueMode.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/23/25.
//

#import "NSStringFromNSImageSymbolVariableValueMode.h"

NSString * NSStringFromNSImageSymbolVariableValueMode(NSImageSymbolVariableValueMode mode) {
    switch (mode) {
        case NSImageSymbolVariableValueModeAutomatic:
            return @"Automatic";
        case NSImageSymbolVariableValueModeColor:
            return @"Color";
        case NSImageSymbolVariableValueModeDraw:
            return @"Draw";
        default:
            abort();
    }
}

NSImageSymbolVariableValueMode NSImageSymbolVariableValueModeFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return NSImageSymbolVariableValueModeAutomatic;
    } else if ([string isEqualToString:@"Color"]) {
        return NSImageSymbolVariableValueModeColor;
    } else if ([string isEqualToString:@"Draw"]) {
        return NSImageSymbolVariableValueModeDraw;
    } else {
        abort();
    }
}

const NSImageSymbolVariableValueMode * allNSImageSymbolVariableValueModes(NSUInteger * _Nullable count) {
    static const NSImageSymbolVariableValueMode values[] = {
        NSImageSymbolVariableValueModeAutomatic,
        NSImageSymbolVariableValueModeColor,
        NSImageSymbolVariableValueModeDraw
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSImageSymbolVariableValueMode);
    }
    return values;
}
