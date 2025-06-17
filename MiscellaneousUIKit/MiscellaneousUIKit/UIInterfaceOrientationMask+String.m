//
//  UIInterfaceOrientationMask+String.m
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import "UIInterfaceOrientationMask+String.h"

NSString * NSStringFromUIInterfaceOrientationMask(UIInterfaceOrientationMask mask) {
    if (mask == UIInterfaceOrientationMaskAll) {
        return @"All";
    }
    if (mask == UIInterfaceOrientationMaskAllButUpsideDown) {
        return @"All But Upside Down";
    }
    if (mask == UIInterfaceOrientationMaskLandscape) {
        return @"Landscape";
    }
    
    NSMutableArray<NSString *> *parts = [NSMutableArray new];
    if (mask & UIInterfaceOrientationMaskPortrait) {
        [parts addObject:@"Portrait"];
    }
    if (mask & UIInterfaceOrientationMaskLandscapeLeft) {
        [parts addObject:@"Landscape Left"];
    }
    if (mask & UIInterfaceOrientationMaskLandscapeRight) {
        [parts addObject:@"Landscape Right"];
    }
    if (mask & UIInterfaceOrientationMaskPortraitUpsideDown) {
        [parts addObject:@"Portrait Upside Down"];
    }
    
    NSString *result = [parts componentsJoinedByString:@", "];
    [parts release];
    return result;
}

UIInterfaceOrientationMask UIInterfaceOrientationMaskFromString(NSString *string) {
    if ([string isEqualToString:@"All"]) {
        return UIInterfaceOrientationMaskAll;
    }
    if ([string isEqualToString:@"All But Upside Down"]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    if ([string isEqualToString:@"Landscape"]) {
        return UIInterfaceOrientationMaskLandscape;
    }
    
    UIInterfaceOrientationMask mask = 0;
    NSArray<NSString *> *components = [string componentsSeparatedByString:@", "];
    for (NSString *comp in components) {
        if ([comp isEqualToString:@"Portrait"]) {
            mask |= UIInterfaceOrientationMaskPortrait;
        } else if ([comp isEqualToString:@"Landscape Left"]) {
            mask |= UIInterfaceOrientationMaskLandscapeLeft;
        } else if ([comp isEqualToString:@"Landscape Right"]) {
            mask |= UIInterfaceOrientationMaskLandscapeRight;
        } else if ([comp isEqualToString:@"Portrait Upside Down"]) {
            mask |= UIInterfaceOrientationMaskPortraitUpsideDown;
        } else {
            abort();
        }
    }
    return mask;
}

const UIInterfaceOrientationMask * allUIInterfaceOrientationMasks(NSUInteger * _Nullable count) {
    static const UIInterfaceOrientationMask values[] = {
        UIInterfaceOrientationMaskPortrait,
        UIInterfaceOrientationMaskLandscapeLeft,
        UIInterfaceOrientationMaskLandscapeRight,
        UIInterfaceOrientationMaskPortraitUpsideDown,
        UIInterfaceOrientationMaskLandscape,
        UIInterfaceOrientationMaskAllButUpsideDown,
        UIInterfaceOrientationMaskAll
    };
    if (count) {
        *count = sizeof(values) / sizeof(UIInterfaceOrientationMask);
    }
    return values;
}
