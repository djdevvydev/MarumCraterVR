// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

Shader "Marmoset/Mobile/Transparent/Simple Glass/Bumped Specular IBL" {
	Properties {
		_Color   ("Diffuse Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecInt ("Specular Intensity", Float) = 1.0
		_Shininess ("Specular Sharpness", Range(2.0,8.0)) = 4.0
		_Fresnel ("Fresnel Strength", Range(0.0,1.0)) = 0.0
		_MainTex ("Diffuse(RGB) Alpha(A)", 2D) = "white" {}
		_SpecTex ("Specular(RGB) Gloss(A)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) 	= "bump" {}
	}
	
	SubShader {
		Blend One OneMinusSrcAlpha
		ZWrite Off
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
			"IgnoreProjector"="True"
		}
		LOD 400
		//diffuse LOD 200
		//diffuse-spec LOD 250
		//bumped-diffuse, spec 350
		//bumped-spec 400
		
		//mac stuff
		CGPROGRAM
		#ifdef SHADER_API_OPENGL	
			#pragma glsl 
		#endif
		#pragma target 3.0
		#pragma surface MarmosetSurf MarmosetDirect vertex:MarmosetVert exclude_path:prepass noforwardadd approxview
		//mobile primary
		#pragma only_renderers d3d9 opengl gles
		#pragma multi_compile MARMO_BOX_PROJECTION_OFF MARMO_BOX_PROJECTION_ON
		#if MARMO_BOX_PROJECTION_ON	
			#define MARMO_BOX_PROJECTION
		#endif
		
		#pragma multi_compile MARMO_SKY_BLEND_OFF MARMO_SKY_BLEND_ON
		#if MARMO_SKY_BLEND_ON			
			#define MARMO_SKY_BLEND
		#endif

		
		
		#define MARMO_HQ
		#define MARMO_SKY_ROTATION
		#define MARMO_DIFFUSE_IBL
		#define MARMO_SPECULAR_IBL
		#define MARMO_DIFFUSE_DIRECT
		#define MARMO_SPECULAR_DIRECT
		#define MARMO_NORMALMAP
		#define MARMO_MIP_GLOSS
		//#define MARMO_GLOW
		#define MARMO_ALPHA
		#define MARMO_SIMPLE_GLASS
		
		#include "../../../MarmosetMobile.cginc"
		#include "../../../MarmosetInput.cginc"
		#include "../../../MarmosetCore.cginc"
		#include "../../../MarmosetDirect.cginc"
		#include "../../../MarmosetSurf.cginc"

		ENDCG
	}
	
	SubShader {
		Blend One OneMinusSrcAlpha
		Tags {
			"Queue"="Transparent"
			"RenderType"="Transparent"
			"IgnoreProjector"="True"
		}
		LOD 400
		//diffuse LOD 200
		//diffuse-spec LOD 250
		//bumped-diffuse, spec 350
		//bumped-spec 400
		
		//mac stuff
		CGPROGRAM
		#ifdef SHADER_API_OPENGL	
			#pragma glsl 
		#endif
		#pragma target 3.0
		#pragma surface MarmosetSurf MarmosetDirect vertex:MarmosetVert exclude_path:prepass noforwardadd approxview
		//mobile secondary
		#pragma only_renderers d3d9 opengl gles d3d11 d3d11_9x				
		#pragma multi_compile MARMO_BOX_PROJECTION_OFF MARMO_BOX_PROJECTION_ON
		#if MARMO_BOX_PROJECTION_ON	
			#define MARMO_BOX_PROJECTION
		#endif
		
		#pragma multi_compile MARMO_SKY_BLEND_OFF MARMO_SKY_BLEND_ON
		#if MARMO_SKY_BLEND_ON			
			#define MARMO_SKY_BLEND
		#endif

		
		
		#define MARMO_HQ
		#define MARMO_SKY_ROTATION
		#define MARMO_DIFFUSE_IBL
		#define MARMO_SPECULAR_IBL
		#define MARMO_DIFFUSE_DIRECT
		#define MARMO_SPECULAR_DIRECT
		#define MARMO_NORMALMAP
		//#define MARMO_MIP_GLOSS
		//#define MARMO_GLOW
		#define MARMO_ALPHA
		#define MARMO_SIMPLE_GLASS
		
		#include "../../../MarmosetMobile.cginc"
		#include "../../../MarmosetInput.cginc"
		#include "../../../MarmosetCore.cginc"
		#include "../../../MarmosetDirect.cginc"
		#include "../../../MarmosetSurf.cginc"

		ENDCG
	}
	FallBack "Marmoset/Mobile/Transparent/Simple Glass/Specular IBL"
}
