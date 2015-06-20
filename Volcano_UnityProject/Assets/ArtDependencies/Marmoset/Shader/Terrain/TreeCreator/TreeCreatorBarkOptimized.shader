 Shader "Hidden/Marmoset/Nature/Tree Creator Bark Optimized" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	_BumpSpecMap ("Normalmap (GA) Spec (R)", 2D) = "bump" {}
	_TranslucencyMap ("Trans (RGB) Gloss(A)", 2D) = "white" {}
	
	// These are here only to provide default values
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_Scale ("Scale", Vector) = (1,1,1,1)
	_SquashAmount ("Squash", Float) = 1
	
	_SpecInt ("Specular Intensity", Float) = 1.0
	_Fresnel ("Fresnel Falloff", Range(0.0,1.0)) = 1.0
}

//optimized bark shader for 3D tree rendering
SubShader {
	Tags { "RenderType"="TreeBark" }
	LOD 200
	
	CGPROGRAM
	#pragma surface OptBarkSurf BlinnPhong vertex:BarkVert addshadow nolightmap
	#pragma exclude_renderers d3d11_9x flash
	#pragma glsl_no_auto_normalization
	#pragma target 3.0
	
	#pragma multi_compile MARMO_TERRAIN_BLEND_OFF MARMO_TERRAIN_BLEND_ON
	#if MARMO_TERRAIN_BLEND_ON			
		#define MARMO_SKY_BLEND
	#endif

	#include "TerrainEngine.cginc"

	#define MARMO_SPECULAR_DIRECT
	// no specular, it looks more or less terrible.
	#define MARMO_SKY_ROTATION
	#define MARMO_NORMALMAP

	#include "TreeCore.cginc"
	#include "TreeBarkInput.cginc"
	#include "TreeBark.cginc"
	ENDCG
}

SubShader {
	Tags { "RenderType"="TreeBark" }
	Pass {
		Material {
			Diffuse (1,1,1,1)
			Ambient (1,1,1,1)
		} 
		Lighting On
		SetTexture [_MainTex] {
			ConstantColor [_Color]
			Combine texture * primary DOUBLE, texture * primary
		}
		SetTexture [_MainTex] {
			ConstantColor [_Color]
			Combine previous * constant, previous
		} 
	}
}

Dependency "BillboardShader" = "Hidden/Marmoset/Nature/Tree Creator Bark Rendertex"
}
