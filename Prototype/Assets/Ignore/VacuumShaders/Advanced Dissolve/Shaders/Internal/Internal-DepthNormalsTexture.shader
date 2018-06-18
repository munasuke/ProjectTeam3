// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Hidden/Internal-DepthNormalsTexture" {
Properties {
    _MainTex ("", 2D) = "white" {}
    _Cutoff ("", Float) = 0.5
    _Color ("", Color) = (1,1,1,1)



		//VacuumShaders
		[HideInInspector]_DissolveCutoff("Dissolve", Range(0,1)) = 0.500000

		[KeywordEnum(None, Axis Local, Axis Global, Plane, Sphere, Box)] _DissolveMask("", Float) = 0
		[HideInInspector][KeywordEnum(One, Two, Three, Four)]  _DissolveMask_Count("", Float) = 0
		[Enum(X,0,Y,1,Z,2)] _DissolveCutoffAxis("Axis", int) = 0
		_DissolveAxisInvert("Axis Invert", Float) = 1
		_DissolveMaskOffset("Mask Offset", Float) = 0
		_DissolveEdgeSize("Edge Size", Range(0.0, 1.0)) = 0.15
		[KeywordEnum(Main Map Alpha, Custom Map, Two Custom Maps, Three Custom Maps)] _DissolveAlphaSource("", Float) = 0
		_DissolveMap1("", 2D) = "white"{}
		[UVScroll] _DissolveMap1_Scroll("", vector) = (0, 0, 0, 0)
		_DissolveMap2("", 2D) = "white"{}
		[UVScroll] _DissolveMap2_Scroll("", vector) = (0, 0, 0, 0)
		_DissolveMap3("", 2D) = "white"{}
		[UVScroll] _DissolveMap3_Scroll("", vector) = (0, 0, 0, 0)
		_DissolveNoiseStrength("", Float) = 0.1

		[HideInInspector]_DissolveMaskPosition("", Vector) = (0, 0, 0, 0)
		[HideInInspector]_DissolveMaskPlaneNormal("", Vector) = (1, 0, 0, 0)
		[HideInInspector]_DissolveMaskSphereRadius("", Float) = 1
		
		[HideInInspector]_Dissolve_ObjectWorldPos("wPos", vector) = (0, 0, 0, 0)

		[HideInInspector][Enum(World Space, 0, Object Space, 1)]  _DissolveTriplanarMappingSpace("", Float) = 0
		[HideInInspector] _DissolveTriplanarMainMapTiling("", Float) = 1


		[HideInInspector][Toggle] _DissolveTriplanar("Triplanar?", Float) = 0
		[HideInInspector][Enum(World Space, 0, Object Space, 1)]  _DissolveTriplanarMappingSpace("", Float) = 0
		[HideInInspector] _DissolveTriplanarMainMapTiling("", Float) = 1

		[HideInInspector][KeywordEnum(None, Mask Only, Mask And Edge, All)] _DissolveGlobalControl("Global Controll", Float) = 0
}

