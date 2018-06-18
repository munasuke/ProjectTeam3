Shader "VacuumShaders/Advanced Dissolve/Particles/VertexLit Blended" {
Properties {
 _EmisColor ("Emissive Color", Color) = (0.200000,0.200000,0.200000,0.000000)
 _MainTex ("Particle Texture", 2D) = "white" { }
[Toggle] _MainTexCutoff("Enable Main Texture Cutout", Float) = 0
_Cutoff("   Alpha cutoff", Range(0,1)) = 0.5



[HideInInspector]_DissolveCutoff("Dissolve", Range(0,1)) = 0.500000			      
			 
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
 Tags { "LIGHTMODE"="Vertex" "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" "PreviewType"="Plane" }
 Pass {
  Tags { "LIGHTMODE"="Vertex" "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" "PreviewType"="Plane" }
  ZWrite Off
  Cull Off
  Blend SrcAlpha OneMinusSrcAlpha
  ColorMask RGB
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.5
#include "UnityCG.cginc"



sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed _Cutoff;

#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
#pragma shader_feature _ _MAINTEXCUTOFF_ON
#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"


#pragma multi_compile_fog
#define USING_FOG (defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2))

// ES2.0/WebGL/3DS can not do loops with non-constant-expression iteration counts :(
#if defined(SHADER_API_GLES)
  #define LIGHT_LOOP_LIMIT 8
#elif defined(SHADER_API_N3DS)
  #define LIGHT_LOOP_LIMIT 4
#else
  #define LIGHT_LOOP_LIMIT unity_VertexLightParams.x
#endif

// Some ES3 drivers (e.g. older Adreno) have problems with the light loop
#if defined(SHADER_API_GLES3) && !defined(SHADER_API_DESKTOP) && (defined(SPOT) || defined(POINT))
  #define LIGHT_LOOP_ATTRIBUTE UNITY_UNROLL
#else
  #define LIGHT_LOOP_ATTRIBUTE
#endif
#define ENABLE_SPECULAR (!defined(SHADER_API_N3DS))

// Compile specialized variants for when positional (point/spot) and spot lights are present
#pragma multi_compile __ POINT SPOT

// Compute illumination from one light, given attenuation
half3 computeLighting (int idx, half3 dirToLight, half3 eyeNormal, half3 viewDir, half4 diffuseColor, half shininess, half atten, inout half3 specColor) {
  half NdotL = max(dot(eyeNormal, dirToLight), 0.0);
  // diffuse
  half3 color = NdotL * diffuseColor.rgb * unity_LightColor[idx].rgb;
  return color * atten;
}

// Compute attenuation & illumination from one light
half3 computeOneLight(int idx, float3 eyePosition, half3 eyeNormal, half3 viewDir, half4 diffuseColor, half shininess, inout half3 specColor) {
  float3 dirToLight = unity_LightPosition[idx].xyz;
  half att = 1.0;
  #if defined(POINT) || defined(SPOT)
    dirToLight -= eyePosition * unity_LightPosition[idx].w;
    // distance attenuation
    float distSqr = dot(dirToLight, dirToLight);
    att /= (1.0 + unity_LightAtten[idx].z * distSqr);
    if (unity_LightPosition[idx].w != 0 && distSqr > unity_LightAtten[idx].w) att = 0.0; // set to 0 if outside of range
    distSqr = max(distSqr, 0.000001); // don't produce NaNs if some vertex position overlaps with the light
    dirToLight *= rsqrt(distSqr);
    #if defined(SPOT)
      // spot angle attenuation
      half rho = max(dot(dirToLight, unity_SpotDirection[idx].xyz), 0.0);
      half spotAtt = (rho - unity_LightAtten[idx].x) * unity_LightAtten[idx].y;
      att *= saturate(spotAtt);
    #endif
  #endif
  att *= 0.5; // passed in light colors are 2x brighter than what used to be in FFP
  return min (computeLighting (idx, dirToLight, eyeNormal, viewDir, diffuseColor, shininess, att, specColor), 1.0);
}

// uniforms
half4 _EmisColor;
int4 unity_VertexLightParams; // x: light count, y: zero, z: one (y/z needed by d3d9 vs loop instruction)

// vertex shader input data
struct appdata {
  float3 pos : POSITION;
  float3 normal : NORMAL;
  half4 color : COLOR;
  float3 uv0 : TEXCOORD0;
  float3 uv1 : TEXCOORD1;
  UNITY_VERTEX_INPUT_INSTANCE_ID
};

// vertex-to-fragment interpolators
struct v2f {
  fixed4 color : COLOR0;
  float2 uv0 : TEXCOORD0;
  #if USING_FOG
    fixed fog : TEXCOORD1;
  #endif
  float4 pos : SV_POSITION;
  UNITY_VERTEX_OUTPUT_STEREO


	  float3 worldPos : TEXCOORD3;
#ifdef _DISSOLVETRIPLANAR_ON
  half3 objNormal : TEXCOORD4;
  float3 coords : TEXCOORD5;
#else
  float4 dissolveUV : TEXCOORD4;
#endif
};

// vertex shader
v2f vert (appdata IN) {
  v2f o;
  UNITY_SETUP_INSTANCE_ID(IN);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  half4 color = IN.color;
  float3 eyePos = UnityObjectToViewPos(float4(IN.pos,1)).xyz;
  half3 eyeNormal = normalize (mul ((float3x3)UNITY_MATRIX_IT_MV, IN.normal).xyz);
  half3 viewDir = 0.0;
  // lighting
  half3 lcolor = _EmisColor.rgb + color.rgb * glstate_lightmodel_ambient.rgb;
  half3 specColor = 0.0;
  half shininess = 0 * 128.0;
  LIGHT_LOOP_ATTRIBUTE for (int il = 0; il < LIGHT_LOOP_LIMIT; ++il) {
    lcolor += computeOneLight(il, eyePos, eyeNormal, viewDir, color, shininess, specColor);
  }
  color.rgb = lcolor.rgb;
  color.a = color.a;
  o.color = saturate(color);
  // compute texture coordinates
  o.uv0 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
  // fog
  #if USING_FOG
    float fogCoord = length(eyePos.xyz); // radial fog distance
    UNITY_CALC_FOG_FACTOR_RAW(fogCoord);
    o.fog = saturate(unityFogFactor);
  #endif
  // transform position
  o.pos = UnityObjectToClipPos(IN.pos);



  //VacuumShaders 
  o.worldPos = mul(unity_ObjectToWorld, float4(IN.pos.xyz, 1)).xyz;
#ifdef _DISSOLVETRIPLANAR_ON
  o.coords = float4(IN.pos.xyz, 1);
  o.objNormal = lerp(UnityObjectToWorldNormal(IN.normal), IN.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
  DissolveVertex2Fragment(IN.uv0, IN.uv1, o.dissolveUV);
#endif


  return o;
}

// textures

// fragment shader
fixed4 frag (v2f IN) : SV_Target {


#ifdef _DISSOLVETRIPLANAR_ON
	float alpha = ReadDissolveAlpha_Triplanar(IN.coords, IN.objNormal, IN.worldPos);
#else
	float alpha = ReadDissolveAlpha(IN.uv0.xy, IN.dissolveUV, IN.worldPos);
#endif				
DoDissolveClip(alpha);



  fixed4 col;
  fixed4 tex, tmp0, tmp1, tmp2;
  // SetTexture #0
  tex = tex2D (_MainTex, IN.uv0.xy);


  #ifdef _MAINTEXCUTOFF_ON
				clip(tex.a - _Cutoff);
#endif

  col = IN.color * tex;
  // fog
  #if USING_FOG
    col.rgb = lerp (unity_FogColor.rgb, col.rgb, IN.fog);
  #endif
  return col;
}

// texenvs
//! TexEnv0: 01030101 01030101 [_MainTex]
ENDCG
 }
}
CustomEditor "AdvancedDissolveParticlesGUI"
}