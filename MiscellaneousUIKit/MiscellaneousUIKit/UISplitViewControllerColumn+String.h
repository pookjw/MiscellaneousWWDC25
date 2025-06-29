//
//  UISplitViewControllerColumn+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/11/25.
//

#import <TargetConditionals.h>

#if !TARGET_OS_VISION

#import <UIKit/UIKit.h>
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUISplitViewControllerColumn(UISplitViewControllerColumn column);
MUK_EXTERN UISplitViewControllerColumn UISplitViewControllerColumnFromString(NSString *string);
MUK_EXTERN const UISplitViewControllerColumn * allUISplitViewControllerColumns(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END

#endif
