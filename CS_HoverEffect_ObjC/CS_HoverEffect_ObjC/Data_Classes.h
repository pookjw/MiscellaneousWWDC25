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
#import <os/lock.h>
#import "AnimationState.h"

NS_ASSUME_NONNULL_BEGIN

@interface DrawCallMaterial : NSObject
@property (retain, nonatomic, readonly, nullable) id<MTLTexture> texture;
@property (assign, nonatomic, readonly) std::optional<simd::float4> color;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTexture:(id<MTLTexture> _Nullable)texture color:(std::optional<simd::float4>)color;
@end

@interface DrawCall : NSObject
@property (assign, nonatomic, readonly) simd::float4x4 transformWhole;
@property (assign, nonatomic, readonly) simd::float4x4 transformExploded;
@property (retain, nonatomic, readonly) MTKMesh *mesh;
@property (assign, nonatomic, readonly) MDLAxisAlignedBoundingBox boundingBox;
@property (copy, nonatomic, readonly) NSArray<DrawCallMaterial *> *materials;
@property (retain, nonatomic, readonly) AnimationState *animationState;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithTransformWhole:(simd::float4x4)transformWhole transformExploded:(simd::float4x4)transformExploded mesh:(MTKMesh *)mesh boundingBox:(MDLAxisAlignedBoundingBox)boundingBox materials:(NSArray<DrawCallMaterial *> *)materials;
@end

@interface Scene : NSObject {
    @package os_unfair_lock _lock;
}
@property (assign, nonatomic) NSTimeInterval animationTime;
@property (assign, nonatomic) BOOL hasExpanded;
@property (retain, nonatomic, readonly) NSMutableArray<DrawCall *> *drawCalls;
@end

NS_ASSUME_NONNULL_END

