Shader "Hidden/Marmoset/Nature/Tree Soft Occlusion Bark Rendertex" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,0)
		_MainTex ("Main Texture", 2D) = "white" {}
		_BaseLight ("Base Light", Range(0, 1)) = 0.35
		_AO ("Amb. Occlusion", Range(0, 10)) = 2.4
		
		// These are here only to provide default values
		_Scale ("Scale", Vector) = (1,1,1,1)
		_SquashAmount ("Squash", Float) = 1
	}
	
	SubShader {
		Fog { Mode Off }
		Pass {
			Lighting On
		
			CGPROGRAM
			#pragma vertex bark
			#pragma fragment frag 
			#pragma glsl_no_auto_normalization
			#define WRITE_ALPHA_1 1
			#define USE_CUSTOM_LIGHT_DIR 1
			
			#pragma multi_compile MARMO_TERRAIN_BLEND_OFF MARMO_TERRAIN_BLEND_ON
			#if MARMO_TERRAIN_BLEND_ON			
				#define MARMO_SKY_BLEND
			#endif
						
			#include "SH_Vertex.cginc"

			uniform sampler2D _MainTex;
			
			fixed4 frag(v2f IN) : COLOR
			{
				half4 albedo = tex2D( _MainTex, IN.uv.xy);
				return albedo * IN.color;
			}
			ENDCG
		}
	}
	
	SubShader {
		Fog { Mode Off }
		Pass {
			Lighting On
			
			CGPROGRAM
			#pragma exclude_renderers shaderonly
			#pragma vertex bark
			#define WRITE_ALPHA_1 1
			#define USE_CUSTOM_LIGHT_DIR 1
			#include "SH_Vertex.cginc"
			ENDCG
			
			SetTexture [_MainTex] {
				combine primary * texture double, primary
			}
		}
	}
	
	Fallback Off
}