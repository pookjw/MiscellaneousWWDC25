//
//  MRUINotificationsViewController.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/30/25.
//

#import <TargetConditionals.h>

#if TARGET_OS_VISION

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRUINotificationsViewController : UICollectionViewController

@end

NS_ASSUME_NONNULL_END

#endif
