//
//  NSStringFromNSBezelStyle.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/20/25.
//

#import "NSStringFromNSBezelStyle.h"

NSString * NSStringFromNSBezelStyle(NSBezelStyle style) {
    switch (style) {
        case NSBezelStyleAutomatic:
            return @"Automatic";
        case NSBezelStylePush:
            return @"Push";
        case NSBezelStyleFlexiblePush:
            return @"Flexible Push";
        case NSBezelStyleDisclosure:
            return @"Disclosure";
        case NSBezelStyleCircular:
            return @"Circular";
        case NSBezelStyleHelpButton:
            return @"Help Button";
        case NSBezelStyleSmallSquare:
            return @"Small Square";
        case NSBezelStyleToolbar:
            return @"Toolbar";
        case NSBezelStyleAccessoryBarAction:
            return @"Accessory Bar Action";
        case NSBezelStyleAccessoryBar:
            return @"Accessory Bar";
        case NSBezelStylePushDisclosure:
            return @"Push Disclosure";
        case NSBezelStyleBadge:
            return @"Badge";
        case NSBezelStyleGlass:
            return @"Glass";
        default:
            abort();
    }
}

NSBezelStyle NSBezelStyleFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return NSBezelStyleAutomatic;
    } else if ([string isEqualToString:@"Push"]) {
        return NSBezelStylePush;
    } else if ([string isEqualToString:@"Flexible Push"]) {
        return NSBezelStyleFlexiblePush;
    } else if ([string isEqualToString:@"Disclosure"]) {
        return NSBezelStyleDisclosure;
    } else if ([string isEqualToString:@"Circular"]) {
        return NSBezelStyleCircular;
    } else if ([string isEqualToString:@"Help Button"]) {
        return NSBezelStyleHelpButton;
    } else if ([string isEqualToString:@"Small Square"]) {
        return NSBezelStyleSmallSquare;
    } else if ([string isEqualToString:@"Toolbar"]) {
        return NSBezelStyleToolbar;
    } else if ([string isEqualToString:@"Accessory Bar Action"]) {
        return NSBezelStyleAccessoryBarAction;
    } else if ([string isEqualToString:@"Accessory Bar"]) {
        return NSBezelStyleAccessoryBar;
    } else if ([string isEqualToString:@"Push Disclosure"]) {
        return NSBezelStylePushDisclosure;
    } else if ([string isEqualToString:@"Badge"]) {
        return NSBezelStyleBadge;
    } else if ([string isEqualToString:@"Glass"]) {
        return NSBezelStyleGlass;
    } else {
        abort();
    }
}

const NSBezelStyle * allNSBezelStyles(NSUInteger * _Nullable count) {
    static const NSBezelStyle values[] = {
        NSBezelStyleAutomatic,
        NSBezelStylePush,
        NSBezelStyleFlexiblePush,
        NSBezelStyleDisclosure,
        NSBezelStyleCircular,
        NSBezelStyleHelpButton,
        NSBezelStyleSmallSquare,
        NSBezelStyleToolbar,
        NSBezelStyleAccessoryBarAction,
        NSBezelStyleAccessoryBar,
        NSBezelStylePushDisclosure,
        NSBezelStyleBadge,
        NSBezelStyleGlass
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSBezelStyle);
    }
    return values;
}
