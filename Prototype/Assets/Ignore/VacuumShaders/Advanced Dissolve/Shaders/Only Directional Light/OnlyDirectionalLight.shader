Shader "VacuumShaders/Advanced Dissolve/Only Directional Light" 
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB)", 2D) = "white" {}
		[Toggle] _MainTexCutoff("Enable Main Texture Cutout", Float) = 0
		_Cutoff("   Alpha cutoff", Range(0,1)) = 0.5




		[MaterialEnum(Off,0,Front,1,Back,2)] _Cull("Face Cull", Int) = 0

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

	SubShader
	{
			Tags{ "RenderType" = "AdvancedDissolveCutout" "DisableBatching" = "True" }
		LOD 80
		Cull[_Cull]


		Pass 
		{
			Name "FORWARD"
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma vertex vert_surf
			#pragma fragment frag_surf
			#pragma multi_compile_fwdbase
			#pragma multi_compile_fog
			#include "HLSLSupport.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			inline float3 LightingLambertVS(float3 normal, float3 lightDir)
			{
				fixed diff = max(0, dot(normal, lightDir));
				return _LightColor0.rgb * diff;
			}

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed _Cutoff;


#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
#pragma shader_feature _ _MAINTEXCUTOFF_ON
#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"

			
			struct v2f_surf 
			{
			  float4 pos : SV_POSITION;
			  float2 pack0 : TEXCOORD0;
			  #ifndef LIGHTMAP_ON
			  fixed3 normal : TEXCOORD1;
			  #endif
			  #ifdef LIGHTMAP_ON
			  float2 lmap : TEXCOORD2;
			  #endif
			  #ifndef LIGHTMAP_ON
			  fixed3 vlight : TEXCOORD2;
			  #endif
			  LIGHTING_COORDS(3, 4)
				  UNITY_FOG_COORDS(5)
				  UNITY_VERTEX_OUTPUT_STEREO


				  float3 worldPos : TEXCOORD6;
#ifdef _DISSOLVETRIPLANAR_ON		  
		  half3 objNormal : TEXCOORD7;
		  float3 coords : TEXCOORD8;
#else
		  float4 dissolveUV : TEXCOORD7;
#endif
			};


			
			v2f_surf vert_surf(appdata_full v)
			{
				v2f_surf o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
				#ifdef LIGHTMAP_ON
				o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				float3 worldN = UnityObjectToWorldNormal(v.normal);
				#ifndef LIGHTMAP_ON
				o.normal = worldN;
				#endif
				#ifndef LIGHTMAP_ON

				o.vlight = ShadeSH9(float4(worldN,1.0));
				o.vlight += LightingLambertVS(worldN, _WorldSpaceLightPos0.xyz);

				#endif
				TRANSFER_VERTEX_TO_FRAGMENT(o);
				UNITY_TRANSFER_FOG(o,o.pos);



				o.worldPos = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1)).xyz;
#ifdef _DISSOLVETRIPLANAR_ON
				o.coords = float4(v.vertex.xyz, 1);
				o.objNormal = lerp(UnityObjectToWorldNormal(v.normal), v.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
				DissolveVertex2Fragment(v.texcoord, v.texcoord1, o.dissolveUV);
#endif


				return o;
			}
			fixed4 frag_surf(v2f_surf IN) : SV_Target
			{
#ifdef _DISSOLVETRIPLANAR_ON
				float alpha = ReadDissolveAlpha_Triplanar(IN.coords, IN.objNormal, IN.worldPos);
#else
				float alpha = ReadDissolveAlpha(IN.pack0.xy, IN.dissolveUV, IN.worldPos);
#endif
			DoDissolveClip(alpha);
				

				fixed4 tex = tex2D(_MainTex, IN.pack0.xy) * _Color;

#ifdef _MAINTEXCUTOFF_ON
				clip(tex.a * _Color.a - _Cutoff);
#endif

				fixed atten = LIGHT_ATTENUATION(IN);
				fixed4 c = 0;
				#ifndef LIGHTMAP_ON
				c.rgb = tex.rgb * IN.vlight * atten;
				#endif
				#ifdef LIGHTMAP_ON
				fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy));
				#ifdef SHADOWS_SCREEN
				c.rgb += tex.rgb * min(lm, atten * 2);
				#else
				c.rgb += tex.rgb * lm;
				#endif
				c.a = tex.a;
				#endif


				c.rgb += DoDissolveEmission(alpha, 0);


				UNITY_APPLY_FOG(IN.fogCoord, c);
				UNITY_OPAQUE_ALPHA(c.a);
				return c;
			}

	ENDCG
		}
	}

		FallBack "VacuumShaders/Advanced Dissolve/VertexLit"
		CustomEditor "AdvancedDissolveGUI"
}
