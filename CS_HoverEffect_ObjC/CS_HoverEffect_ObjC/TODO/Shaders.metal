/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Metal shaders the app uses.
*/

#include <metal_stdlib>
using namespace metal;

#import "__ShaderTypes.h"

constant bool use_color [[ function_constant(FunctionConstantColor)]];
constant bool use_texture [[ function_constant(FunctionConstantTexture)]];
constant bool use_normals [[ function_constant(FunctionConstantNormals)]];
constant bool use_debug_colors [[ function_constant(FunctionConstantDebugColors)]];

struct VertexIn
{
    float3 position [[ attribute(0) ]];
    float2 uv [[attribute(1), function_constant(use_texture)]];
    float3 normal [[ attribute(2), function_constant(use_normals) ]];
};

struct VertexOut
{
    float4 position [[ position ]];
    float3 worldPosition;
    float3 normal;
    float2 uv;
};

vertex
VertexOut vertexShader(VertexIn in [[ stage_in ]],
                       ushort amp_id [[amplification_id]],
                       constant UniformsArray & uniformsArray [[ buffer(1) ]])
{
    VertexOut out;

    Uniforms uniforms = uniformsArray.uniforms[amp_id];

    float4 position = float4(in.position, 1.0);
    out.position = uniforms.pmMatrix * position;
    out.worldPosition = (uniforms.modelMatrix * float4(in.position, 1.0)).xyz;
    out.uv = in.uv;
    out.uv.y = 1 - out.uv.y;
    out.normal = (uniforms.normalMatrix * float4(in.normal, 1.0)).xyz;

    return out;
}

struct FragmentOut {
    float4 color [[color(0)]];
    uint16_t index [[color(1)]];
};

constexpr sampler textureSampler (mag_filter::linear,
                                  min_filter::linear,
                                  mip_filter::linear,
                                  address::clamp_to_border);

constexpr sampler skyboxSampler (mag_filter::linear,
                                 min_filter::linear,
                                 mip_filter::linear);

float mod(float v) {
    return v - floor(v);
}

fragment FragmentOut fragmentShader(VertexOut in [[stage_in]],
                               ushort amp_id [[amplification_id]],
                               texture2d<float> texture [[texture(0), function_constant(use_texture)]],
                               texturecube<float> skybox [[texture(1)]],
                               constant UniformsArray & uniformsArray [[ buffer(1) ]],
                               constant simd_float4 & color [[ buffer(2), function_constant(use_color)]])
{
    float3 outColor = float3(0);

    // Diffuse
    outColor += 0.1 * skybox.sample(skyboxSampler, normalize(in.normal), min_lod_clamp(skybox.get_num_mip_levels() - 4)).rgb;

    Uniforms uniforms = uniformsArray.uniforms[amp_id];

    // Specular
    float3 viewDirection = in.worldPosition - uniforms.viewWorldPosition;
    viewDirection.z *= -1;
    float3 reflected = reflect(viewDirection, in.normal);
    outColor += 0.5 * skybox.sample(skyboxSampler, normalize(reflected), min_lod_clamp(3)).rgb;

    if (use_color) {
        outColor += color.rgb;
    }

    if (use_texture) {
        outColor += texture.sample(textureSampler, in.uv).rgb;
    }

    if (use_debug_colors) {
        float3 debugColor = float3(mod(sqrt(2.f) * float(uniformsArray.hoverIndex)),
                                   mod(sqrt(3.f) * float(uniformsArray.hoverIndex)),
                                   mod(sqrt(5.f) * float(uniformsArray.hoverIndex)));

        outColor = (1 - uniformsArray.debugFactor) * outColor + uniformsArray.debugFactor * debugColor;
    }

    return FragmentOut {
        float4(outColor, 1.0),
        uniformsArray.hoverIndex
    };
}

fragment FragmentOut skyboxFragmentShader(VertexOut in [[stage_in]],
                                          ushort amp_id [[amplification_id]],
                                          texturecube<float> texture [[texture(0)]],
                                          constant UniformsArray & uniformsArray [[ buffer(1) ]])
{
    float3 direction = normalize(in.worldPosition);

    float4 color = texture.sample(skyboxSampler, direction);

    return FragmentOut {
        (1 - uniformsArray.debugFactor) * color,
        0
    };
}

constant bool use_texture_array [[function_constant(FunctionConstantUseTextureArray)]];
constant bool not_texture_array = !use_texture_array;

kernel void block_resolve(imageblock<FragmentOut> block,
                          ushort2 tid [[thread_position_in_threadgroup]],
                          uint2 gid [[thread_position_in_grid]],
                          ushort array_index [[render_target_array_index]],
                          texture2d_array<uint16_t, access::write> resolvedTextureArray [[texture(0), function_constant(use_texture_array)]],
                          texture2d<uint16_t, access::write> resolvedTexture [[texture(0), function_constant(not_texture_array)]])
{

    const ushort pixelCount = block.get_num_colors(tid);
    ushort index = 0;

    for (ushort i = 0; i < pixelCount; ++i) {
        const FragmentOut color = block.read(tid, i, imageblock_data_rate::color);
        index = max(index, color.index);
    }

    if (use_texture_array) {
        resolvedTextureArray.write(index, gid, array_index);
    } else {
        resolvedTexture.write(index, gid);
    }
}
