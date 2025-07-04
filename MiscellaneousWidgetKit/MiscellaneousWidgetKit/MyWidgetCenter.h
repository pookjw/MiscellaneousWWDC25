//
//  MyWidgetCenter.h
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyWidgetCenter : NSObject
@property (class, nonatomic, readonly) MyWidgetCenter *sharedInstance NS_SWIFT_NAME(shared);
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (void)reloadAllTimelines:(void (^ _Nullable)(NSError * _Nullable error))completion;
- (void)loadCurrentConfigurations:(void (^ _Nullable)(NSArray * _Nullable configurations, NSError * _Nullable error))completion;
- (void)reloadAllTimelinesOfKind:(NSString *)kind completion:(void (^ _Nullable)(NSError * _Nullable error))completion;
- (void)reloadAllTimelinesOfKind:(NSString *)kind inBundle:(NSString *)bundle completion:(void (^ _Nullable)(NSError * _Nullable error))completion;
- (void)invalidateConfigurationRecommendationsInBundle:(NSString *)bundle completion:(void (^ _Nullable)(NSError * _Nullable error))completion; // not working
- (void)invalidateConfigurationRecommendationsWithCompletion:(void (^ _Nullable)(NSError * _Nullable error))completion;
- (void)invalidateRelevancesOfKind:(NSString *)kind completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler; // not working
- (void)invalidateRelevancesOfKind:(NSString *)kind inBundle:(NSString *)bundle completionHandler:(void (^ _Nullable)(NSError * _Nullable error))completionHandler; // not working
- (void)widgetPushTokenWithCompletionHandler:(void (^ _Nullable)(NSData * _Nullable pushInfo, NSError * _Nullable error))completionHandler;
- (void)widgetRelevanceArchiveForKind:(NSString *)kind inBundle:(NSString *)bundle handler:(void (^ _Nullable)(NSData * _Nullable archive, NSError * _Nullable error))handler;
@end

NS_ASSUME_NONNULL_END
