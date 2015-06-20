Shader "Hidden/Marmoset/Nature/Tree Soft Occlusion Leaves Rendertex" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,0)
		_MainTex ("Main Texture", 2D) = "white" {}
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
		_HalfOverCutoff ("0.5 / Alpha cutoff", Range(0,1)) = 1.0
		_BaseLight ("Base Light", Range(0, 1)) = 0.35
		_AO ("Amb. Occlusion", Range(0, 10)) = 2.4
		_Occlusion ("Dir Occlusion", Range(0, 20)) = 7.5
		
		// These are here only to provide default values
		_Scale ("Scale", Vector) = (1,1,1,1)
		_SquashAmount ("Squash", Float) = 1
	}
	SubShader {

		Tags { "Queue" = "Transparent-99" }
		Cull Off
		Fog { Mode Off}
		
		Pass {
			Lighting On
			ZWrite On

			CGPROGRAM
			#pragma vertex leaves
			#pragma fragment frag
			#pragma glsl_no_auto_normalization
			#define USE_CUSTOM_LIGHT_DIR 1
			
			#pragma multi_compile MARMO_TERRAIN_BLEND_OFF MARMO_TERRAIN_BLEND_ON
			#if MARMO_TERRAIN_BLEND_ON			
				#define MARMO_SKY_BLEND
			#endif
			
			#include "SH_Vertex.cginc"
			
			uniform sampler2D _MainTex;
			uniform fixed _Cutoff;
			
			fixed4 frag(v2f IN) : COLOR
			{
				half4 albedo = tex2D( _MainTex, IN.uv.xy);
				clip (albedo.a - _Cutoff);
				return albedo * IN.color;
			}
			ENDCG
		}
	}
	SubShader {
		Tags { "Queue" = "Transparent-99" }
		Cull Off
		Fog { Mode Off}
		
		Pass {
			CGPROGRAM
			#pragma exclude_renderers shaderonly
			#pragma vertex leaves
			#define USE_CUSTOM_LIGHT_DIR 1
			#include "SH_Vertex.cginc"
			ENDCG
			
			Lighting On
			ZWrite On
			
			// We want to do alpha testing on cutoff, but at the same
			// time write 1.0 into alpha. So we multiply alpha by 0.25/cutoff
			// and alpha test on alpha being greater or equal to 1.0.
			// That will work for cutoff values in range [0.25;1].
			// Remember that color gets clamped to [0;1].
			AlphaTest GEqual 1.0
			SetTexture [_MainTex] {
				combine primary * texture double, primary * texture QUAD
			}
		}
	}
	
	Fallback Off
}
