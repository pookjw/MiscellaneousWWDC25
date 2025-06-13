//
//  UIUserInterfaceStyle+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/13/25.
//

#import <UIKit/UIKit.h>
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUIUserInterfaceStyle(UIUserInterfaceStyle style);
MUK_EXTERN UIUserInterfaceStyle UIUserInterfaceStyleFromString(NSString *string);
MUK_EXTERN const UIUserInterfaceStyle * allUIUserInterfaceStyles(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
