Shader "Custom/LavaDisplacement" {
	Properties {
		_RampTex  ("Color Ramp", 2D) = "white" {}
		_DispTex ("Displacement Texture", 2D) = "gray" {}
		_Displacement ("Displacement", Range(0.0, 100.0)) = 0.1
		_LoopDuration ("LoopDuration", Range(0.0, 10.0)) = 5.0
		_RampMin ("Ramp min", Range(0.0, 1.0)) = 0.0
		_RampMax ("Ramp max", Range(0.0, 1.0)) = 1.0
	}
	
	SubShader {
		Pass {
			Tags { "RenderType"="Opaque" }
			Lighting Off

			CGPROGRAM
			#pragma glsl
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform sampler2D _RampTex;
			uniform sampler2D _DispTex;
			uniform float4 _DispTex_ST;
			uniform float _Displacement;		
			uniform float _LoopDuration;

			uniform float _RampMin;
			uniform float _RampMax;

			struct vertexInput {
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};
			struct vertexOutput {
				float4 transformedVert : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float3 channelFactor : TEXCOORD1;
			};

			vertexOutput vert (vertexInput vertIn)
			{
				vertexOutput vertOut;

				// loop duraction is x seconds
				// 2.0 * PI = 
				float channelFactorR = sin((_Time.y / _LoopDuration) * (6.283185)) * 0.5 + 0.25;
				float channelFactorG = sin((_Time.y / _LoopDuration + 0.33333333) * 6.283185) * 0.5 + 0.25;
				float channelFactorB = sin((_Time.y / _LoopDuration + 0.66666667) * 6.283185) * 0.5 + 0.25;
				float normFactor = 1.0 / (channelFactorR + channelFactorG + channelFactorB);
				// normalize channel factor
				channelFactorR *= normFactor;
				channelFactorG *= normFactor;
				channelFactorB *= normFactor;

				vertOut.texcoord = _DispTex_ST.xy * vertIn.texcoord.xy + _DispTex_ST.zw;
				float3 dcolor = tex2Dlod(_DispTex, float4(vertOut.texcoord, 0.0, 0.0));
				float d = (dcolor.r * channelFactorR + dcolor.g * channelFactorG + dcolor.b * channelFactorB);
				vertOut.transformedVert = vertIn.vertex;
				vertOut.transformedVert.xyz = vertIn.vertex.xyz + vertIn.normal.xyz * d * (_Displacement - _Displacement*0.5);
				
				vertOut.transformedVert = mul(UNITY_MATRIX_MVP, vertOut.transformedVert);
				vertOut.channelFactor = float3(channelFactorR, channelFactorG, channelFactorB);

				return vertOut;
			}

			float4 frag (vertexOutput vert) : COLOR
			{
				float3 dcolor = tex2D(_DispTex, vert.texcoord);
				float d = (dcolor.r*vert.channelFactor.r + dcolor.g*vert.channelFactor.g + 
							dcolor.b*vert.channelFactor.b) * (_RampMax - _RampMin) + _RampMin; 
				float4 color = tex2D(_RampTex, float2(d, 0.5));
				return float4(color.r, color.g, color.b, 1.0);
			}
			
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
