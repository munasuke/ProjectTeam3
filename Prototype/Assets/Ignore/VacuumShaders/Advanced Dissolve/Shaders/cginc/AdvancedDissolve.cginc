#ifndef ADVANCED_DISSOLVE_INCLUDED
#define ADVANCED_DISSOLVE_INCLUDED



#if (SHADER_TARGET < 25)
	#if defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS) && defined(_DISSOLVETRIPLANAR_ON)
		#undef _DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS
		#define _DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS
	#endif
#endif

#if (SHADER_TARGET <= 30)
	#if defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) && defined(_PARALLAXMAP)
		#undef _PARALLAXMAP
	#endif 

	#if defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS) && defined(_PARALLAXMAP)
		#undef _PARALLAXMAP

		//Also disable OcclusionMap sampler!!!
	#endif


	#if (_DETAIL_MULX2 || _DETAIL_MUL || _DETAIL_ADD || _DETAIL_LERP)
		#define _DETAIL 0
	#endif
	#if defined(_DETAIL_MULX2)
		#undef _DETAIL_MULX2
	#endif	
#endif



float _DissolveCutoff;						uniform float _DissolveCutoff_Global;

float _DissolveCutoffAxis;					uniform float _DissolveCutoffAxis_Global;
float _DissolveMaskOffset;					uniform float _DissolveMaskOffset_Global;
float _DissolveAxisInvert;					uniform float _DissolveAxisInvert_Global;

float _DissolveEdgeSize;					uniform float _DissolveEdgeSize_Global;
fixed4 _DissolveEdgeColor;					uniform fixed4 _DissolveEdgeColor_Global;
sampler2D _DissolveEdgeRamp;				uniform sampler2D _DissolveEdgeRamp_Global;
float _DissolveGIStrength;					uniform float _DissolveGIStrength_Global;

#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP) || defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
	sampler2D _DissolveMap1;					uniform sampler2D _DissolveMap1_Global;
	float4 _DissolveMap1_ST;					uniform float4 _DissolveMap1_ST_Global;
	float2 _DissolveMap1_Scroll;				uniform float2 _DissolveMap1_Scroll_Global;
#endif
	
#if defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
	sampler2D _DissolveMap2;					uniform sampler2D _DissolveMap2_Global;
	float4 _DissolveMap2_ST;					uniform float4 _DissolveMap2_ST_Global;
	float2 _DissolveMap2_Scroll;				uniform float2 _DissolveMap2_Scroll_Global;
#endif

#if defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
	sampler2D _DissolveMap3;					uniform sampler2D _DissolveMap3_Global;
	float4 _DissolveMap3_ST;					uniform float4 _DissolveMap3_ST_Global;
	float2 _DissolveMap3_Scroll;				uniform float2 _DissolveMap3_Scroll_Global;
#endif


float _DissolveAlphaTextureBlend;			uniform float _DissolveAlphaTextureBlend_Global;
float _DissolveUVSet;						uniform float _DissolveUVSet_Global;
float _DissolveNoiseStrength;				uniform float _DissolveNoiseStrength_Global;

float3 _DissolveMaskPosition;				uniform float3 _DissolveMaskPosition_Global;
float3 _DissolveMaskPlaneNormal;			uniform float3 _DissolveMaskPlaneNormal_Global;
float _DissolveMaskSphereRadius;			uniform float  _DissolveMaskSphereRadius_Global;


#if defined(_DISSOLVEMASK_COUNT_FOUR)
	
	float3 _DissolveMask2Position;				uniform float3 _DissolveMask2Position_Global;
	float3 _DissolveMask2PlaneNormal;			uniform float3 _DissolveMask2PlaneNormal_Global;
	float _DissolveMask2SphereRadius;			uniform float  _DissolveMask2SphereRadius_Global;

	float3 _DissolveMask3Position;				uniform float3 _DissolveMask3Position_Global;
	float3 _DissolveMask3PlaneNormal;			uniform float3 _DissolveMask3PlaneNormal_Global;
	float _DissolveMask3SphereRadius;			uniform float  _DissolveMask3SphereRadius_Global;
	

	float3 _DissolveMask4Position;				uniform float3 _DissolveMask4Position_Global;
	float3 _DissolveMask4PlaneNormal;			uniform float3 _DissolveMask4PlaneNormal_Global;
	float _DissolveMask4SphereRadius;			uniform float  _DissolveMask4SphereRadius_Global;

