Shader "Hidden/VacuumShaders/Advanced Dissolve/Nature/Tree Creator/Bark Rendertex" {
Properties {
    _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
[Toggle] _MainTexCutoff("Enable Main Texture Cutout", Float) = 0
_Cutoff("   Alpha cutoff", Range(0,1)) = 0.5

    _BumpSpecMap ("Normalmap (GA) Spec (R)", 2D) = "bump" {}
    _TranslucencyMap ("Trans (RGB) Gloss(A)", 2D) = "white" {}

    // These are here only to provide default values
    _SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)




		[MaterialEnum(Off,0,Front,1,Back,2)] _Cull("Face Cull", Int) = 0

		[HideInInspector]_DissolveCutoff ("Dissolve", Range(0,1)) = 0.500000
		
			 
		[HideInInspector][KeywordEnum(None, Axis Local, Axis Global, Plane, Sphere, Box)]  _DissolveMask("", Float) = 0
		[HideInInspector][KeywordEnum(One, Two, Three, Four)]  _DissolveMask_Count("", Float) = 0
		[HideInInspector][Enum(X,0,Y,1,Z,2)]  _DissolveCutoffAxis("Axis", Float) = 0
		[HideInInspector]_DissolveAxisInvert("Axis Invert", Float) = 1
		[HideInInspector]_DissolveMaskOffset("Mask Offset", Float) = 0
		[HideInInspector]_DissolveEdgeSize("Edge Size", Range(0,1)) = 0.15
		[HideInInspector][HDR]  _DissolveEdgeColor("Edge Color", Color) = (1,1,1,1)
		[HideInInspector][NoScaleOffset]  _DissolveEdgeRamp("Ramp", 2D) = "white" { }
		[HideInInspector]_DissolveGIStrength("GI Strength", Float) = 1
		[HideInInspector][KeywordEnum(Main Map Alpha, Custom Map, Two Custom Maps, Three Custom Maps)]  _DissolveAlphaSource("", Float) = 0
		[HideInInspector]_DissolveMap1("", 2D) = "white" { }
		[HideInInspector][UVScroll]  _DissolveMap1_Scroll("", Vector) = (0,0,0,0)
		[HideInInspector]_DissolveMap2("", 2D) = "white" { }
		[HideInInspector][UVScroll]  _DissolveMap2_Scroll("", Vector) = (0,0,0,0)
		[HideInInspector]_DissolveMap3("", 2D) = "white" { }
		[HideInInspector][UVScroll]  _DissolveMap3_Scroll("", Vector) = (0,0,0,0)
		[HideInInspector]_DissolveNoiseStrength("", Float) = 0.100000
		[HideInInspector][Enum(Multiply, 0, Add, 1)]  _DissolveAlphaTextureBlend("", Float) = 0
		[HideInInspector][Enum(UV0,0,UV1,1)] _DissolveUVSet("UV Set", Float) = 0

		[HideInInspector]  _DissolveMaskPosition("", Vector) = (0,0,0,0)
		[HideInInspector]  _DissolveMaskPlaneNormal("", Vector) = (1,0,0,0)
		[HideInInspector]  _DissolveMaskSphereRadius("", Float) = 1
		[HideInInspector]  _Dissolve_ObjectWorldPos("wPos", Vector) = (0,0,0,0)

		[HideInInspector][Toggle] _DissolveTriplanar("Triplanar?", Float) = 0
		[HideInInspector][Enum(World Space, 0, Object Space, 1)]  _DissolveTriplanarMappingSpace("", Float) = 0
		[HideInInspector] _DissolveTriplanarMainMapTiling("", Float) = 1

		[HideInInspector][KeywordEnum(None, Mask Only, Mask And Edge, All)] _DissolveGlobalControl("Global Controll", Float) = 0
}

