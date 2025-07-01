//
//  Configuration.mm
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/1/25.
//

#import "Configuration.h"
#import <Metal/Metal.h>

@implementation Configuration

+ (BOOL)supportsMSAA {
    static BOOL result;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id<MTLDevice> device = MTLCreateSystemDefaultDevice();
        result = device.supports32BitMSAA;
        [device release];
    });
    return result;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)init {
    if (self = [super init]) {
        _hoverEnabled = YES;
        _backgroundEnabled = YES;
        _resolution = nil;
        _foveation = YES;
        _debugFactor = 0.f;
        _useMSAA = Configuration.supportsMSAA;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        _hoverEnabled = [coder decodeBoolForKey:@"hoverEnabled"];
        _backgroundEnabled = [coder decodeBoolForKey:@"backgroundEnabled"];
        _resolution = [coder decodeObjectForKey:@"resolution"];
        _foveation = [coder decodeBoolForKey:@"foveation"];
        _debugFactor = [coder decodeFloatForKey:@"debugFactor"];
        _useMSAA = [coder decodeBoolForKey:@"useMSAA"];
    }
    
    return self;
}

- (void)dealloc {
    [_resolution release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:_hoverEnabled forKey:@"hoverEnabled"];
    [coder encodeBool:_backgroundEnabled forKey:@"backgroundEnabled"];
    [coder encodeObject:_resolution forKey:@"resolution"];
    [coder encodeBool:_foveation forKey:@"foveation"];
    [coder encodeFloat:_debugFactor forKey:@"debugFactor"];
    [coder encodeBool:_useMSAA forKey:@"useMSAA"];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    Configuration *copy = [Configuration new];
    copy->_hoverEnabled = _hoverEnabled;
    copy->_backgroundEnabled = _backgroundEnabled;
    copy->_resolution = [_resolution copyWithZone:zone];
    copy->_foveation = _foveation;
    copy->_debugFactor = _debugFactor;
    copy->_useMSAA = _useMSAA;
    return copy;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:[Configuration class]]) {
        return NO;
    }
    
    Configuration *casted = static_cast<Configuration *>(other);
    
    BOOL resolutionEqual = (_resolution == casted->_resolution) || [_resolution isEqualToNumber:casted->_resolution];
    
    return _hoverEnabled == casted->_hoverEnabled &&
    _backgroundEnabled == casted->_backgroundEnabled &&
    resolutionEqual &&
    _foveation == casted->_foveation &&
    _debugFactor == casted->_debugFactor &&
    _useMSAA == casted->_useMSAA;
}

- (NSUInteger)hash {
    return _hoverEnabled ^ _backgroundEnabled ^ _resolution.hash ^ _foveation ^ @(_debugFactor).hash ^ _useMSAA;
}

@end