#elif defined(_DISSOLVEMASK_COUNT_THREE)
	
	float3 _DissolveMask2Position;				uniform float3 _DissolveMask2Position_Global;
	float3 _DissolveMask2PlaneNormal;			uniform float3 _DissolveMask2PlaneNormal_Global;
	float _DissolveMask2SphereRadius;			uniform float  _DissolveMask2SphereRadius_Global;
	
	float3 _DissolveMask3Position;				uniform float3 _DissolveMask3Position_Global;
	float3 _DissolveMask3PlaneNormal;			uniform float3 _DissolveMask3PlaneNormal_Global;
	float _DissolveMask3SphereRadius;			uniform float  _DissolveMask3SphereRadius_Global;	

#elif defined(_DISSOLVEMASK_COUNT_TWO)
	
	float3 _DissolveMask2Position;				uniform float3 _DissolveMask2Position_Global;
	float3 _DissolveMask2PlaneNormal;			uniform float3 _DissolveMask2PlaneNormal_Global;
	float _DissolveMask2SphereRadius;			uniform float  _DissolveMask2SphereRadius_Global;

#endif



#if defined(_DISSOLVEMASK_BOX)
	float3 _DissolveMaskBoxBoundsMin;			uniform float3 _DissolveMaskBoxBoundsMin_Global;
	float3 _DissolveMaskBoxBoundsMax;			uniform float3 _DissolveMaskBoxBoundsMax_Global;
	float4x4 _DissolveMaskBoxTRS;				uniform float4x4 _DissolveMaskBoxTRS_Global;
#endif

#ifdef _DISSOLVETRIPLANAR_ON
	float _DissolveTriplanarMainMapTiling;		uniform float _DissolveTriplanarMainMapTiling_Global;
	float _DissolveTriplanarMappingSpace;		uniform float _DissolveTriplanarMappingSpace_Global;
#endif

float3 _Dissolve_ObjectWorldPos;




#define TIME _Time.x


#if defined(_DISSOLVEGLOBALCONTROL_MASK_ONLY)
	
	//Globals-----------------------------------------------------------------------
	#define VALUE_CUTOFF					_DissolveCutoff_Global

	#define VALUE_CUTOFF_AXIS				_DissolveCutoffAxis_Global
	#define VALUE_MASK_OFFSET				_DissolveMaskOffset_Global
	#define VALUE_AXIS_INVERT				_DissolveAxisInvert_Global

	#define VALUE_MASK_POSITION				_DissolveMaskPosition_Global
	#define VALUE_MASK_PLANE_NORMAL			_DissolveMaskPlaneNormal_Global
	#define VALUE_MASK_SPHERE_RADIUS		_DissolveMaskSphereRadius_Global


	#if defined(_DISSOLVEMASK_COUNT_FOUR)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global

		#define VALUE_MASK_3_POSITION			_DissolveMask3Position_Global
		#define VALUE_MASK_3_PLANE_NORMAL		_DissolveMask3PlaneNormal_Global
		#define VALUE_MASK_3_SPHERE_RADIUS		_DissolveMask3SphereRadius_Global

		#define VALUE_MASK_4_POSITION			_DissolveMask4Position_Global
		#define VALUE_MASK_4_PLANE_NORMAL		_DissolveMask4PlaneNormal_Global
		#define VALUE_MASK_4_SPHERE_RADIUS		_DissolveMask4SphereRadius_Global
	#elif defined(_DISSOLVEMASK_COUNT_THREE)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global

		#define VALUE_MASK_3_POSITION			_DissolveMask3Position_Global
		#define VALUE_MASK_3_PLANE_NORMAL		_DissolveMask3PlaneNormal_Global
		#define VALUE_MASK_3_SPHERE_RADIUS		_DissolveMask3SphereRadius_Global
	#elif defined(_DISSOLVEMASK_COUNT_TWO)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global
	#endif


	#if defined(_DISSOLVEMASK_BOX)
		#define VALUE_MASK_BOX_BOUNDS_MIN		_DissolveMaskBoxBoundsMin_Global
		#define VALUE_MASK_BOX_BOUNDS_MAX		_DissolveMaskBoxBoundsMax_Global
		#define VALUE_MASK_BOX_TRS				_DissolveMaskBoxTRS_Global
	#endif
	//Per material---------------------------------------------------------------------

	#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP) || defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP1						_DissolveMap1
		#define VALUE_MAP1_ST					_DissolveMap1_ST
		#define VALUE_MAP1_SCROLL				_DissolveMap1_Scroll
	#endif

	#if defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP2						_DissolveMap2
		#define VALUE_MAP2_ST					_DissolveMap2_ST
		#define VALUE_MAP2_SCROLL				_DissolveMap2_Scroll
	#endif

	#if defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP3						_DissolveMap3
		#define VALUE_MAP3_ST					_DissolveMap3_ST
		#define VALUE_MAP3_SCROLL				_DissolveMap3_Scroll
	#endif

	#define VALUE_EDGE_SIZE					_DissolveEdgeSize
	#define VALUE_EDGE_COLOR				_DissolveEdgeColor
	#define VALUE_EDGERAMP					_DissolveEdgeRamp
	#define VALUE_GISTRENGTH				_DissolveGIStrength

	#define VALUE_ALPHATEXTUREBLEND			_DissolveAlphaTextureBlend
	#define VALUE_UVSET						_DissolveUVSet
	#define VALUE_NOISE_STRENGTH			_DissolveNoiseStrength

	#ifdef _DISSOLVETRIPLANAR_ON
		#define VALUE_TRIPLANARMAINMAPTILING    _DissolveTriplanarMainMapTiling
		#define VALUE_TRIPLANARMAPPINGSPACE     _DissolveTriplanarMappingSpace
	#endif

