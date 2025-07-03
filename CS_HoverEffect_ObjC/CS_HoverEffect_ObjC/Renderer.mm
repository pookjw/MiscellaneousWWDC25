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
#import "ShaderTypes.h"
#import "Data_Classes.h"

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
@property (retain, nonatomic, nullable, getter=_skybox, setter=_setSkybox:) id<MTLTexture> skybox;
@property (retain, nonatomic, nullable, getter=_skyboxPipeline, setter=_setSkyboxPipeline:) id<MTLRenderPipelineState> skyboxPipeline;

@property (retain, nonatomic, readonly, getter=_textures) NSMutableArray<id<MTLTexture>> *textures;
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
        _textures = [NSMutableArray new];
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
    [_skybox release];
    [_skyboxPipeline release];
    [_textures release];
    
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
    [self _setupWorldTracking];
    
    abort();
}

- (void)_setupWorldTracking {
    if (ar_world_tracking_provider_is_supported()) {
        ar_world_tracking_configuration_t worldTrackingConfiguration = ar_world_tracking_configuration_create();
        ar_world_tracking_provider_t worldTrackingProvider = ar_world_tracking_provider_create(worldTrackingConfiguration);
        ar_release(worldTrackingConfiguration);
        ar_data_providers_t dataProvders = ar_data_providers_create_with_data_providers(worldTrackingProvider, nil);
        ar_release(worldTrackingProvider);
        ar_session_run(self.session, dataProvders);
        ar_release(dataProvders);
    }
}

- (void)_loadAssets {
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self _loadAsset:self.asset];
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self _loadSkybox];
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self _loadSkyboxShader];
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

- (void)_loadAsset:(MDLAsset *)asset {
    NSUInteger count = asset.count;
    NSMutableArray<MDLObject *> *objects = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        [objects addObject:[asset objectAtIndex:i]];
    }
    
    while (MDLObject *object = objects.lastObject) {
        [object retain];
        [objects removeLastObject];
        
        [objects addObjectsFromArray:object.children.objects];
        
        if ([object isKindOfClass:[MDLMesh class]]) {
            MDLMesh *mesh = static_cast<MDLMesh *>(object);
            NSMutableArray<MDLSubmesh *> *submeshes = mesh.submeshes;
            if (submeshes == nil) {
                NSLog(@"Submeshes was unexpectedly nil.");
                continue;
            }
            
            NSMutableArray<DrawCallMaterial *> *materials = [NSMutableArray new];
            for (MDLSubmesh *submesh in submeshes) {
                MDLMaterialProperty *color = [submesh.material propertyNamed:@"emissiveColor"];
                if (color == nil) {
                    DrawCallMaterial *material = [[DrawCallMaterial alloc] initWithTexture:nil color:std::nullopt];
                    [materials addObject:material];
                    [material release];
                    continue;
                }
                
                NSURL *URLValue = color.URLValue;
                if (URLValue == nil) continue;
                
                
                abort();
            }
        }
        
        [object release];
    }
}

- (void)_loadSkybox {
    NSURL *url = [NSBundle.mainBundle URLForResource:@"Scene/Nebula_VerticalCubeMap" withExtension:@"exr"];
    assert(url != nil);
    
    assert(self.skybox == nil);
    
    NSDictionary<MTKTextureLoaderOption, id> *options = @{
        MTKTextureLoaderOptionCubeLayout: MTKTextureLoaderCubeLayoutVertical,
        MTKTextureLoaderOptionAllocateMipmaps: @YES,
        MTKTextureLoaderOptionGenerateMipmaps: @YES
    };
    
    NSError * _Nullable error = nil;
    id<MTLTexture> skybox = [self.textureLoader newTextureWithContentsOfURL:url options:options error:&error];
    assert(skybox != nil);
    
    self.skybox = skybox;
    [skybox release];
}

- (void)_loadSkyboxShader {
    id<MTLLibrary> library = [self.device newDefaultLibrary];
    assert(library != nil);
    
    MTLRenderPipelineDescriptor *pDesc = [MTLRenderPipelineDescriptor new];
    cp_layer_renderer_configuration_t configuration = cp_layer_renderer_get_configuration(self.layerRenderer);
    pDesc.colorAttachments[0].pixelFormat = cp_layer_renderer_configuration_get_color_format(configuration);
    pDesc.colorAttachments[1].pixelFormat = cp_layer_renderer_configuration_get_tracking_areas_format(configuration);
    pDesc.depthAttachmentPixelFormat = cp_layer_renderer_configuration_get_depth_format(configuration);
    
    MTLFunctionConstantValues *constants = [MTLFunctionConstantValues new];
    const BOOL texture = NO;
    [constants setConstantValue:&texture type:MTLDataTypeBool atIndex:FunctionConstantTexture];
    const BOOL normals = NO;
    [constants setConstantValue:&normals type:MTLDataTypeBool atIndex:FunctionConstantNormals];
    
    NSError * _Nullable error = nil;
    
    id<MTLFunction> vertexFunction = [library newFunctionWithName:@"vertexShader" constantValues:constants error:&error];
    assert(vertexFunction != nil);
    pDesc.vertexFunction = vertexFunction;
    [vertexFunction release];
    
    id<MTLFunction> fragmentFunction = [library newFunctionWithName:@"skyboxFragmentShader" constantValues:constants error:&error];
    assert(fragmentFunction != nil);
    pDesc.fragmentFunction = fragmentFunction;
    [fragmentFunction release];
    
    MTLVertexDescriptor *vDesc = [MTLVertexDescriptor new];
    vDesc.attributes[0].format = MTLVertexFormatFloat3;
    vDesc.attributes[0].bufferIndex = 0;
    vDesc.attributes[0].offset = 0;
    vDesc.layouts[0].stride = sizeof(simd::float3);
    
    pDesc.vertexDescriptor = vDesc;
    [vDesc release];
    
    pDesc.maxVertexAmplificationCount = cp_layer_renderer_properties_get_view_count(cp_layer_renderer_get_properties(self.layerRenderer));
    
    if (self.configuration.useMSAA) {
        pDesc.rasterSampleCount = 4;
    }
    
    id<MTLRenderPipelineState> pState = [self.device newRenderPipelineStateWithDescriptor:pDesc error:&error];
    [pDesc release];
    assert(pState != nil);
    
    self.skyboxPipeline = pState;
    [pState release];
}

@end
