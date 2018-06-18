Shader "VacuumShaders/Advanced Dissolve/Nature/Tree Creator/Leaves Fast" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _TranslucencyColor ("Translucency Color", Color) = (0.73,0.85,0.41,1) // (187,219,106,255)
    _Cutoff ("Alpha cutoff", Range(0,1)) = 0.3
    _TranslucencyViewDependency ("View dependency", Range(0,1)) = 0.7
    _ShadowStrength("Shadow Strength", Range(0,1)) = 1.0

    _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}

    // These are here only to provide default values
    [HideInInspector] _TreeInstanceColor ("TreeInstanceColor", Vector) = (1,1,1,1)
    [HideInInspector] _TreeInstanceScale ("TreeInstanceScale", Vector) = (1,1,1,1)
    [HideInInspector] _SquashAmount ("Squash", Float) = 1


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
    Tags {
        "IgnoreProjector"="True"
        "RenderType" = "AdvancedDissolveTreeLeaf"
    }
	Cull[_Cull]
    LOD 200

    Pass {
        Tags { "LightMode" = "ForwardBase" }
        Name "ForwardBase"

    CGPROGRAM
        #include "UnityBuiltin3xTreeLibrary.cginc"

        #pragma vertex VertexLeaf
        #pragma fragment FragmentLeaf
        #pragma multi_compile_fwdbase nolightmap
        #pragma multi_compile_fog

        sampler2D _MainTex;
        float4 _MainTex_ST;

        fixed _Cutoff;
        sampler2D _ShadowMapTexture;


#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"

        struct v2f_leaf {
            float4 pos : SV_POSITION;
            fixed4 diffuse : COLOR0;
        #if defined(SHADOWS_SCREEN)
            fixed4 mainLight : COLOR1;
        #endif
            float2 uv : TEXCOORD0;
        #if defined(SHADOWS_SCREEN)
            float4 screenPos : TEXCOORD1;
        #endif
			UNITY_FOG_COORDS(2)
				UNITY_VERTEX_OUTPUT_STEREO


				float3 worldPos : TEXCOORD3;
#ifdef _DISSOLVETRIPLANAR_ON
				half3 objNormal : TEXCOORD4;
			float3 coords : TEXCOORD5;
#else
				float4 dissolveUV : TEXCOORD4;
#endif
        };

        v2f_leaf VertexLeaf (appdata_full v)
        {
            v2f_leaf o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            TreeVertLeaf(v);
            o.pos = UnityObjectToClipPos(v.vertex);

            fixed ao = v.color.a;
            ao += 0.1; ao = saturate(ao * ao * ao); // emphasize AO

            fixed3 color = v.color.rgb * ao;

            float3 worldN = UnityObjectToWorldNormal (v.normal);

            fixed4 mainLight;
            mainLight.rgb = ShadeTranslucentMainLight (v.vertex, worldN) * color;
            mainLight.a = v.color.a;
            o.diffuse.rgb = ShadeTranslucentLights (v.vertex, worldN) * color;
            o.diffuse.a = 1;
        #if defined(SHADOWS_SCREEN)
            o.mainLight = mainLight;
            o.screenPos = ComputeScreenPos (o.pos);
        #else
            o.diffuse += mainLight;
        #endif
            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
            UNITY_TRANSFER_FOG(o,o.pos);


			o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
			//VacuumShaders
#ifdef _DISSOLVETRIPLANAR_ON
			o.coords = v.vertex;
			o.objNormal = lerp(worldN, v.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
			DissolveVertex2Fragment(v.texcoord, v.texcoord1.xy, o.dissolveUV);
#endif


            return o;
        }

        fixed4 FragmentLeaf (v2f_leaf IN) : SV_Target
        {

#ifdef _DISSOLVETRIPLANAR_ON
			float dAlpha = ReadDissolveAlpha_Triplanar(IN.coords, IN.objNormal, IN.worldPos);
#else
			float dAlpha = ReadDissolveAlpha(IN.uv.xy, IN.dissolveUV, IN.worldPos);
#endif
		DoDissolveClip(dAlpha);


            fixed4 albedo = tex2D(_MainTex, IN.uv);
            fixed alpha = albedo.a;
            clip (alpha - _Cutoff);

        #if defined(SHADOWS_SCREEN)
            half4 light = IN.mainLight;
            half atten = tex2Dproj(_ShadowMapTexture, UNITY_PROJ_COORD(IN.screenPos)).r;
            light.rgb *= lerp(1, atten, _ShadowStrength);
            light.rgb += IN.diffuse.rgb;
        #else
            half4 light = IN.diffuse;
        #endif

            fixed4 col = fixed4 (albedo.rgb * light, 0.0);


			col.rgb += DoDissolveEmission(dAlpha, 0);


            UNITY_APPLY_FOG(IN.fogCoord, col);
            return col;
        }

    ENDCG
    }
}

Dependency "OptimizedShader" = "VacuumShaders/Advanced Dissolve/Nature/Tree Creator/Leaves Fast Optimized"

Fallback "VacuumShaders/Advanced Dissolve/VertexLit"
CustomEditor "AdvancedDissolveGUI"
}
