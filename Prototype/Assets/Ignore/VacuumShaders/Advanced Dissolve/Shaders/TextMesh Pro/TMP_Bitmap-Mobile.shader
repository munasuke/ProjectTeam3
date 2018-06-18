Shader "VacuumShaders/Advanced Dissolve/TextMeshPro/Mobile/Bitmap" {

Properties {
	_MainTex		("Font Atlas", 2D) = "white" {}
	_Color			("Text Color", Color) = (1,1,1,1)
	_DiffusePower	("Diffuse Power", Range(1.0,4.0)) = 1.0

	_VertexOffsetX("Vertex OffsetX", float) = 0
	_VertexOffsetY("Vertex OffsetY", float) = 0
	_MaskSoftnessX("Mask SoftnessX", float) = 0
	_MaskSoftnessY("Mask SoftnessY", float) = 0

	_ClipRect("Clip Rect", vector) = (-32767, -32767, 32767, 32767)

	_StencilComp("Stencil Comparison", Float) = 8
	_Stencil("Stencil ID", Float) = 0
	_StencilOp("Stencil Operation", Float) = 0
	_StencilWriteMask("Stencil Write Mask", Float) = 255
	_StencilReadMask("Stencil Read Mask", Float) = 255

	_ColorMask("Color Mask", Float) = 15


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

	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

	Stencil
	{
		Ref[_Stencil]
		Comp[_StencilComp]
		Pass[_StencilOp]
		ReadMask[_StencilReadMask]
		WriteMask[_StencilWriteMask]
	}


	Lighting Off
	Cull Off
	ZTest [unity_GUIZTestMode]
	ZWrite Off
	Fog { Mode Off }
	Blend SrcAlpha OneMinusSrcAlpha
	ColorMask[_ColorMask]

	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest

		#pragma multi_compile __ UNITY_UI_CLIP_RECT


		#include "UnityCG.cginc"


		sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed _Cutoff;

#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"


		struct appdata_t {
			float4 vertex : POSITION;
			fixed4 color : COLOR;
			float2 texcoord0 : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
			float3 normal    : NORMAL;
		};

		struct v2f {
			float4 vertex		: POSITION;
			fixed4 color		: COLOR;
			float2 texcoord0	: TEXCOORD0;
			float4 mask			: TEXCOORD2;

			float3 worldPos : TEXCOORD3;
#ifdef _DISSOLVETRIPLANAR_ON
			half3 objNormal : TEXCOORD4;
			float3 coords : TEXCOORD5;
#else
			float4 dissolveUV : TEXCOORD4;
#endif	
		};


		fixed4		_Color;
		float		_DiffusePower;

		uniform float		_VertexOffsetX;
		uniform float		_VertexOffsetY;
		uniform float4		_ClipRect;
		uniform float		_MaskSoftnessX;
		uniform float		_MaskSoftnessY;

		v2f vert (appdata_t v)
		{
			v2f OUT;
			float4 vert = v.vertex;
			vert.x += _VertexOffsetX;
			vert.y += _VertexOffsetY;

			vert.xy += (vert.w * 0.5) / _ScreenParams.xy;

			OUT.vertex = UnityPixelSnap(UnityObjectToClipPos(vert));
			OUT.color = v.color;
			OUT.color *= _Color;
			OUT.color.rgb *= _DiffusePower;
			OUT.texcoord0 = v.texcoord0;

			float2 pixelSize = OUT.vertex.w;
			//pixelSize /= abs(float2(_ScreenParams.x * UNITY_MATRIX_P[0][0], _ScreenParams.y * UNITY_MATRIX_P[1][1]));

			// Clamp _ClipRect to 16bit.
			float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
			OUT.mask = float4(vert.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_MaskSoftnessX, _MaskSoftnessY) + pixelSize.xy));


			//VacuumShaders 
			OUT.worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)).xyz;
#ifdef _DISSOLVETRIPLANAR_ON
			OUT.coords = float4(v.vertex.xyz, 1);
			OUT.objNormal = lerp(UnityObjectToWorldNormal(v.normal), v.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
			DissolveVertex2Fragment(v.texcoord0, v.texcoord1, OUT.dissolveUV);
#endif


			return OUT;
		}

		fixed4 frag (v2f IN) : COLOR
		{

#ifdef _DISSOLVETRIPLANAR_ON
			float alpha = ReadDissolveAlpha_Triplanar(IN.coords, IN.objNormal, IN.worldPos);
#else
			float alpha = ReadDissolveAlpha(IN.texcoord0.xy, IN.dissolveUV, IN.worldPos);
#endif				
		DoDissolveClip(alpha);


			fixed4 color = fixed4(IN.color.rgb, IN.color.a * tex2D(_MainTex, IN.texcoord0).a);

			// Alternative implementation to UnityGet2DClipping with support for softness.
			#if UNITY_UI_CLIP_RECT
				half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
				color *= m.x * m.y;
			#endif
			
//#if UNITY_UI_ALPHACLIP
				clip(color.a - 0.001);
			//#endif

			color.rgb += DoDissolveEmission(alpha, 0);

			
			return color;
		}
		ENDCG
	}
}

//CustomEditor "TMPro.EditorUtilities.TMP_BitmapShaderGUI"
CustomEditor "AdvancedDissolveTextMeshProGUI"
}