#elif defined(_DISSOLVEGLOBALCONTROL_MASK_AND_EDGE)

	//Globals-----------------------------------------------------------------------
	#define VALUE_CUTOFF					_DissolveCutoff_Global

	#define VALUE_CUTOFF_AXIS				_DissolveCutoffAxis_Global
	#define VALUE_MASK_OFFSET				_DissolveMaskOffset_Global
	#define VALUE_AXIS_INVERT				_DissolveAxisInvert_Global

	#define VALUE_MASK_POSITION				_DissolveMaskPosition_Global
	#define VALUE_MASK_PLANE_NORMAL			_DissolveMaskPlaneNormal_Global
	#define VALUE_MASK_SPHERE_RADIUS		_DissolveMaskSphereRadius_Global


	#if defined(_DISSOLVEMASK_COUNT_FOUR)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global

		#define VALUE_MASK_3_POSITION			_DissolveMask3Position_Global
		#define VALUE_MASK_3_PLANE_NORMAL		_DissolveMask3PlaneNormal_Global
		#define VALUE_MASK_3_SPHERE_RADIUS		_DissolveMask3SphereRadius_Global

		#define VALUE_MASK_4_POSITION			_DissolveMask4Position_Global
		#define VALUE_MASK_4_PLANE_NORMAL		_DissolveMask4PlaneNormal_Global
		#define VALUE_MASK_4_SPHERE_RADIUS		_DissolveMask4SphereRadius_Global
	#elif defined(_DISSOLVEMASK_COUNT_THREE)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global

		#define VALUE_MASK_3_POSITION			_DissolveMask3Position_Global
		#define VALUE_MASK_3_PLANE_NORMAL		_DissolveMask3PlaneNormal_Global
		#define VALUE_MASK_3_SPHERE_RADIUS		_DissolveMask3SphereRadius_Global
	#elif defined(_DISSOLVEMASK_COUNT_TWO)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global
	#endif


	#if defined(_DISSOLVEMASK_BOX)
		#define VALUE_MASK_BOX_BOUNDS_MIN		_DissolveMaskBoxBoundsMin_Global
		#define VALUE_MASK_BOX_BOUNDS_MAX		_DissolveMaskBoxBoundsMax_Global
		#define VALUE_MASK_BOX_TRS				_DissolveMaskBoxTRS_Global
	#endif

	#define VALUE_EDGE_SIZE					_DissolveEdgeSize_Global
	#define VALUE_EDGE_COLOR				_DissolveEdgeColor_Global

	//Per material---------------------------------------------------------------------	
	#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP) || defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP1						_DissolveMap1
		#define VALUE_MAP1_ST					_DissolveMap1_ST
		#define VALUE_MAP1_SCROLL				_DissolveMap1_Scroll
	#endif

	#if defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP2						_DissolveMap2
		#define VALUE_MAP2_ST					_DissolveMap2_ST
		#define VALUE_MAP2_SCROLL				_DissolveMap2_Scroll
	#endif

	#if defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP3						_DissolveMap3
		#define VALUE_MAP3_ST					_DissolveMap3_ST
		#define VALUE_MAP3_SCROLL				_DissolveMap3_Scroll
	#endif

	#define VALUE_EDGERAMP					_DissolveEdgeRamp
	#define VALUE_GISTRENGTH				_DissolveGIStrength

	#define VALUE_ALPHATEXTUREBLEND			_DissolveAlphaTextureBlend
	#define VALUE_UVSET						_DissolveUVSet
	#define VALUE_NOISE_STRENGTH			_DissolveNoiseStrength

	#ifdef _DISSOLVETRIPLANAR_ON
		#define VALUE_TRIPLANARMAINMAPTILING    _DissolveTriplanarMainMapTiling
		#define VALUE_TRIPLANARMAPPINGSPACE     _DissolveTriplanarMappingSpace
	#endif

