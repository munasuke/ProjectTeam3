Shader "Hidden/VacuumShaders/Advanced Dissolve/Nature/Tree Creator/Leaves Rendertex" {
Properties {
    _TranslucencyColor ("Translucency Color", Color) = (0.73,0.85,0.41,1) // (187,219,106,255)
    _Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    _HalfOverCutoff ("0.5 / alpha cutoff", Range(0,1)) = 1.0
    _TranslucencyViewDependency ("View dependency", Range(0,1)) = 0.7

    _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
    _BumpSpecMap ("Normalmap (GA) Spec (R) Shadow Offset (B)", 2D) = "bump" {}
    _TranslucencyMap ("Trans (B) Gloss(A)", 2D) = "white" {}



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

			Cull[_Cull]

    Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 3.0
#include "UnityCG.cginc"
#include "UnityBuiltin3xTreeLibrary.cginc"


sampler2D _MainTex;
sampler2D _BumpSpecMap;
sampler2D _TranslucencyMap;
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
    float3 backContrib : TEXCOORD2;
    float3 nl : TEXCOORD3;
    float3 nh : TEXCOORD4;
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

v2f vert (appdata_full v) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    ExpandBillboard (UNITY_MATRIX_IT_MV, v.vertex, v.normal, v.tangent);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;
    float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));

    for (int j = 0; j < 3; j++)
    {
        float3 lightDir = _TerrainTreeLightDirections[j];

        half nl = dot (v.normal, lightDir);

        // view dependent back contribution for translucency
        half backContrib = saturate(dot(viewDir, -lightDir));

        // normally translucency is more like -nl, but looks better when it's view dependent
        backContrib = lerp(saturate(-nl), backContrib, _TranslucencyViewDependency);
        o.backContrib[j] = backContrib * 2;

        // wrap-around diffuse
        nl = max (0, nl * 0.6 + 0.4);
        o.nl[j] = nl;

        half3 h = normalize (lightDir + viewDir);
        float nh = max (0, dot (v.normal, h));
        o.nh[j] = nh;
    }

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


half3 CalcTreeLighting(half3 lightColor, fixed3 albedo, half backContrib, half nl, half nh, half specular, half gloss)
{
    half3 translucencyColor = backContrib * _TranslucencyColor;

    half spec = pow (nh, specular) * gloss;
    return (albedo * (translucencyColor + nl) + _SpecColor.rgb * spec) * lightColor;
}

fixed4 frag (v2f i) : SV_Target {


#ifdef _DISSOLVETRIPLANAR_ON
	float alpha = ReadDissolveAlpha_Triplanar(i.coords, i.objNormal, i.worldPos);
#else
	float alpha = ReadDissolveAlpha(i.uv.xy, i.dissolveUV, i.worldPos);
#endif
DoDissolveClip(alpha);


    fixed4 col = tex2D (_MainTex, i.uv);
    clip (col.a - _Cutoff);

    fixed3 albedo = col.rgb * i.color;

    half specular = tex2D (_BumpSpecMap, i.uv).r * 128.0;

    fixed4 trngls = tex2D (_TranslucencyMap, i.uv);
    half gloss = trngls.a;

    half3 light = UNITY_LIGHTMODEL_AMBIENT * albedo;

    half3 backContribs = i.backContrib * trngls.b;

/*  This is unrolled below, indexing into a vec3 components is a terrible idea
    for (int j = 0; j < 3; j++)
    {
        half3 lightColor = _TerrainTreeLightColors[j].rgb;
        half3 translucencyColor = backContribs[j] * _TranslucencyColor;

        half nl = i.nl[j];
        half nh = i.nh[j];
        half spec = pow (nh, specular) * gloss;
        light += (albedo * (translucencyColor + nl) + _SpecColor.rgb * spec) * lightColor;
    }*/

    light += CalcTreeLighting(_TerrainTreeLightColors[0].rgb, albedo, backContribs.x, i.nl.x, i.nh.x, specular, gloss);
    light += CalcTreeLighting(_TerrainTreeLightColors[1].rgb, albedo, backContribs.y, i.nl.y, i.nh.y, specular, gloss);
    light += CalcTreeLighting(_TerrainTreeLightColors[2].rgb, albedo, backContribs.z, i.nl.z, i.nh.z, specular, gloss);

    fixed4 c;
    c.rgb = light;

	c.rgb += DoDissolveEmission(alpha, 0);


    c.a = 1;
    return c;
}
ENDCG
    }
}

FallBack Off
CustomEditor "AdvancedDissolveGUI"
}
