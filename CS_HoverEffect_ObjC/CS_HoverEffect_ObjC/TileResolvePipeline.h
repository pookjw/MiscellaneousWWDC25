//
//  TileResolvePipeline.h
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import <ModelIO/ModelIO.h>
#import <ARKit/ARKit.h>
#import <MetalKit/MetalKit.h>
#import <CompositorServices/CompositorServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface TileResolvePipeline : NSObject
@property (retain, nonatomic, readonly) id<MTLRenderPipelineState> indexResolveState;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDevice:(id<MTLDevice>)device configuration:(cp_layer_renderer_configuration_t)configuration;
@end

NS_ASSUME_NONNULL_END
