//
//  InterfaceOrientationsViewController.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/18/25.
//

#import <TargetConditionals.h>

#if !TARGET_OS_VISION

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InterfaceOrientationsViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

#endif