SubShader {
    Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"



sampler2D _MainTex;
sampler2D _BumpSpecMap;
sampler2D _TranslucencyMap;
fixed4 _SpecColor;
fixed _Cutoff;

#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
#pragma shader_feature _ _MAINTEXCUTOFF_ON
#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"



struct v2f {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 color : TEXCOORD1;
    float2 params1: TEXCOORD2;
    float2 params2: TEXCOORD3;
    float2 params3: TEXCOORD4;
	UNITY_VERTEX_OUTPUT_STEREO


		float3 worldPos : TEXCOORD5;
#ifdef _DISSOLVETRIPLANAR_ON
  half3 objNormal : TEXCOORD6;
  float3 coords : TEXCOORD7;
#else
	  float4 dissolveUV : TEXCOORD6;
#endif
};



CBUFFER_START(UnityTerrainImposter)
    float3 _TerrainTreeLightDirections[4];
    float4 _TerrainTreeLightColors[4];
CBUFFER_END

float2 CalcTreeLightingParams(float3 normal, float3 lightDir, float3 viewDir)
{
    float2 output;
    half nl = dot (normal, lightDir);
    output.r = max (0, nl);

    half3 h = normalize (lightDir + viewDir);
    float nh = max (0, dot (normal, h));
    output.g = nh;
    return output;
}

v2f vert (appdata_full v) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;
    float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));

    /* We used to do a for loop and store params as a texcoord array[3].
     * HLSL compiler, however, unrolls this loop and opens up the uniforms
     * into 3 separate texcoords, but doesn't do it on fragment shader.
     * This discrepancy causes error on iOS, so do it manually. */
    o.params1 = CalcTreeLightingParams(v.normal, _TerrainTreeLightDirections[0], viewDir);
    o.params2 = CalcTreeLightingParams(v.normal, _TerrainTreeLightDirections[1], viewDir);
    o.params3 = CalcTreeLightingParams(v.normal, _TerrainTreeLightDirections[2], viewDir);

    o.color = v.color.a;


	o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
	//VacuumShaders
#ifdef _DISSOLVETRIPLANAR_ON
	o.coords = v.vertex;
	o.objNormal = lerp(UnityObjectToWorldNormal(v.normal), v.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
	DissolveVertex2Fragment(v.texcoord, v.texcoord1.xy, o.dissolveUV);
#endif

    return o;
}





void ApplyTreeLighting(inout half3 light, half3 albedo, half gloss, half specular, half3 lightColor, float2 param)
{
    half nl = param.r;
    light += albedo * lightColor * nl;

    float nh = param.g;
    float spec = pow (nh, specular) * gloss;
    light += lightColor * _SpecColor.rgb * spec;
}

fixed4 frag (v2f i) : SV_Target
{

#ifdef _DISSOLVETRIPLANAR_ON
	float alpha = ReadDissolveAlpha_Triplanar(i.coords, i.objNormal, i.worldPos);
#else
	float alpha = ReadDissolveAlpha(i.uv.xy, i.dissolveUV, i.worldPos);
#endif
DoDissolveClip(alpha);


    fixed4 albedo = tex2D (_MainTex, i.uv);


#ifdef _MAINTEXCUTOFF_ON
	clip(albedo.a - _Cutoff * 1.01);
#endif


	albedo.rgb *= i.color;
    half gloss = tex2D(_TranslucencyMap, i.uv).a;
    half specular = tex2D (_BumpSpecMap, i.uv).r * 128.0;

    half3 light = UNITY_LIGHTMODEL_AMBIENT * albedo.rgb;

    ApplyTreeLighting(light, albedo.rgb, gloss, specular, _TerrainTreeLightColors[0], i.params1);
    ApplyTreeLighting(light, albedo.rgb, gloss, specular, _TerrainTreeLightColors[1], i.params2);
    ApplyTreeLighting(light, albedo.rgb, gloss, specular, _TerrainTreeLightColors[2], i.params3);

    fixed4 c;
    c.rgb = light;

	c.rgb += DoDissolveEmission(alpha, 0);


    c.a = 1.0;
    UNITY_OPAQUE_ALPHA(c.a);
    return c;
}
ENDCG
    }
}

FallBack Off
CustomEditor "AdvancedDissolveGUI"
}
