//
//  NSStringFromNSSplitViewItemBehavior.m
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/24/25.
//

#import "NSStringFromNSSplitViewItemBehavior.h"

NSString * NSStringFromNSSplitViewItemBehavior(NSSplitViewItemBehavior behavior) {
    switch (behavior) {
        case NSSplitViewItemBehaviorDefault:
            return @"Default";
        case NSSplitViewItemBehaviorSidebar:
            return @"Sidebar";
        case NSSplitViewItemBehaviorContentList:
            return @"Content List";
        case NSSplitViewItemBehaviorInspector:
            return @"Inspector";
        default:
            abort();
    }
}

NSSplitViewItemBehavior NSSplitViewItemBehaviorFromString(NSString *string) {
    if ([string isEqualToString:@"Default"]) {
        return NSSplitViewItemBehaviorDefault;
    } else if ([string isEqualToString:@"Sidebar"]) {
        return NSSplitViewItemBehaviorSidebar;
    } else if ([string isEqualToString:@"Content List"]) {
        return NSSplitViewItemBehaviorContentList;
    } else if ([string isEqualToString:@"Inspector"]) {
        return NSSplitViewItemBehaviorInspector;
    } else {
        abort();
    }
}

const NSSplitViewItemBehavior * allNSSplitViewItemBehaviors(NSUInteger * _Nullable count) {
    static const NSSplitViewItemBehavior values[] = {
        NSSplitViewItemBehaviorDefault,
        NSSplitViewItemBehaviorSidebar,
        NSSplitViewItemBehaviorContentList,
        NSSplitViewItemBehaviorInspector
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(NSSplitViewItemBehavior);
    }
    return values;
}
