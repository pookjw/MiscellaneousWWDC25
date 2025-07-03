//
//  MyWidgetCenter.h
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyWidgetCenter : NSObject
@property (class, nonatomic, readonly) MyWidgetCenter *sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (void)reloadAllTimelines:(void (^ _Nullable)(NSError * _Nullable error))completion;
- (void)loadCurrentConfigurations:(void (^ _Nullable)(NSArray * _Nullable configurations, NSError * _Nullable error))completion;
- (void)reloadAllTimelinesOfKind:(NSString *)kind completion:(void (^ _Nullable)(NSError * _Nullable error))completion;
- (void)reloadAllTimelinesOfKind:(NSString *)kind inBundle:(NSString *)bundle completion:(void (^ _Nullable)(NSError * _Nullable error))completion;
- (void)invalidateConfigurationRecommendationsInBundle:(NSString *)bundle completion:(void (^ _Nullable)(NSError * _Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
