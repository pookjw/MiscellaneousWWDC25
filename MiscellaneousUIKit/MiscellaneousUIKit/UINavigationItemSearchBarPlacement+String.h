//
//  UINavigationItemSearchBarPlacement+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import <UIKit/UIKit.h>
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUINavigationItemSearchBarPlacement(UINavigationItemSearchBarPlacement placement);
MUK_EXTERN UINavigationItemSearchBarPlacement UINavigationItemSearchBarPlacementFromString(NSString *string);
MUK_EXTERN const UINavigationItemSearchBarPlacement * allUINavigationItemSearchBarPlacements(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
