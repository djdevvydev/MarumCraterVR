// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

#ifndef MARMOSET_INPUT_CGINC
#define MARMOSET_INPUT_CGINC

//deprecated #define
#ifdef MARMO_ALPHA_PREMULT
	#define MARMO_SIMPLE_GLASS
#endif

#if defined(MARMO_DIFFUSE_IBL) && !defined(MARMO_NORMALMAP) && !defined(MARMO_SPECULAR_IBL)
	#ifndef MARMO_DIFFUSE_VERTEX_IBL
//	#define MARMO_DIFFUSE_VERTEX_IBL
	#endif
#endif

uniform float4		_Color;
uniform sampler2D 	_MainTex;

#ifdef MARMO_DIFFUSE_SCATTER
	float4			_ScatterColor;
	float			_Scatter;	
#endif

#if defined(MARMO_TEXTURE_LAYER_MASK)
uniform sampler2D	_LayerMask;
#endif


#if defined(MARMO_DIFFUSE_2_LAYER)
uniform float4		_Color1;
uniform sampler2D 	_MainTex1;
#elif defined(MARMO_DIFFUSE_3_LAYER)
uniform float4		_Color1;
uniform float4		_Color2;
uniform sampler2D 	_MainTex1;
uniform sampler2D 	_MainTex2;
#elif defined(MARMO_DIFFUSE_4_LAYER)
uniform float4		_Color1;
uniform float4		_Color2;
uniform float4		_Color3;
uniform sampler2D 	_MainTex1;
uniform sampler2D 	_MainTex2;
uniform sampler2D 	_MainTex3;
#endif

#ifdef  MARMO_CUSTOM_TILING
	uniform half4	_MainTexTiling;
	uniform half4	_SpecTexTiling;
	uniform half4	_BumpMapTiling;
	uniform half4	_IllumTiling;
	uniform half4 	_OccTexTiling;
	
	#if defined(MARMO_TEXTURE_LAYER_MASK)
	uniform float4	_LayerMaskTiling;
	#endif
	
	#if defined(MARMO_DIFFUSE_2_LAYER)
	uniform float4	_MainTex1Tiling;	
	#elif defined(MARMO_DIFFUSE_3_LAYER)
	uniform float4	_MainTex1Tiling;
	uniform float4	_MainTex2Tiling;
	#elif defined(MARMO_DIFFUSE_4_LAYER)
	uniform float4	_MainTex1Tiling;
	uniform float4	_MainTex2Tiling;
	uniform float4	_MainTex3Tiling;
	#endif
	
	#if defined(MARMO_SPECULAR_2_LAYER)
	uniform float4	_SpecTex1Tiling;
	#elif defined(MARMO_SPECULAR_3_LAYER)
	uniform float4	_SpecTex1Tiling;
	uniform float4	_SpecTex2Tiling;
	#elif defined(MARMO_SPECULAR_4_LAYER)
	uniform float4	_SpecTex1Tiling;
	uniform float4	_SpecTex2Tiling;
	uniform float4	_SpecTex3Tiling;
	#endif
	
	#if defined(MARMO_NORMALMAP_2_LAYER)
	uniform float4	_BumpMap1Tiling;
	#elif defined(MARMO_NORMALMAP_3_LAYER)
	uniform float4	_BumpMap1Tiling;
	uniform float4	_BumpMap2Tiling;
	#elif defined(MARMO_NORMALMAP_4_LAYER)
	uniform float4	_BumpMap1Tiling;
	uniform float4	_BumpMap2Tiling;
	uniform float4	_BumpMap3Tiling;
	#endif
#endif

#if defined(MARMO_OCCLUSION) || defined(MARMO_VERTEX_OCCLUSION)
uniform half		_OccStrength;
#endif

#ifdef MARMO_OCCLUSION
uniform sampler2D	_OccTex;
#endif

#if defined(MARMO_SPECULAR_DIRECT) || defined(MARMO_SPECULAR_IBL)
//uniform float4	_SpecColor; //defined by unity
uniform float		_SpecInt;
uniform float		_Shininess;
uniform float		_Fresnel;