#elif defined(_DISSOLVEGLOBALCONTROL_ALL)

	#define VALUE_CUTOFF					_DissolveCutoff_Global

	#define VALUE_CUTOFF_AXIS				_DissolveCutoffAxis_Global
	#define VALUE_MASK_OFFSET				_DissolveMaskOffset_Global
	#define VALUE_AXIS_INVERT				_DissolveAxisInvert_Global

	#define VALUE_EDGE_SIZE					_DissolveEdgeSize_Global
	#define VALUE_EDGE_COLOR				_DissolveEdgeColor_Global
	#define VALUE_EDGERAMP					_DissolveEdgeRamp_Global
	#define VALUE_GISTRENGTH				_DissolveGIStrength_Global

	#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP) || defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP1						_DissolveMap1_Global
		#define VALUE_MAP1_ST					_DissolveMap1_ST_Global
		#define VALUE_MAP1_SCROLL				_DissolveMap1_Scroll_Global
	#endif

	#if defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP2						_DissolveMap2_Global
		#define VALUE_MAP2_ST					_DissolveMap2_ST_Global
		#define VALUE_MAP2_SCROLL				_DissolveMap2_Scroll_Global
	#endif

	#if defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP3						_DissolveMap3_Global
		#define VALUE_MAP3_ST					_DissolveMap3_ST_Global
		#define VALUE_MAP3_SCROLL				_DissolveMap3_Scroll_Global
	#endif
	
	#define VALUE_ALPHATEXTUREBLEND			_DissolveAlphaTextureBlend_Global
	#define VALUE_UVSET						_DissolveUVSet_Global
	#define VALUE_NOISE_STRENGTH			_DissolveNoiseStrength_Global

	#define VALUE_MASK_POSITION				_DissolveMaskPosition_Global
	#define VALUE_MASK_PLANE_NORMAL			_DissolveMaskPlaneNormal_Global
	#define VALUE_MASK_SPHERE_RADIUS		_DissolveMaskSphereRadius_Global


	#if defined(_DISSOLVEMASK_COUNT_FOUR)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global

		#define VALUE_MASK_3_POSITION			_DissolveMask3Position_Global
		#define VALUE_MASK_3_PLANE_NORMAL		_DissolveMask3PlaneNormal_Global
		#define VALUE_MASK_3_SPHERE_RADIUS		_DissolveMask3SphereRadius_Global

		#define VALUE_MASK_4_POSITION			_DissolveMask4Position_Global
		#define VALUE_MASK_4_PLANE_NORMAL		_DissolveMask4PlaneNormal_Global
		#define VALUE_MASK_4_SPHERE_RADIUS		_DissolveMask4SphereRadius_Global
	#elif defined(_DISSOLVEMASK_COUNT_THREE)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global

		#define VALUE_MASK_3_POSITION			_DissolveMask3Position_Global
		#define VALUE_MASK_3_PLANE_NORMAL		_DissolveMask3PlaneNormal_Global
		#define VALUE_MASK_3_SPHERE_RADIUS		_DissolveMask3SphereRadius_Global
	#elif defined(_DISSOLVEMASK_COUNT_TWO)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position_Global
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal_Global
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius_Global
	#endif


	#if defined(_DISSOLVEMASK_BOX)
		#define VALUE_MASK_BOX_BOUNDS_MIN		_DissolveMaskBoxBoundsMin_Global
		#define VALUE_MASK_BOX_BOUNDS_MAX		_DissolveMaskBoxBoundsMax_Global
		#define VALUE_MASK_BOX_TRS				_DissolveMaskBoxTRS_Global
	#endif

	#ifdef _DISSOLVETRIPLANAR_ON
		#define VALUE_TRIPLANARMAINMAPTILING    _DissolveTriplanarMainMapTiling_Global
		#define VALUE_TRIPLANARMAPPINGSPACE     _DissolveTriplanarMappingSpace_Global
	#endif

