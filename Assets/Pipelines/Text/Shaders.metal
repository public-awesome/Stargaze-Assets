#include "Library/Map.metal"
#include "Library/Gamma.metal"
#include "Library/Colors.metal"
#include "Library/Adjustments.metal"
#include "Library/CubicSmooth.metal"

typedef struct {
    float4 color; // color
    float4 bounds;
    float colorSmooth;     //slider,-1,1,0
    float colorOffset;     //slider
    float colorRange;      //slider
    float colorHue;        //slider,0,1,0
    float colorBrightness; //slider,0,1,0
    float colorConstrast;  //slider,1,2,1
    float colorVibrance;   //slider,1,1.5,0
    float colorGamma;      //slider,-1,1,0
} TextUniforms;

typedef struct {
    float4 position [[position]];
    float3 worldPosition;
} CustomVertexData;

vertex CustomVertexData textVertex(Vertex in [[stage_in]],
                                   constant VertexUniforms &vertexUniforms
                                   [[buffer(VertexBufferVertexUniforms)]]) {
    CustomVertexData out;
    const float4 worldPosition = vertexUniforms.modelMatrix * in.position;
    out.position = vertexUniforms.modelViewProjectionMatrix * in.position;
    out.worldPosition = worldPosition.xyz;
    return out;
}

fragment float4 textFragment(CustomVertexData in [[stage_in]],
                             constant TextUniforms &uniforms
                             [[buffer(FragmentBufferMaterialUniforms)]]) {
    const float2 wp = in.worldPosition.xy;
    const float2 bbmin = uniforms.bounds.xy;
    const float2 bbmax = uniforms.bounds.zw;
    const float x = map(wp.x, bbmin.x, bbmax.x, uniforms.colorOffset, uniforms.colorOffset + uniforms.colorRange);
    const float y = map(wp.y, bbmin.y, bbmax.y, uniforms.colorOffset, uniforms.colorOffset + uniforms.colorRange);
    float2 uv = float2(x, y);

    // float3 color = blendRYB5Linear(uniforms.colorRange * mix(x, y, uniforms.colorAngle), uniforms.colorOffset);

    float3 color = float3(0., 0.3, 1.); //vec3 col = vec3(.009, .288, .828);
    float3 hsv = float3(.57, .9, .5);
    color = mix(1.0, color, hsv.yyy);
    color *= hsv.z;

    uv = mix(uv, float2(cubicSmooth(uv.x), cubicSmooth(uv.y)), uniforms.colorSmooth);
    color = scatter(uv.x, color); //comment to see better what is going on
    color = scatter(uv.y, color);

    color = hue(color, uniforms.colorHue);
    color = brightness(color, uniforms.colorBrightness);
    color = contrast(color, uniforms.colorConstrast);
    color = vibrance(color, uniforms.colorVibrance);
    // float3 color = spectrum(fract(  + ));
    color = mix(color, gamma(color), uniforms.colorGamma);
    return uniforms.color * float4(color, 1.0);
}
