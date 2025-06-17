//
//  UISplitViewControllerLayoutEnvironment+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//

#import "UISplitViewControllerLayoutEnvironment+String.h"

NSString * NSStringFromUISplitViewControllerLayoutEnvironment(UISplitViewControllerLayoutEnvironment environment) {
    switch (environment) {
        case UISplitViewControllerLayoutEnvironmentNone:
            return @"None";
        case UISplitViewControllerLayoutEnvironmentExpanded:
            return @"Expanded";
        case UISplitViewControllerLayoutEnvironmentCollapsed:
            return @"Collapsed";
        default:
            abort();
    }
}

UISplitViewControllerLayoutEnvironment UISplitViewControllerLayoutEnvironmentFromString(NSString *string) {
    if ([string isEqualToString:@"None"]) {
        return UISplitViewControllerLayoutEnvironmentNone;
    } else if ([string isEqualToString:@"Expanded"]) {
        return UISplitViewControllerLayoutEnvironmentExpanded;
    } else if ([string isEqualToString:@"Collapsed"]) {
        return UISplitViewControllerLayoutEnvironmentCollapsed;
    } else {
        abort();
    }
}

const UISplitViewControllerLayoutEnvironment * allUISplitViewControllerLayoutEnvironments(NSUInteger * _Nullable count) {
    static const UISplitViewControllerLayoutEnvironment values[] = {
        UISplitViewControllerLayoutEnvironmentNone,
        UISplitViewControllerLayoutEnvironmentExpanded,
        UISplitViewControllerLayoutEnvironmentCollapsed
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(UISplitViewControllerLayoutEnvironment);
    }
    return values;
}
