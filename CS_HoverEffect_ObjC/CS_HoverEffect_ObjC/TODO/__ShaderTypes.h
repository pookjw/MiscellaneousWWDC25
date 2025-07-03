/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Metal data types used in the app's shaders.
*/

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef struct
{
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelMatrix;
    matrix_float4x4 modelViewMatrix;
    simd_float3 viewWorldPosition;
    matrix_float4x4 normalMatrix;
    matrix_float4x4 pmMatrix; // projectionMatrix * modelViewMatrix
} Uniforms;

typedef struct
{
    Uniforms uniforms[2];
    uint16_t hoverIndex;

    float debugFactor; // in [0;1]
} UniformsArray;

typedef enum FunctionConstant
{
    FunctionConstantColor,
    FunctionConstantTexture,
    FunctionConstantNormals,
    FunctionConstantDebugColors,
    FunctionConstantUseTextureArray
} FunctionConstant;

#endif /* ShaderTypes_h */
