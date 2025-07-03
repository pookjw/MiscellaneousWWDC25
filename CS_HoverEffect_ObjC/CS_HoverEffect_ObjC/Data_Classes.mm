//
//  Data_Classes.mm
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/2/25.
//

#import "Data_Classes.h"

@implementation DrawCallMaterial

- (instancetype)initWithTexture:(id<MTLTexture>)texture color:(std::optional<simd::float4>)color {
    if (self = [super init]) {
        _texture = [texture retain];
        _color = color;
    }
    
    return self;
}

- (void)dealloc {
    [_texture release];
    [super dealloc];
}

@end


@implementation DrawCall

- (instancetype)initWithTransformWhole:(simd::float4x4)transformWhole transformExploded:(simd::float4x4)transformExploded mesh:(MTKMesh *)mesh boundingBox:(MDLAxisAlignedBoundingBox)boundingBox materials:(NSArray<DrawCallMaterial *> *)materials {
    if (self = [super init]) {
        _transformWhole = transformWhole;
        _transformExploded = transformExploded;
        _mesh = [mesh retain];
        _boundingBox = boundingBox;
        _materials = [materials retain];
        
        _animationState = [AnimationState new];
        _animationState.value = AnimationStateValueIdle;
        _animationState.progress = std::nullopt;
    }
    
    return self;
}

- (void)dealloc {
    [_mesh release];
    [_materials release];
    [_animationState release];
    [super dealloc];
}

@end


@implementation Scene

- (instancetype)init {
    if (self = [super init]) {
        _drawCalls = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc {
    [_drawCalls release];
    [super dealloc];
}

@end