#else

	#define VALUE_CUTOFF					_DissolveCutoff

	#define VALUE_CUTOFF_AXIS				_DissolveCutoffAxis
	#define VALUE_MASK_OFFSET				_DissolveMaskOffset	
	#define VALUE_AXIS_INVERT				_DissolveAxisInvert

	#define VALUE_EDGE_SIZE					_DissolveEdgeSize
	#define VALUE_EDGE_COLOR				_DissolveEdgeColor
	#define VALUE_EDGERAMP					_DissolveEdgeRamp
	#define VALUE_GISTRENGTH				_DissolveGIStrength

	#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP) || defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP1						_DissolveMap1
		#define VALUE_MAP1_ST					_DissolveMap1_ST
		#define VALUE_MAP1_SCROLL				_DissolveMap1_Scroll
	#endif

	#if defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP2						_DissolveMap2
		#define VALUE_MAP2_ST					_DissolveMap2_ST
		#define VALUE_MAP2_SCROLL				_DissolveMap2_Scroll
	#endif

	#if defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		#define VALUE_MAP3						_DissolveMap3
		#define VALUE_MAP3_ST					_DissolveMap3_ST
		#define VALUE_MAP3_SCROLL				_DissolveMap3_Scroll
	#endif

	#define VALUE_ALPHATEXTUREBLEND			_DissolveAlphaTextureBlend
	#define VALUE_UVSET						_DissolveUVSet
	#define VALUE_NOISE_STRENGTH			_DissolveNoiseStrength

	#define VALUE_MASK_POSITION				_DissolveMaskPosition
	#define VALUE_MASK_PLANE_NORMAL			_DissolveMaskPlaneNormal
	#define VALUE_MASK_SPHERE_RADIUS		_DissolveMaskSphereRadius


	#if defined(_DISSOLVEMASK_COUNT_FOUR)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius

		#define VALUE_MASK_3_POSITION			_DissolveMask3Position
		#define VALUE_MASK_3_PLANE_NORMAL		_DissolveMask3PlaneNormal
		#define VALUE_MASK_3_SPHERE_RADIUS		_DissolveMask3SphereRadius

		#define VALUE_MASK_4_POSITION			_DissolveMask4Position
		#define VALUE_MASK_4_PLANE_NORMAL		_DissolveMask4PlaneNormal
		#define VALUE_MASK_4_SPHERE_RADIUS		_DissolveMask4SphereRadius
	#elif defined(_DISSOLVEMASK_COUNT_THREE)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius

		#define VALUE_MASK_3_POSITION			_DissolveMask3Position
		#define VALUE_MASK_3_PLANE_NORMAL		_DissolveMask3PlaneNormal
		#define VALUE_MASK_3_SPHERE_RADIUS		_DissolveMask3SphereRadius
	#elif defined(_DISSOLVEMASK_COUNT_TWO)
		#define VALUE_MASK_2_POSITION			_DissolveMask2Position
		#define VALUE_MASK_2_PLANE_NORMAL		_DissolveMask2PlaneNormal
		#define VALUE_MASK_2_SPHERE_RADIUS		_DissolveMask2SphereRadius
	#endif


	#if defined(_DISSOLVEMASK_BOX)
		#define VALUE_MASK_BOX_BOUNDS_MIN		_DissolveMaskBoxBoundsMin
		#define VALUE_MASK_BOX_BOUNDS_MAX		_DissolveMaskBoxBoundsMax
		#define VALUE_MASK_BOX_TRS				_DissolveMaskBoxTRS
	#endif

	#ifdef _DISSOLVETRIPLANAR_ON
		#define VALUE_TRIPLANARMAINMAPTILING    _DissolveTriplanarMainMapTiling
		#define VALUE_TRIPLANARMAPPINGSPACE     _DissolveTriplanarMappingSpace
	#endif

#endif




inline void DissolveVertex2Fragment(float2 vertexUV0, float2 vertexUV1, inout float4 dissolveMapUV)
{
	dissolveMapUV = 0;

	#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP) || defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS) || defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)
		float2 texUV = VALUE_UVSET == 0 ? vertexUV0 : vertexUV1;

		#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP)

			dissolveMapUV.xy = texUV.xy * VALUE_MAP1_ST.xy + VALUE_MAP1_ST.zw + VALUE_MAP1_SCROLL * TIME;

		#elif defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS)

			dissolveMapUV.xy = texUV.xy * VALUE_MAP1_ST.xy + VALUE_MAP1_ST.zw + VALUE_MAP1_SCROLL * TIME;
			dissolveMapUV.zw = texUV.xy * VALUE_MAP2_ST.xy + VALUE_MAP2_ST.zw + VALUE_MAP2_SCROLL * TIME;

		#else
				
			dissolveMapUV.xy = texUV;
			dissolveMapUV.zw = texUV;

		#endif
	#endif
}


