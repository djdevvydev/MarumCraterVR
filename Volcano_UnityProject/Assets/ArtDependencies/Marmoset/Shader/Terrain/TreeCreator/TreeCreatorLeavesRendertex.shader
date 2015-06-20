Shader "Hidden/Marmoset/Nature/Tree Creator Leaves Rendertex" {
Properties {
	_TranslucencyColor ("Translucency Color", Color) = (0.73,0.85,0.41,1) // (187,219,106,255)
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	_HalfOverCutoff ("0.5 / alpha cutoff", Range(0,1)) = 1.0
	_TranslucencyViewDependency ("View dependency", Range(0,1)) = 0.7
	
	_MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
	_BumpSpecMap ("Normalmap (GA) Spec (R) Shadow Offset (B)", 2D) = "bump" {}
	_TranslucencyMap ("Trans (B) Gloss(A)", 2D) = "white" {}
}

SubShader {  
	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile MARMO_TERRAIN_BLEND_OFF MARMO_TERRAIN_BLEND_ON
		#if MARMO_TERRAIN_BLEND_ON			
			#define MARMO_SKY_BLEND
		#endif

		#include "UnityCG.cginc"
		#include "Lighting.cginc"

		// no specular, it looks more or less terrible.
		//#define MARMO_SPECULAR_DIRECT
		#define MARMO_SKY_ROTATION
		
		#include "TreeCore.cginc"
		#include "TreeLeavesInput.cginc"
		
		fixed _Cutoff;
		
		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv : TEXCOORD0;
			float3 color : TEXCOORD1; 
			float3 backContrib : TEXCOORD2;
			float3 nl : TEXCOORD3;
			float3 nh : TEXCOORD4;
		};

		CBUFFER_START(UnityTerrainImposter)
			float3 _TerrainTreeLightDirections[4];
			float4 _TerrainTreeLightColors[4];
		CBUFFER_END

		v2f vert (appdata_full v) {	
			v2f o;
			ExpandBillboard (UNITY_MATRIX_IT_MV, v.vertex, v.normal, v.tangent);
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = v.texcoord.xy;
			float3 viewDir = normalize(ObjSpaceViewDir(v.vertex));
			
			for (int j = 0; j < 3; j++)
			{
				float3 lightDir = _TerrainTreeLightDirections[j];
			
				half nl = dot (v.normal, lightDir);
				
				// view dependent back contribution for translucency
				half backContrib = saturate(dot(viewDir, -lightDir));
				
				// normally translucency is more like -nl, but looks better when it's view dependent
				backContrib = lerp(saturate(-nl), backContrib, _TranslucencyViewDependency);
				o.backContrib[j] = backContrib * 2;
				
				// wrap-around diffuse
				nl = max (0, nl * 0.6 + 0.4);
				o.nl[j] = nl;
				
				half3 h = normalize (lightDir + viewDir);
				float nh = max (0, dot (v.normal, h));
				o.nh[j] = nh;
			}
			
			o.color = v.color.a;
			return o;
		}

		fixed4 frag (v2f i) : COLOR {
			half4 exposureIBL = blendedExposure();
			
			fixed4 col = tex2D (_MainTex, i.uv);
			clip (col.a - _Cutoff);
			
			fixed3 albedo = col.rgb * i.color;
			fixed4 trngls = tex2D (_TranslucencyMap, i.uv);
			#ifdef MARMO_SPECULAR_DIRECT
				half gloss = trngls.a;
				half specular = tex2D (_BumpSpecMap, i.uv).r * 128.0;
			#endif
			
			half3 light = UNITY_LIGHTMODEL_AMBIENT * albedo;
			half3 ibl = blendedSHAmbient() * albedo * exposureIBL.x;

			half3 backContribs = i.backContrib * trngls.b;
			
			for (int j = 0; j < 3; j++)
			{
				half3 lightColor = _TerrainTreeLightColors[j].rgb;
				half3 translucencyColor = backContribs[j] * _TranslucencyColor;
				
				half nl = i.nl[j];		
				light += (translucencyColor + nl) * albedo * lightColor;
				
				#ifdef MARMO_SPECULAR_DIRECT
					half nh = i.nh[j];
					half spec = pow (nh, specular) * gloss;
					light += (_SpecColor.rgb * spec)*lightColor;
				#endif
			}
			
			half4 c;
			c.rgb = (light + ibl) * exposureIBL.w;
			c.a = 1;
			return c;
		}
		ENDCG
	}
}

SubShader {
	Pass {		
		Fog { Mode Off }
		
		CGPROGRAM
		#pragma vertex vert
		#pragma exclude_renderers shaderonly
		#include "UnityCG.cginc"

		struct v2f {
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
			float2 uv : TEXCOORD0;
		};

		CBUFFER_START(UnityTerrainImposter)
			float3 _TerrainTreeLightDirections[4];
			float4 _TerrainTreeLightColors[4];
		CBUFFER_END
		float _HalfOverCutoff;

		v2f vert (appdata_full v) {
			v2f o;
			o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
			o.uv = v.texcoord.xy;

			float3 light = UNITY_LIGHTMODEL_AMBIENT.rgb;
			
			for (int j = 0; j < 3; j++)
			{
				half3 lightColor = _TerrainTreeLightColors[j].rgb;
				float3 lightDir = _TerrainTreeLightDirections[j];
			
				half nl = dot (v.normal, lightDir);
				light += lightColor * nl;
			}
			
			// lighting * AO
			o.color.rgb = light * v.color.a;
			
			// We want to do alpha testing on cutoff, but at the same
			// time write 1.0 into alpha. So we multiply alpha by 0.25/cutoff
			// and alpha test on alpha being greater or equal to 1.0.
			// That will work for cutoff values in range [0.25;1].
			// Remember that color gets clamped to [0;1].
			o.color.a = 0.5 * _HalfOverCutoff;
			return o;
		}
		ENDCG
		
		AlphaTest GEqual 1
		SetTexture [_MainTex] {
			Combine texture * primary DOUBLE, texture * primary QUAD
		} 
	}
}

FallBack Off
}
