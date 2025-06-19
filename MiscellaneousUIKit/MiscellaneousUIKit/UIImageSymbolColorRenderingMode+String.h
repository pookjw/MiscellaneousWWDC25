//
//  UIImageSymbolColorRenderingMode+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

#import <UIKit/UIKit.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUIImageSymbolColorRenderingMode(UIImageSymbolColorRenderingMode mode);
MUK_EXTERN UIImageSymbolColorRenderingMode UIImageSymbolColorRenderingModeFromString(NSString *string);
MUK_EXTERN const UIImageSymbolColorRenderingMode * allUIImageSymbolColorRenderingModes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
