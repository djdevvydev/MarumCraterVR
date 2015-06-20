Shader "Hidden/Marmoset/Nature/Tree Creator Leaves Optimized" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_TranslucencyColor ("Translucency Color", Color) = (0.73,0.85,0.41,1) // (187,219,106,255)
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.3
		_TranslucencyViewDependency ("View dependency", Range(0,1)) = 0.7
		_ShadowStrength("Shadow Strength", Range(0,1)) = 0.8
		_ShadowOffsetScale ("Shadow Offset Scale", Float) = 1
		
		_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
		_ShadowTex ("Shadow (RGB)", 2D) = "white" {}
		_BumpSpecMap ("Normalmap (GA) Spec (R) Shadow Offset (B)", 2D) = "bump" {}
		_TranslucencyMap ("Trans (B) Gloss(A)", 2D) = "white" {}

		// These are here only to provide default values
		_Scale ("Scale", Vector) = (1,1,1,1)
		_SquashAmount ("Squash", Float) = 1
		
		_SpecInt ("Specular Intensity", Float) = 1.0
		_Fresnel ("Fresnel Falloff", Range(0.0,1.0)) = 1.0
	}

	SubShader { 
		Tags {
			"IgnoreProjector"="True"
			"RenderType"="TreeLeaf"
		}
		LOD 200
		
		CGPROGRAM
		#pragma surface OptLeavesSurf LeavesDirect alphatest:_Cutoff vertex:LeavesVert nolightmap
		#pragma exclude_renderers d3d11_9x flash
		#pragma target 3.0
		#pragma multi_compile MARMO_TERRAIN_BLEND_OFF MARMO_TERRAIN_BLEND_ON
		#if MARMO_TERRAIN_BLEND_ON			
			#define MARMO_SKY_BLEND
		#endif

		#pragma glsl_no_auto_normalization
		#include "Lighting.cginc"

		// no specular, it looks more or less terrible.
		//#define MARMO_SPECULAR_DIRECT
		
		#define MARMO_SKY_ROTATION
		#include "TreeCore.cginc"
		#include "TreeLeavesInput.cginc"
		#include "TreeLeaves.cginc"
		
		ENDCG

	// Pass to render object as a shadow caster
	Pass {
		Name "ShadowCaster"
		Tags { "LightMode" = "ShadowCaster" }
		
		Fog {Mode Off}
		ZWrite On ZTest LEqual Cull Off
		Offset 1, 1

		CGPROGRAM
		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma exclude_renderers noshadows d3d11_9x flash
		#pragma glsl_no_auto_normalization
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma multi_compile_shadowcaster
		#include "HLSLSupport.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		#define INTERNAL_DATA
		#define WorldReflectionVector(data,normal) data.worldRefl
		#include "TreeLeavesInput.cginc"

		sampler2D _ShadowTex;
		fixed _Cutoff;
		
		struct Input {
			float2 uv_MainTex;
		};

		struct v2f_surf {
			V2F_SHADOW_CASTER;
			float2 hip_pack0 : TEXCOORD1;
		};
		float4 _ShadowTex_ST;
		v2f_surf vert_surf (appdata_full v) {
			v2f_surf o;
			TreeVertLeaf (v);
			o.hip_pack0.xy = TRANSFORM_TEX(v.texcoord, _ShadowTex);
			TRANSFER_SHADOW_CASTER(o)
			return o;
		}
		float4 frag_surf (v2f_surf IN) : COLOR {
			half alpha = tex2D(_ShadowTex, IN.hip_pack0.xy).r;
			clip (alpha - _Cutoff);
			SHADOW_CASTER_FRAGMENT(IN)
		}
		ENDCG
	}
	
	// Pass to render object as a shadow collector
	Pass {
		Name "ShadowCollector"
		Tags { "LightMode" = "ShadowCollector" }
		
		Fog {Mode Off}
		ZWrite On ZTest LEqual

		CGPROGRAM
		#pragma vertex vert_surf
		#pragma fragment frag_surf
		#pragma exclude_renderers noshadows d3d11_9x flash
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma multi_compile_shadowcollector
		#pragma glsl_no_auto_normalization
		#include "HLSLSupport.cginc"
		#define SHADOW_COLLECTOR_PASS
		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		#define INTERNAL_DATA
		#define WorldReflectionVector(data,normal) data.worldRefl
		#include "TreeLeavesInput.cginc"

		fixed	_Cutoff;		
		float4 _MainTex_ST;

		struct Input {
			float2 uv_MainTex;
		};

		struct v2f_surf {
			V2F_SHADOW_COLLECTOR;
			float2 hip_pack0 : TEXCOORD5;
			float3 normal : TEXCOORD6;
		};
		
		v2f_surf vert_surf (appdata_full v) {
			v2f_surf o;
			TreeVertLeaf (v);
			o.hip_pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
			
			float3 worldN = mul((float3x3)_Object2World, SCALED_NORMAL);
			o.normal = mul(_World2Shadow, half4(worldN, 0)).xyz;

			TRANSFER_SHADOW_COLLECTOR(o)
			return o;
		}
		
		half4 frag_surf (v2f_surf IN) : COLOR {
			half alpha = tex2D(_MainTex, IN.hip_pack0.xy).a;

			float3 shadowOffset = _ShadowOffsetScale * IN.normal * tex2D (_BumpSpecMap, IN.hip_pack0.xy).b;
			clip (alpha - _Cutoff);

			IN._ShadowCoord0 += shadowOffset;
			IN._ShadowCoord1 += shadowOffset;
			IN._ShadowCoord2 += shadowOffset;
			IN._ShadowCoord3 += shadowOffset;

			SHADOW_COLLECTOR_FRAGMENT(IN)
		}
		ENDCG
	}
}
Dependency "BillboardShader" = "Hidden/Marmoset/Nature/Tree Creator Leaves Rendertex"
Fallback "Nature/Tree Creator Leaves Optimized"
}
