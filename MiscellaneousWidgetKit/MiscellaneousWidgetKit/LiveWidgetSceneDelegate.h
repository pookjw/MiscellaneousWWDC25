//
//  LiveWidgetSceneDelegate.h
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/5/25.
//

#import <TargetConditionals.h>

#if TARGET_OS_VISION

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LiveWidgetSceneDelegate : UIResponder <UIWindowSceneDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

NS_ASSUME_NONNULL_END

#endif
