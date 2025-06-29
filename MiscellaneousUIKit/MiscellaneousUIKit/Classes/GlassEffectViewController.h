//
//  GlassEffectViewController.h
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/10/25.
//

#import <TargetConditionals.h>

#if !TARGET_OS_VISION

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GlassEffectViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

#endif
