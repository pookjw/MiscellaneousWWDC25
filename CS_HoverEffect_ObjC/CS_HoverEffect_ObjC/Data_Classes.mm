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