inline float ReadMaskValue(float3 vertexPos, float noise)
{
	float cutout = -1;

	#if defined(_DISSOLVEMASK_AXIS_LOCAL) || defined(_DISSOLVEMASK_AXIS_GLOBAL)

		#if defined(_DISSOLVEMASK_AXIS_LOCAL)
			vertexPos = mul(unity_WorldToObject, float4(vertexPos, 1));
		#endif

		cutout = (vertexPos - VALUE_MASK_OFFSET)[(int)VALUE_CUTOFF_AXIS] * VALUE_AXIS_INVERT;

		cutout += noise;

	#elif defined(_DISSOLVEMASK_PLANE)

		#if defined(_DISSOLVEMASK_COUNT_FOUR)
			
			float d1 = dot(VALUE_MASK_PLANE_NORMAL, vertexPos - VALUE_MASK_POSITION);
			float d2 = dot(VALUE_MASK_2_PLANE_NORMAL, vertexPos - VALUE_MASK_2_POSITION);
			float d3 = dot(VALUE_MASK_3_PLANE_NORMAL, vertexPos - VALUE_MASK_3_POSITION);
			float d4 = dot(VALUE_MASK_4_PLANE_NORMAL, vertexPos - VALUE_MASK_4_POSITION);

			if (VALUE_AXIS_INVERT > 0)
			{
				cutout = min(min(d1, d2), min(d3, d4));
			}
			else
			{
				cutout = max(max(-d1, -d2), max(-d3, -d4));
			}

			cutout += noise;

		#elif defined(_DISSOLVEMASK_COUNT_THREE)
			
			float d1 = dot(VALUE_MASK_PLANE_NORMAL, vertexPos - VALUE_MASK_POSITION);
			float d2 = dot(VALUE_MASK_2_PLANE_NORMAL, vertexPos - VALUE_MASK_2_POSITION);
			float d3 = dot(VALUE_MASK_3_PLANE_NORMAL, vertexPos - VALUE_MASK_3_POSITION);

			if (VALUE_AXIS_INVERT > 0)
			{
				cutout = min(min(d1, d2), d3);
			}
			else
			{
				cutout = max(max(-d1, -d2), -d3);
			}

			cutout += noise;

		#elif defined(_DISSOLVEMASK_COUNT_TWO)

			float d1 = dot(VALUE_MASK_PLANE_NORMAL, vertexPos - VALUE_MASK_POSITION);
			float d2 = dot(VALUE_MASK_2_PLANE_NORMAL, vertexPos - VALUE_MASK_2_POSITION);
		
			if (VALUE_AXIS_INVERT > 0)
			{
				cutout = min(d1, d2);
			}
			else
			{
				cutout = max(-d1, -d2);
			}

			cutout += noise;

		#else
			cutout = dot(VALUE_MASK_PLANE_NORMAL * VALUE_AXIS_INVERT, vertexPos - VALUE_MASK_POSITION);
		
			cutout += noise;
		#endif
		

	#elif defined(_DISSOLVEMASK_SPHERE)

		#if defined(_DISSOLVEMASK_COUNT_FOUR)

			float4 radius = float4(VALUE_MASK_SPHERE_RADIUS, VALUE_MASK_2_SPHERE_RADIUS, VALUE_MASK_3_SPHERE_RADIUS, VALUE_MASK_4_SPHERE_RADIUS);

			float4 n = noise * (radius < 1 ? radius : 1);

			float4 d = float4(distance(vertexPos, VALUE_MASK_POSITION), distance(vertexPos, VALUE_MASK_2_POSITION), distance(vertexPos, VALUE_MASK_3_POSITION), distance(vertexPos, VALUE_MASK_4_POSITION));

			//radius += abs(noise) * (1 - VALUE_AXIS_INVERT * 2);
			radius -= noise;


			if (VALUE_AXIS_INVERT > 0)
			{
				float4 b = radius - min(d, radius);
				cutout = dot(b, 1);
			}
			else
			{
				float4 a = saturate(max(0, d - radius));

				a.xy = a.xz*a.yw;
				cutout = a.x * a.y;
			}

		#elif defined(_DISSOLVEMASK_COUNT_THREE)

			float3 radius = float3(VALUE_MASK_SPHERE_RADIUS, VALUE_MASK_2_SPHERE_RADIUS, VALUE_MASK_3_SPHERE_RADIUS);

			float3 n = noise * (radius < 1 ? radius : 1);

			float3 d = float3(distance(vertexPos, VALUE_MASK_POSITION), distance(vertexPos, VALUE_MASK_2_POSITION), distance(vertexPos, VALUE_MASK_3_POSITION));

			//radius += abs(noise) * (1 - VALUE_AXIS_INVERT * 2);
			radius -= noise;
						

			if (VALUE_AXIS_INVERT > 0)
			{
				float3 b = radius - min(d, radius);
				cutout = dot(b, 1);
			}
			else
			{
				float3 a = saturate(max(0, d - radius));
				cutout = a.x * a.y * a.z;
			}

		#elif defined(_DISSOLVEMASK_COUNT_TWO)


			float2 radius = float2(VALUE_MASK_SPHERE_RADIUS, VALUE_MASK_2_SPHERE_RADIUS);

			float2 n = noise * (radius < 1 ? radius : 1);

			float2 d = float2(distance(vertexPos, VALUE_MASK_POSITION), distance(vertexPos, VALUE_MASK_2_POSITION));

			//radius += abs(noise) * (1 - VALUE_AXIS_INVERT * 2);
			radius -= noise;

			
			if (VALUE_AXIS_INVERT > 0)
			{
				float2 b = radius - min(d, radius);
				cutout = dot(b, 1);
			}
			else
			{
				float2 a = saturate(max(0, d - radius));
				cutout = a.x * a.y;
			}				
			
		#else

			float radius = VALUE_MASK_SPHERE_RADIUS;

			noise *= (radius < 1 ? radius : 1);

			float d = distance(vertexPos, VALUE_MASK_POSITION);

			//radius += abs(noise) * (1 - VALUE_AXIS_INVERT * 2);
			radius -= noise;

			if (VALUE_AXIS_INVERT > 0)
			{
				cutout = radius - min(d, radius);
			}
			else
			{
				cutout = max(0, d - radius);
			} 

		#endif

		

	#elif defined(_DISSOLVEMASK_BOX)
		
		float3 vertexInverseTransform = mul(VALUE_MASK_BOX_TRS, float4(vertexPos, 1)).xyz;

		float3 min = VALUE_MASK_BOX_BOUNDS_MIN - noise;
		float3 max = VALUE_MASK_BOX_BOUNDS_MAX + noise;

		
		if ((vertexInverseTransform.x > min.x && vertexInverseTransform.x < max.x) &&
			(vertexInverseTransform.y > min.y && vertexInverseTransform.y < max.y) &&
			(vertexInverseTransform.z > min.z && vertexInverseTransform.z < max.z))
		{
			cutout = 1;			
			

			//Edge Detect
			float dissolveEdgeSize = VALUE_EDGE_SIZE;
			#ifdef UNITY_PASS_META
				dissolveEdgeSize *= VALUE_GISTRENGTH;
			#endif

			min += dissolveEdgeSize;
			max -= dissolveEdgeSize;

			if( !((vertexInverseTransform.x > min.x && vertexInverseTransform.x < max.x) &&
				  (vertexInverseTransform.y > min.y && vertexInverseTransform.y < max.y) &&
				  (vertexInverseTransform.z > min.z && vertexInverseTransform.z < max.z)))
			{
				cutout = dissolveEdgeSize * 0.5 * VALUE_AXIS_INVERT;
			}
		}
		
		cutout *= VALUE_AXIS_INVERT;


	#endif

	
	return (cutout > 0 ? cutout : -1);
}


