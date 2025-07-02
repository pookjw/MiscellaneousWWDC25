//
//  ShaderTypes.h
//  CS_HoverEffect_ObjC
//
//  Created by Jinwoo Kim on 7/2/25.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef enum FunctionConstant
{
    FunctionConstantColor,
    FunctionConstantTexture,
    FunctionConstantNormals,
    FunctionConstantDebugColors,
    FunctionConstantUseTextureArray
} FunctionConstant;

#endif /* ShaderTypes_h */
