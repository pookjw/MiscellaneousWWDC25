//
//  ImmersiveSceneDelegate.mm
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import "ImmersiveSceneDelegate.h"
#include <objc/message.h>
#include <objc/runtime.h>
#import <CompositorServices/CompositorServices.h>
#import "Configuration.h"
#import "Renderer.h"

@interface ImmersiveSceneDelegate ()
@property (copy, nonatomic, nullable, getter=_configuration, setter=_setConfiguration:) Configuration *configuration;
@property (retain, nonatomic, nullable, getter=_renderer, setter=_setRenderer:) Renderer *renderer;
@end

@implementation ImmersiveSceneDelegate

- (void)dealloc {
    [_window release];
    [_configuration release];
    [_renderer release];
    [super dealloc];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(scene, sel_registerName("setConfigurationProvider:"), self);
    
    NSUserActivity *userActivity = connectionOptions.userActivities.allObjects.firstObject;
    assert(userActivity != nil);
    NSData *data = userActivity.userInfo[@"configuration"];
    
    NSError * _Nullable error = nil;
    Configuration *configuration = [NSKeyedUnarchiver unarchivedObjectOfClass:[Configuration class] fromData:data error:&error];
    assert(configuration != nil);
    self.configuration = configuration;
    
    cp_layer_renderer_t layerRenderer = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(scene, NSSelectorFromString(@"layer"));
    Renderer *renderer = [[Renderer alloc] initWithLayerRenderer:layerRenderer configuration:configuration];
    self.renderer = renderer;
    [renderer run];
    [renderer release];
}

- (cp_layer_renderer_configuration_t)layerConfigurationWithDefaultConfiguration:(cp_layer_renderer_configuration_t)defaultConfiguration layerCapabilites:(cp_layer_renderer_capabilities_t)layerCapabilites {
    cp_layer_renderer_configuration_t configuration = [defaultConfiguration copy];
    cp_layer_renderer_configuration_set_depth_format(configuration, MTLPixelFormatDepth32Float);
    cp_layer_renderer_configuration_set_color_format(configuration, MTLPixelFormatBGRA8Unorm_sRGB);
    
    if (cp_layer_renderer_capabilities_supports_foveation(layerCapabilites)) {
        cp_layer_renderer_configuration_set_foveation_enabled(configuration, self.configuration.foveation);
    }
    
    if (self.configuration.hoverEnabled) {
        cp_layer_renderer_configuration_set_tracking_areas_format(configuration, MTLPixelFormatR8Uint);
        
        if (self.configuration.useMSAA) {
            cp_layer_renderer_configuration_set_tracking_areas_usage(configuration, MTLTextureUsageShaderWrite | MTLTextureUsageShaderRead);
        } else {
            cp_layer_renderer_configuration_set_tracking_areas_usage(configuration, MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead);
        }
        
        if (NSNumber *resolution = self.configuration.resolution) {
            cp_layer_renderer_configuration_set_max_render_quality(configuration, resolution.floatValue);
        }
    }
    
    return [configuration autorelease];
}

@end