inline float ReadDissolveAlpha(float2 mainTexUV, float4 dissolveMapUV, float3 vertexPos)
{
	float alphaSource = 1;
	#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP)

		alphaSource = tex2D(VALUE_MAP1, dissolveMapUV.xy).a;

	#elif defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS)

		float t1 = tex2D(VALUE_MAP1, dissolveMapUV.xy).a;
		float t2 = tex2D(VALUE_MAP2, dissolveMapUV.zw).a;


		alphaSource = lerp((t1 * t2), (t1 + t2) * 0.5, VALUE_ALPHATEXTUREBLEND);

	#elif defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)

		float2 uv1 = dissolveMapUV.xy * VALUE_MAP1_ST.xy + VALUE_MAP1_ST.zw + VALUE_MAP1_SCROLL * TIME;
		float2 uv2 = dissolveMapUV.xy * VALUE_MAP2_ST.xy + VALUE_MAP2_ST.zw + VALUE_MAP2_SCROLL * TIME;
		float2 uv3 = dissolveMapUV.xy * VALUE_MAP3_ST.xy + VALUE_MAP3_ST.zw + VALUE_MAP3_SCROLL * TIME;


		float t1 = tex2D(VALUE_MAP1, uv1).a;
		float t2 = tex2D(VALUE_MAP2, uv2).a;
		float t3 = tex2D(VALUE_MAP3, uv3).a;

		alphaSource = lerp((t1 * t2 * t3), (t1 + t2 + t3) / 3.0, VALUE_ALPHATEXTUREBLEND);

	#else

		alphaSource = tex2D(_MainTex, mainTexUV).a;
	 
	#endif


	
	#if defined(_DISSOLVEMASK_AXIS_LOCAL) || defined(_DISSOLVEMASK_AXIS_GLOBAL) || defined(_DISSOLVEMASK_PLANE) || defined(_DISSOLVEMASK_SPHERE) || defined(_DISSOLVEMASK_BOX)
	
		float noise = ((alphaSource - 0.5) * 2) * VALUE_NOISE_STRENGTH;

		return ReadMaskValue(vertexPos, noise);

	#else

		return alphaSource;

	#endif	
}
 


inline float4 ReadTriplanarTexture(sampler2D _texture, float3 coords, float3 blend)
{
	fixed4 cx = tex2D(_texture, coords.yz);
	fixed4 cy = tex2D(_texture, coords.xz);
	fixed4 cz = tex2D(_texture, coords.xy);

	return (cx * blend.x + cy * blend.y + cz * blend.z);
}