uniform sampler2D	_SpecTex;
#if defined(MARMO_SPECULAR_2_LAYER)
uniform float		_Fresnel1;
uniform sampler2D 	_SpecTex1;
#elif defined(MARMO_SPECULAR_3_LAYER)
uniform float		_Fresnel1;
uniform sampler2D 	_SpecTex1;
uniform float		_Fresnel2;
uniform sampler2D 	_SpecTex2;
#elif defined(MARMO_SPECULAR_4_LAYER)
uniform float		_Fresnel1;
uniform sampler2D 	_SpecTex1;
uniform float		_Fresnel2;
uniform sampler2D 	_SpecTex2;
uniform float		_Fresnel3;
uniform sampler2D 	_SpecTex3;
#endif
#endif

//#ifdef MARMO_NORMALMAP
uniform sampler2D 	_BumpMap;
#if defined(MARMO_NORMALMAP_2_LAYER)
uniform sampler2D 	_BumpMap1;
#elif defined(MARMO_NORMALMAP_3_LAYER)
uniform sampler2D 	_BumpMap1;
uniform sampler2D 	_BumpMap2;
#elif defined(MARMO_NORMALMAP_4_LAYER)
uniform sampler2D 	_BumpMap1;
uniform sampler2D 	_BumpMap2;
uniform sampler2D 	_BumpMap3;
#endif
//#endif

#ifdef MARMO_GLOW
uniform sampler2D	_Illum;
uniform float4		_GlowColor;
uniform float		_GlowStrength;
uniform float		_EmissionLM;
#endif

#ifdef MARMO_ALPHA_TEST
uniform float		_Cutoff;
#endif

//disable box projection when it conflicts with features that exceed interpolator limits
#ifdef MARMO_BOX_PROJECTION
	#if defined(MARMO_OCCLUSION) || defined(MARMO_TEXTURE_LAYER_MASK_UV1)
		#undef MARMO_BOX_PROJECTION
		
	#elif defined(MARMO_VERTEX_COLOR) || defined(MARMO_VERTEX_LAYER_MASK)
		#undef MARMO_BOX_PROJECTION	
		
	#elif defined(MARMO_VERTEX_OCCLUSION)
		#undef MARMO_BOX_PROJECTION		
	#endif
#endif

struct Input {	
	#ifdef MARMO_CUSTOM_TILING
		float2 texcoord;
	#else
		float2 uv_MainTex;
	#endif
	#if defined(MARMO_OCCLUSION) || defined(MARMO_TEXTURE_LAYER_MASK_UV1)
		float2 texcoord1;
	#endif
	#ifdef MARMO_NORMALMAP
		float3 worldNormal; //internal, required for the WorldNormalVector macro
	#else
		float3 worldN; //without normalmapping, Unity cannot be trusted to generate this right (android scale bug)	
	#endif	
	#if defined(MARMO_SPECULAR_DIRECT) || defined(MARMO_SPECULAR_IBL)
		float3 viewDir;
	#endif
	#ifdef MARMO_SPECULAR_IBL
		float3 worldRefl; //internal, required for the WorldReflVector macro
	#endif
	#ifdef MARMO_BOX_PROJECTION
		float3 worldPos;
	#endif
	#if defined(MARMO_VERTEX_COLOR) || defined(MARMO_VERTEX_LAYER_MASK)
		half4 color : COLOR;
	#elif defined(MARMO_VERTEX_OCCLUSION)
		half2 color : COLOR;
	#endif	
	#ifdef MARMO_DIFFUSE_VERTEX_IBL
		float3 vertexIBL;
	#endif	
	INTERNAL_DATA
};

struct MarmosetOutput {
	half3 Albedo;	//diffuse map RGB
	half Alpha;		//diffuse map A
	half3 Normal;	//world-space normal
	half3 Emission;	//contains IBL contribution
	half Specular;	//specular exponent (required by Unity)
	#ifdef MARMO_SPECULAR_DIRECT
		half3 SpecularRGB;	//specular mask
	#endif
};
#endif