//
//  Data_Classes.h
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/2/25.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#include <optional>

NS_ASSUME_NONNULL_BEGIN

@interface DrawCallMaterial : NSObject
@property (retain, nonatomic, readonly, nullable) id<MTLTexture> texture;
@property (assign, nonatomic, readonly) std::optional<simd::float4> color;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTexture:(id<MTLTexture> _Nullable)texture color:(std::optional<simd::float4>)color;
@end

NS_ASSUME_NONNULL_END