#ifdef _DISSOLVETRIPLANAR_ON
	inline float ReadDissolveAlpha_Triplanar(float3 coords, float3 normal, float3 vertexPos)
	{	
		half3 blend = abs(normal);
		blend /= dot(blend, 1.0);

		float alphaSource = 1;
		#if defined(_DISSOLVEALPHASOURCE_CUSTOM_MAP)

			alphaSource = ReadTriplanarTexture(VALUE_MAP1, coords * VALUE_MAP1_ST.x, blend).a;

		#elif defined(_DISSOLVEALPHASOURCE_TWO_CUSTOM_MAPS)

			float t1 = ReadTriplanarTexture(VALUE_MAP1, coords * VALUE_MAP1_ST.x, blend).a;
			float t2 = ReadTriplanarTexture(VALUE_MAP2, coords * VALUE_MAP2_ST.x, blend).a;


			alphaSource = lerp((t1 * t2), (t1 + t2) * 0.5, VALUE_ALPHATEXTUREBLEND);

		#elif defined(_DISSOLVEALPHASOURCE_THREE_CUSTOM_MAPS)

			float t1 = ReadTriplanarTexture(VALUE_MAP1, coords * VALUE_MAP1_ST.x, blend).a;
			float t2 = ReadTriplanarTexture(VALUE_MAP2, coords * VALUE_MAP2_ST.x, blend).a;
			float t3 = ReadTriplanarTexture(VALUE_MAP3, coords * VALUE_MAP3_ST.x, blend).a;


			alphaSource = lerp((t1 * t2 * t3), (t1 + t2 + t3) / 3.0, VALUE_ALPHATEXTUREBLEND);

		#else		

			alphaSource = ReadTriplanarTexture(_MainTex, coords * VALUE_TRIPLANARMAINMAPTILING, blend).a;

		#endif



		#if defined(_DISSOLVEMASK_AXIS_LOCAL) || defined(_DISSOLVEMASK_AXIS_GLOBAL) || defined(_DISSOLVEMASK_PLANE) || defined(_DISSOLVEMASK_SPHERE) || defined(_DISSOLVEMASK_BOX)

			float noise = ((alphaSource - 0.5) * 2) * VALUE_NOISE_STRENGTH;

			return ReadMaskValue(vertexPos, noise);

		#else

			return alphaSource;

		#endif	
	}
#endif

inline void DoDissolveClip(float alpha)
{
	#if defined(_DISSOLVEMASK_AXIS_LOCAL) || defined(_DISSOLVEMASK_AXIS_GLOBAL) || defined(_DISSOLVEMASK_PLANE) || defined(_DISSOLVEMASK_SPHERE) || defined(_DISSOLVEMASK_BOX)
		clip(alpha);
	#else
		clip(alpha - VALUE_CUTOFF * 1.01);
	#endif
}


float3 DoDissolveEmission(float alpha, float3 emission)
{
	float3 dissolve = emission;

	float dissolveEdgeSize = VALUE_EDGE_SIZE;
	fixed4 dissolveEdgeColor = VALUE_EDGE_COLOR;

#ifdef UNITY_PASS_META
	dissolveEdgeSize *= VALUE_GISTRENGTH;
	dissolveEdgeColor *= VALUE_GISTRENGTH;
#endif


	#if defined(_DISSOLVEMASK_AXIS_LOCAL) || defined(_DISSOLVEMASK_AXIS_GLOBAL) || defined(_DISSOLVEMASK_PLANE) || defined(_DISSOLVEMASK_SPHERE) || defined(_DISSOLVEMASK_BOX)

		if (dissolveEdgeSize > 0 && dissolveEdgeSize > alpha)
		{
			#if defined(_DISSOLVEMASK_BOX)
				float4 edgeColor = dissolveEdgeColor;
			#else
				float4 edgeColor = tex2D(VALUE_EDGERAMP, float2(saturate(alpha) * (1.0 / dissolveEdgeSize), 0.5)) * dissolveEdgeColor;
			#endif

			dissolve = lerp(emission, edgeColor.rgb, edgeColor.a);
		}
	#else

		dissolveEdgeSize *= VALUE_CUTOFF < 0.1 ? (VALUE_CUTOFF * 10) : 1;


		alpha -= VALUE_CUTOFF;

		if (dissolveEdgeSize > 0 && dissolveEdgeSize > alpha && alpha >= 0)
		{
			float4 edgeColor = tex2D(VALUE_EDGERAMP, float2(alpha * (1.0 / dissolveEdgeSize), 0.5)) * dissolveEdgeColor;
			
			dissolve = lerp(emission, edgeColor.rgb, edgeColor.a);
		}
	#endif	

	#ifdef UNITY_PASS_META
		if (alpha <= 0)
			dissolve = float3(0, 0, 0);
	#endif



	return dissolve;
}


#endif // STANDARD_DISSOLVE_PRO_INCLUDED