SubShader {
    Tags { "RenderType"="Opaque" }
    Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
struct v2f {
    float4 pos : SV_POSITION;
    float4 nz : TEXCOORD0;
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f vert( appdata_base v ) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.nz.xyz = COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
fixed4 frag(v2f i) : SV_Target {
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
}

SubShader {
    Tags { "RenderType"="TransparentCutout" }
    Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
struct v2f {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float4 nz : TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};
uniform float4 _MainTex_ST;
v2f vert( appdata_base v ) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
    o.nz.xyz = COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
uniform sampler2D _MainTex;
uniform fixed _Cutoff;
uniform fixed4 _Color;
fixed4 frag(v2f i) : SV_Target {
    fixed4 texcol = tex2D( _MainTex, i.uv );
    clip( texcol.a*_Color.a - _Cutoff );
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
}

SubShader {
    Tags { "RenderType"="TreeBark" }
    Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityBuiltin3xTreeLibrary.cginc"
struct v2f {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float4 nz : TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f vert( appdata_full v ) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    TreeVertBark(v);

    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;
    o.nz.xyz = COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
fixed4 frag( v2f i ) : SV_Target {
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
}

SubShader {
    Tags { "RenderType"="TreeLeaf" }
    Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityBuiltin3xTreeLibrary.cginc"
struct v2f {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float4 nz : TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f vert( appdata_full v ) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    TreeVertLeaf(v);

    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;
    o.nz.xyz = COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
uniform sampler2D _MainTex;
uniform fixed _Cutoff;
fixed4 frag( v2f i ) : SV_Target {
    half alpha = tex2D(_MainTex, i.uv).a;

    clip (alpha - _Cutoff);
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
}

SubShader {
    Tags { "RenderType"="TreeOpaque" "DisableBatching"="True" }
    Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "TerrainEngine.cginc"
struct v2f {
    float4 pos : SV_POSITION;
    float4 nz : TEXCOORD0;
    UNITY_VERTEX_OUTPUT_STEREO
};
struct appdata {
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    fixed4 color : COLOR;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
v2f vert( appdata v ) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    TerrainAnimateTree(v.vertex, v.color.w);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.nz.xyz = COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
fixed4 frag(v2f i) : SV_Target {
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
}

SubShader {
    Tags { "RenderType"="TreeTransparentCutout" "DisableBatching"="True" }
    Pass {
        Cull Back
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "TerrainEngine.cginc"

struct v2f {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float4 nz : TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};
struct appdata {
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    fixed4 color : COLOR;
    float4 texcoord : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
v2f vert( appdata v ) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    TerrainAnimateTree(v.vertex, v.color.w);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;
    o.nz.xyz = COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
uniform sampler2D _MainTex;
uniform fixed _Cutoff;
fixed4 frag(v2f i) : SV_Target {
    half alpha = tex2D(_MainTex, i.uv).a;

    clip (alpha - _Cutoff);
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
    Pass {
        Cull Front
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "TerrainEngine.cginc"

struct v2f {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float4 nz : TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};
struct appdata {
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    fixed4 color : COLOR;
    float4 texcoord : TEXCOORD0;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};
v2f vert( appdata v ) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    TerrainAnimateTree(v.vertex, v.color.w);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;
    o.nz.xyz = -COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
uniform sampler2D _MainTex;
uniform fixed _Cutoff;
fixed4 frag(v2f i) : SV_Target {
    fixed4 texcol = tex2D( _MainTex, i.uv );
    clip( texcol.a - _Cutoff );
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }

}

SubShader {
    Tags { "RenderType"="TreeBillboard" }
    Pass {
        Cull Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "TerrainEngine.cginc"
struct v2f {
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
    float4 nz : TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};
v2f vert (appdata_tree_billboard v) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    TerrainBillboardTree(v.vertex, v.texcoord1.xy, v.texcoord.y);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv.x = v.texcoord.x;
    o.uv.y = v.texcoord.y > 0;
    o.nz.xyz = float3(0,0,1);
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
uniform sampler2D _MainTex;
fixed4 frag(v2f i) : SV_Target {
    fixed4 texcol = tex2D( _MainTex, i.uv );
    clip( texcol.a - 0.001 );
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
}

SubShader {
    Tags { "RenderType"="GrassBillboard" }
    Pass {
        Cull Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "TerrainEngine.cginc"

struct v2f {
    float4 pos : SV_POSITION;
    fixed4 color : COLOR;
    float2 uv : TEXCOORD0;
    float4 nz : TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};

v2f vert (appdata_full v) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    WavingGrassBillboardVert (v);
    o.color = v.color;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord.xy;
    o.nz.xyz = COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
uniform sampler2D _MainTex;
uniform fixed _Cutoff;
fixed4 frag(v2f i) : SV_Target {
    fixed4 texcol = tex2D( _MainTex, i.uv );
    fixed alpha = texcol.a * i.color.a;
    clip( alpha - _Cutoff );
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
}

SubShader {
    Tags { "RenderType"="Grass" }
    Pass {
        Cull Off
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "TerrainEngine.cginc"
struct v2f {
    float4 pos : SV_POSITION;
    fixed4 color : COLOR;
    float2 uv : TEXCOORD0;
    float4 nz : TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};

v2f vert (appdata_full v) {
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    WavingGrassVert (v);
    o.color = v.color;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord;
    o.nz.xyz = COMPUTE_VIEW_NORMAL;
    o.nz.w = COMPUTE_DEPTH_01;
    return o;
}
uniform sampler2D _MainTex;
uniform fixed _Cutoff;
fixed4 frag(v2f i) : SV_Target {
    fixed4 texcol = tex2D( _MainTex, i.uv );
    fixed alpha = texcol.a * i.color.a;
    clip( alpha - _Cutoff );
    return EncodeDepthNormal (i.nz.w, i.nz.xyz);
}
ENDCG
    }
}






SubShader 
{
	Tags { "RenderType"="AdvancedDissolveCutout" }

    Pass 
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		

		uniform float4 _MainTex_ST;
		uniform sampler2D _MainTex;
		uniform fixed4 _Color;
		uniform fixed _Cutoff;

		#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
		#pragma shader_feature _ _MAINTEXCUTOFF_ON
		#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
		#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
		#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
		#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
		#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"


		struct v2f 
		{
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float4 nz : TEXCOORD1;

			//VacuumShaders
			float3 worldPos : TEXCOORD2;
#ifdef _DISSOLVETRIPLANAR_ON
			half3 objNormal : TEXCOORD3;
			float3 coords : TEXCOORD4;
#else
			float4 dissolveUV : TEXCOORD3;
			
#endif


			UNITY_VERTEX_OUTPUT_STEREO
		};

		

		v2f vert(appdata_full v )
		{
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
			o.nz.xyz = COMPUTE_VIEW_NORMAL;
			o.nz.w = COMPUTE_DEPTH_01;



			//VacuumShaders
			o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#ifdef _DISSOLVETRIPLANAR_ON
			o.coords = v.vertex;
			o.objNormal = lerp(UnityObjectToWorldNormal(v.normal), v.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
			DissolveVertex2Fragment(v.texcoord, v.texcoord1, o.dissolveUV);
#endif
			


			return o;
		}

		


		fixed4 frag(v2f i) : SV_Target 
		{
#ifdef _DISSOLVETRIPLANAR_ON
			float alpha = ReadDissolveAlpha_Triplanar(i.coords, i.objNormal, i.worldPos);
#else
			float alpha = ReadDissolveAlpha(i.uv, i.dissolveUV, i.worldPos);
#endif
			DoDissolveClip(alpha);


#ifdef _MAINTEXCUTOFF_ON
			clip(tex2D(_MainTex, i.uv).a * _Color.a - _Cutoff);
#endif

			return EncodeDepthNormal (i.nz.w, i.nz.xyz);
		}
		ENDCG
    }
}

SubShader{
			Tags{ "RenderType" = "AdvancedDissolveTreeOpaque" "DisableBatching" = "True" }
			
			Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "TerrainEngine.cginc"


			uniform float4 _MainTex_ST;
			uniform sampler2D _MainTex;
			uniform fixed4 _Color;
			uniform fixed _Cutoff;

			#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
			#pragma shader_feature _ _MAINTEXCUTOFF_ON
			#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
			#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
			#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
			#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
			#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"

			struct v2f 
			{
			float4 pos : SV_POSITION;
			float4 nz : TEXCOORD0;
			UNITY_VERTEX_OUTPUT_STEREO


			float2 uv : TEXCOORD1;
			float3 worldPos : TEXCOORD2;
#ifdef _DISSOLVETRIPLANAR_ON
	  half3 objNormal : TEXCOORD3;
  float3 coords : TEXCOORD4;
#else
	  float4 dissolveUV : TEXCOORD3;
#endif
		};

			v2f vert(appdata_full v) {
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			TerrainAnimateTree(v.vertex, v.color.w);
			o.pos = UnityObjectToClipPos(v.vertex);
			o.nz.xyz = COMPUTE_VIEW_NORMAL;
			o.nz.w = COMPUTE_DEPTH_01;


			o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
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
		fixed4 frag(v2f i) : SV_Target{

#ifdef _DISSOLVETRIPLANAR_ON
			float alpha = ReadDissolveAlpha_Triplanar(i.coords, i.objNormal, i.worldPos);
#else
			float alpha = ReadDissolveAlpha(i.uv.xy, i.dissolveUV, i.worldPos);
#endif
		DoDissolveClip(alpha);


#ifdef _MAINTEXCUTOFF_ON
		clip(tex2D(_MainTex, i.uv).a * _Color.a - _Cutoff);
#endif

			return EncodeDepthNormal(i.nz.w, i.nz.xyz);
		}
			ENDCG
			}
		}

SubShader{
			Tags{ "RenderType" = "AdvancedDissolveTreeBark" }
			Pass{
			CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#include "UnityBuiltin3xTreeLibrary.cginc"



		uniform sampler2D _MainTex;
		uniform fixed _Cutoff;

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
			float4 nz : TEXCOORD1;
			UNITY_VERTEX_OUTPUT_STEREO

				//VacuumShaders
				float3 worldPos : TEXCOORD2;
#ifdef _DISSOLVETRIPLANAR_ON
			half3 objNormal : TEXCOORD3;
			float3 coords : TEXCOORD4;
#else
			float4 dissolveUV : TEXCOORD3;

#endif
		};
		v2f vert(appdata_full v) {
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			TreeVertBark(v);

			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord.xy;
			o.nz.xyz = COMPUTE_VIEW_NORMAL;
			o.nz.w = COMPUTE_DEPTH_01;


			o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
#ifdef _DISSOLVETRIPLANAR_ON
			o.coords = v.vertex;
			o.objNormal = lerp(UnityObjectToWorldNormal(v.normal), v.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
			DissolveVertex2Fragment(v.texcoord, v.texcoord1, o.dissolveUV);
#endif


			return o;
		}
		fixed4 frag(v2f i) : SV_Target{

#ifdef _DISSOLVETRIPLANAR_ON
			float alpha = ReadDissolveAlpha_Triplanar(i.coords, i.objNormal, i.worldPos);
#else
			float alpha = ReadDissolveAlpha(i.uv, i.dissolveUV, i.worldPos);
#endif
		DoDissolveClip(alpha);


#ifdef _MAINTEXCUTOFF_ON
		clip(tex2D(_MainTex, i.uv).a * _Color.a - _Cutoff);
#endif


			return EncodeDepthNormal(i.nz.w, i.nz.xyz);
		}
			ENDCG
		}
		}


SubShader {
    Tags { "RenderType"="AdvancedDissolveTreeLeaf" }
    Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#include "UnityBuiltin3xTreeLibrary.cginc"

		uniform sampler2D _MainTex;
				uniform fixed _Cutoff;

		#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
		#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
		#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
		#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
		#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
		#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"


		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float4 nz : TEXCOORD1;
			UNITY_VERTEX_OUTPUT_STEREO


			float3 worldPos : TEXCOORD2;
		#ifdef _DISSOLVETRIPLANAR_ON
			half3 objNormal : TEXCOORD3;
			float3 coords : TEXCOORD4;
		#else
			float4 dissolveUV : TEXCOORD3;
		#endif
		};
		v2f vert( appdata_full v ) {
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			TreeVertLeaf(v);

			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord.xy;
			o.nz.xyz = COMPUTE_VIEW_NORMAL;
			o.nz.w = COMPUTE_DEPTH_01;


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

		fixed4 frag( v2f i ) : SV_Target {


		#ifdef _DISSOLVETRIPLANAR_ON
			float dAlpha = ReadDissolveAlpha_Triplanar(i.coords, i.objNormal, i.worldPos);
		#else
			float dAlpha = ReadDissolveAlpha(i.uv.xy, i.dissolveUV, i.worldPos);
		#endif
		DoDissolveClip(dAlpha);


			half alpha = tex2D(_MainTex, i.uv).a;

			clip (alpha - _Cutoff);
			return EncodeDepthNormal (i.nz.w, i.nz.xyz);
		}
		ENDCG
    }
}

SubShader{
			Tags{ "RenderType" = "AdvancedDissolveTreeTransparentCutout" "DisableBatching" = "True" }
			
			
			Pass{
			Cull Back
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "TerrainEngine.cginc"


			uniform sampler2D _MainTex;
		uniform fixed _Cutoff;
#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"

			struct v2f {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float4 nz : TEXCOORD1;
			UNITY_VERTEX_OUTPUT_STEREO

				float3 worldPos : TEXCOORD2;
#ifdef _DISSOLVETRIPLANAR_ON
			half3 objNormal : TEXCOORD3;
			float3 coords : TEXCOORD4;
#else
			float4 dissolveUV : TEXCOORD3;
#endif
		};


		v2f vert(appdata_full v) {
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			TerrainAnimateTree(v.vertex, v.color.w);
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord.xy;
			o.nz.xyz = COMPUTE_VIEW_NORMAL;
			o.nz.w = COMPUTE_DEPTH_01;


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
		
		fixed4 frag(v2f i) : SV_Target{

#ifdef _DISSOLVETRIPLANAR_ON
			float dAlpha = ReadDissolveAlpha_Triplanar(i.coords, i.objNormal, i.worldPos);
#else
			float dAlpha = ReadDissolveAlpha(i.uv.xy, i.dissolveUV, i.worldPos);
#endif
		DoDissolveClip(dAlpha);


			half alpha = tex2D(_MainTex, i.uv).a;

		clip(alpha - _Cutoff);
		return EncodeDepthNormal(i.nz.w, i.nz.xyz);
		}
			ENDCG
		}
			
	Pass{
			Cull Front
			CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#include "UnityCG.cginc"
#include "TerrainEngine.cginc"


			uniform sampler2D _MainTex;
		uniform fixed _Cutoff;

#pragma shader_feature _DISSOLVEGLOBALCONTROL_NONE _DISSOLVEGLOBALCONTROL_MASK_ONLY _DISSOLVEGLOBALCONTROL_MASK_AND_EDGE _DISSOLVEGLOBALCONTROL_ALL
#pragma shader_feature _ _DISSOLVETRIPLANAR_ON
#pragma shader_feature _DISSOLVEALPHASOURCE_MAIN_MAP_ALPHA _DISSOLVEALPHASOURCE_CUSTOM_MAP _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
#pragma shader_feature _DISSOLVEMASK_NONE _DISSOLVEMASK_AXIS_LOCAL _DISSOLVEMASK_AXIS_GLOBAL _DISSOLVEMASK_PLANE _DISSOLVEMASK_SPHERE _DISSOLVEMASK_BOX
#pragma shader_feature _DISSOLVEMASK_COUNT_ONE _DISSOLVEMASK_COUNT_TWO _DISSOLVEMASK_COUNT_THREE _DISSOLVEMASK_COUNT_FOUR
#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"



			struct v2f {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float4 nz : TEXCOORD1;
			UNITY_VERTEX_OUTPUT_STEREO


				float3 worldPos : TEXCOORD2;
#ifdef _DISSOLVETRIPLANAR_ON
			half3 objNormal : TEXCOORD3;
			float3 coords : TEXCOORD4;
#else
			float4 dissolveUV : TEXCOORD3;
#endif
		};
		v2f vert(appdata_full v) {
			v2f o;
			UNITY_SETUP_INSTANCE_ID(v);
			UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
			TerrainAnimateTree(v.vertex, v.color.w);
			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord.xy;
			o.nz.xyz = -COMPUTE_VIEW_NORMAL;
			o.nz.w = COMPUTE_DEPTH_01;


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
		
		fixed4 frag(v2f i) : SV_Target{


#ifdef _DISSOLVETRIPLANAR_ON
			float alpha = ReadDissolveAlpha_Triplanar(i.coords, i.objNormal, i.worldPos);
#else
			float alpha = ReadDissolveAlpha(i.uv.xy, i.dissolveUV, i.worldPos);
#endif
		DoDissolveClip(alpha);



			fixed4 texcol = tex2D(_MainTex, i.uv);
		clip(texcol.a - _Cutoff);
		return EncodeDepthNormal(i.nz.w, i.nz.xyz);
		}
			ENDCG
		}

		}


Fallback Off
}
