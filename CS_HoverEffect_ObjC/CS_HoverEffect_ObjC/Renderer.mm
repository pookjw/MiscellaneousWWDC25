//
//  Renderer.mm
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import "Renderer.h"
#import <TargetConditionals.h>
#import <ARKit/ARKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface Renderer ()
@property (retain, nonatomic, readonly, getter=_layerRenderer) cp_layer_renderer_t layerRenderer;
@property (copy, nonatomic, readonly, getter=_configuration) Configuration *configuration;

@property (retain, nonatomic, readonly, getter=_session) ar_session_t session;
@property (retain, nonatomic, readonly, getter=_device) id<MTLDevice> device;
@property (retain, nonatomic, readonly, getter=_queue) id<MTLCommandQueue> queue;
@property (copy, nonatomic, readonly, getter=_mdlVD) MDLVertexDescriptor *mdlVD;
@property (retain, nonatomic, readonly, getter=_asset) MDLAsset *asset;
@property (retain, nonatomic, readonly, getter=_textLoader) MTKTextureLoader *textureLoader;

@property (retain, nonatomic, nullable, getter=_thread, setter=_setThread:) NSThread *thread;
@end

@implementation Renderer

- (instancetype)initWithLayerRenderer:(cp_layer_renderer_t)layerRenderer configuration:(nonnull Configuration *)configuration {
    if (self = [super init]) {
        _layerRenderer = [layerRenderer retain];
        _configuration = [configuration copy];
        
#if TARGET_OS_OSX
        abort();
        _session = ar_session_create_with_device(nil);
#else
        _session = ar_session_create();
#endif
        
        id<MTLDevice> device = cp_layer_renderer_get_device(layerRenderer);
        _device = [device retain];
        _queue = [device newCommandQueue];
        
        _mdlVD = [MDLVertexDescriptor new];
        
        {
            MDLVertexAttribute *attribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributePosition
                                                                              format:MDLVertexFormatFloat3
                                                                              offset:0
                                                                         bufferIndex:0];
            _mdlVD.attributes[0] = attribute;
            [attribute release];
        }
        
        {
            MDLVertexAttribute *attribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeTextureCoordinate
                                                                              format:MDLVertexFormatFloat2
                                                                              offset:sizeof(simd::float3)
                                                                         bufferIndex:0];
            _mdlVD.attributes[1] = attribute;
            [attribute release];
        }
        
        {
            MDLVertexAttribute *attribute = [[MDLVertexAttribute alloc] initWithName:MDLVertexAttributeNormal
                                                                              format:MDLVertexFormatFloat3
                                                                              offset:sizeof(simd::float3) + sizeof(simd::float2)
                                                                         bufferIndex:0];
            _mdlVD.attributes[2] = attribute;
            [attribute release];
        }
        
        {
            MDLVertexBufferLayout *layout = [[MDLVertexBufferLayout alloc] initWithStride:sizeof(simd::float3) * 2 + sizeof(simd::float2)];
            _mdlVD.layouts[0] = layout;
            [layout release];
        }
        
        
        NSURL *url = [NSBundle.mainBundle URLForResource:@"Scene/Monolith_Fragments/Monolith_Fragments" withExtension:@"usdc"];
        assert(url != nil);
        
        MTKMeshBufferAllocator *allocator = [[MTKMeshBufferAllocator alloc] initWithDevice:device];
        _asset = [[MDLAsset alloc] initWithURL:url
                              vertexDescriptor:_mdlVD
                               bufferAllocator:allocator];
        [allocator release];
        
        _textureLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    }
    
    return self;
}

- (void)dealloc {
    [_thread cancel];
    [_thread release];
    
    [_layerRenderer release];
    [_configuration release];
    ar_release(_session);
    [_device release];
    [_queue release];
    [_mdlVD release];
    [_asset release];
    [_textureLoader release];
    [super dealloc];
}

- (void)run {
    assert(self.thread == nil);
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(_threadMain:) object:nil];
    self.thread = thread;
    [thread start];
    [thread release];
}

- (void)_threadMain:(id _Nullable)object {
    abort();
}

@end
