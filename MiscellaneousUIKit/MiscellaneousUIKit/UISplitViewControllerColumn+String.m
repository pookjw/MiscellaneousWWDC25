//
//  UISplitViewControllerColumn+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "UISplitViewControllerColumn+String.h"

NSString * NSStringFromUISplitViewControllerColumn(UISplitViewControllerColumn column) {
    switch (column) {
        case UISplitViewControllerColumnPrimary:
            return @"Primary";
        case UISplitViewControllerColumnSupplementary:
            return @"Supplementary";
        case UISplitViewControllerColumnSecondary:
            return @"Secondary";
        case UISplitViewControllerColumnCompact:
            return @"Compact";
        case UISplitViewControllerColumnInspector:
            return @"Inspector";
        default:
            abort();
    }
}

UISplitViewControllerColumn UISplitViewControllerColumnFromString(NSString *string) {
    if ([string isEqualToString:@"Primary"]) {
        return UISplitViewControllerColumnPrimary;
    } else if ([string isEqualToString:@"Supplementary"]) {
        return UISplitViewControllerColumnSupplementary;
    } else if ([string isEqualToString:@"Secondary"]) {
        return UISplitViewControllerColumnSecondary;
    } else if ([string isEqualToString:@"Compact"]) {
        return UISplitViewControllerColumnCompact;
    } else if ([string isEqualToString:@"Inspector"]) {
        return UISplitViewControllerColumnInspector;
    } else {
        abort();
    }
}

const UISplitViewControllerColumn * allUISplitViewControllerColumns(NSUInteger * _Nullable count) {
    static const UISplitViewControllerColumn columns[] = {
        UISplitViewControllerColumnPrimary,
        UISplitViewControllerColumnSupplementary,
        UISplitViewControllerColumnSecondary,
        UISplitViewControllerColumnCompact,
        UISplitViewControllerColumnInspector
    };
    
    if (count != NULL) {
        *count = sizeof(columns) / sizeof(UISplitViewControllerColumn);
    }
    
    return columns;
}
