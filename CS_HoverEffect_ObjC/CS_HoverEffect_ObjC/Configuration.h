//
//  Configuration.h
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Configuration : NSObject <NSSecureCoding, NSCopying>
@property (class, nonatomic, readonly) BOOL supportsMSAA;
@property (assign, nonatomic, getter=isHoverEnabled) BOOL hoverEnabled;
@property (assign, nonatomic, getter=isBackgroundEnabled) BOOL backgroundEnabled;
@property (copy, nonatomic, nullable) NSNumber *resolution;
@property (assign, nonatomic) BOOL foveation;
@property (assign, nonatomic) float debugFactor;
@property (assign, nonatomic) BOOL useMSAA;
@end

NS_ASSUME_NONNULL_END
