//
//  Renderer.h
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import <CompositorServices/CompositorServices.h>
#import "Configuration.h"

NS_ASSUME_NONNULL_BEGIN

@interface Renderer : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithLayerRenderer:(cp_layer_renderer_t)layerRenderer configuration:(Configuration *)configuration;
- (void)run;
@end

NS_ASSUME_NONNULL_END
