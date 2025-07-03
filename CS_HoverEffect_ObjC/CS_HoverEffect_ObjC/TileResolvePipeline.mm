//
//  TileResolvePipeline.mm
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/3/25.
//

#import "TileResolvePipeline.h"
#import "ShaderTypes.h"

@implementation TileResolvePipeline

- (instancetype)initWithDevice:(id<MTLDevice>)device configuration:(cp_layer_renderer_configuration_t)configuration {
    if (self = [super init]) {
        MTLTileRenderPipelineDescriptor *desc = [MTLTileRenderPipelineDescriptor new];
        desc.colorAttachments[0].pixelFormat = cp_layer_renderer_configuration_get_color_format(configuration);
        desc.colorAttachments[1].pixelFormat = cp_layer_renderer_configuration_get_tracking_areas_format(configuration);
        desc.rasterSampleCount = 4;
        desc.threadgroupSizeMatchesTileSize = YES;
        
        MTLFunctionConstantValues *constants = [MTLFunctionConstantValues new];
        const BOOL useTextureArray = (cp_layer_renderer_configuration_get_layout(configuration) == cp_layer_renderer_layout_layered);
        [constants setConstantValue:&useTextureArray type:MTLDataTypeBool atIndex:FunctionConstantUseTextureArray];
        
        id<MTLLibrary> library = [device newDefaultLibrary];
        NSError * _Nullable error = nil;
        id<MTLFunction> resolveFunction = [library newFunctionWithName:@"block_resolve" constantValues:constants error:&error];
        [constants release];
        [library release];
        assert(resolveFunction != nil);
        
        desc.tileFunction = resolveFunction;
        [resolveFunction release];
        
        _indexResolveState = [device newRenderPipelineStateWithTileDescriptor:desc options:0 reflection:nil error:&error];
        assert(error == nil);
    }
    
    return self;
}

- (void)dealloc {
    [_indexResolveState release];
    [super dealloc];
}

@end
