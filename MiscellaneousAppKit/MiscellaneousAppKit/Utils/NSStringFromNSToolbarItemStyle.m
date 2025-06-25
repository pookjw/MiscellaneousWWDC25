//
//  NSStringFromNSToolbarItemStyle.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/25/25.
//

#import "NSStringFromNSToolbarItemStyle.h"

NSString * NSStringFromNSToolbarItemStyle(NSToolbarItemStyle style) {
    switch (style) {
        case NSToolbarItemStylePlain:
            return @"Plain";
        case NSToolbarItemStyleProminent:
            return @"Prominent";
        default:
            abort();
    }
}

NSToolbarItemStyle NSToolbarItemStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Plain"]) {
        return NSToolbarItemStylePlain;
    } else if ([string isEqualToString:@"Prominent"]) {
        return NSToolbarItemStyleProminent;
    } else {
        abort();
    }
}

const NSToolbarItemStyle * allNSToolbarItemStyles(NSUInteger * _Nullable count) {
    static const NSToolbarItemStyle values[] = {
        NSToolbarItemStylePlain,
        NSToolbarItemStyleProminent
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSToolbarItemStyle);
    }
    return values;
}
