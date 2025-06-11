//
//  UINavigationItemSearchBarPlacement+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import "UINavigationItemSearchBarPlacement+String.h"

NSString * NSStringFromUINavigationItemSearchBarPlacement(UINavigationItemSearchBarPlacement placement) {
    switch (placement) {
        case UINavigationItemSearchBarPlacementAutomatic:
            return @"Automatic";
        case UINavigationItemSearchBarPlacementIntegrated:
            return @"Integrated (Inline)";
        case UINavigationItemSearchBarPlacementStacked:
            return @"Stacked";
        case UINavigationItemSearchBarPlacementIntegratedCentered:
            return @"Integrated Centered";
        case UINavigationItemSearchBarPlacementIntegratedButton:
            return @"Integrated Button";
        default:
            abort();
    }
}

UINavigationItemSearchBarPlacement UINavigationItemSearchBarPlacementFromString(NSString *string) {
    if ([string isEqualToString:@"Automatic"]) {
        return UINavigationItemSearchBarPlacementAutomatic;
    } else if ([string isEqualToString:@"Integrated (Inline)"]) {
        return UINavigationItemSearchBarPlacementIntegrated;
    } else if ([string isEqualToString:@"Stacked"]) {
        return UINavigationItemSearchBarPlacementStacked;
    } else if ([string isEqualToString:@"Integrated Centered"]) {
        return UINavigationItemSearchBarPlacementIntegratedCentered;
    } else if ([string isEqualToString:@"Integrated Button"]) {
        return UINavigationItemSearchBarPlacementIntegratedButton;
    } else {
        abort();
    }
}

const UINavigationItemSearchBarPlacement * allUINavigationItemSearchBarPlacements(NSUInteger * _Nullable count) {
    static const UINavigationItemSearchBarPlacement values[] = {
        UINavigationItemSearchBarPlacementAutomatic,
        UINavigationItemSearchBarPlacementIntegrated,
        UINavigationItemSearchBarPlacementStacked,
        UINavigationItemSearchBarPlacementIntegratedCentered,
        UINavigationItemSearchBarPlacementIntegratedButton,
    };
    if (count != NULL) {
        *count = sizeof(values) / sizeof(UINavigationItemSearchBarPlacement);
    }
    return values;
}
