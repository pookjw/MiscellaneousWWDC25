//
//  UISplitViewControllerLayoutEnvironment+String.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/17/25.
//


#import <UIKit/UIKit.h>
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

MUK_EXTERN NSString * NSStringFromUISplitViewControllerLayoutEnvironment(UISplitViewControllerLayoutEnvironment environment);
MUK_EXTERN UISplitViewControllerLayoutEnvironment UISplitViewControllerLayoutEnvironmentFromString(NSString *string);
MUK_EXTERN const UISplitViewControllerLayoutEnvironment * allUISplitViewControllerLayoutEnvironments(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
