Shader "DT_Shaders/DT_BumpedSpecular" {
    Properties {
        _DiffuseMap ("DiffuseMap", 2D) = "white" {}
        _SpecularMap ("SpecularMap", 2D) = "white" {}
        _Glossiness ("Glossiness", Range(0, 1)) = 0
        _SpecIntesity ("SpecIntesity", Range(0, 1)) = 0
        _NormalMap ("NormalMap", 2D) = "bump" {}
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _DiffuseMap; uniform float4 _DiffuseMap_ST;
            uniform float _Glossiness;
            uniform sampler2D _SpecularMap; uniform float4 _SpecularMap_ST;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            uniform float _SpecIntesity;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.tangentDir = normalize( mul( _Object2World, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 node_76 = i.uv0;
                float3 normalLocal = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(node_76.rg, _NormalMap))).rgb;
                float3 normalDirection =  mul( normalLocal, tangentTransform );
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor + UNITY_LIGHTMODEL_AMBIENT.xyz;
///////// Gloss:
                float gloss = exp2(_Glossiness*10.0+1.0);
////// Specular:
                NdotL = max(0.0, NdotL);
                float3 specularColor = (tex2D(_SpecularMap,TRANSFORM_TEX(node_76.rg, _SpecularMap)).rgb*_SpecIntesity);
                float3 specular = (floor(attenuation) * _LightColor0.xyz) * pow(max(0,dot(reflect(-lightDirection, normalDirection),viewDirection)),gloss) * specularColor;
                float3 finalColor = diffuse * tex2D(_DiffuseMap,TRANSFORM_TEX(node_76.rg, _DiffuseMap)).rgb + specular;
/// Final Color:
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ForwardAdd"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            
            Fog { Color (0,0,0,0) }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _DiffuseMap; uniform float4 _DiffuseMap_ST;
            uniform float _Glossiness;
            uniform sampler2D _SpecularMap; uniform float4 _SpecularMap_ST;
            uniform sampler2D _NormalMap; uniform float4 _NormalMap_ST;
            uniform float _SpecIntesity;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float4 uv0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float4 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                float3 normalDir : TEXCOORD2;
                float3 tangentDir : TEXCOORD3;
                float3 binormalDir : TEXCOORD4;
                LIGHTING_COORDS(5,6)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o;
                o.uv0 = v.uv0;
                o.normalDir = mul(float4(v.normal,0), _World2Object).xyz;
                o.tangentDir = normalize( mul( _Object2World, float4( v.tangent.xyz, 0.0 ) ).xyz );
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                o.posWorld = mul(_Object2World, v.vertex);
                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
                float3x3 tangentTransform = float3x3( i.tangentDir, i.binormalDir, i.normalDir);
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float2 node_77 = i.uv0;
                float3 normalLocal = UnpackNormal(tex2D(_NormalMap,TRANSFORM_TEX(node_77.rg, _NormalMap))).rgb;
                float3 normalDirection =  mul( normalLocal, tangentTransform );
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
/////// Diffuse:
                float NdotL = dot( normalDirection, lightDirection );
                float3 diffuse = max( 0.0, NdotL) * attenColor;
///////// Gloss:
                float gloss = exp2(_Glossiness*10.0+1.0);
////// Specular:
                NdotL = max(0.0, NdotL);
                float3 specularColor = (tex2D(_SpecularMap,TRANSFORM_TEX(node_77.rg, _SpecularMap)).rgb*_SpecIntesity);
                float3 specular = attenColor * pow(max(0,dot(reflect(-lightDirection, normalDirection),viewDirection)),gloss) * specularColor;
                float3 finalColor = diffuse * tex2D(_DiffuseMap,TRANSFORM_TEX(node_77.rg, _DiffuseMap)).rgb + specular;
/// Final Color:
                return fixed4(finalColor * 1,0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
