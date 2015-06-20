Shader "Custom/HeatHaze" {
	Properties {
        _AlphaTex ("Alpha mask", 2D) = "white" {}
		_BumpMap ("Normal map", 2D) = "bump" {}
		_BumpAmt ("Distortion", range(0, 128)) = 10
	}
	SubShader {
		// This pass grabs the screen behind the object into a texture.
		// We can access the result in the next pass as _GrabTexture
		GrabPass {
			Name "BASE"
			Tags { "LightMode" = "Always" }
		}
		
		// We must be transparent, so that other objects are drawn
		// before us.
		Tags { "Queue"="Transparent"  "IgnoreProjector"="True" "RenderType"="Opaque" }
		
		// Main pass: Take the texture grabbed above and see the bumpmap
		// to perturb it on the screen
		Pass {
			Name "BASE"
			// always rendered, no lighting applied
			Tags { "LightMode" = "Always" }
			Blend SrcAlpha OneMinusSrcAlpha
			//Blend SrcAlpha OneMinusSrcAlpha // use alpha blending
			// render pixels with alpha greather than 0.01
			AlphaTest Greater .01
			// don't write to z buffer for transparent objects
			Cull Off Lighting Off ZWrite Off
	
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// hint_fastest not mac friendly
			//#pragma fragmentoption ARGB_precision_hint_fastest
			#include "UnityCG.cginc"
			
			uniform sampler2D _AlphaTex;
			uniform float4 _AlphaTex_ST;
			uniform sampler2D _BumpMap;
			uniform float4 _BumpMap_ST;
			uniform float _BumpAmt;
			
			uniform sampler2D_float _CameraDepthTexture;

			uniform sampler2D _GrabTexture;
			uniform float4 _GrabTexture_TexelSize;

			struct vertIn {	
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};

			struct vertOut {
				float4 vertex : POSITION;
				float4 uvgrab : TEXCOORD0;
				float2 uvbump : TEXCOORD1;
				float2 uvalpha : TEXCOORD2;
				fixed4 color : COLOR;
			};
			
			vertOut vert (vertIn vertexIn)
			{
				vertOut outV;
				outV.vertex = mul(UNITY_MATRIX_MVP, vertexIn.vertex);
				// depending on graphics API, uv coordinates might start at top or bottom
				#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
				#else
				float scale = 1.0;
				#endif
				outV.uvgrab.xy = (float2(outV.vertex.x, outV.vertex.y*scale) +
								outV.vertex.w) * 0.5;
				outV.uvgrab.zw = outV.vertex.zw;
				// applies each texture's scale and offset to texture coords
				outV.uvbump = TRANSFORM_TEX(vertexIn.texcoord, _BumpMap);
				outV.uvalpha = TRANSFORM_TEX(vertexIn.texcoord, _AlphaTex); 

				outV.color = vertexIn.color;
				return outV;
			}

			fixed4 frag(vertOut input) : COLOR
			{
				// calculate perturbed coordinates
				// unpack basically does normal.xy = packednormal.wy * 2 - 1;
				// that makes normal coordinates go from 0-1 -> -1 to +1
				// followed by normal.z = sqrt(1 - normal.x*normal.x - normal.y * normal.y);
				// since Z is not stored in the normal map
				fixed2 bump = UnpackNormal(tex2D(_BumpMap, input.uvbump)).rg;
				// could optimize by just reading x and y without reconstructing z
				fixed2 offsetBump = bump * _BumpAmt * _GrabTexture_TexelSize.xy;
				input.uvgrab.xy = offsetBump * input.uvgrab.z + input.uvgrab.xy;
				// texel size is just 1/(texture size). i.e. how big each texture
				// pixel is in 0-1.0 space	
				// tex2Dproj does texture look up in projected space; UNITY_PROJ_COORD
				// simply prepares 3-tuple input, or xyw
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(input.uvgrab));
				fixed4 alphaTint = tex2D(_AlphaTex, input.uvalpha);
				
				fixed4 finalColor = col * input.color;
				return fixed4(finalColor.r, finalColor.g, finalColor.b, finalColor.a * alphaTint.a);
			}

			ENDCG

		}		
		
	} 
	FallBack "Diffuse"
}
