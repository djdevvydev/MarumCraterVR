Shader "Animated/Diffuse/Diffuse Normalmap Specular"
{
	Properties 
	{
_MainColor("Main Color", Color) = (0.4980392,0.4980392,0.4980392,1)
_SpecularColor("Specular Color", Color) = (0.4980392,0.4980392,0.4980392,1)
_SpecularPower("Specular Power", Range(0,1) ) = 0.5
_Gloss("Gloss", Range(0,1) ) = 0.5
_Alpha("Alpha", Range(0,1) ) = 0
_Diffuse("Diffuse", 2D) = "black" {}
_Specular("Specular", 2D) = "black" {}
_Normalmap("Normalmap", 2D) = "black" {}
_Pan("UV Pan (Speed(XY))", Vector) = (0,0,0,0)
_Rotation("Rotation (Pivot(XY), Angle Speed(Z))", Vector) = (0,0,0,0)

	}
	
	SubShader 
	{
		Tags
		{
"Queue"="Transparent"
"IgnoreProjector"="False"
"RenderType"="Transparent"

		}

		
Cull Back
ZWrite On
ZTest LEqual
ColorMask RGBA
Blend One OneMinusSrcAlpha
Fog{
}


			
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
Program "vp" {
// Vertex combos: 6
//   opengl - ALU: 6 to 79
//   d3d9 - ALU: 6 to 82
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 22 [unity_Scale]
Vector 23 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 43 ALU
PARAM c[24] = { { 1 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[22].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MOV R0.w, c[0].x;
MUL R1, R0.xyzz, R0.yzzx;
DP4 R2.z, R0, c[17];
DP4 R2.y, R0, c[16];
DP4 R2.x, R0, c[15];
MUL R0.w, R2, R2;
MAD R0.w, R0.x, R0.x, -R0;
DP4 R0.z, R1, c[20];
DP4 R0.y, R1, c[19];
DP4 R0.x, R1, c[18];
ADD R0.xyz, R2, R0;
MUL R1.xyz, R0.w, c[21];
ADD result.texcoord[2].xyz, R0, R1;
MOV R1.xyz, c[13];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[22].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[14];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.y, R0, c[10];
DP4 R3.x, R0, c[9];
DP3 result.texcoord[1].y, R3, R1;
DP3 result.texcoord[3].y, R1, R2;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[23], c[23].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 43 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 21 [unity_Scale]
Vector 22 [_Diffuse_ST]
"vs_3_0
; 46 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c23, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c21.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mov r0.w, c23.x
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c16
dp4 r2.y, r0, c15
dp4 r2.x, r0, c14
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c19
dp4 r0.y, r1, c18
dp4 r0.x, r1, c17
mul r1.xyz, r0.w, c20
add r0.xyz, r2, r0
add o3.xyz, r0, r1
mov r0.w, c23.x
mov r0.xyz, c12
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c21.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c13, r0
mov r0, c9
mov r1, c8
dp4 r4.y, c13, r0
dp4 r4.x, c13, r1
dp3 o2.y, r4, r2
dp3 o4.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o4.z, v2, r3
dp3 o4.x, v1, r3
mad o1.xy, v3, c22, c22.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.00000;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = (tmpvar_6 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_13;
  mediump vec4 normal_14;
  normal_14 = tmpvar_12;
  mediump vec3 x3_15;
  highp float vC_16;
  mediump vec3 x2_17;
  mediump vec3 x1_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAr, normal_14);
  x1_18.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAg, normal_14);
  x1_18.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAb, normal_14);
  x1_18.z = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = (normal_14.xyzz * normal_14.yzzx);
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBr, tmpvar_22);
  x2_17.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBg, tmpvar_22);
  x2_17.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBb, tmpvar_22);
  x2_17.z = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = ((normal_14.x * normal_14.x) - (normal_14.y * normal_14.y));
  vC_16 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (unity_SHC.xyz * vC_16);
  x3_15 = tmpvar_27;
  tmpvar_13 = ((x1_18 + x2_17) + x3_15);
  shlight_3 = tmpvar_13;
  tmpvar_5 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = (tmpvar_9 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  mediump float tmpvar_6;
  highp vec4 Tex2D1_7;
  highp vec4 Tex2DNormal0_8;
  highp vec4 Tex2D0_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_11;
  tmpvar_11 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_12;
  tmpvar_12 = cos(tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_14;
  tmpvar_14 = sin(tmpvar_11);
  highp vec4 tmpvar_15;
  tmpvar_15.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_10 * tmpvar_12) - (tmpvar_13 * tmpvar_14)))).x;
  tmpvar_15.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_10 * tmpvar_14) + (tmpvar_13 * tmpvar_12)))).x;
  tmpvar_15.z = 0.000000;
  tmpvar_15.w = 0.000000;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Diffuse, tmpvar_15.xy);
  Tex2D0_9 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_9.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_18;
  tmpvar_18.w = 1.00000;
  tmpvar_18.xyz = ((texture2D (_Normalmap, tmpvar_15.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_8 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Specular, tmpvar_15.xy);
  Tex2D1_7 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (mix (tmpvar_17, Tex2D0_9, tmpvar_17) * _MainColor).xyz;
  tmpvar_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = Tex2DNormal0_8.xyz;
  tmpvar_3 = tmpvar_21;
  tmpvar_5 = _Gloss;
  highp vec3 tmpvar_22;
  tmpvar_22 = ((Tex2D1_7 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_4 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = tmpvar_17.x;
  tmpvar_6 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(tmpvar_3);
  tmpvar_3 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_26;
  lightDir_26 = xlv_TEXCOORD1;
  mediump vec3 viewDir_27;
  viewDir_27 = tmpvar_25;
  mediump vec4 res_28;
  highp float nh_29;
  mediump float tmpvar_30;
  tmpvar_30 = max (0.000000, dot (tmpvar_24, normalize((lightDir_26 + viewDir_27))));
  nh_29 = tmpvar_30;
  mediump float arg1_31;
  arg1_31 = (tmpvar_5 * 128.000);
  res_28.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_26, tmpvar_24)));
  lowp float tmpvar_32;
  tmpvar_32 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_33;
  tmpvar_33 = (pow (nh_29, arg1_31) * tmpvar_32);
  res_28.w = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_28 * 2.00000);
  res_28 = tmpvar_34;
  mediump vec4 c_35;
  c_35.xyz = ((tmpvar_2 * tmpvar_34.xyz) + (tmpvar_34.xyz * (tmpvar_34.w * tmpvar_4)));
  c_35.w = tmpvar_6;
  c_1 = c_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  c_1.xyz = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = c_1.xyz;
  c_1.xyz = tmpvar_37;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.00000;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = (tmpvar_6 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_13;
  mediump vec4 normal_14;
  normal_14 = tmpvar_12;
  mediump vec3 x3_15;
  highp float vC_16;
  mediump vec3 x2_17;
  mediump vec3 x1_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAr, normal_14);
  x1_18.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAg, normal_14);
  x1_18.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAb, normal_14);
  x1_18.z = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = (normal_14.xyzz * normal_14.yzzx);
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBr, tmpvar_22);
  x2_17.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBg, tmpvar_22);
  x2_17.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBb, tmpvar_22);
  x2_17.z = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = ((normal_14.x * normal_14.x) - (normal_14.y * normal_14.y));
  vC_16 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (unity_SHC.xyz * vC_16);
  x3_15 = tmpvar_27;
  tmpvar_13 = ((x1_18 + x2_17) + x3_15);
  shlight_3 = tmpvar_13;
  tmpvar_5 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = (tmpvar_9 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  mediump float tmpvar_6;
  highp vec4 Tex2D1_7;
  highp vec4 Tex2DNormal0_8;
  highp vec4 Tex2D0_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_11;
  tmpvar_11 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_12;
  tmpvar_12 = cos(tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_14;
  tmpvar_14 = sin(tmpvar_11);
  highp vec4 tmpvar_15;
  tmpvar_15.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_10 * tmpvar_12) - (tmpvar_13 * tmpvar_14)))).x;
  tmpvar_15.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_10 * tmpvar_14) + (tmpvar_13 * tmpvar_12)))).x;
  tmpvar_15.z = 0.000000;
  tmpvar_15.w = 0.000000;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Diffuse, tmpvar_15.xy);
  Tex2D0_9 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_9.wwww) * vec4(_Alpha)));
  lowp vec3 normal_18;
  normal_18.xy = ((texture2D (_Normalmap, tmpvar_15.xy).wy * 2.00000) - 1.00000);
  normal_18.z = sqrt(((1.00000 - (normal_18.x * normal_18.x)) - (normal_18.y * normal_18.y)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = normal_18;
  Tex2DNormal0_8 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_15.xy);
  Tex2D1_7 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_17, Tex2D0_9, tmpvar_17) * _MainColor).xyz;
  tmpvar_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_8.xyz;
  tmpvar_3 = tmpvar_22;
  tmpvar_5 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_7 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_4 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_17.x;
  tmpvar_6 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_3);
  tmpvar_3 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_27;
  lightDir_27 = xlv_TEXCOORD1;
  mediump vec3 viewDir_28;
  viewDir_28 = tmpvar_26;
  mediump vec4 res_29;
  highp float nh_30;
  mediump float tmpvar_31;
  tmpvar_31 = max (0.000000, dot (tmpvar_25, normalize((lightDir_27 + viewDir_28))));
  nh_30 = tmpvar_31;
  mediump float arg1_32;
  arg1_32 = (tmpvar_5 * 128.000);
  res_29.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_27, tmpvar_25)));
  lowp float tmpvar_33;
  tmpvar_33 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_34;
  tmpvar_34 = (pow (nh_30, arg1_32) * tmpvar_33);
  res_29.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (res_29 * 2.00000);
  res_29 = tmpvar_35;
  mediump vec4 c_36;
  c_36.xyz = ((tmpvar_2 * tmpvar_35.xyz) + (tmpvar_35.xyz * (tmpvar_35.w * tmpvar_4)));
  c_36.w = tmpvar_6;
  c_1 = c_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  c_1.xyz = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = c_1.xyz;
  c_1.xyz = tmpvar_38;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 14 [unity_LightmapST]
Vector 15 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 6 ALU
PARAM c[16] = { program.local[0],
		state.matrix.mvp,
		program.local[5..15] };
MAD result.texcoord[0].xy, vertex.texcoord[0], c[15], c[15].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[14], c[14].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 6 instructions, 0 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_LightmapST]
Vector 13 [_Diffuse_ST]
"vs_3_0
; 6 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_position0 v0
dcl_texcoord0 v3
dcl_texcoord1 v4
mad o1.xy, v3, c13, c13.zwzw
mad o2.xy, v4, c12, c12.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Time;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 Tex2DNormal0_5;
  highp vec4 Tex2D0_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_8;
  tmpvar_8 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_9;
  tmpvar_9 = cos(tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_11;
  tmpvar_11 = sin(tmpvar_8);
  highp vec4 tmpvar_12;
  tmpvar_12.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_7 * tmpvar_9) - (tmpvar_10 * tmpvar_11)))).x;
  tmpvar_12.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_7 * tmpvar_11) + (tmpvar_10 * tmpvar_9)))).x;
  tmpvar_12.z = 0.000000;
  tmpvar_12.w = 0.000000;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Diffuse, tmpvar_12.xy);
  Tex2D0_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_6.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.00000;
  tmpvar_15.xyz = ((texture2D (_Normalmap, tmpvar_12.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (mix (tmpvar_14, Tex2D0_6, tmpvar_14) * _MainColor).xyz;
  tmpvar_2 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = Tex2DNormal0_5.xyz;
  tmpvar_3 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = tmpvar_14.x;
  tmpvar_4 = tmpvar_18;
  tmpvar_3 = normalize(tmpvar_3);
  lowp vec3 tmpvar_19;
  tmpvar_19 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz);
  mediump vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_2 * tmpvar_19);
  c_1.xyz = tmpvar_20;
  c_1.w = tmpvar_4;
  mediump vec3 tmpvar_21;
  tmpvar_21 = c_1.xyz;
  c_1.xyz = tmpvar_21;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Time;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 Tex2DNormal0_5;
  highp vec4 Tex2D0_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_8;
  tmpvar_8 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_9;
  tmpvar_9 = cos(tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_11;
  tmpvar_11 = sin(tmpvar_8);
  highp vec4 tmpvar_12;
  tmpvar_12.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_7 * tmpvar_9) - (tmpvar_10 * tmpvar_11)))).x;
  tmpvar_12.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_7 * tmpvar_11) + (tmpvar_10 * tmpvar_9)))).x;
  tmpvar_12.z = 0.000000;
  tmpvar_12.w = 0.000000;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Diffuse, tmpvar_12.xy);
  Tex2D0_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_6.wwww) * vec4(_Alpha)));
  lowp vec3 normal_15;
  normal_15.xy = ((texture2D (_Normalmap, tmpvar_12.xy).wy * 2.00000) - 1.00000);
  normal_15.z = sqrt(((1.00000 - (normal_15.x * normal_15.x)) - (normal_15.y * normal_15.y)));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.00000;
  tmpvar_16.xyz = normal_15;
  Tex2DNormal0_5 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (mix (tmpvar_14, Tex2D0_6, tmpvar_14) * _MainColor).xyz;
  tmpvar_2 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = Tex2DNormal0_5.xyz;
  tmpvar_3 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_14.x;
  tmpvar_4 = tmpvar_19;
  tmpvar_3 = normalize(tmpvar_3);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_21;
  tmpvar_21 = ((8.00000 * tmpvar_20.w) * tmpvar_20.xyz);
  mediump vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_2 * tmpvar_21);
  c_1.xyz = tmpvar_22;
  c_1.w = tmpvar_4;
  mediump vec3 tmpvar_23;
  tmpvar_23 = c_1.xyz;
  c_1.xyz = tmpvar_23;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 23 [unity_Scale]
Vector 24 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 48 ALU
PARAM c[25] = { { 1, 0.5 },
		state.matrix.mvp,
		program.local[5..24] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[23].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MOV R0.w, c[0].x;
MUL R1, R0.xyzz, R0.yzzx;
DP4 R2.z, R0, c[18];
DP4 R2.y, R0, c[17];
DP4 R2.x, R0, c[16];
MUL R0.w, R2, R2;
MAD R0.w, R0.x, R0.x, -R0;
DP4 R0.z, R1, c[21];
DP4 R0.y, R1, c[20];
DP4 R0.x, R1, c[19];
ADD R0.xyz, R2, R0;
MUL R1.xyz, R0.w, c[22];
ADD result.texcoord[2].xyz, R0, R1;
MOV R1.xyz, c[13];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[23].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[15];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.y, R0, c[10];
DP4 R3.x, R0, c[9];
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
DP3 result.texcoord[1].y, R3, R1;
DP3 result.texcoord[3].y, R1, R2;
MUL R1.xyz, R0.xyww, c[0].y;
MUL R1.y, R1, c[14].x;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[24], c[24].zwzw;
END
# 48 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 23 [unity_Scale]
Vector 24 [_Diffuse_ST]
"vs_3_0
; 51 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c25, 1.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r1.xyz, v2, c23.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mov r0.w, c25.x
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c18
dp4 r2.y, r0, c17
dp4 r2.x, r0, c16
mul r0.w, r2, r2
mad r0.w, r0.x, r0.x, -r0
dp4 r0.z, r1, c21
dp4 r0.y, r1, c20
dp4 r0.x, r1, c19
mul r1.xyz, r0.w, c22
add r0.xyz, r2, r0
add o3.xyz, r0, r1
mov r0.w, c25.x
mov r0.xyz, c12
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c23.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c15, r0
mov r0, c9
dp4 r4.y, c15, r0
mov r1, c8
dp4 r4.x, c15, r1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c25.y
mul r1.y, r1, c13.x
dp3 o2.y, r4, r2
dp3 o4.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o4.z, v2, r3
dp3 o4.x, v1, r3
mad o5.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o5.zw, r0
mad o1.xy, v3, c24, c24.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  highp vec3 tmpvar_8;
  tmpvar_7 = tmpvar_1.xyz;
  tmpvar_8 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_9;
  tmpvar_9[0].x = tmpvar_7.x;
  tmpvar_9[0].y = tmpvar_8.x;
  tmpvar_9[0].z = tmpvar_2.x;
  tmpvar_9[1].x = tmpvar_7.y;
  tmpvar_9[1].y = tmpvar_8.y;
  tmpvar_9[1].z = tmpvar_2.y;
  tmpvar_9[2].x = tmpvar_7.z;
  tmpvar_9[2].y = tmpvar_8.z;
  tmpvar_9[2].z = tmpvar_2.z;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.00000;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = (tmpvar_6 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_13;
  mediump vec4 normal_14;
  normal_14 = tmpvar_12;
  mediump vec3 x3_15;
  highp float vC_16;
  mediump vec3 x2_17;
  mediump vec3 x1_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAr, normal_14);
  x1_18.x = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAg, normal_14);
  x1_18.y = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAb, normal_14);
  x1_18.z = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22 = (normal_14.xyzz * normal_14.yzzx);
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBr, tmpvar_22);
  x2_17.x = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBg, tmpvar_22);
  x2_17.y = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBb, tmpvar_22);
  x2_17.z = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = ((normal_14.x * normal_14.x) - (normal_14.y * normal_14.y));
  vC_16 = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (unity_SHC.xyz * vC_16);
  x3_15 = tmpvar_27;
  tmpvar_13 = ((x1_18 + x2_17) + x3_15);
  shlight_3 = tmpvar_13;
  tmpvar_5 = shlight_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = (tmpvar_9 * (((_World2Object * tmpvar_11).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  mediump float tmpvar_6;
  highp vec4 Tex2D1_7;
  highp vec4 Tex2DNormal0_8;
  highp vec4 Tex2D0_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_11;
  tmpvar_11 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_12;
  tmpvar_12 = cos(tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_14;
  tmpvar_14 = sin(tmpvar_11);
  highp vec4 tmpvar_15;
  tmpvar_15.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_10 * tmpvar_12) - (tmpvar_13 * tmpvar_14)))).x;
  tmpvar_15.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_10 * tmpvar_14) + (tmpvar_13 * tmpvar_12)))).x;
  tmpvar_15.z = 0.000000;
  tmpvar_15.w = 0.000000;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Diffuse, tmpvar_15.xy);
  Tex2D0_9 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_9.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_18;
  tmpvar_18.w = 1.00000;
  tmpvar_18.xyz = ((texture2D (_Normalmap, tmpvar_15.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_8 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Specular, tmpvar_15.xy);
  Tex2D1_7 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (mix (tmpvar_17, Tex2D0_9, tmpvar_17) * _MainColor).xyz;
  tmpvar_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = Tex2DNormal0_8.xyz;
  tmpvar_3 = tmpvar_21;
  tmpvar_5 = _Gloss;
  highp vec3 tmpvar_22;
  tmpvar_22 = ((Tex2D1_7 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_4 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = tmpvar_17.x;
  tmpvar_6 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(tmpvar_3);
  tmpvar_3 = tmpvar_24;
  lowp float tmpvar_25;
  mediump float lightShadowDataX_26;
  highp float dist_27;
  lowp float tmpvar_28;
  tmpvar_28 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = _LightShadowData.x;
  lightShadowDataX_26 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = max (float((dist_27 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_26);
  tmpvar_25 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_32;
  lightDir_32 = xlv_TEXCOORD1;
  mediump vec3 viewDir_33;
  viewDir_33 = tmpvar_31;
  mediump float atten_34;
  atten_34 = tmpvar_25;
  mediump vec4 res_35;
  highp float nh_36;
  mediump float tmpvar_37;
  tmpvar_37 = max (0.000000, dot (tmpvar_24, normalize((lightDir_32 + viewDir_33))));
  nh_36 = tmpvar_37;
  mediump float arg1_38;
  arg1_38 = (tmpvar_5 * 128.000);
  res_35.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_32, tmpvar_24)));
  lowp float tmpvar_39;
  tmpvar_39 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_40;
  tmpvar_40 = (pow (nh_36, arg1_38) * tmpvar_39);
  res_35.w = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_35 * (atten_34 * 2.00000));
  res_35 = tmpvar_41;
  mediump vec4 c_42;
  c_42.xyz = ((tmpvar_2 * tmpvar_41.xyz) + (tmpvar_41.xyz * (tmpvar_41.w * tmpvar_4)));
  c_42.w = tmpvar_6;
  c_1 = c_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  c_1.xyz = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = c_1.xyz;
  c_1.xyz = tmpvar_44;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  mediump vec3 tmpvar_14;
  mediump vec4 normal_15;
  normal_15 = tmpvar_13;
  mediump vec3 x3_16;
  highp float vC_17;
  mediump vec3 x2_18;
  mediump vec3 x1_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal_15);
  x1_19.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal_15);
  x1_19.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal_15);
  x1_19.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal_15.xyzz * normal_15.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2_18.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2_18.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2_18.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y));
  vC_17 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC_17);
  x3_16 = tmpvar_28;
  tmpvar_14 = ((x1_19 + x2_18) + x3_16);
  shlight_3 = tmpvar_14;
  tmpvar_5 = shlight_3;
  highp vec4 o_29;
  highp vec4 tmpvar_30;
  tmpvar_30 = (tmpvar_6 * 0.500000);
  highp vec2 tmpvar_31;
  tmpvar_31.x = tmpvar_30.x;
  tmpvar_31.y = (tmpvar_30.y * _ProjectionParams.x);
  o_29.xy = (tmpvar_31 + tmpvar_30.w);
  o_29.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = (tmpvar_10 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD4 = o_29;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  mediump float tmpvar_6;
  highp vec4 Tex2D1_7;
  highp vec4 Tex2DNormal0_8;
  highp vec4 Tex2D0_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_11;
  tmpvar_11 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_12;
  tmpvar_12 = cos(tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_14;
  tmpvar_14 = sin(tmpvar_11);
  highp vec4 tmpvar_15;
  tmpvar_15.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_10 * tmpvar_12) - (tmpvar_13 * tmpvar_14)))).x;
  tmpvar_15.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_10 * tmpvar_14) + (tmpvar_13 * tmpvar_12)))).x;
  tmpvar_15.z = 0.000000;
  tmpvar_15.w = 0.000000;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Diffuse, tmpvar_15.xy);
  Tex2D0_9 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_9.wwww) * vec4(_Alpha)));
  lowp vec3 normal_18;
  normal_18.xy = ((texture2D (_Normalmap, tmpvar_15.xy).wy * 2.00000) - 1.00000);
  normal_18.z = sqrt(((1.00000 - (normal_18.x * normal_18.x)) - (normal_18.y * normal_18.y)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = normal_18;
  Tex2DNormal0_8 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_15.xy);
  Tex2D1_7 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_17, Tex2D0_9, tmpvar_17) * _MainColor).xyz;
  tmpvar_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_8.xyz;
  tmpvar_3 = tmpvar_22;
  tmpvar_5 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_7 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_4 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_17.x;
  tmpvar_6 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_3);
  tmpvar_3 = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  highp vec3 tmpvar_27;
  tmpvar_27 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_28;
  lightDir_28 = xlv_TEXCOORD1;
  mediump vec3 viewDir_29;
  viewDir_29 = tmpvar_27;
  mediump float atten_30;
  atten_30 = tmpvar_26;
  mediump vec4 res_31;
  highp float nh_32;
  mediump float tmpvar_33;
  tmpvar_33 = max (0.000000, dot (tmpvar_25, normalize((lightDir_28 + viewDir_29))));
  nh_32 = tmpvar_33;
  mediump float arg1_34;
  arg1_34 = (tmpvar_5 * 128.000);
  res_31.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_28, tmpvar_25)));
  lowp float tmpvar_35;
  tmpvar_35 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_36;
  tmpvar_36 = (pow (nh_32, arg1_34) * tmpvar_35);
  res_31.w = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37 = (res_31 * (atten_30 * 2.00000));
  res_31 = tmpvar_37;
  mediump vec4 c_38;
  c_38.xyz = ((tmpvar_2 * tmpvar_37.xyz) + (tmpvar_37.xyz * (tmpvar_37.w * tmpvar_4)));
  c_38.w = tmpvar_6;
  c_1 = c_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  c_1.xyz = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = c_1.xyz;
  c_1.xyz = tmpvar_40;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 15 [unity_LightmapST]
Vector 16 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 11 ALU
PARAM c[17] = { { 0.5 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[4];
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[2].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[2].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[1].xy, vertex.texcoord[1], c[15], c[15].zwzw;
END
# 11 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_LightmapST]
Vector 15 [_Diffuse_ST]
"vs_3_0
; 11 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c16, 0.50000000, 0, 0, 0
dcl_position0 v0
dcl_texcoord0 v3
dcl_texcoord1 v4
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c16.x
mul r1.y, r1, c12.x
mad o3.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov o3.zw, r0
mad o1.xy, v3, c15, c15.zwzw
mad o2.xy, v4, c14, c14.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_LightmapST;

uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Time;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform highp vec4 _LightShadowData;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 Tex2DNormal0_5;
  highp vec4 Tex2D0_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_8;
  tmpvar_8 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_9;
  tmpvar_9 = cos(tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_11;
  tmpvar_11 = sin(tmpvar_8);
  highp vec4 tmpvar_12;
  tmpvar_12.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_7 * tmpvar_9) - (tmpvar_10 * tmpvar_11)))).x;
  tmpvar_12.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_7 * tmpvar_11) + (tmpvar_10 * tmpvar_9)))).x;
  tmpvar_12.z = 0.000000;
  tmpvar_12.w = 0.000000;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Diffuse, tmpvar_12.xy);
  Tex2D0_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_6.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.00000;
  tmpvar_15.xyz = ((texture2D (_Normalmap, tmpvar_12.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_5 = tmpvar_15;
  highp vec3 tmpvar_16;
  tmpvar_16 = (mix (tmpvar_14, Tex2D0_6, tmpvar_14) * _MainColor).xyz;
  tmpvar_2 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = Tex2DNormal0_5.xyz;
  tmpvar_3 = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = tmpvar_14.x;
  tmpvar_4 = tmpvar_18;
  tmpvar_3 = normalize(tmpvar_3);
  lowp float tmpvar_19;
  mediump float lightShadowDataX_20;
  highp float dist_21;
  lowp float tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2).x;
  dist_21 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = _LightShadowData.x;
  lightShadowDataX_20 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = max (float((dist_21 > (xlv_TEXCOORD2.z / xlv_TEXCOORD2.w))), lightShadowDataX_20);
  tmpvar_19 = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = min ((2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD1).xyz), vec3((tmpvar_19 * 2.00000)));
  mediump vec3 tmpvar_26;
  tmpvar_26 = (tmpvar_2 * tmpvar_25);
  c_1.xyz = tmpvar_26;
  c_1.w = tmpvar_4;
  mediump vec3 tmpvar_27;
  tmpvar_27 = c_1.xyz;
  c_1.xyz = tmpvar_27;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_LightmapST;

uniform highp vec4 _ProjectionParams;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (tmpvar_1 * 0.500000);
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_3.x;
  tmpvar_4.y = (tmpvar_3.y * _ProjectionParams.x);
  o_2.xy = (tmpvar_4 + tmpvar_3.w);
  o_2.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD2 = o_2;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD2;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Time;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump float tmpvar_4;
  highp vec4 Tex2DNormal0_5;
  highp vec4 Tex2D0_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_8;
  tmpvar_8 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_9;
  tmpvar_9 = cos(tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_11;
  tmpvar_11 = sin(tmpvar_8);
  highp vec4 tmpvar_12;
  tmpvar_12.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_7 * tmpvar_9) - (tmpvar_10 * tmpvar_11)))).x;
  tmpvar_12.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_7 * tmpvar_11) + (tmpvar_10 * tmpvar_9)))).x;
  tmpvar_12.z = 0.000000;
  tmpvar_12.w = 0.000000;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_Diffuse, tmpvar_12.xy);
  Tex2D0_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_6.wwww) * vec4(_Alpha)));
  lowp vec3 normal_15;
  normal_15.xy = ((texture2D (_Normalmap, tmpvar_12.xy).wy * 2.00000) - 1.00000);
  normal_15.z = sqrt(((1.00000 - (normal_15.x * normal_15.x)) - (normal_15.y * normal_15.y)));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.00000;
  tmpvar_16.xyz = normal_15;
  Tex2DNormal0_5 = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (mix (tmpvar_14, Tex2D0_6, tmpvar_14) * _MainColor).xyz;
  tmpvar_2 = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = Tex2DNormal0_5.xyz;
  tmpvar_3 = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = tmpvar_14.x;
  tmpvar_4 = tmpvar_19;
  tmpvar_3 = normalize(tmpvar_3);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD2);
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (unity_Lightmap, xlv_TEXCOORD1);
  lowp vec3 tmpvar_22;
  tmpvar_22 = ((8.00000 * tmpvar_21.w) * tmpvar_21.xyz);
  lowp vec3 tmpvar_23;
  tmpvar_23 = max (min (tmpvar_22, ((tmpvar_20.x * 2.00000) * tmpvar_21.xyz)), (tmpvar_22 * tmpvar_20.x));
  mediump vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_2 * tmpvar_23);
  c_1.xyz = tmpvar_24;
  c_1.w = tmpvar_4;
  mediump vec3 tmpvar_25;
  tmpvar_25 = c_1.xyz;
  c_1.xyz = tmpvar_25;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 30 [unity_Scale]
Vector 31 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 74 ALU
PARAM c[32] = { { 1, 0 },
		state.matrix.mvp,
		program.local[5..31] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[30].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[16];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[15];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[17];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[18];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R1.xyz, R0.x, c[19], R1;
MAD R0.xyz, R0.z, c[21], R1;
MAD R1.xyz, R0.w, c[22], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R3.z, R0, c[28];
DP4 R3.y, R0, c[27];
DP4 R3.x, R0, c[26];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[29];
MOV R1.w, c[0].x;
DP4 R2.z, R4, c[25];
DP4 R2.y, R4, c[24];
DP4 R2.x, R4, c[23];
ADD R2.xyz, R2, R3;
ADD R0.xyz, R2, R0;
ADD result.texcoord[2].xyz, R0, R1;
MOV R1.xyz, c[13];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[30].w, -vertex.position;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R1, c[14];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP4 R3.z, R1, c[11];
DP4 R3.y, R1, c[10];
DP4 R3.x, R1, c[9];
DP3 result.texcoord[1].y, R3, R0;
DP3 result.texcoord[3].y, R0, R2;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[31], c[31].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 74 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_WorldSpaceLightPos0]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 29 [unity_Scale]
Vector 30 [_Diffuse_ST]
"vs_3_0
; 77 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c31, 1.00000000, 0.00000000, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c29.w
dp4 r0.x, v0, c5
add r1, -r0.x, c15
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c14
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c31.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c16
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c17
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c31.x
dp4 r2.z, r4, c24
dp4 r2.y, r4, c23
dp4 r2.x, r4, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c31.y
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mad r1.xyz, r0.w, c21, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c27
dp4 r3.y, r0, c26
dp4 r3.x, r0, c25
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c28
add r2.xyz, r2, r3
add r0.xyz, r2, r0
add o3.xyz, r0, r1
mov r1.w, c31.x
mov r1.xyz, c12
dp4 r0.z, r1, c10
dp4 r0.y, r1, c9
dp4 r0.x, r1, c8
mad r3.xyz, r0, c29.w, -v0
mov r1.xyz, v1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r1.yzxw
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c13, r0
mov r1, c9
mov r0, c8
dp4 r4.y, c13, r1
dp4 r4.x, c13, r0
dp3 o2.y, r4, r2
dp3 o4.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o4.z, v2, r3
dp3 o4.x, v1, r3
mad o1.xy, v3, c30, c30.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = tmpvar_7;
  mediump vec3 tmpvar_14;
  mediump vec4 normal_15;
  normal_15 = tmpvar_13;
  mediump vec3 x3_16;
  highp float vC_17;
  mediump vec3 x2_18;
  mediump vec3 x1_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal_15);
  x1_19.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal_15);
  x1_19.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal_15);
  x1_19.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal_15.xyzz * normal_15.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2_18.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2_18.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2_18.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y));
  vC_17 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC_17);
  x3_16 = tmpvar_28;
  tmpvar_14 = ((x1_19 + x2_18) + x3_16);
  shlight_3 = tmpvar_14;
  tmpvar_5 = shlight_3;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosX0 - tmpvar_29.x);
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosY0 - tmpvar_29.y);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosZ0 - tmpvar_29.z);
  highp vec4 tmpvar_33;
  tmpvar_33 = (((tmpvar_30 * tmpvar_30) + (tmpvar_31 * tmpvar_31)) + (tmpvar_32 * tmpvar_32));
  highp vec4 tmpvar_34;
  tmpvar_34 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_30 * tmpvar_7.x) + (tmpvar_31 * tmpvar_7.y)) + (tmpvar_32 * tmpvar_7.z)) * inversesqrt(tmpvar_33))) * (1.0/((1.00000 + (tmpvar_33 * unity_4LightAtten0)))));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_34.x) + (unity_LightColor[1].xyz * tmpvar_34.y)) + (unity_LightColor[2].xyz * tmpvar_34.z)) + (unity_LightColor[3].xyz * tmpvar_34.w)));
  tmpvar_5 = tmpvar_35;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = (tmpvar_10 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  mediump float tmpvar_6;
  highp vec4 Tex2D1_7;
  highp vec4 Tex2DNormal0_8;
  highp vec4 Tex2D0_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_11;
  tmpvar_11 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_12;
  tmpvar_12 = cos(tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_14;
  tmpvar_14 = sin(tmpvar_11);
  highp vec4 tmpvar_15;
  tmpvar_15.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_10 * tmpvar_12) - (tmpvar_13 * tmpvar_14)))).x;
  tmpvar_15.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_10 * tmpvar_14) + (tmpvar_13 * tmpvar_12)))).x;
  tmpvar_15.z = 0.000000;
  tmpvar_15.w = 0.000000;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Diffuse, tmpvar_15.xy);
  Tex2D0_9 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_9.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_18;
  tmpvar_18.w = 1.00000;
  tmpvar_18.xyz = ((texture2D (_Normalmap, tmpvar_15.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_8 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Specular, tmpvar_15.xy);
  Tex2D1_7 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (mix (tmpvar_17, Tex2D0_9, tmpvar_17) * _MainColor).xyz;
  tmpvar_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = Tex2DNormal0_8.xyz;
  tmpvar_3 = tmpvar_21;
  tmpvar_5 = _Gloss;
  highp vec3 tmpvar_22;
  tmpvar_22 = ((Tex2D1_7 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_4 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = tmpvar_17.x;
  tmpvar_6 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(tmpvar_3);
  tmpvar_3 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_26;
  lightDir_26 = xlv_TEXCOORD1;
  mediump vec3 viewDir_27;
  viewDir_27 = tmpvar_25;
  mediump vec4 res_28;
  highp float nh_29;
  mediump float tmpvar_30;
  tmpvar_30 = max (0.000000, dot (tmpvar_24, normalize((lightDir_26 + viewDir_27))));
  nh_29 = tmpvar_30;
  mediump float arg1_31;
  arg1_31 = (tmpvar_5 * 128.000);
  res_28.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_26, tmpvar_24)));
  lowp float tmpvar_32;
  tmpvar_32 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_33;
  tmpvar_33 = (pow (nh_29, arg1_31) * tmpvar_32);
  res_28.w = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_28 * 2.00000);
  res_28 = tmpvar_34;
  mediump vec4 c_35;
  c_35.xyz = ((tmpvar_2 * tmpvar_34.xyz) + (tmpvar_34.xyz * (tmpvar_34.w * tmpvar_4)));
  c_35.w = tmpvar_6;
  c_1 = c_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  c_1.xyz = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = c_1.xyz;
  c_1.xyz = tmpvar_37;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = tmpvar_7;
  mediump vec3 tmpvar_14;
  mediump vec4 normal_15;
  normal_15 = tmpvar_13;
  mediump vec3 x3_16;
  highp float vC_17;
  mediump vec3 x2_18;
  mediump vec3 x1_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal_15);
  x1_19.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal_15);
  x1_19.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal_15);
  x1_19.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal_15.xyzz * normal_15.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2_18.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2_18.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2_18.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y));
  vC_17 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC_17);
  x3_16 = tmpvar_28;
  tmpvar_14 = ((x1_19 + x2_18) + x3_16);
  shlight_3 = tmpvar_14;
  tmpvar_5 = shlight_3;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosX0 - tmpvar_29.x);
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosY0 - tmpvar_29.y);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosZ0 - tmpvar_29.z);
  highp vec4 tmpvar_33;
  tmpvar_33 = (((tmpvar_30 * tmpvar_30) + (tmpvar_31 * tmpvar_31)) + (tmpvar_32 * tmpvar_32));
  highp vec4 tmpvar_34;
  tmpvar_34 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_30 * tmpvar_7.x) + (tmpvar_31 * tmpvar_7.y)) + (tmpvar_32 * tmpvar_7.z)) * inversesqrt(tmpvar_33))) * (1.0/((1.00000 + (tmpvar_33 * unity_4LightAtten0)))));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_34.x) + (unity_LightColor[1].xyz * tmpvar_34.y)) + (unity_LightColor[2].xyz * tmpvar_34.z)) + (unity_LightColor[3].xyz * tmpvar_34.w)));
  tmpvar_5 = tmpvar_35;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = (tmpvar_10 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - _glesVertex.xyz));
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  mediump float tmpvar_6;
  highp vec4 Tex2D1_7;
  highp vec4 Tex2DNormal0_8;
  highp vec4 Tex2D0_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_11;
  tmpvar_11 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_12;
  tmpvar_12 = cos(tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_14;
  tmpvar_14 = sin(tmpvar_11);
  highp vec4 tmpvar_15;
  tmpvar_15.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_10 * tmpvar_12) - (tmpvar_13 * tmpvar_14)))).x;
  tmpvar_15.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_10 * tmpvar_14) + (tmpvar_13 * tmpvar_12)))).x;
  tmpvar_15.z = 0.000000;
  tmpvar_15.w = 0.000000;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Diffuse, tmpvar_15.xy);
  Tex2D0_9 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_9.wwww) * vec4(_Alpha)));
  lowp vec3 normal_18;
  normal_18.xy = ((texture2D (_Normalmap, tmpvar_15.xy).wy * 2.00000) - 1.00000);
  normal_18.z = sqrt(((1.00000 - (normal_18.x * normal_18.x)) - (normal_18.y * normal_18.y)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = normal_18;
  Tex2DNormal0_8 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_15.xy);
  Tex2D1_7 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_17, Tex2D0_9, tmpvar_17) * _MainColor).xyz;
  tmpvar_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_8.xyz;
  tmpvar_3 = tmpvar_22;
  tmpvar_5 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_7 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_4 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_17.x;
  tmpvar_6 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_3);
  tmpvar_3 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_27;
  lightDir_27 = xlv_TEXCOORD1;
  mediump vec3 viewDir_28;
  viewDir_28 = tmpvar_26;
  mediump vec4 res_29;
  highp float nh_30;
  mediump float tmpvar_31;
  tmpvar_31 = max (0.000000, dot (tmpvar_25, normalize((lightDir_27 + viewDir_28))));
  nh_30 = tmpvar_31;
  mediump float arg1_32;
  arg1_32 = (tmpvar_5 * 128.000);
  res_29.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_27, tmpvar_25)));
  lowp float tmpvar_33;
  tmpvar_33 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_34;
  tmpvar_34 = (pow (nh_30, arg1_32) * tmpvar_33);
  res_29.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (res_29 * 2.00000);
  res_29 = tmpvar_35;
  mediump vec4 c_36;
  c_36.xyz = ((tmpvar_2 * tmpvar_35.xyz) + (tmpvar_35.xyz * (tmpvar_35.w * tmpvar_4)));
  c_36.w = tmpvar_6;
  c_1 = c_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  c_1.xyz = tmpvar_37;
  mediump vec3 tmpvar_38;
  tmpvar_38 = c_1.xyz;
  c_1.xyz = tmpvar_38;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_ProjectionParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 31 [unity_Scale]
Vector 32 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 79 ALU
PARAM c[33] = { { 1, 0, 0.5 },
		state.matrix.mvp,
		program.local[5..32] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R3.xyz, vertex.normal, c[31].w;
DP4 R0.x, vertex.position, c[6];
ADD R1, -R0.x, c[17];
DP3 R3.w, R3, c[6];
DP3 R4.x, R3, c[5];
DP3 R3.x, R3, c[7];
MUL R2, R3.w, R1;
DP4 R0.x, vertex.position, c[5];
ADD R0, -R0.x, c[16];
MUL R1, R1, R1;
MOV R4.z, R3.x;
MAD R2, R4.x, R0, R2;
MOV R4.w, c[0].x;
DP4 R4.y, vertex.position, c[7];
MAD R1, R0, R0, R1;
ADD R0, -R4.y, c[18];
MAD R1, R0, R0, R1;
MAD R0, R3.x, R0, R2;
MUL R2, R1, c[19];
MOV R4.y, R3.w;
RSQ R1.x, R1.x;
RSQ R1.y, R1.y;
RSQ R1.w, R1.w;
RSQ R1.z, R1.z;
MUL R0, R0, R1;
ADD R1, R2, c[0].x;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].y;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[21];
MAD R1.xyz, R0.x, c[20], R1;
MAD R0.xyz, R0.z, c[22], R1;
MAD R1.xyz, R0.w, c[23], R0;
MUL R0, R4.xyzz, R4.yzzx;
MUL R1.w, R3, R3;
DP4 R3.z, R0, c[29];
DP4 R3.y, R0, c[28];
DP4 R3.x, R0, c[27];
MAD R1.w, R4.x, R4.x, -R1;
MUL R0.xyz, R1.w, c[30];
MOV R1.w, c[0].x;
DP4 R0.w, vertex.position, c[4];
DP4 R2.z, R4, c[26];
DP4 R2.y, R4, c[25];
DP4 R2.x, R4, c[24];
ADD R2.xyz, R2, R3;
ADD R0.xyz, R2, R0;
ADD result.texcoord[2].xyz, R0, R1;
MOV R1.xyz, c[13];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[31].w, -vertex.position;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R1, c[15];
MUL R0.xyz, R0, vertex.attrib[14].w;
DP4 R3.z, R1, c[11];
DP4 R3.y, R1, c[10];
DP4 R3.x, R1, c[9];
DP3 result.texcoord[1].y, R3, R0;
DP3 result.texcoord[3].y, R0, R2;
DP4 R0.z, vertex.position, c[3];
DP4 R0.x, vertex.position, c[1];
DP4 R0.y, vertex.position, c[2];
MUL R1.xyz, R0.xyww, c[0].z;
MUL R1.y, R1, c[14].x;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[3].z, vertex.normal, R2;
DP3 result.texcoord[3].x, vertex.attrib[14], R2;
ADD result.texcoord[4].xy, R1, R1.z;
MOV result.position, R0;
MOV result.texcoord[4].zw, R0;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[32], c[32].zwzw;
END
# 79 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Vector 13 [_ProjectionParams]
Vector 14 [_ScreenParams]
Vector 15 [_WorldSpaceLightPos0]
Vector 16 [unity_4LightPosX0]
Vector 17 [unity_4LightPosY0]
Vector 18 [unity_4LightPosZ0]
Vector 19 [unity_4LightAtten0]
Vector 20 [unity_LightColor0]
Vector 21 [unity_LightColor1]
Vector 22 [unity_LightColor2]
Vector 23 [unity_LightColor3]
Vector 24 [unity_SHAr]
Vector 25 [unity_SHAg]
Vector 26 [unity_SHAb]
Vector 27 [unity_SHBr]
Vector 28 [unity_SHBg]
Vector 29 [unity_SHBb]
Vector 30 [unity_SHC]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 31 [unity_Scale]
Vector 32 [_Diffuse_ST]
"vs_3_0
; 82 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
def c33, 1.00000000, 0.00000000, 0.50000000, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mul r3.xyz, v2, c31.w
dp4 r0.x, v0, c5
add r1, -r0.x, c17
dp3 r3.w, r3, c5
dp3 r4.x, r3, c4
dp3 r3.x, r3, c6
mul r2, r3.w, r1
dp4 r0.x, v0, c4
add r0, -r0.x, c16
mul r1, r1, r1
mov r4.z, r3.x
mad r2, r4.x, r0, r2
mov r4.w, c33.x
dp4 r4.y, v0, c6
mad r1, r0, r0, r1
add r0, -r4.y, c18
mad r1, r0, r0, r1
mad r0, r3.x, r0, r2
mul r2, r1, c19
mov r4.y, r3.w
rsq r1.x, r1.x
rsq r1.y, r1.y
rsq r1.w, r1.w
rsq r1.z, r1.z
mul r0, r0, r1
add r1, r2, c33.x
dp4 r2.z, r4, c26
dp4 r2.y, r4, c25
dp4 r2.x, r4, c24
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c33.y
mul r0, r0, r1
mul r1.xyz, r0.y, c21
mad r1.xyz, r0.x, c20, r1
mad r0.xyz, r0.z, c22, r1
mad r1.xyz, r0.w, c23, r0
mul r0, r4.xyzz, r4.yzzx
mul r1.w, r3, r3
dp4 r3.z, r0, c29
dp4 r3.y, r0, c28
dp4 r3.x, r0, c27
mad r1.w, r4.x, r4.x, -r1
mul r0.xyz, r1.w, c30
add r2.xyz, r2, r3
add r0.xyz, r2, r0
add o3.xyz, r0, r1
mov r1.w, c33.x
mov r1.xyz, c12
dp4 r0.z, r1, c10
dp4 r0.y, r1, c9
dp4 r0.x, r1, c8
mad r3.xyz, r0, c31.w, -v0
mov r1.xyz, v1
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r1.yzxw
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c15, r0
mov r0, c8
dp4 r4.x, c15, r0
mov r1, c9
dp4 r4.y, c15, r1
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
dp4 r0.x, v0, c0
dp4 r0.y, v0, c1
mul r1.xyz, r0.xyww, c33.z
mul r1.y, r1, c13.x
dp3 o2.y, r4, r2
dp3 o4.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o4.z, v2, r3
dp3 o4.x, v1, r3
mad o5.xy, r1.z, c14.zwzw, r1
mov o0, r0
mov o5.zw, r0
mad o1.xy, v3, c32, c32.zwzw
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp mat4 unity_World2Shadow[4];
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_6 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_8;
  highp vec3 tmpvar_9;
  tmpvar_8 = tmpvar_1.xyz;
  tmpvar_9 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_10;
  tmpvar_10[0].x = tmpvar_8.x;
  tmpvar_10[0].y = tmpvar_9.x;
  tmpvar_10[0].z = tmpvar_2.x;
  tmpvar_10[1].x = tmpvar_8.y;
  tmpvar_10[1].y = tmpvar_9.y;
  tmpvar_10[1].z = tmpvar_2.y;
  tmpvar_10[2].x = tmpvar_8.z;
  tmpvar_10[2].y = tmpvar_9.z;
  tmpvar_10[2].z = tmpvar_2.z;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.00000;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = tmpvar_7;
  mediump vec3 tmpvar_14;
  mediump vec4 normal_15;
  normal_15 = tmpvar_13;
  mediump vec3 x3_16;
  highp float vC_17;
  mediump vec3 x2_18;
  mediump vec3 x1_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHAr, normal_15);
  x1_19.x = tmpvar_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAg, normal_15);
  x1_19.y = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAb, normal_15);
  x1_19.z = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23 = (normal_15.xyzz * normal_15.yzzx);
  highp float tmpvar_24;
  tmpvar_24 = dot (unity_SHBr, tmpvar_23);
  x2_18.x = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBg, tmpvar_23);
  x2_18.y = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBb, tmpvar_23);
  x2_18.z = tmpvar_26;
  mediump float tmpvar_27;
  tmpvar_27 = ((normal_15.x * normal_15.x) - (normal_15.y * normal_15.y));
  vC_17 = tmpvar_27;
  highp vec3 tmpvar_28;
  tmpvar_28 = (unity_SHC.xyz * vC_17);
  x3_16 = tmpvar_28;
  tmpvar_14 = ((x1_19 + x2_18) + x3_16);
  shlight_3 = tmpvar_14;
  tmpvar_5 = shlight_3;
  highp vec3 tmpvar_29;
  tmpvar_29 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_30;
  tmpvar_30 = (unity_4LightPosX0 - tmpvar_29.x);
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosY0 - tmpvar_29.y);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosZ0 - tmpvar_29.z);
  highp vec4 tmpvar_33;
  tmpvar_33 = (((tmpvar_30 * tmpvar_30) + (tmpvar_31 * tmpvar_31)) + (tmpvar_32 * tmpvar_32));
  highp vec4 tmpvar_34;
  tmpvar_34 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_30 * tmpvar_7.x) + (tmpvar_31 * tmpvar_7.y)) + (tmpvar_32 * tmpvar_7.z)) * inversesqrt(tmpvar_33))) * (1.0/((1.00000 + (tmpvar_33 * unity_4LightAtten0)))));
  highp vec3 tmpvar_35;
  tmpvar_35 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_34.x) + (unity_LightColor[1].xyz * tmpvar_34.y)) + (unity_LightColor[2].xyz * tmpvar_34.z)) + (unity_LightColor[3].xyz * tmpvar_34.w)));
  tmpvar_5 = tmpvar_35;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = (tmpvar_10 * (((_World2Object * tmpvar_12).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD4 = (unity_World2Shadow[0] * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform highp vec4 _LightShadowData;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  mediump float tmpvar_6;
  highp vec4 Tex2D1_7;
  highp vec4 Tex2DNormal0_8;
  highp vec4 Tex2D0_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_11;
  tmpvar_11 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_12;
  tmpvar_12 = cos(tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_14;
  tmpvar_14 = sin(tmpvar_11);
  highp vec4 tmpvar_15;
  tmpvar_15.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_10 * tmpvar_12) - (tmpvar_13 * tmpvar_14)))).x;
  tmpvar_15.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_10 * tmpvar_14) + (tmpvar_13 * tmpvar_12)))).x;
  tmpvar_15.z = 0.000000;
  tmpvar_15.w = 0.000000;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Diffuse, tmpvar_15.xy);
  Tex2D0_9 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_9.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_18;
  tmpvar_18.w = 1.00000;
  tmpvar_18.xyz = ((texture2D (_Normalmap, tmpvar_15.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_8 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Specular, tmpvar_15.xy);
  Tex2D1_7 = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (mix (tmpvar_17, Tex2D0_9, tmpvar_17) * _MainColor).xyz;
  tmpvar_2 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = Tex2DNormal0_8.xyz;
  tmpvar_3 = tmpvar_21;
  tmpvar_5 = _Gloss;
  highp vec3 tmpvar_22;
  tmpvar_22 = ((Tex2D1_7 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_4 = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = tmpvar_17.x;
  tmpvar_6 = tmpvar_23;
  mediump vec3 tmpvar_24;
  tmpvar_24 = normalize(tmpvar_3);
  tmpvar_3 = tmpvar_24;
  lowp float tmpvar_25;
  mediump float lightShadowDataX_26;
  highp float dist_27;
  lowp float tmpvar_28;
  tmpvar_28 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  dist_27 = tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = _LightShadowData.x;
  lightShadowDataX_26 = tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = max (float((dist_27 > (xlv_TEXCOORD4.z / xlv_TEXCOORD4.w))), lightShadowDataX_26);
  tmpvar_25 = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_32;
  lightDir_32 = xlv_TEXCOORD1;
  mediump vec3 viewDir_33;
  viewDir_33 = tmpvar_31;
  mediump float atten_34;
  atten_34 = tmpvar_25;
  mediump vec4 res_35;
  highp float nh_36;
  mediump float tmpvar_37;
  tmpvar_37 = max (0.000000, dot (tmpvar_24, normalize((lightDir_32 + viewDir_33))));
  nh_36 = tmpvar_37;
  mediump float arg1_38;
  arg1_38 = (tmpvar_5 * 128.000);
  res_35.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_32, tmpvar_24)));
  lowp float tmpvar_39;
  tmpvar_39 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_40;
  tmpvar_40 = (pow (nh_36, arg1_38) * tmpvar_39);
  res_35.w = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41 = (res_35 * (atten_34 * 2.00000));
  res_35 = tmpvar_41;
  mediump vec4 c_42;
  c_42.xyz = ((tmpvar_2 * tmpvar_41.xyz) + (tmpvar_41.xyz * (tmpvar_41.w * tmpvar_4)));
  c_42.w = tmpvar_6;
  c_1 = c_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  c_1.xyz = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = c_1.xyz;
  c_1.xyz = tmpvar_44;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 shlight_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (gl_ModelViewProjectionMatrix * _glesVertex);
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (tmpvar_2 * unity_Scale.w));
  highp vec3 tmpvar_9;
  highp vec3 tmpvar_10;
  tmpvar_9 = tmpvar_1.xyz;
  tmpvar_10 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_11;
  tmpvar_11[0].x = tmpvar_9.x;
  tmpvar_11[0].y = tmpvar_10.x;
  tmpvar_11[0].z = tmpvar_2.x;
  tmpvar_11[1].x = tmpvar_9.y;
  tmpvar_11[1].y = tmpvar_10.y;
  tmpvar_11[1].z = tmpvar_2.y;
  tmpvar_11[2].x = tmpvar_9.z;
  tmpvar_11[2].y = tmpvar_10.z;
  tmpvar_11[2].z = tmpvar_2.z;
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_11 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = tmpvar_8;
  mediump vec3 tmpvar_15;
  mediump vec4 normal_16;
  normal_16 = tmpvar_14;
  mediump vec3 x3_17;
  highp float vC_18;
  mediump vec3 x2_19;
  mediump vec3 x1_20;
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHAr, normal_16);
  x1_20.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHAg, normal_16);
  x1_20.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHAb, normal_16);
  x1_20.z = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24 = (normal_16.xyzz * normal_16.yzzx);
  highp float tmpvar_25;
  tmpvar_25 = dot (unity_SHBr, tmpvar_24);
  x2_19.x = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHBg, tmpvar_24);
  x2_19.y = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHBb, tmpvar_24);
  x2_19.z = tmpvar_27;
  mediump float tmpvar_28;
  tmpvar_28 = ((normal_16.x * normal_16.x) - (normal_16.y * normal_16.y));
  vC_18 = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (unity_SHC.xyz * vC_18);
  x3_17 = tmpvar_29;
  tmpvar_15 = ((x1_20 + x2_19) + x3_17);
  shlight_3 = tmpvar_15;
  tmpvar_5 = shlight_3;
  highp vec3 tmpvar_30;
  tmpvar_30 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_31;
  tmpvar_31 = (unity_4LightPosX0 - tmpvar_30.x);
  highp vec4 tmpvar_32;
  tmpvar_32 = (unity_4LightPosY0 - tmpvar_30.y);
  highp vec4 tmpvar_33;
  tmpvar_33 = (unity_4LightPosZ0 - tmpvar_30.z);
  highp vec4 tmpvar_34;
  tmpvar_34 = (((tmpvar_31 * tmpvar_31) + (tmpvar_32 * tmpvar_32)) + (tmpvar_33 * tmpvar_33));
  highp vec4 tmpvar_35;
  tmpvar_35 = (max (vec4(0.000000, 0.000000, 0.000000, 0.000000), ((((tmpvar_31 * tmpvar_8.x) + (tmpvar_32 * tmpvar_8.y)) + (tmpvar_33 * tmpvar_8.z)) * inversesqrt(tmpvar_34))) * (1.0/((1.00000 + (tmpvar_34 * unity_4LightAtten0)))));
  highp vec3 tmpvar_36;
  tmpvar_36 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_35.x) + (unity_LightColor[1].xyz * tmpvar_35.y)) + (unity_LightColor[2].xyz * tmpvar_35.z)) + (unity_LightColor[3].xyz * tmpvar_35.w)));
  tmpvar_5 = tmpvar_36;
  highp vec4 o_37;
  highp vec4 tmpvar_38;
  tmpvar_38 = (tmpvar_6 * 0.500000);
  highp vec2 tmpvar_39;
  tmpvar_39.x = tmpvar_38.x;
  tmpvar_39.y = (tmpvar_38.y * _ProjectionParams.x);
  o_37.xy = (tmpvar_39 + tmpvar_38.w);
  o_37.zw = tmpvar_6.zw;
  gl_Position = tmpvar_6;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_4;
  xlv_TEXCOORD2 = tmpvar_5;
  xlv_TEXCOORD3 = (tmpvar_11 * (((_World2Object * tmpvar_13).xyz * unity_Scale.w) - _glesVertex.xyz));
  xlv_TEXCOORD4 = o_37;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD4;
varying highp vec3 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform sampler2D _ShadowMapTexture;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  mediump float tmpvar_6;
  highp vec4 Tex2D1_7;
  highp vec4 Tex2DNormal0_8;
  highp vec4 Tex2D0_9;
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_11;
  tmpvar_11 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_12;
  tmpvar_12 = cos(tmpvar_11);
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_14;
  tmpvar_14 = sin(tmpvar_11);
  highp vec4 tmpvar_15;
  tmpvar_15.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_10 * tmpvar_12) - (tmpvar_13 * tmpvar_14)))).x;
  tmpvar_15.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_10 * tmpvar_14) + (tmpvar_13 * tmpvar_12)))).x;
  tmpvar_15.z = 0.000000;
  tmpvar_15.w = 0.000000;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_Diffuse, tmpvar_15.xy);
  Tex2D0_9 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_9.wwww) * vec4(_Alpha)));
  lowp vec3 normal_18;
  normal_18.xy = ((texture2D (_Normalmap, tmpvar_15.xy).wy * 2.00000) - 1.00000);
  normal_18.z = sqrt(((1.00000 - (normal_18.x * normal_18.x)) - (normal_18.y * normal_18.y)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = normal_18;
  Tex2DNormal0_8 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_15.xy);
  Tex2D1_7 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_17, Tex2D0_9, tmpvar_17) * _MainColor).xyz;
  tmpvar_2 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_8.xyz;
  tmpvar_3 = tmpvar_22;
  tmpvar_5 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_7 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_4 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_17.x;
  tmpvar_6 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_3);
  tmpvar_3 = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD4).x;
  highp vec3 tmpvar_27;
  tmpvar_27 = normalize(xlv_TEXCOORD3);
  mediump vec3 lightDir_28;
  lightDir_28 = xlv_TEXCOORD1;
  mediump vec3 viewDir_29;
  viewDir_29 = tmpvar_27;
  mediump float atten_30;
  atten_30 = tmpvar_26;
  mediump vec4 res_31;
  highp float nh_32;
  mediump float tmpvar_33;
  tmpvar_33 = max (0.000000, dot (tmpvar_25, normalize((lightDir_28 + viewDir_29))));
  nh_32 = tmpvar_33;
  mediump float arg1_34;
  arg1_34 = (tmpvar_5 * 128.000);
  res_31.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_28, tmpvar_25)));
  lowp float tmpvar_35;
  tmpvar_35 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_36;
  tmpvar_36 = (pow (nh_32, arg1_34) * tmpvar_35);
  res_31.w = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37 = (res_31 * (atten_30 * 2.00000));
  res_31 = tmpvar_37;
  mediump vec4 c_38;
  c_38.xyz = ((tmpvar_2 * tmpvar_37.xyz) + (tmpvar_37.xyz * (tmpvar_37.w * tmpvar_4)));
  c_38.w = tmpvar_6;
  c_1 = c_38;
  mediump vec3 tmpvar_39;
  tmpvar_39 = (c_1.xyz + (tmpvar_2 * xlv_TEXCOORD2));
  c_1.xyz = tmpvar_39;
  mediump vec3 tmpvar_40;
  tmpvar_40 = c_1.xyz;
  c_1.xyz = tmpvar_40;
  gl_FragData[0] = c_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 4
//   opengl - ALU: 29 to 62, TEX: 2 to 4
//   d3d9 - ALU: 38 to 72, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 60 ALU, 3 TEX
PARAM c[11] = { program.local[0..8],
		{ 3.1415927, 1, 2, 0 },
		{ 128, 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[8].z;
ADD R0.y, R0, -c[9].x;
COS R0.z, R0.y;
SIN R0.w, R0.y;
ADD R0.y, fragment.texcoord[0], -c[8];
MUL R1.x, R0.y, R0.w;
MUL R1.y, R0.z, R0;
ADD R0.y, fragment.texcoord[0].x, -c[8].x;
MAD R0.w, R0.y, R0, R1.y;
MAD R0.y, R0, R0.z, -R1.x;
ADD R0.z, -R0.w, c[8].y;
MAD R0.z, R0.x, -c[7].y, R0;
ADD R0.y, -R0, c[8].x;
MAD R0.x, R0, -c[7], R0.y;
ADD R3.y, R0.z, c[9];
ADD R3.x, R0, c[9].y;
TEX R0.yw, R3, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[9].z, -c[9].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[9].y;
RSQ R0.z, R0.z;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
RCP R0.z, R0.z;
RSQ R0.w, R0.w;
MOV R1.xyz, fragment.texcoord[1];
MAD R1.xyz, R0.w, fragment.texcoord[3], R1;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
DP3 R2.x, R1, R1;
RSQ R0.w, R2.x;
MUL R0.xyz, R1.w, R0;
MUL R2.xyz, R0.w, R1;
DP3 R0.w, R0, R2;
MOV R1, c[10];
DP3 R0.y, R0, fragment.texcoord[1];
TEX R2.xyz, R3, texture[2], 2D;
MUL R2.xyz, R2, c[4].x;
DP3 R0.x, R1.yzww, c[1];
MUL R1.x, R1, c[5];
MAX R0.w, R0, c[9];
POW R0.w, R0.w, R1.x;
MAX R0.y, R0, c[9].w;
MUL R1.w, R0, R0.x;
MUL R1.xyz, R0.y, c[1];
TEX R0, R3, texture[0], 2D;
ADD R0.w, -R0, c[9].y;
MUL R0.w, -R0, c[6].x;
ADD R0.w, R0, c[9].y;
ADD R0.xyz, -R0.w, R0;
MAD R0.xyz, R0.w, R0, R0.w;
MUL R1, R1, c[9].z;
MUL R2.xyz, R2, c[3];
MUL R2.xyz, R1.w, R2;
MUL R0.xyz, R0, c[2];
MUL R2.xyz, R1, R2;
MAD R1.xyz, R0, R1, R2;
MAD result.color.xyz, R0, fragment.texcoord[2], R1;
MOV result.color.w, R0;
END
# 60 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
"ps_3_0
; 71 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c10, 6.28318501, -3.14159298, 2.00000000, -1.00000000
def c11, 0.00000000, 128.00000000, 0, 0
def c12, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mov r0.x, c8.z
mul r0.x, c0, r0
add r0.x, r0, c9
mad r0.x, r0, c9.y, c9.z
frc r0.x, r0
mad r1.x, r0, c10, c10.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c8.y
dp3_pp r1.w, v3, v3
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c8.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c8.y
mov r0.x, c7.y
mad r0.z, c0.x, -r0.x, r0
add r2.y, r0.z, c9.w
add r0.y, -r0, c8.x
mov r0.x, c7
mad r0.x, c0, -r0, r0.y
add r2.x, r0, c9.w
texld r0.yw, r2, s1
mad_pp r0.xy, r0.wyzw, c10.z, c10.w
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
rsq_pp r1.w, r1.w
mov_pp r1.xyz, v1
mad_pp r1.xyz, r1.w, v3, r1
dp3_pp r1.w, r0, v1
dp3_pp r0.w, r1, r1
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r1
dp3_pp r0.x, r0, r1
mov_pp r0.w, c5.x
max_pp r2.z, r1.w, c11.x
mul_pp r1.y, c11, r0.w
max_pp r1.x, r0, c11
pow r0, r1.x, r1.y
mov_pp r1.xyz, c1
dp3_pp r0.y, c12, r1
mul r1.w, r0.x, r0.y
texld r0, r2, s0
mul_pp r1.xyz, r2.z, c1
add r0.w, -r0, c9
texld r2.xyz, r2, s2
mul r0.w, -r0, c6.x
add r0.w, r0, c9
mul r2.xyz, r2, c4.x
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
mul_pp r1, r1, c10.z
mul r2.xyz, r2, c3
mul_pp r2.xyz, r1.w, r2
mul r0.xyz, r0, c2
mul_pp r2.xyz, r1, r2
mad_pp r1.xyz, r0, r1, r2
mad_pp oC0.xyz, r0, v2, r1
mov_pp oC0.w, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Float 2 [_Alpha]
Vector 3 [_Pan]
Vector 4 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 29 ALU, 2 TEX
PARAM c[6] = { program.local[0..4],
		{ 3.1415927, 1, 8 } };
TEMP R0;
TEMP R1;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[4].z;
ADD R0.z, R0.y, -c[5].x;
COS R0.y, R0.z;
SIN R0.w, R0.z;
ADD R0.z, fragment.texcoord[0].y, -c[4].y;
MUL R1.x, R0.z, R0.w;
MUL R1.y, R0, R0.z;
ADD R0.z, fragment.texcoord[0].x, -c[4].x;
MAD R0.y, R0.z, R0, -R1.x;
MAD R0.w, R0.z, R0, R1.y;
ADD R0.z, -R0.w, c[4].y;
MAD R0.z, R0.x, -c[3].y, R0;
ADD R0.y, -R0, c[4].x;
MAD R0.x, R0, -c[3], R0.y;
ADD R0.y, R0.z, c[5];
ADD R0.x, R0, c[5].y;
TEX R0, R0, texture[0], 2D;
ADD R0.w, -R0, c[5].y;
MUL R0.w, -R0, c[2].x;
ADD R1.w, R0, c[5].y;
ADD R0.xyz, -R1.w, R0;
MAD R1.xyz, R1.w, R0, R1.w;
TEX R0, fragment.texcoord[1], texture[2], 2D;
MUL R1.xyz, R1, c[1];
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, R1;
MUL result.color.xyz, R0, c[5].z;
MOV result.color.w, R1;
END
# 29 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Float 2 [_Alpha]
Vector 3 [_Pan]
Vector 4 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [unity_Lightmap] 2D
"ps_3_0
; 38 ALU, 2 TEX
dcl_2d s0
dcl_2d s2
def c5, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c6, 6.28318501, -3.14159298, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
mov r0.x, c4.z
mul r0.x, c0, r0
add r0.x, r0, c5
mad r0.x, r0, c5.y, c5.z
frc r0.x, r0
mad r1.x, r0, c6, c6.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c4.y
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c4.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c4.y
mov r0.x, c3.y
mad r0.z, c0.x, -r0.x, r0
add r0.y, -r0, c4.x
mov r0.x, c3
mad r0.x, c0, -r0, r0.y
add r0.y, r0.z, c5.w
add r0.x, r0, c5.w
texld r0, r0, s0
add r0.w, -r0, c5
mul r0.w, -r0, c2.x
add r1.w, r0, c5
add r0.xyz, -r1.w, r0
mad r1.xyz, r1.w, r0, r1.w
texld r0, v1, s2
mul r1.xyz, r1, c1
mul_pp r0.xyz, r0.w, r0
mul_pp r0.xyz, r0, r1
mul_pp oC0.xyz, r0, c6.z
mov_pp oC0.w, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_ShadowMapTexture] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 62 ALU, 4 TEX
PARAM c[11] = { program.local[0..8],
		{ 3.1415927, 1, 2, 0 },
		{ 128, 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[8].z;
ADD R0.y, R0, -c[9].x;
COS R0.z, R0.y;
SIN R0.w, R0.y;
ADD R0.y, fragment.texcoord[0], -c[8];
MUL R1.x, R0.y, R0.w;
MUL R1.y, R0.z, R0;
ADD R0.y, fragment.texcoord[0].x, -c[8].x;
MAD R0.w, R0.y, R0, R1.y;
MAD R0.y, R0, R0.z, -R1.x;
ADD R0.z, -R0.w, c[8].y;
MAD R0.z, R0.x, -c[7].y, R0;
ADD R0.y, -R0, c[8].x;
MAD R0.x, R0, -c[7], R0.y;
ADD R3.y, R0.z, c[9];
ADD R3.x, R0, c[9].y;
TEX R0.yw, R3, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[9].z, -c[9].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[9].y;
RSQ R0.z, R0.z;
DP3 R0.w, fragment.texcoord[3], fragment.texcoord[3];
RCP R0.z, R0.z;
RSQ R0.w, R0.w;
MOV R1.xyz, fragment.texcoord[1];
MAD R1.xyz, R0.w, fragment.texcoord[3], R1;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
DP3 R2.x, R1, R1;
RSQ R0.w, R2.x;
MUL R0.xyz, R1.w, R0;
MUL R2.xyz, R0.w, R1;
DP3 R0.w, R0, R2;
DP3 R0.y, R0, fragment.texcoord[1];
MOV R1, c[10];
TEX R2.xyz, R3, texture[2], 2D;
MUL R2.xyz, R2, c[4].x;
DP3 R0.x, R1.yzww, c[1];
MUL R1.x, R1, c[5];
MAX R0.w, R0, c[9];
POW R0.w, R0.w, R1.x;
MUL R0.w, R0, R0.x;
MAX R0.y, R0, c[9].w;
MUL R0.xyz, R0.y, c[1];
TXP R1.x, fragment.texcoord[4], texture[3], 2D;
MUL R1, R1.x, R0;
TEX R0, R3, texture[0], 2D;
ADD R0.w, -R0, c[9].y;
MUL R0.w, -R0, c[6].x;
ADD R0.w, R0, c[9].y;
ADD R0.xyz, -R0.w, R0;
MAD R0.xyz, R0.w, R0, R0.w;
MUL R1, R1, c[9].z;
MUL R2.xyz, R2, c[3];
MUL R2.xyz, R1.w, R2;
MUL R0.xyz, R0, c[2];
MUL R2.xyz, R1, R2;
MAD R1.xyz, R0, R1, R2;
MAD result.color.xyz, R0, fragment.texcoord[2], R1;
MOV result.color.w, R0;
END
# 62 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_ShadowMapTexture] 2D
"ps_3_0
; 72 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c10, 6.28318501, -3.14159298, 2.00000000, -1.00000000
def c11, 0.00000000, 128.00000000, 0, 0
def c12, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dcl_texcoord4 v4
mov r0.x, c8.z
mul r0.x, c0, r0
add r0.x, r0, c9
mad r0.x, r0, c9.y, c9.z
frc r0.x, r0
mad r1.x, r0, c10, c10.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c8.y
dp3_pp r1.w, v3, v3
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c8.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c8.y
mov r0.x, c7.y
mad r0.z, c0.x, -r0.x, r0
add r2.y, r0.z, c9.w
add r0.y, -r0, c8.x
mov r0.x, c7
mad r0.x, c0, -r0, r0.y
add r2.x, r0, c9.w
texld r0.yw, r2, s1
mad_pp r0.xy, r0.wyzw, c10.z, c10.w
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
rsq_pp r1.w, r1.w
mov_pp r1.xyz, v1
mad_pp r1.xyz, r1.w, v3, r1
dp3_pp r1.w, r0, v1
dp3_pp r0.w, r1, r1
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r1
dp3_pp r0.x, r0, r1
mov_pp r0.w, c5.x
mul_pp r1.y, c11, r0.w
max_pp r1.x, r0, c11
pow r0, r1.x, r1.y
mov_pp r1.xyz, c1
dp3_pp r0.y, c12, r1
mul r0.w, r0.x, r0.y
max_pp r1.w, r1, c11.x
mul_pp r0.xyz, r1.w, c1
texldp r1.x, v4, s3
mul_pp r1, r1.x, r0
texld r0, r2, s0
add r0.w, -r0, c9
texld r2.xyz, r2, s2
mul r0.w, -r0, c6.x
add r0.w, r0, c9
mul r2.xyz, r2, c4.x
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
mul_pp r1, r1, c10.z
mul r2.xyz, r2, c3
mul_pp r2.xyz, r1.w, r2
mul r0.xyz, r0, c2
mul_pp r2.xyz, r1, r2
mad_pp r1.xyz, r0, r1, r2
mad_pp oC0.xyz, r0, v2, r1
mov_pp oC0.w, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Float 2 [_Alpha]
Vector 3 [_Pan]
Vector 4 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 3 TEX
PARAM c[6] = { program.local[0..4],
		{ 3.1415927, 1, 8, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[4].z;
ADD R0.y, R0, -c[5].x;
COS R0.z, R0.y;
SIN R0.w, R0.y;
ADD R0.y, fragment.texcoord[0], -c[4];
MUL R1.x, R0.y, R0.w;
MUL R1.y, R0.z, R0;
ADD R0.y, fragment.texcoord[0].x, -c[4].x;
MAD R0.w, R0.y, R0, R1.y;
MAD R0.y, R0, R0.z, -R1.x;
ADD R0.z, -R0.w, c[4].y;
MAD R0.z, R0.x, -c[3].y, R0;
ADD R0.y, -R0, c[4].x;
MAD R0.x, R0, -c[3], R0.y;
ADD R0.y, R0.z, c[5];
ADD R0.x, R0, c[5].y;
TEX R1, R0, texture[0], 2D;
ADD R0.x, -R1.w, c[5].y;
MUL R0.x, -R0, c[2];
ADD R1.w, R0.x, c[5].y;
ADD R1.xyz, -R1.w, R1;
MAD R1.xyz, R1.w, R1, R1.w;
TXP R2.x, fragment.texcoord[2], texture[2], 2D;
TEX R0, fragment.texcoord[1], texture[3], 2D;
MUL R2.yzw, R0.xxyz, R2.x;
MUL R0.xyz, R0.w, R0;
MUL R0.xyz, R0, c[5].z;
MUL R2.yzw, R2, c[5].w;
MIN R2.yzw, R0.xxyz, R2;
MUL R0.xyz, R0, R2.x;
MAX R0.xyz, R2.yzww, R0;
MUL R1.xyz, R1, c[1];
MUL result.color.xyz, R1, R0;
MOV result.color.w, R1;
END
# 35 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Float 2 [_Alpha]
Vector 3 [_Pan]
Vector 4 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [unity_Lightmap] 2D
"ps_3_0
; 43 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
def c5, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c6, 6.28318501, -3.14159298, 8.00000000, 2.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xy
dcl_texcoord2 v2
mov r0.x, c4.z
mul r0.x, c0, r0
add r0.x, r0, c5
mad r0.x, r0, c5.y, c5.z
frc r0.x, r0
mad r1.x, r0, c6, c6.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c4.y
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c4.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c4.y
mov r0.x, c3.y
mad r0.z, c0.x, -r0.x, r0
texld r2, v1, s3
mul_pp r1.xyz, r2.w, r2
texldp r3.x, v2, s2
mul_pp r2.xyz, r2, r3.x
mul_pp r1.xyz, r1, c6.z
add r0.y, -r0, c4.x
mov r0.x, c3
mad r0.x, c0, -r0, r0.y
mul_pp r3.xyz, r1, r3.x
mul_pp r2.xyz, r2, c6.w
min_pp r1.xyz, r1, r2
add r0.y, r0.z, c5.w
add r0.x, r0, c5.w
texld r0, r0, s0
add r0.w, -r0, c5
mul r0.w, -r0, c2.x
add r0.w, r0, c5
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
max_pp r1.xyz, r1, r3
mul r0.xyz, r0, c1
mul_pp oC0.xyz, r0, r1
mov_pp oC0.w, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 25 to 34
//   d3d9 - ALU: 28 to 37
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 19 [unity_Scale]
Matrix 13 [_LightMatrix0]
Vector 20 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 33 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[17];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 33 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 18 [unity_Scale]
Matrix 12 [_LightMatrix0]
Vector 19 [_Diffuse_ST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c20.x
mov r0.xyz, c16
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c18.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1, c8
dp4 r4.x, c17, r1
mad r0.xyz, r4, c18.w, -v0
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = ((texture2D (_Normalmap, tmpvar_16.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_9 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_22;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_18.x;
  tmpvar_7 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_LightTexture0, vec2(tmpvar_27));
  mediump vec3 lightDir_29;
  lightDir_29 = lightDir_2;
  mediump float atten_30;
  atten_30 = tmpvar_28.w;
  mediump vec4 res_31;
  highp float nh_32;
  mediump float tmpvar_33;
  tmpvar_33 = max (0.000000, dot (tmpvar_25, normalize((lightDir_29 + normalize(xlv_TEXCOORD2)))));
  nh_32 = tmpvar_33;
  mediump float arg1_34;
  arg1_34 = (tmpvar_6 * 128.000);
  res_31.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_29, tmpvar_25)));
  lowp float tmpvar_35;
  tmpvar_35 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_36;
  tmpvar_36 = (pow (nh_32, arg1_34) * tmpvar_35);
  res_31.w = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37 = (res_31 * (atten_30 * 2.00000));
  res_31 = tmpvar_37;
  mediump vec4 c_38;
  c_38.xyz = ((tmpvar_3 * tmpvar_37.xyz) + (tmpvar_37.xyz * (tmpvar_37.w * tmpvar_5)));
  c_38.w = tmpvar_7;
  c_1.xyz = c_38.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_Normalmap, tmpvar_16.xy).wy * 2.00000) - 1.00000);
  normal_19.z = sqrt(((1.00000 - (normal_19.x * normal_19.x)) - (normal_19.y * normal_19.y)));
  lowp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = normal_19;
  Tex2DNormal0_9 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_23;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_24;
  tmpvar_24 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_18.x;
  tmpvar_7 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_LightTexture0, vec2(tmpvar_28));
  mediump vec3 lightDir_30;
  lightDir_30 = lightDir_2;
  mediump float atten_31;
  atten_31 = tmpvar_29.w;
  mediump vec4 res_32;
  highp float nh_33;
  mediump float tmpvar_34;
  tmpvar_34 = max (0.000000, dot (tmpvar_26, normalize((lightDir_30 + normalize(xlv_TEXCOORD2)))));
  nh_33 = tmpvar_34;
  mediump float arg1_35;
  arg1_35 = (tmpvar_6 * 128.000);
  res_32.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_30, tmpvar_26)));
  lowp float tmpvar_36;
  tmpvar_36 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_37;
  tmpvar_37 = (pow (nh_33, arg1_35) * tmpvar_36);
  res_32.w = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38 = (res_32 * (atten_31 * 2.00000));
  res_32 = tmpvar_38;
  mediump vec4 c_39;
  c_39.xyz = ((tmpvar_3 * tmpvar_38.xyz) + (tmpvar_38.xyz * (tmpvar_38.w * tmpvar_5)));
  c_39.w = tmpvar_7;
  c_1.xyz = c_39.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Vector 10 [_WorldSpaceLightPos0]
Matrix 5 [_World2Object]
Vector 11 [unity_Scale]
Vector 12 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 25 ALU
PARAM c[13] = { { 1 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[9];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[7];
DP4 R2.y, R1, c[6];
DP4 R2.x, R1, c[5];
MAD R2.xyz, R2, c[11].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[10];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[7];
DP4 R3.y, R0, c[6];
DP4 R3.x, R0, c[5];
DP3 result.texcoord[1].y, R3, R1;
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[12], c[12].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 25 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Vector 9 [_WorldSpaceLightPos0]
Matrix 4 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_Diffuse_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c12, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c12.x
mov r0.xyz, c8
dp4 r1.z, r0, c6
dp4 r1.y, r0, c5
dp4 r1.x, r0, c4
mad r3.xyz, r1, c10.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c6
dp4 r4.z, c9, r0
mov r0, c5
mov r1, c4
dp4 r4.y, c9, r0
dp4 r4.x, c9, r1
dp3 o2.y, r4, r2
dp3 o3.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
mad o1.xy, v3, c11, c11.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = ((texture2D (_Normalmap, tmpvar_16.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_9 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_22;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_18.x;
  tmpvar_7 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_25;
  lightDir_2 = xlv_TEXCOORD1;
  mediump vec3 lightDir_26;
  lightDir_26 = lightDir_2;
  mediump vec4 res_27;
  highp float nh_28;
  mediump float tmpvar_29;
  tmpvar_29 = max (0.000000, dot (tmpvar_25, normalize((lightDir_26 + normalize(xlv_TEXCOORD2)))));
  nh_28 = tmpvar_29;
  mediump float arg1_30;
  arg1_30 = (tmpvar_6 * 128.000);
  res_27.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_26, tmpvar_25)));
  lowp float tmpvar_31;
  tmpvar_31 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_32;
  tmpvar_32 = (pow (nh_28, arg1_30) * tmpvar_31);
  res_27.w = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33 = (res_27 * 2.00000);
  res_27 = tmpvar_33;
  mediump vec4 c_34;
  c_34.xyz = ((tmpvar_3 * tmpvar_33.xyz) + (tmpvar_33.xyz * (tmpvar_33.w * tmpvar_5)));
  c_34.w = tmpvar_7;
  c_1.xyz = c_34.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_Normalmap, tmpvar_16.xy).wy * 2.00000) - 1.00000);
  normal_19.z = sqrt(((1.00000 - (normal_19.x * normal_19.x)) - (normal_19.y * normal_19.y)));
  lowp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = normal_19;
  Tex2DNormal0_9 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_23;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_24;
  tmpvar_24 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_18.x;
  tmpvar_7 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_26;
  lightDir_2 = xlv_TEXCOORD1;
  mediump vec3 lightDir_27;
  lightDir_27 = lightDir_2;
  mediump vec4 res_28;
  highp float nh_29;
  mediump float tmpvar_30;
  tmpvar_30 = max (0.000000, dot (tmpvar_26, normalize((lightDir_27 + normalize(xlv_TEXCOORD2)))));
  nh_29 = tmpvar_30;
  mediump float arg1_31;
  arg1_31 = (tmpvar_6 * 128.000);
  res_28.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_27, tmpvar_26)));
  lowp float tmpvar_32;
  tmpvar_32 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_33;
  tmpvar_33 = (pow (nh_29, arg1_31) * tmpvar_32);
  res_28.w = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34 = (res_28 * 2.00000);
  res_28 = tmpvar_34;
  mediump vec4 c_35;
  c_35.xyz = ((tmpvar_3 * tmpvar_34.xyz) + (tmpvar_34.xyz * (tmpvar_34.w * tmpvar_5)));
  c_35.w = tmpvar_7;
  c_1.xyz = c_35.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 19 [unity_Scale]
Matrix 13 [_LightMatrix0]
Vector 20 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 34 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[17];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].w, R0, c[16];
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 34 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 18 [unity_Scale]
Matrix 12 [_LightMatrix0]
Vector 19 [_Diffuse_ST]
"vs_3_0
; 37 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c20.x
mov r0.xyz, c16
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c18.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1, c8
dp4 r4.x, c17, r1
mad r0.xyz, r4, c18.w, -v0
dp4 r0.w, v0, c7
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
dp4 o4.w, r0, c15
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = ((texture2D (_Normalmap, tmpvar_16.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_9 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_22;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_18.x;
  tmpvar_7 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.500000);
  tmpvar_27 = texture2D (_LightTexture0, P_28);
  highp float tmpvar_29;
  tmpvar_29 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_LightTextureB0, vec2(tmpvar_29));
  mediump vec3 lightDir_31;
  lightDir_31 = lightDir_2;
  mediump float atten_32;
  atten_32 = ((float((xlv_TEXCOORD3.z > 0.000000)) * tmpvar_27.w) * tmpvar_30.w);
  mediump vec4 res_33;
  highp float nh_34;
  mediump float tmpvar_35;
  tmpvar_35 = max (0.000000, dot (tmpvar_25, normalize((lightDir_31 + normalize(xlv_TEXCOORD2)))));
  nh_34 = tmpvar_35;
  mediump float arg1_36;
  arg1_36 = (tmpvar_6 * 128.000);
  res_33.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_31, tmpvar_25)));
  lowp float tmpvar_37;
  tmpvar_37 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_38;
  tmpvar_38 = (pow (nh_34, arg1_36) * tmpvar_37);
  res_33.w = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39 = (res_33 * (atten_32 * 2.00000));
  res_33 = tmpvar_39;
  mediump vec4 c_40;
  c_40.xyz = ((tmpvar_3 * tmpvar_39.xyz) + (tmpvar_39.xyz * (tmpvar_39.w * tmpvar_5)));
  c_40.w = tmpvar_7;
  c_1.xyz = c_40.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_Normalmap, tmpvar_16.xy).wy * 2.00000) - 1.00000);
  normal_19.z = sqrt(((1.00000 - (normal_19.x * normal_19.x)) - (normal_19.y * normal_19.y)));
  lowp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = normal_19;
  Tex2DNormal0_9 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_23;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_24;
  tmpvar_24 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_18.x;
  tmpvar_7 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_27;
  lowp vec4 tmpvar_28;
  highp vec2 P_29;
  P_29 = ((xlv_TEXCOORD3.xy / xlv_TEXCOORD3.w) + 0.500000);
  tmpvar_28 = texture2D (_LightTexture0, P_29);
  highp float tmpvar_30;
  tmpvar_30 = dot (xlv_TEXCOORD3.xyz, xlv_TEXCOORD3.xyz);
  lowp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_LightTextureB0, vec2(tmpvar_30));
  mediump vec3 lightDir_32;
  lightDir_32 = lightDir_2;
  mediump float atten_33;
  atten_33 = ((float((xlv_TEXCOORD3.z > 0.000000)) * tmpvar_28.w) * tmpvar_31.w);
  mediump vec4 res_34;
  highp float nh_35;
  mediump float tmpvar_36;
  tmpvar_36 = max (0.000000, dot (tmpvar_26, normalize((lightDir_32 + normalize(xlv_TEXCOORD2)))));
  nh_35 = tmpvar_36;
  mediump float arg1_37;
  arg1_37 = (tmpvar_6 * 128.000);
  res_34.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_32, tmpvar_26)));
  lowp float tmpvar_38;
  tmpvar_38 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_39;
  tmpvar_39 = (pow (nh_35, arg1_37) * tmpvar_38);
  res_34.w = tmpvar_39;
  mediump vec4 tmpvar_40;
  tmpvar_40 = (res_34 * (atten_33 * 2.00000));
  res_34 = tmpvar_40;
  mediump vec4 c_41;
  c_41.xyz = ((tmpvar_3 * tmpvar_40.xyz) + (tmpvar_40.xyz * (tmpvar_40.w * tmpvar_5)));
  c_41.w = tmpvar_7;
  c_1.xyz = c_41.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 19 [unity_Scale]
Matrix 13 [_LightMatrix0]
Vector 20 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 33 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[17];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.x, R0, c[9];
DP4 R3.y, R0, c[10];
MAD R0.xyz, R3, c[19].w, -vertex.position;
DP3 result.texcoord[1].y, R0, R1;
DP3 result.texcoord[1].z, vertex.normal, R0;
DP3 result.texcoord[1].x, R0, vertex.attrib[14];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].z, R0, c[15];
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 33 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 18 [unity_Scale]
Matrix 12 [_LightMatrix0]
Vector 19 [_Diffuse_ST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c20.x
mov r0.xyz, c16
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c18.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1, c8
dp4 r4.x, c17, r1
mad r0.xyz, r4, c18.w, -v0
dp3 o2.y, r0, r2
dp3 o2.z, v2, r0
dp3 o2.x, r0, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o3.y, r2, r3
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
dp4 o4.z, r0, c14
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = ((texture2D (_Normalmap, tmpvar_16.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_9 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_22;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_18.x;
  tmpvar_7 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_LightTextureB0, vec2(tmpvar_27));
  lowp vec4 tmpvar_29;
  tmpvar_29 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_30;
  lightDir_30 = lightDir_2;
  mediump float atten_31;
  atten_31 = (tmpvar_28.w * tmpvar_29.w);
  mediump vec4 res_32;
  highp float nh_33;
  mediump float tmpvar_34;
  tmpvar_34 = max (0.000000, dot (tmpvar_25, normalize((lightDir_30 + normalize(xlv_TEXCOORD2)))));
  nh_33 = tmpvar_34;
  mediump float arg1_35;
  arg1_35 = (tmpvar_6 * 128.000);
  res_32.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_30, tmpvar_25)));
  lowp float tmpvar_36;
  tmpvar_36 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_37;
  tmpvar_37 = (pow (nh_33, arg1_35) * tmpvar_36);
  res_32.w = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38 = (res_32 * (atten_31 * 2.00000));
  res_32 = tmpvar_38;
  mediump vec4 c_39;
  c_39.xyz = ((tmpvar_3 * tmpvar_38.xyz) + (tmpvar_38.xyz * (tmpvar_38.w * tmpvar_5)));
  c_39.w = tmpvar_7;
  c_1.xyz = c_39.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (((_World2Object * _WorldSpaceLightPos0).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_Normalmap, tmpvar_16.xy).wy * 2.00000) - 1.00000);
  normal_19.z = sqrt(((1.00000 - (normal_19.x * normal_19.x)) - (normal_19.y * normal_19.y)));
  lowp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = normal_19;
  Tex2DNormal0_9 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_23;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_24;
  tmpvar_24 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_18.x;
  tmpvar_7 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(xlv_TEXCOORD1);
  lightDir_2 = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (xlv_TEXCOORD3, xlv_TEXCOORD3);
  lowp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_LightTextureB0, vec2(tmpvar_28));
  lowp vec4 tmpvar_30;
  tmpvar_30 = textureCube (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_31;
  lightDir_31 = lightDir_2;
  mediump float atten_32;
  atten_32 = (tmpvar_29.w * tmpvar_30.w);
  mediump vec4 res_33;
  highp float nh_34;
  mediump float tmpvar_35;
  tmpvar_35 = max (0.000000, dot (tmpvar_26, normalize((lightDir_31 + normalize(xlv_TEXCOORD2)))));
  nh_34 = tmpvar_35;
  mediump float arg1_36;
  arg1_36 = (tmpvar_6 * 128.000);
  res_33.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_31, tmpvar_26)));
  lowp float tmpvar_37;
  tmpvar_37 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_38;
  tmpvar_38 = (pow (nh_34, arg1_36) * tmpvar_37);
  res_33.w = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39 = (res_33 * (atten_32 * 2.00000));
  res_33 = tmpvar_39;
  mediump vec4 c_40;
  c_40.xyz = ((tmpvar_3 * tmpvar_39.xyz) + (tmpvar_39.xyz * (tmpvar_39.w * tmpvar_5)));
  c_40.w = tmpvar_7;
  c_1.xyz = c_40.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 19 [unity_Scale]
Matrix 13 [_LightMatrix0]
Vector 20 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 31 ALU
PARAM c[21] = { { 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R1.xyz, c[17];
MOV R1.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MAD R2.xyz, R2, c[19].w, -vertex.position;
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R1.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MOV R0, c[18];
MUL R1.xyz, R1, vertex.attrib[14].w;
DP4 R3.z, R0, c[11];
DP4 R3.y, R0, c[10];
DP4 R3.x, R0, c[9];
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP3 result.texcoord[1].y, R3, R1;
DP3 result.texcoord[2].y, R1, R2;
DP3 result.texcoord[1].z, vertex.normal, R3;
DP3 result.texcoord[1].x, R3, vertex.attrib[14];
DP3 result.texcoord[2].z, vertex.normal, R2;
DP3 result.texcoord[2].x, vertex.attrib[14], R2;
DP4 result.texcoord[3].y, R0, c[14];
DP4 result.texcoord[3].x, R0, c[13];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 31 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [_WorldSpaceCameraPos]
Vector 17 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 18 [unity_Scale]
Matrix 12 [_LightMatrix0]
Vector 19 [_Diffuse_ST]
"vs_3_0
; 34 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c20, 1.00000000, 0, 0, 0
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.w, c20.x
mov r0.xyz, c16
dp4 r1.z, r0, c10
dp4 r1.y, r0, c9
dp4 r1.x, r0, c8
mad r3.xyz, r1, c18.w, -v0
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r1.xyz, v2.yzxw, r0.zxyw, -r1
mul r2.xyz, r1, v1.w
mov r0, c10
dp4 r4.z, c17, r0
mov r0, c9
dp4 r4.y, c17, r0
mov r1, c8
dp4 r4.x, c17, r1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp3 o2.y, r4, r2
dp3 o3.y, r2, r3
dp3 o2.z, v2, r4
dp3 o2.x, r4, v1
dp3 o3.z, v2, r3
dp3 o3.x, v1, r3
dp4 o4.y, r0, c13
dp4 o4.x, r0, c12
mad o1.xy, v3, c19, c19.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = ((texture2D (_Normalmap, tmpvar_16.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_9 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_22;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_18.x;
  tmpvar_7 = tmpvar_24;
  mediump vec3 tmpvar_25;
  tmpvar_25 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_25;
  lightDir_2 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_27;
  lightDir_27 = lightDir_2;
  mediump float atten_28;
  atten_28 = tmpvar_26.w;
  mediump vec4 res_29;
  highp float nh_30;
  mediump float tmpvar_31;
  tmpvar_31 = max (0.000000, dot (tmpvar_25, normalize((lightDir_27 + normalize(xlv_TEXCOORD2)))));
  nh_30 = tmpvar_31;
  mediump float arg1_32;
  arg1_32 = (tmpvar_6 * 128.000);
  res_29.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_27, tmpvar_25)));
  lowp float tmpvar_33;
  tmpvar_33 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_34;
  tmpvar_34 = (pow (nh_30, arg1_32) * tmpvar_33);
  res_29.w = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35 = (res_29 * (atten_28 * 2.00000));
  res_29 = tmpvar_35;
  mediump vec4 c_36;
  c_36.xyz = ((tmpvar_3 * tmpvar_35.xyz) + (tmpvar_35.xyz * (tmpvar_35.w * tmpvar_5)));
  c_36.w = tmpvar_7;
  c_1.xyz = c_36.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  highp vec3 tmpvar_5;
  highp vec3 tmpvar_6;
  tmpvar_5 = tmpvar_1.xyz;
  tmpvar_6 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_7;
  tmpvar_7[0].x = tmpvar_5.x;
  tmpvar_7[0].y = tmpvar_6.x;
  tmpvar_7[0].z = tmpvar_2.x;
  tmpvar_7[1].x = tmpvar_5.y;
  tmpvar_7[1].y = tmpvar_6.y;
  tmpvar_7[1].z = tmpvar_2.y;
  tmpvar_7[2].x = tmpvar_5.z;
  tmpvar_7[2].y = tmpvar_6.z;
  tmpvar_7[2].z = tmpvar_2.z;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * (_World2Object * _WorldSpaceLightPos0).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.00000;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7 * (((_World2Object * tmpvar_9).xyz * unity_Scale.w) - _glesVertex.xyz));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform highp float _Gloss;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 c_1;
  lowp vec3 lightDir_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump float tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_Normalmap, tmpvar_16.xy).wy * 2.00000) - 1.00000);
  normal_19.z = sqrt(((1.00000 - (normal_19.x * normal_19.x)) - (normal_19.y * normal_19.y)));
  lowp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = normal_19;
  Tex2DNormal0_9 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_3 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = Tex2DNormal0_9.xyz;
  tmpvar_4 = tmpvar_23;
  tmpvar_6 = _Gloss;
  highp vec3 tmpvar_24;
  tmpvar_24 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_5 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_18.x;
  tmpvar_7 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_26;
  lightDir_2 = xlv_TEXCOORD1;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_LightTexture0, xlv_TEXCOORD3);
  mediump vec3 lightDir_28;
  lightDir_28 = lightDir_2;
  mediump float atten_29;
  atten_29 = tmpvar_27.w;
  mediump vec4 res_30;
  highp float nh_31;
  mediump float tmpvar_32;
  tmpvar_32 = max (0.000000, dot (tmpvar_26, normalize((lightDir_28 + normalize(xlv_TEXCOORD2)))));
  nh_31 = tmpvar_32;
  mediump float arg1_33;
  arg1_33 = (tmpvar_6 * 128.000);
  res_30.xyz = (_LightColor0.xyz * max (0.000000, dot (lightDir_28, tmpvar_26)));
  lowp float tmpvar_34;
  tmpvar_34 = dot (_LightColor0.xyz, vec3(0.220000, 0.707000, 0.0710000));
  highp float tmpvar_35;
  tmpvar_35 = (pow (nh_31, arg1_33) * tmpvar_34);
  res_30.w = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36 = (res_30 * (atten_29 * 2.00000));
  res_30 = tmpvar_36;
  mediump vec4 c_37;
  c_37.xyz = ((tmpvar_3 * tmpvar_36.xyz) + (tmpvar_36.xyz * (tmpvar_36.w * tmpvar_5)));
  c_37.w = tmpvar_7;
  c_1.xyz = c_37.xyz;
  c_1.w = 0.000000;
  gl_FragData[0] = c_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 59 to 72, TEX: 3 to 5
//   d3d9 - ALU: 70 to 79, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 64 ALU, 4 TEX
PARAM c[11] = { program.local[0..8],
		{ 0, 3.1415927, 1, 2 },
		{ 128, 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.y, c[0].x;
MUL R0.x, R0.y, c[8].z;
ADD R0.x, R0, -c[9].y;
COS R0.z, R0.x;
SIN R0.w, R0.x;
ADD R0.x, fragment.texcoord[0].y, -c[8].y;
MUL R1.x, R0, R0.w;
MUL R1.y, R0.z, R0.x;
ADD R0.x, fragment.texcoord[0], -c[8];
MAD R0.w, R0.x, R0, R1.y;
MAD R0.x, R0, R0.z, -R1;
ADD R0.z, -R0.w, c[8].y;
MAD R0.z, R0.y, -c[7].y, R0;
ADD R0.x, -R0, c[8];
MAD R0.x, R0.y, -c[7], R0;
ADD R4.y, R0.z, c[9].z;
ADD R4.x, R0, c[9].z;
TEX R0.yw, R4, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[9].w, -c[9].z;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R0.w;
ADD R0.z, R0, c[9];
RSQ R0.z, R0.z;
DP3 R0.w, fragment.texcoord[2], fragment.texcoord[2];
MUL R2.xyz, R1.x, fragment.texcoord[1];
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[2], R2;
RCP R0.z, R0.z;
DP3 R0.w, R0, R0;
DP3 R1.w, R1, R1;
RSQ R0.w, R0.w;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, R1;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R0, R3;
DP3 R0.x, R0, R2;
MOV R1, c[10];
MAX R0.y, R0.x, c[9].x;
TEX R2.xyz, R4, texture[2], 2D;
MUL R2.xyz, R2, c[4].x;
MUL R1.x, R1, c[5];
MAX R0.w, R0, c[9].x;
POW R0.w, R0.w, R1.x;
DP3 R1.x, R1.yzww, c[1];
MUL R1.w, R0, R1.x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
MUL R1.xyz, R0.y, c[1];
TEX R0.w, R0.x, texture[3], 2D;
MUL R1, R0.w, R1;
TEX R0, R4, texture[0], 2D;
ADD R0.w, -R0, c[9].z;
MUL R0.w, -R0, c[6].x;
ADD R0.w, R0, c[9].z;
ADD R0.xyz, -R0.w, R0;
MAD R0.xyz, R0.w, R0, R0.w;
MUL R1, R1, c[9].w;
MUL R2.xyz, R2, c[3];
MUL R2.xyz, R1.w, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R1, R2;
MOV result.color.w, c[9].x;
END
# 64 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 74 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c10, 6.28318501, -3.14159298, 2.00000000, -1.00000000
def c11, 0.00000000, 128.00000000, 0, 0
def c12, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mov r0.x, c8.z
mul r0.x, c0, r0
add r0.x, r0, c9
mad r0.x, r0, c9.y, c9.z
frc r0.x, r0
mad r1.x, r0, c10, c10.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c8.y
dp3_pp r1.w, v2, v2
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c8.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c8.y
mov r0.x, c7.y
mad r0.z, c0.x, -r0.x, r0
dp3_pp r1.x, v1, v1
rsq_pp r1.x, r1.x
add r3.y, r0.z, c9.w
mul_pp r1.xyz, r1.x, v1
rsq_pp r1.w, r1.w
mad_pp r2.xyz, r1.w, v2, r1
dp3_pp r1.w, r2, r2
add r0.y, -r0, c8.x
mov r0.x, c7
mad r0.x, c0, -r0, r0.y
add r3.x, r0, c9.w
texld r0.yw, r3, s1
mad_pp r0.xy, r0.wyzw, c10.z, c10.w
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp r2.w, r0, r1
rsq_pp r0.w, r1.w
mul_pp r1.xyz, r0.w, r2
dp3_pp r0.x, r0, r1
mov_pp r0.w, c5.x
texld r2.xyz, r3, s2
mul r2.xyz, r2, c4.x
mul_pp r1.y, c11, r0.w
max_pp r1.x, r0, c11
pow r0, r1.x, r1.y
mov_pp r1.xyz, c1
dp3_pp r0.y, c12, r1
mul r1.w, r0.x, r0.y
max_pp r0.y, r2.w, c11.x
dp3 r0.x, v3, v3
mul_pp r1.xyz, r0.y, c1
texld r0.x, r0.x, s3
mul_pp r1, r0.x, r1
texld r0, r3, s0
add r0.w, -r0, c9
mul r0.w, -r0, c6.x
add r0.w, r0, c9
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
mul_pp r1, r1, c10.z
mul r2.xyz, r2, c3
mul_pp r2.xyz, r1.w, r2
mul_pp r2.xyz, r1, r2
mul r0.xyz, r0, c2
mad_pp oC0.xyz, r0, r1, r2
mov_pp oC0.w, c11.x
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 59 ALU, 3 TEX
PARAM c[11] = { program.local[0..8],
		{ 0, 3.1415927, 1, 2 },
		{ 128, 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[8].z;
ADD R0.y, R0, -c[9];
COS R0.z, R0.y;
SIN R0.w, R0.y;
ADD R0.y, fragment.texcoord[0], -c[8];
MUL R1.x, R0.y, R0.w;
MUL R1.y, R0.z, R0;
ADD R0.y, fragment.texcoord[0].x, -c[8].x;
MAD R0.w, R0.y, R0, R1.y;
MAD R0.y, R0, R0.z, -R1.x;
ADD R0.z, -R0.w, c[8].y;
MAD R0.z, R0.x, -c[7].y, R0;
ADD R0.y, -R0, c[8].x;
MAD R0.x, R0, -c[7], R0.y;
ADD R3.y, R0.z, c[9].z;
ADD R3.x, R0, c[9].z;
TEX R0.yw, R3, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[9].w, -c[9].z;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[9];
RSQ R0.z, R0.z;
DP3 R0.w, fragment.texcoord[2], fragment.texcoord[2];
RCP R0.z, R0.z;
RSQ R0.w, R0.w;
MOV R1.xyz, fragment.texcoord[1];
MAD R1.xyz, R0.w, fragment.texcoord[2], R1;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
DP3 R2.x, R1, R1;
RSQ R0.w, R2.x;
MUL R0.xyz, R1.w, R0;
MUL R2.xyz, R0.w, R1;
DP3 R0.w, R0, R2;
MOV R1, c[10];
DP3 R0.y, R0, fragment.texcoord[1];
TEX R2.xyz, R3, texture[2], 2D;
MUL R2.xyz, R2, c[4].x;
DP3 R0.x, R1.yzww, c[1];
MUL R1.x, R1, c[5];
MAX R0.w, R0, c[9].x;
POW R0.w, R0.w, R1.x;
MAX R0.y, R0, c[9].x;
MUL R1.w, R0, R0.x;
MUL R1.xyz, R0.y, c[1];
TEX R0, R3, texture[0], 2D;
ADD R0.w, -R0, c[9].z;
MUL R0.w, -R0, c[6].x;
ADD R0.w, R0, c[9].z;
ADD R0.xyz, -R0.w, R0;
MAD R0.xyz, R0.w, R0, R0.w;
MUL R1, R1, c[9].w;
MUL R2.xyz, R2, c[3];
MUL R2.xyz, R1.w, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R1, R2;
MOV result.color.w, c[9].x;
END
# 59 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
"ps_3_0
; 70 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
def c9, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c10, 6.28318501, -3.14159298, 2.00000000, -1.00000000
def c11, 0.00000000, 128.00000000, 0, 0
def c12, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
mov r0.x, c8.z
mul r0.x, c0, r0
add r0.x, r0, c9
mad r0.x, r0, c9.y, c9.z
frc r0.x, r0
mad r1.x, r0, c10, c10.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c8.y
dp3_pp r1.w, v2, v2
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c8.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c8.y
mov r0.x, c7.y
mad r0.z, c0.x, -r0.x, r0
add r2.y, r0.z, c9.w
add r0.y, -r0, c8.x
mov r0.x, c7
mad r0.x, c0, -r0, r0.y
add r2.x, r0, c9.w
texld r0.yw, r2, s1
mad_pp r0.xy, r0.wyzw, c10.z, c10.w
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
rsq_pp r1.w, r1.w
mov_pp r1.xyz, v1
mad_pp r1.xyz, r1.w, v2, r1
dp3_pp r1.w, r0, v1
dp3_pp r0.w, r1, r1
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r1
dp3_pp r0.x, r0, r1
mov_pp r0.w, c5.x
max_pp r2.z, r1.w, c11.x
mul_pp r1.y, c11, r0.w
max_pp r1.x, r0, c11
pow r0, r1.x, r1.y
mov_pp r1.xyz, c1
dp3_pp r0.y, c12, r1
mul r1.w, r0.x, r0.y
texld r0, r2, s0
mul_pp r1.xyz, r2.z, c1
add r0.w, -r0, c9
texld r2.xyz, r2, s2
mul r0.w, -r0, c6.x
add r0.w, r0, c9
mul r2.xyz, r2, c4.x
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
mul_pp r1, r1, c10.z
mul r2.xyz, r2, c3
mul_pp r2.xyz, r1.w, r2
mul_pp r2.xyz, r1, r2
mul r0.xyz, r0, c2
mad_pp oC0.xyz, r0, r1, r2
mov_pp oC0.w, c11.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 72 ALU, 5 TEX
PARAM c[12] = { program.local[0..8],
		{ 0, 3.1415927, 1, 0.5 },
		{ 2, 128 },
		{ 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.y, c[0].x;
MUL R0.x, R0.y, c[8].z;
ADD R0.x, R0, -c[9].y;
DP3 R1.z, fragment.texcoord[2], fragment.texcoord[2];
SIN R1.x, R0.x;
COS R0.z, R0.x;
ADD R0.w, fragment.texcoord[0].y, -c[8].y;
MUL R1.y, R0.z, R0.w;
MUL R0.w, R0, R1.x;
ADD R0.x, fragment.texcoord[0], -c[8];
MAD R0.z, R0.x, R0, -R0.w;
MAD R0.w, R0.x, R1.x, R1.y;
ADD R0.x, -R0.z, c[8];
MAD R0.x, R0.y, -c[7], R0;
ADD R3.x, R0, c[9].z;
ADD R0.z, -R0.w, c[8].y;
MAD R0.y, R0, -c[7], R0.z;
ADD R3.y, R0, c[9].z;
TEX R0.yw, R3, texture[1], 2D;
MOV R0.x, c[9].z;
MAD R1.xy, R0.wyzw, c[10].x, -R0.x;
MUL R0.x, R1.y, R1.y;
MAD R0.x, -R1, R1, -R0;
ADD R0.x, R0, c[9].z;
RSQ R0.w, R0.x;
DP3 R0.y, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.y;
MUL R0.xyz, R0.x, fragment.texcoord[1];
RSQ R1.z, R1.z;
MAD R2.xyz, R1.z, fragment.texcoord[2], R0;
RCP R1.z, R0.w;
DP3 R1.w, R2, R2;
DP3 R0.w, R1, R1;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
DP3 R0.x, R1, R0;
DP3 R0.w, R1, R2;
MAX R0.y, R0.x, c[9].x;
MOV R1.w, c[10].y;
MUL R1.w, R1, c[5].x;
MAX R0.w, R0, c[9].x;
POW R0.w, R0.w, R1.w;
MOV R2.xyz, c[11];
DP3 R1.w, R2, c[1];
MUL R2.w, R0, R1;
DP3 R0.z, fragment.texcoord[3], fragment.texcoord[3];
MUL R2.xyz, R0.y, c[1];
RCP R0.x, fragment.texcoord[3].w;
MAD R0.xy, fragment.texcoord[3], R0.x, c[9].w;
TEX R0.w, R0, texture[3], 2D;
SLT R0.x, c[9], fragment.texcoord[3].z;
TEX R1.w, R0.z, texture[4], 2D;
MUL R0.x, R0, R0.w;
MUL R0.x, R0, R1.w;
MUL R1, R0.x, R2;
TEX R0, R3, texture[0], 2D;
ADD R0.w, -R0, c[9].z;
TEX R2.xyz, R3, texture[2], 2D;
MUL R0.w, -R0, c[6].x;
ADD R0.w, R0, c[9].z;
MUL R2.xyz, R2, c[4].x;
ADD R0.xyz, -R0.w, R0;
MAD R0.xyz, R0.w, R0, R0.w;
MUL R1, R1, c[10].x;
MUL R2.xyz, R2, c[3];
MUL R2.xyz, R1.w, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R1, R2;
MOV result.color.w, c[9].x;
END
# 72 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightTexture0] 2D
SetTexture 4 [_LightTextureB0] 2D
"ps_3_0
; 79 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_2d s4
def c9, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c10, 6.28318501, -3.14159298, 0.00000000, 1.00000000
def c11, 2.00000000, -1.00000000, 128.00000000, 0
def c12, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dp3_pp r1.z, v1, v1
rsq_pp r1.w, r1.z
mov r0.x, c8.z
mul r0.x, c0, r0
add r0.x, r0, c9
mad r0.x, r0, c9.y, c9.z
frc r0.x, r0
mad r1.x, r0, c10, c10.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c8.y
dp3_pp r1.z, v2, v2
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c8.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
mul_pp r2.xyz, r1.w, v1
rsq_pp r1.z, r1.z
mad_pp r3.xyz, r1.z, v2, r2
dp3_pp r1.z, r3, r3
add r0.z, -r1.x, c8.y
mov r0.x, c7.y
mad r0.z, c0.x, -r0.x, r0
add r1.y, r0.z, c9.w
add r0.y, -r0, c8.x
mov r0.x, c7
mad r0.x, c0, -r0, r0.y
add r1.x, r0, c9.w
texld r0.yw, r1, s1
mad_pp r0.xy, r0.wyzw, c11.x, c11.y
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
rsq_pp r0.w, r1.z
dp3_pp r1.z, r0, r2
mul_pp r2.xyz, r0.w, r3
dp3_pp r0.x, r0, r2
mov_pp r0.w, c5.x
mul_pp r2.x, c11.z, r0.w
max_pp r1.w, r0.x, c10.z
pow r0, r1.w, r2.x
mov_pp r2.xyz, c1
dp3_pp r0.y, c12, r2
mul r2.w, r0.x, r0.y
max_pp r0.y, r1.z, c10.z
rcp r0.x, v3.w
mad r3.xy, v3, r0.x, c9.z
mul_pp r2.xyz, r0.y, c1
dp3 r0.x, v3, v3
texld r0.w, r3, s3
cmp r0.y, -v3.z, c10.z, c10.w
mul_pp r0.y, r0, r0.w
texld r0.x, r0.x, s4
mul_pp r0.x, r0.y, r0
mul_pp r2, r0.x, r2
texld r0, r1, s0
add r0.w, -r0, c9
texld r1.xyz, r1, s2
mul r0.w, -r0, c6.x
add r0.w, r0, c9
mul r1.xyz, r1, c4.x
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
mul_pp r2, r2, c11.x
mul r1.xyz, r1, c3
mul_pp r1.xyz, r2.w, r1
mul_pp r1.xyz, r2, r1
mul r0.xyz, r0, c2
mad_pp oC0.xyz, r0, r2, r1
mov_pp oC0.w, c10.z
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 66 ALU, 5 TEX
PARAM c[11] = { program.local[0..8],
		{ 0, 3.1415927, 1, 2 },
		{ 128, 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.y, c[0].x;
MUL R0.x, R0.y, c[8].z;
ADD R0.x, R0, -c[9].y;
COS R0.z, R0.x;
SIN R0.w, R0.x;
ADD R0.x, fragment.texcoord[0].y, -c[8].y;
MUL R1.x, R0, R0.w;
MUL R1.y, R0.z, R0.x;
ADD R0.x, fragment.texcoord[0], -c[8];
MAD R0.w, R0.x, R0, R1.y;
MAD R0.x, R0, R0.z, -R1;
ADD R0.z, -R0.w, c[8].y;
MAD R0.z, R0.y, -c[7].y, R0;
ADD R0.x, -R0, c[8];
MAD R0.x, R0.y, -c[7], R0;
ADD R4.y, R0.z, c[9].z;
ADD R4.x, R0, c[9].z;
TEX R0.yw, R4, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[9].w, -c[9].z;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.x, R0.w;
ADD R0.z, R0, c[9];
RSQ R0.z, R0.z;
DP3 R0.w, fragment.texcoord[2], fragment.texcoord[2];
MUL R2.xyz, R1.x, fragment.texcoord[1];
RSQ R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[2], R2;
RCP R0.z, R0.z;
DP3 R0.w, R0, R0;
DP3 R1.w, R1, R1;
RSQ R0.w, R0.w;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, R1;
MUL R0.xyz, R0.w, R0;
DP3 R0.w, R0, R3;
DP3 R0.y, R0, R2;
MOV R1, c[10];
MAX R0.y, R0, c[9].x;
DP3 R0.x, R1.yzww, c[1];
MUL R2.xyz, R0.y, c[1];
MUL R1.x, R1, c[5];
MAX R0.w, R0, c[9].x;
POW R0.w, R0.w, R1.x;
MUL R2.w, R0, R0.x;
DP3 R0.x, fragment.texcoord[3], fragment.texcoord[3];
TEX R1.w, R0.x, texture[3], 2D;
TEX R0.w, fragment.texcoord[3], texture[4], CUBE;
MUL R0.x, R1.w, R0.w;
MUL R1, R0.x, R2;
TEX R0, R4, texture[0], 2D;
ADD R0.w, -R0, c[9].z;
TEX R2.xyz, R4, texture[2], 2D;
MUL R0.w, -R0, c[6].x;
ADD R0.w, R0, c[9].z;
MUL R2.xyz, R2, c[4].x;
ADD R0.xyz, -R0.w, R0;
MAD R0.xyz, R0.w, R0, R0.w;
MUL R1, R1, c[9].w;
MUL R2.xyz, R2, c[3];
MUL R2.xyz, R1.w, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R1, R2;
MOV result.color.w, c[9].x;
END
# 66 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightTextureB0] 2D
SetTexture 4 [_LightTexture0] CUBE
"ps_3_0
; 75 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c9, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c10, 6.28318501, -3.14159298, 2.00000000, -1.00000000
def c11, 0.00000000, 128.00000000, 0, 0
def c12, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
dp3_pp r1.z, v1, v1
rsq_pp r1.w, r1.z
mov r0.x, c8.z
mul r0.x, c0, r0
add r0.x, r0, c9
mad r0.x, r0, c9.y, c9.z
frc r0.x, r0
mad r1.x, r0, c10, c10.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c8.y
dp3_pp r1.z, v2, v2
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c8.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
mul_pp r2.xyz, r1.w, v1
rsq_pp r1.z, r1.z
mad_pp r3.xyz, r1.z, v2, r2
add r0.z, -r1.x, c8.y
mov r0.x, c7.y
mad r0.z, c0.x, -r0.x, r0
add r1.y, r0.z, c9.w
add r0.y, -r0, c8.x
mov r0.x, c7
mad r0.x, c0, -r0, r0.y
add r1.x, r0, c9.w
texld r0.yw, r1, s1
mad_pp r0.xy, r0.wyzw, c10.z, c10.w
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
dp3_pp r1.z, r0, r2
dp3_pp r0.w, r3, r3
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, r3
dp3_pp r0.x, r0, r2
mov_pp r0.w, c5.x
mul_pp r2.x, c11.y, r0.w
max_pp r1.w, r0.x, c11.x
pow r0, r1.w, r2.x
mov_pp r2.xyz, c1
dp3_pp r0.y, c12, r2
mul r2.w, r0.x, r0.y
max_pp r1.z, r1, c11.x
dp3 r0.x, v3, v3
mul_pp r2.xyz, r1.z, c1
texld r0.w, v3, s4
texld r0.x, r0.x, s3
mul r0.x, r0, r0.w
mul_pp r2, r0.x, r2
texld r0, r1, s0
add r0.w, -r0, c9
texld r1.xyz, r1, s2
mul r0.w, -r0, c6.x
add r0.w, r0, c9
mul r1.xyz, r1, c4.x
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
mul_pp r2, r2, c10.z
mul r1.xyz, r1, c3
mul_pp r1.xyz, r2.w, r1
mul_pp r1.xyz, r2, r1
mul r0.xyz, r0, c2
mad_pp oC0.xyz, r0, r2, r1
mov_pp oC0.w, c11.x
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightTexture0] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 61 ALU, 4 TEX
PARAM c[11] = { program.local[0..8],
		{ 0, 3.1415927, 1, 2 },
		{ 128, 0.2199707, 0.70703125, 0.070983887 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[8].z;
ADD R0.y, R0, -c[9];
COS R0.z, R0.y;
SIN R0.w, R0.y;
ADD R0.y, fragment.texcoord[0], -c[8];
MUL R1.x, R0.y, R0.w;
MUL R1.y, R0.z, R0;
ADD R0.y, fragment.texcoord[0].x, -c[8].x;
MAD R0.w, R0.y, R0, R1.y;
MAD R0.y, R0, R0.z, -R1.x;
ADD R0.z, -R0.w, c[8].y;
MAD R0.z, R0.x, -c[7].y, R0;
ADD R0.y, -R0, c[8].x;
MAD R0.x, R0, -c[7], R0.y;
ADD R3.y, R0.z, c[9].z;
ADD R3.x, R0, c[9].z;
TEX R0.yw, R3, texture[1], 2D;
MAD R0.xy, R0.wyzw, c[9].w, -c[9].z;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[9];
RSQ R0.z, R0.z;
DP3 R0.w, fragment.texcoord[2], fragment.texcoord[2];
RCP R0.z, R0.z;
RSQ R0.w, R0.w;
MOV R1.xyz, fragment.texcoord[1];
MAD R1.xyz, R0.w, fragment.texcoord[2], R1;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
DP3 R2.x, R1, R1;
RSQ R0.w, R2.x;
MUL R0.xyz, R1.w, R0;
MUL R2.xyz, R0.w, R1;
DP3 R0.w, R0, R2;
MOV R1, c[10];
DP3 R0.y, R0, fragment.texcoord[1];
DP3 R0.x, R1.yzww, c[1];
TEX R2.xyz, R3, texture[2], 2D;
MUL R2.xyz, R2, c[4].x;
MUL R1.x, R1, c[5];
MAX R0.w, R0, c[9].x;
POW R0.w, R0.w, R1.x;
MUL R0.w, R0, R0.x;
MAX R0.y, R0, c[9].x;
MUL R0.xyz, R0.y, c[1];
TEX R1.w, fragment.texcoord[3], texture[3], 2D;
MUL R1, R1.w, R0;
TEX R0, R3, texture[0], 2D;
ADD R0.w, -R0, c[9].z;
MUL R0.w, -R0, c[6].x;
ADD R0.w, R0, c[9].z;
ADD R0.xyz, -R0.w, R0;
MAD R0.xyz, R0.w, R0, R0.w;
MUL R1, R1, c[9].w;
MUL R2.xyz, R2, c[3];
MUL R2.xyz, R1.w, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R0, c[2];
MAD result.color.xyz, R0, R1, R2;
MOV result.color.w, c[9].x;
END
# 61 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_Time]
Vector 1 [_LightColor0]
Vector 2 [_MainColor]
Vector 3 [_SpecularColor]
Float 4 [_SpecularPower]
Float 5 [_Gloss]
Float 6 [_Alpha]
Vector 7 [_Pan]
Vector 8 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 1 [_Normalmap] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightTexture0] 2D
"ps_3_0
; 71 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
def c9, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c10, 6.28318501, -3.14159298, 2.00000000, -1.00000000
def c11, 0.00000000, 128.00000000, 0, 0
def c12, 0.21997070, 0.70703125, 0.07098389, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
mov r0.x, c8.z
mul r0.x, c0, r0
add r0.x, r0, c9
mad r0.x, r0, c9.y, c9.z
frc r0.x, r0
mad r1.x, r0, c10, c10.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c8.y
dp3_pp r1.w, v2, v2
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c8.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c8.y
mov r0.x, c7.y
mad r0.z, c0.x, -r0.x, r0
add r2.y, r0.z, c9.w
add r0.y, -r0, c8.x
mov r0.x, c7
mad r0.x, c0, -r0, r0.y
add r2.x, r0, c9.w
texld r0.yw, r2, s1
mad_pp r0.xy, r0.wyzw, c10.z, c10.w
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c9.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, r0
rsq_pp r1.w, r1.w
mov_pp r1.xyz, v1
mad_pp r1.xyz, r1.w, v2, r1
dp3_pp r1.w, r0, v1
dp3_pp r0.w, r1, r1
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r1
dp3_pp r0.x, r0, r1
mov_pp r0.w, c5.x
mul_pp r1.y, c11, r0.w
max_pp r1.x, r0, c11
pow r0, r1.x, r1.y
mov_pp r1.xyz, c1
dp3_pp r0.y, c12, r1
mul r0.w, r0.x, r0.y
max_pp r1.w, r1, c11.x
mul_pp r0.xyz, r1.w, c1
texld r1.w, v3, s3
mul_pp r1, r1.w, r0
texld r0, r2, s0
add r0.w, -r0, c9
texld r2.xyz, r2, s2
mul r0.w, -r0, c6.x
add r0.w, r0, c9
mul r2.xyz, r2, c4.x
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
mul_pp r1, r1, c10.z
mul r2.xyz, r2, c3
mul_pp r2.xyz, r1.w, r2
mul_pp r2.xyz, r1, r2
mul r0.xyz, r0, c2
mad_pp oC0.xyz, r0, r1, r2
mov_pp oC0.w, c11.x
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassBase" }
		Fog {Mode Off}
Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 21 to 21
//   d3d9 - ALU: 22 to 22
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" ATTR14
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Vector 9 [unity_Scale]
Vector 10 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 21 ALU
PARAM c[11] = { program.local[0],
		state.matrix.mvp,
		program.local[5..10] };
TEMP R0;
TEMP R1;
MOV R0.xyz, vertex.attrib[14];
MUL R1.xyz, vertex.normal.zxyw, R0.yzxw;
MAD R0.xyz, vertex.normal.yzxw, R0.zxyw, -R1;
MUL R1.xyz, R0, vertex.attrib[14].w;
DP3 R0.y, R1, c[5];
DP3 R0.x, vertex.attrib[14], c[5];
DP3 R0.z, vertex.normal, c[5];
MUL result.texcoord[1].xyz, R0, c[9].w;
DP3 R0.y, R1, c[6];
DP3 R0.x, vertex.attrib[14], c[6];
DP3 R0.z, vertex.normal, c[6];
MUL result.texcoord[2].xyz, R0, c[9].w;
DP3 R0.y, R1, c[7];
DP3 R0.x, vertex.attrib[14], c[7];
DP3 R0.z, vertex.normal, c[7];
MUL result.texcoord[3].xyz, R0, c[9].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[10], c[10].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 21 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "tangent" TexCoord2
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Vector 8 [unity_Scale]
Vector 9 [_Diffuse_ST]
"vs_3_0
; 22 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_position0 v0
dcl_tangent0 v1
dcl_normal0 v2
dcl_texcoord0 v3
mov r0.xyz, v1
mul r1.xyz, v2.zxyw, r0.yzxw
mov r0.xyz, v1
mad r0.xyz, v2.yzxw, r0.zxyw, -r1
mul r1.xyz, r0, v1.w
dp3 r0.y, r1, c4
dp3 r0.x, v1, c4
dp3 r0.z, v2, c4
mul o2.xyz, r0, c8.w
dp3 r0.y, r1, c5
dp3 r0.x, v1, c5
dp3 r0.z, v2, c5
mul o3.xyz, r0, c8.w
dp3 r0.y, r1, c6
dp3 r0.x, v1, c6
dp3 r0.z, v2, c6
mul o4.xyz, r0, c8.w
mad o1.xy, v3, c9, c9.zwzw
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_3 = tmpvar_1.xyz;
  tmpvar_4 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_3.x;
  tmpvar_5[0].y = tmpvar_4.x;
  tmpvar_5[0].z = tmpvar_2.x;
  tmpvar_5[1].x = tmpvar_3.y;
  tmpvar_5[1].y = tmpvar_4.y;
  tmpvar_5[1].z = tmpvar_2.y;
  tmpvar_5[2].x = tmpvar_3.z;
  tmpvar_5[2].y = tmpvar_4.z;
  tmpvar_5[2].z = tmpvar_2.z;
  vec3 v_6;
  v_6.x = _Object2World[0].x;
  v_6.y = _Object2World[1].x;
  v_6.z = _Object2World[2].x;
  vec3 v_7;
  v_7.x = _Object2World[0].y;
  v_7.y = _Object2World[1].y;
  v_7.z = _Object2World[2].y;
  vec3 v_8;
  v_8.x = _Object2World[0].z;
  v_8.y = _Object2World[1].z;
  v_8.z = _Object2World[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_5 * v_6) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_5 * v_7) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_5 * v_8) * unity_Scale.w);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp float _Gloss;
void main ()
{
  lowp vec4 res_1;
  lowp vec3 worldN_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  highp vec4 Tex2DNormal0_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_8;
  tmpvar_8 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_9;
  tmpvar_9 = cos(tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_11;
  tmpvar_11 = sin(tmpvar_8);
  highp vec4 tmpvar_12;
  tmpvar_12.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_7 * tmpvar_9) - (tmpvar_10 * tmpvar_11)))).x;
  tmpvar_12.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_7 * tmpvar_11) + (tmpvar_10 * tmpvar_9)))).x;
  tmpvar_12.z = 0.000000;
  tmpvar_12.w = 0.000000;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 1.00000;
  tmpvar_13.xyz = ((texture2D (_Normalmap, tmpvar_12.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_6 = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = Tex2DNormal0_6.xyz;
  tmpvar_4 = tmpvar_14;
  tmpvar_5 = _Gloss;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (xlv_TEXCOORD1, tmpvar_15);
  worldN_2.x = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD2, tmpvar_15);
  worldN_2.y = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD3, tmpvar_15);
  worldN_2.z = tmpvar_18;
  tmpvar_3 = worldN_2;
  mediump vec3 tmpvar_19;
  tmpvar_19 = ((tmpvar_3 * 0.500000) + 0.500000);
  res_1.xyz = tmpvar_19;
  res_1.w = tmpvar_5;
  gl_FragData[0] = res_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec4 tmpvar_1;
  tmpvar_1.xyz = normalize(_glesTANGENT.xyz);
  tmpvar_1.w = _glesTANGENT.w;
  vec3 tmpvar_2;
  tmpvar_2 = normalize(_glesNormal);
  highp vec3 tmpvar_3;
  highp vec3 tmpvar_4;
  tmpvar_3 = tmpvar_1.xyz;
  tmpvar_4 = (((tmpvar_2.yzx * tmpvar_1.zxy) - (tmpvar_2.zxy * tmpvar_1.yzx)) * _glesTANGENT.w);
  highp mat3 tmpvar_5;
  tmpvar_5[0].x = tmpvar_3.x;
  tmpvar_5[0].y = tmpvar_4.x;
  tmpvar_5[0].z = tmpvar_2.x;
  tmpvar_5[1].x = tmpvar_3.y;
  tmpvar_5[1].y = tmpvar_4.y;
  tmpvar_5[1].z = tmpvar_2.y;
  tmpvar_5[2].x = tmpvar_3.z;
  tmpvar_5[2].y = tmpvar_4.z;
  tmpvar_5[2].z = tmpvar_2.z;
  vec3 v_6;
  v_6.x = _Object2World[0].x;
  v_6.y = _Object2World[1].x;
  v_6.z = _Object2World[2].x;
  vec3 v_7;
  v_7.x = _Object2World[0].y;
  v_7.y = _Object2World[1].y;
  v_7.z = _Object2World[2].y;
  vec3 v_8;
  v_8.x = _Object2World[0].z;
  v_8.y = _Object2World[1].z;
  v_8.z = _Object2World[2].z;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = ((tmpvar_5 * v_6) * unity_Scale.w);
  xlv_TEXCOORD2 = ((tmpvar_5 * v_7) * unity_Scale.w);
  xlv_TEXCOORD3 = ((tmpvar_5 * v_8) * unity_Scale.w);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp float _Gloss;
void main ()
{
  lowp vec4 res_1;
  lowp vec3 worldN_2;
  mediump vec3 tmpvar_3;
  mediump vec3 tmpvar_4;
  mediump float tmpvar_5;
  highp vec4 Tex2DNormal0_6;
  highp vec4 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_8;
  tmpvar_8 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_9;
  tmpvar_9 = cos(tmpvar_8);
  highp vec4 tmpvar_10;
  tmpvar_10 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_11;
  tmpvar_11 = sin(tmpvar_8);
  highp vec4 tmpvar_12;
  tmpvar_12.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_7 * tmpvar_9) - (tmpvar_10 * tmpvar_11)))).x;
  tmpvar_12.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_7 * tmpvar_11) + (tmpvar_10 * tmpvar_9)))).x;
  tmpvar_12.z = 0.000000;
  tmpvar_12.w = 0.000000;
  lowp vec3 normal_13;
  normal_13.xy = ((texture2D (_Normalmap, tmpvar_12.xy).wy * 2.00000) - 1.00000);
  normal_13.z = sqrt(((1.00000 - (normal_13.x * normal_13.x)) - (normal_13.y * normal_13.y)));
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 1.00000;
  tmpvar_14.xyz = normal_13;
  Tex2DNormal0_6 = tmpvar_14;
  highp vec3 tmpvar_15;
  tmpvar_15 = Tex2DNormal0_6.xyz;
  tmpvar_4 = tmpvar_15;
  tmpvar_5 = _Gloss;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(tmpvar_4);
  tmpvar_4 = tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = dot (xlv_TEXCOORD1, tmpvar_16);
  worldN_2.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (xlv_TEXCOORD2, tmpvar_16);
  worldN_2.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (xlv_TEXCOORD3, tmpvar_16);
  worldN_2.z = tmpvar_19;
  tmpvar_3 = worldN_2;
  mediump vec3 tmpvar_20;
  tmpvar_20 = ((tmpvar_3 * 0.500000) + 0.500000);
  res_1.xyz = tmpvar_20;
  res_1.w = tmpvar_5;
  gl_FragData[0] = res_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 32 to 32, TEX: 1 to 1
//   d3d9 - ALU: 42 to 42, TEX: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_Time]
Float 1 [_Gloss]
Vector 2 [_Pan]
Vector 3 [_Rotation]
SetTexture 0 [_Normalmap] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 32 ALU, 1 TEX
PARAM c[5] = { program.local[0..3],
		{ 3.1415927, 1, 2, 0.5 } };
TEMP R0;
TEMP R1;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[3].z;
ADD R0.z, R0.y, -c[4].x;
COS R0.y, R0.z;
SIN R0.w, R0.z;
ADD R0.z, fragment.texcoord[0].y, -c[3].y;
MUL R1.x, R0.z, R0.w;
MUL R1.y, R0, R0.z;
ADD R0.z, fragment.texcoord[0].x, -c[3].x;
MAD R0.y, R0.z, R0, -R1.x;
MAD R0.w, R0.z, R0, R1.y;
ADD R0.z, -R0.w, c[3].y;
MAD R0.z, R0.x, -c[2].y, R0;
ADD R0.y, -R0, c[3].x;
MAD R0.x, R0, -c[2], R0.y;
ADD R0.y, R0.z, c[4];
ADD R0.x, R0, c[4].y;
TEX R0.yw, R0, texture[0], 2D;
MAD R0.xy, R0.wyzw, c[4].z, -c[4].y;
MUL R0.z, R0.y, R0.y;
MAD R0.z, -R0.x, R0.x, -R0;
ADD R0.z, R0, c[4].y;
RSQ R0.z, R0.z;
RCP R0.z, R0.z;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
DP3 R0.z, fragment.texcoord[3], R1;
DP3 R0.x, R1, fragment.texcoord[1];
DP3 R0.y, R1, fragment.texcoord[2];
MAD result.color.xyz, R0, c[4].w, c[4].w;
MOV result.color.w, c[1].x;
END
# 32 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Time]
Float 1 [_Gloss]
Vector 2 [_Pan]
Vector 3 [_Rotation]
SetTexture 0 [_Normalmap] 2D
"ps_3_0
; 42 ALU, 1 TEX
dcl_2d s0
def c4, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c5, 6.28318501, -3.14159298, 2.00000000, -1.00000000
dcl_texcoord0 v0.xy
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xyz
mov r0.x, c3.z
mul r0.x, c0, r0
add r0.x, r0, c4
mad r0.x, r0, c4.y, c4.z
frc r0.x, r0
mad r1.x, r0, c5, c5.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c3.y
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c3.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c3.y
mov r0.x, c2.y
mad r0.z, c0.x, -r0.x, r0
add r0.y, -r0, c3.x
mov r0.x, c2
mad r0.x, c0, -r0, r0.y
add r0.y, r0.z, c4.w
add r0.x, r0, c4.w
texld r0.yw, r0, s0
mad_pp r0.xy, r0.wyzw, c5.z, c5.w
mul_pp r0.z, r0.y, r0.y
mad_pp r0.z, -r0.x, r0.x, -r0
add_pp r0.z, r0, c4.w
rsq_pp r0.z, r0.z
rcp_pp r0.z, r0.z
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, r0
dp3 r0.z, v3, r1
dp3 r0.x, r1, v1
dp3 r0.y, r1, v2
mad_pp oC0.xyz, r0, c4.z, c4.z
mov_pp oC0.w, c1.x
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

}
	}
	Pass {
		Name "PREPASS"
		Tags { "LightMode" = "PrePassFinal" }
		ZWrite Off
Program "vp" {
// Vertex combos: 4
//   opengl - ALU: 20 to 28
//   d3d9 - ALU: 20 to 28
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 28 ALU
PARAM c[19] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[1].zw, R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_Diffuse_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c19.x
mul r0.y, r0, c8.x
add o3.xyz, r3, r2
mad o2.xy, r0.z, c9.zwzw, r0
mov o0, r1
mov o2.zw, r1
mad o1.xy, v2, c18, c18.zwzw
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.500000);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  mediump vec3 x3_10;
  highp float vC_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_11 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_11);
  x3_10 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_10);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightBuffer;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = ((texture2D (_Normalmap, tmpvar_16.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_9 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_4 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_9.xyz;
  tmpvar_5 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_6 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_18.x;
  tmpvar_7 = tmpvar_24;
  tmpvar_5 = normalize(tmpvar_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26 = -(log2(max (light_3, vec4(0.00100000, 0.00100000, 0.00100000, 0.00100000))));
  light_3.w = tmpvar_26.w;
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_26.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_27;
  mediump vec4 c_28;
  c_28.xyz = ((tmpvar_4 * light_3.xyz) + (light_3.xyz * (tmpvar_26.w * tmpvar_6)));
  c_28.w = tmpvar_7;
  c_2.w = c_28.w;
  c_2.xyz = c_28.xyz;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.500000);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  mediump vec3 x3_10;
  highp float vC_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_11 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_11);
  x3_10 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_10);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightBuffer;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_Normalmap, tmpvar_16.xy).wy * 2.00000) - 1.00000);
  normal_19.z = sqrt(((1.00000 - (normal_19.x * normal_19.x)) - (normal_19.y * normal_19.y)));
  lowp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = normal_19;
  Tex2DNormal0_9 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_4 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = Tex2DNormal0_9.xyz;
  tmpvar_5 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_6 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_18.x;
  tmpvar_7 = tmpvar_25;
  tmpvar_5 = normalize(tmpvar_5);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = -(log2(max (light_3, vec4(0.00100000, 0.00100000, 0.00100000, 0.00100000))));
  light_3.w = tmpvar_27.w;
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_27.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_28;
  mediump vec4 c_29;
  c_29.xyz = ((tmpvar_4 * light_3.xyz) + (light_3.xyz * (tmpvar_27.w * tmpvar_6)));
  c_29.w = tmpvar_7;
  c_2.w = c_29.w;
  c_2.xyz = c_29.xyz;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[17] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..16] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[1].zw, R0;
MUL result.texcoord[3].xyz, R1, c[14].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_Diffuse_ST]
"vs_3_0
; 20 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad o2.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o2.zw, r0
mul o4.xyz, r1, c14.w
mad o1.xy, v1, c16, c16.zwzw
mad o3.xy, v2, c15, c15.zwzw
mul o4.w, -r0.x, r0.y
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.500000);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.00000 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightBuffer;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump vec4 light_5;
  mediump vec3 tmpvar_6;
  mediump vec3 tmpvar_7;
  mediump vec3 tmpvar_8;
  mediump float tmpvar_9;
  highp vec4 Tex2D1_10;
  highp vec4 Tex2DNormal0_11;
  highp vec4 Tex2D0_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_14;
  tmpvar_14 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_15;
  tmpvar_15 = cos(tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_17;
  tmpvar_17 = sin(tmpvar_14);
  highp vec4 tmpvar_18;
  tmpvar_18.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_13 * tmpvar_15) - (tmpvar_16 * tmpvar_17)))).x;
  tmpvar_18.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_13 * tmpvar_17) + (tmpvar_16 * tmpvar_15)))).x;
  tmpvar_18.z = 0.000000;
  tmpvar_18.w = 0.000000;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Diffuse, tmpvar_18.xy);
  Tex2D0_12 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_12.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_21;
  tmpvar_21.w = 1.00000;
  tmpvar_21.xyz = ((texture2D (_Normalmap, tmpvar_18.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_11 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_Specular, tmpvar_18.xy);
  Tex2D1_10 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (mix (tmpvar_20, Tex2D0_12, tmpvar_20) * _MainColor).xyz;
  tmpvar_6 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = Tex2DNormal0_11.xyz;
  tmpvar_7 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = ((Tex2D1_10 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_8 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = tmpvar_20.x;
  tmpvar_9 = tmpvar_26;
  tmpvar_7 = normalize(tmpvar_7);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_5 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = -(log2(max (light_5, vec4(0.00100000, 0.00100000, 0.00100000, 0.00100000))));
  light_5.w = tmpvar_28.w;
  lowp vec3 tmpvar_29;
  tmpvar_29 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull_4 = tmpvar_29;
  lowp vec3 tmpvar_30;
  tmpvar_30 = (2.00000 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect_3 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.000000, 1.00000);
  light_5.xyz = (tmpvar_28.xyz + mix (lmIndirect_3, lmFull_4, vec3(tmpvar_31)));
  mediump vec4 c_32;
  c_32.xyz = ((tmpvar_6 * light_5.xyz) + (light_5.xyz * (tmpvar_28.w * tmpvar_8)));
  c_32.w = tmpvar_9;
  c_2.w = c_32.w;
  c_2.xyz = c_32.xyz;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.500000);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.00000 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightBuffer;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump vec4 light_5;
  mediump vec3 tmpvar_6;
  mediump vec3 tmpvar_7;
  mediump vec3 tmpvar_8;
  mediump float tmpvar_9;
  highp vec4 Tex2D1_10;
  highp vec4 Tex2DNormal0_11;
  highp vec4 Tex2D0_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_14;
  tmpvar_14 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_15;
  tmpvar_15 = cos(tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_17;
  tmpvar_17 = sin(tmpvar_14);
  highp vec4 tmpvar_18;
  tmpvar_18.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_13 * tmpvar_15) - (tmpvar_16 * tmpvar_17)))).x;
  tmpvar_18.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_13 * tmpvar_17) + (tmpvar_16 * tmpvar_15)))).x;
  tmpvar_18.z = 0.000000;
  tmpvar_18.w = 0.000000;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Diffuse, tmpvar_18.xy);
  Tex2D0_12 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_12.wwww) * vec4(_Alpha)));
  lowp vec3 normal_21;
  normal_21.xy = ((texture2D (_Normalmap, tmpvar_18.xy).wy * 2.00000) - 1.00000);
  normal_21.z = sqrt(((1.00000 - (normal_21.x * normal_21.x)) - (normal_21.y * normal_21.y)));
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = normal_21;
  Tex2DNormal0_11 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_Specular, tmpvar_18.xy);
  Tex2D1_10 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (mix (tmpvar_20, Tex2D0_12, tmpvar_20) * _MainColor).xyz;
  tmpvar_6 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = Tex2DNormal0_11.xyz;
  tmpvar_7 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = ((Tex2D1_10 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_8 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = tmpvar_20.x;
  tmpvar_9 = tmpvar_27;
  tmpvar_7 = normalize(tmpvar_7);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_5 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = -(log2(max (light_5, vec4(0.00100000, 0.00100000, 0.00100000, 0.00100000))));
  light_5.w = tmpvar_29.w;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec3 tmpvar_31;
  tmpvar_31 = ((8.00000 * tmpvar_30.w) * tmpvar_30.xyz);
  lmFull_4 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  lowp vec3 tmpvar_33;
  tmpvar_33 = ((8.00000 * tmpvar_32.w) * tmpvar_32.xyz);
  lmIndirect_3 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.000000, 1.00000);
  light_5.xyz = (tmpvar_29.xyz + mix (lmIndirect_3, lmFull_4, vec3(tmpvar_34)));
  mediump vec4 c_35;
  c_35.xyz = ((tmpvar_6 * light_5.xyz) + (light_5.xyz * (tmpvar_29.w * tmpvar_8)));
  c_35.w = tmpvar_9;
  c_2.w = c_35.w;
  c_2.xyz = c_35.xyz;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_ProjectionParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 5 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 28 ALU
PARAM c[19] = { { 0.5, 1 },
		state.matrix.mvp,
		program.local[5..18] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 R2.w, R1, c[6];
DP3 R0.x, R1, c[5];
DP3 R0.z, R1, c[7];
MOV R0.y, R2.w;
MUL R1, R0.xyzz, R0.yzzx;
MOV R0.w, c[0].y;
DP4 R2.z, R0, c[12];
DP4 R2.y, R0, c[11];
DP4 R2.x, R0, c[10];
MUL R0.y, R2.w, R2.w;
DP4 R3.z, R1, c[15];
DP4 R3.y, R1, c[14];
DP4 R3.x, R1, c[13];
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
MAD R0.x, R0, R0, -R0.y;
ADD R3.xyz, R2, R3;
MUL R2.xyz, R0.x, c[16];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
MUL R0.xyz, R1.xyww, c[0].x;
MUL R0.y, R0, c[9].x;
ADD result.texcoord[2].xyz, R3, R2;
ADD result.texcoord[1].xy, R0, R0.z;
MOV result.position, R1;
MOV result.texcoord[1].zw, R1;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[18], c[18].zwzw;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_ProjectionParams]
Vector 9 [_ScreenParams]
Vector 10 [unity_SHAr]
Vector 11 [unity_SHAg]
Vector 12 [unity_SHAb]
Vector 13 [unity_SHBr]
Vector 14 [unity_SHBg]
Vector 15 [unity_SHBb]
Vector 16 [unity_SHC]
Matrix 4 [_Object2World]
Vector 17 [unity_Scale]
Vector 18 [_Diffuse_ST]
"vs_3_0
; 28 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
def c19, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c17.w
dp3 r2.w, r1, c5
dp3 r0.x, r1, c4
dp3 r0.z, r1, c6
mov r0.y, r2.w
mul r1, r0.xyzz, r0.yzzx
mov r0.w, c19.y
dp4 r2.z, r0, c12
dp4 r2.y, r0, c11
dp4 r2.x, r0, c10
mul r0.y, r2.w, r2.w
dp4 r3.z, r1, c15
dp4 r3.y, r1, c14
dp4 r3.x, r1, c13
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
mad r0.x, r0, r0, -r0.y
add r3.xyz, r2, r3
mul r2.xyz, r0.x, c16
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
mul r0.xyz, r1.xyww, c19.x
mul r0.y, r0, c8.x
add o3.xyz, r3, r2
mad o2.xy, r0.z, c9.zwzw, r0
mov o0, r1
mov o2.zw, r1
mad o1.xy, v2, c18, c18.zwzw
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.500000);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  mediump vec3 x3_10;
  highp float vC_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_11 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_11);
  x3_10 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_10);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightBuffer;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_19;
  tmpvar_19.w = 1.00000;
  tmpvar_19.xyz = ((texture2D (_Normalmap, tmpvar_16.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_9 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_4 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = Tex2DNormal0_9.xyz;
  tmpvar_5 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_6 = tmpvar_23;
  highp float tmpvar_24;
  tmpvar_24 = tmpvar_18.x;
  tmpvar_7 = tmpvar_24;
  tmpvar_5 = normalize(tmpvar_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26 = max (light_3, vec4(0.00100000, 0.00100000, 0.00100000, 0.00100000));
  light_3.w = tmpvar_26.w;
  highp vec3 tmpvar_27;
  tmpvar_27 = (tmpvar_26.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_27;
  mediump vec4 c_28;
  c_28.xyz = ((tmpvar_4 * light_3.xyz) + (light_3.xyz * (tmpvar_26.w * tmpvar_6)));
  c_28.w = tmpvar_7;
  c_2.w = c_28.w;
  c_2.xyz = c_28.xyz;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.500000);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.00000;
  tmpvar_7.xyz = (tmpvar_6 * (normalize(_glesNormal) * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal_9;
  normal_9 = tmpvar_7;
  mediump vec3 x3_10;
  highp float vC_11;
  mediump vec3 x2_12;
  mediump vec3 x1_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal_9);
  x1_13.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal_9);
  x1_13.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal_9);
  x1_13.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal_9.xyzz * normal_9.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2_12.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2_12.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2_12.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal_9.x * normal_9.x) - (normal_9.y * normal_9.y));
  vC_11 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC_11);
  x3_10 = tmpvar_22;
  tmpvar_8 = ((x1_13 + x2_12) + x3_10);
  tmpvar_1 = tmpvar_8;
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightBuffer;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec4 light_3;
  mediump vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  mediump vec3 tmpvar_6;
  mediump float tmpvar_7;
  highp vec4 Tex2D1_8;
  highp vec4 Tex2DNormal0_9;
  highp vec4 Tex2D0_10;
  highp vec4 tmpvar_11;
  tmpvar_11 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_12;
  tmpvar_12 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_13;
  tmpvar_13 = cos(tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_15;
  tmpvar_15 = sin(tmpvar_12);
  highp vec4 tmpvar_16;
  tmpvar_16.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_11 * tmpvar_13) - (tmpvar_14 * tmpvar_15)))).x;
  tmpvar_16.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_11 * tmpvar_15) + (tmpvar_14 * tmpvar_13)))).x;
  tmpvar_16.z = 0.000000;
  tmpvar_16.w = 0.000000;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_Diffuse, tmpvar_16.xy);
  Tex2D0_10 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_10.wwww) * vec4(_Alpha)));
  lowp vec3 normal_19;
  normal_19.xy = ((texture2D (_Normalmap, tmpvar_16.xy).wy * 2.00000) - 1.00000);
  normal_19.z = sqrt(((1.00000 - (normal_19.x * normal_19.x)) - (normal_19.y * normal_19.y)));
  lowp vec4 tmpvar_20;
  tmpvar_20.w = 1.00000;
  tmpvar_20.xyz = normal_19;
  Tex2DNormal0_9 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_Specular, tmpvar_16.xy);
  Tex2D1_8 = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (mix (tmpvar_18, Tex2D0_10, tmpvar_18) * _MainColor).xyz;
  tmpvar_4 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = Tex2DNormal0_9.xyz;
  tmpvar_5 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = ((Tex2D1_8 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_6 = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = tmpvar_18.x;
  tmpvar_7 = tmpvar_25;
  tmpvar_5 = normalize(tmpvar_5);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_3 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27 = max (light_3, vec4(0.00100000, 0.00100000, 0.00100000, 0.00100000));
  light_3.w = tmpvar_27.w;
  highp vec3 tmpvar_28;
  tmpvar_28 = (tmpvar_27.xyz + xlv_TEXCOORD2);
  light_3.xyz = tmpvar_28;
  mediump vec4 c_29;
  c_29.xyz = ((tmpvar_4 * light_3.xyz) + (light_3.xyz * (tmpvar_27.w * tmpvar_6)));
  c_29.w = tmpvar_7;
  c_2.w = c_29.w;
  c_2.xyz = c_29.xyz;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [_ProjectionParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 9 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_Diffuse_ST]
"3.0-!!ARBvp1.0
# 20 ALU
PARAM c[17] = { { 0.5, 1 },
		state.matrix.modelview[0],
		state.matrix.mvp,
		program.local[9..16] };
TEMP R0;
TEMP R1;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MUL R1.xyz, R0.xyww, c[0].x;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[1].xy, R1, R1.z;
MOV result.position, R0;
MOV R0.x, c[0].y;
ADD R0.y, R0.x, -c[14].w;
DP4 R0.x, vertex.position, c[3];
DP4 R1.z, vertex.position, c[11];
DP4 R1.x, vertex.position, c[9];
DP4 R1.y, vertex.position, c[10];
ADD R1.xyz, R1, -c[14];
MOV result.texcoord[1].zw, R0;
MUL result.texcoord[3].xyz, R1, c[14].w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[2].xy, vertex.texcoord[1], c[15], c[15].zwzw;
MUL result.texcoord[3].w, -R0.x, R0.y;
END
# 20 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Bind "vertex" Vertex
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_modelview0]
Matrix 4 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [unity_ShadowFadeCenterAndType]
Matrix 8 [_Object2World]
Vector 15 [unity_LightmapST]
Vector 16 [_Diffuse_ST]
"vs_3_0
; 20 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
def c17, 0.50000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_texcoord0 v1
dcl_texcoord1 v2
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mul r1.xyz, r0.xyww, c17.x
mul r1.y, r1, c12.x
mad o2.xy, r1.z, c13.zwzw, r1
mov o0, r0
mov r0.x, c14.w
add r0.y, c17, -r0.x
dp4 r0.x, v0, c2
dp4 r1.z, v0, c10
dp4 r1.x, v0, c8
dp4 r1.y, v0, c9
add r1.xyz, r1, -c14
mov o2.zw, r0
mul o4.xyz, r1, c14.w
mad o1.xy, v1, c16, c16.zwzw
mad o3.xy, v2, c15, c15.zwzw
mul o4.w, -r0.x, r0.y
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.500000);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.00000 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightBuffer;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump vec4 light_5;
  mediump vec3 tmpvar_6;
  mediump vec3 tmpvar_7;
  mediump vec3 tmpvar_8;
  mediump float tmpvar_9;
  highp vec4 Tex2D1_10;
  highp vec4 Tex2DNormal0_11;
  highp vec4 Tex2D0_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_14;
  tmpvar_14 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_15;
  tmpvar_15 = cos(tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_17;
  tmpvar_17 = sin(tmpvar_14);
  highp vec4 tmpvar_18;
  tmpvar_18.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_13 * tmpvar_15) - (tmpvar_16 * tmpvar_17)))).x;
  tmpvar_18.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_13 * tmpvar_17) + (tmpvar_16 * tmpvar_15)))).x;
  tmpvar_18.z = 0.000000;
  tmpvar_18.w = 0.000000;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Diffuse, tmpvar_18.xy);
  Tex2D0_12 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_12.wwww) * vec4(_Alpha)));
  lowp vec4 tmpvar_21;
  tmpvar_21.w = 1.00000;
  tmpvar_21.xyz = ((texture2D (_Normalmap, tmpvar_18.xy).xyz * 2.00000) - 1.00000);
  Tex2DNormal0_11 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_Specular, tmpvar_18.xy);
  Tex2D1_10 = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (mix (tmpvar_20, Tex2D0_12, tmpvar_20) * _MainColor).xyz;
  tmpvar_6 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = Tex2DNormal0_11.xyz;
  tmpvar_7 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = ((Tex2D1_10 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_8 = tmpvar_25;
  highp float tmpvar_26;
  tmpvar_26 = tmpvar_20.x;
  tmpvar_9 = tmpvar_26;
  tmpvar_7 = normalize(tmpvar_7);
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_5 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28 = max (light_5, vec4(0.00100000, 0.00100000, 0.00100000, 0.00100000));
  light_5.w = tmpvar_28.w;
  lowp vec3 tmpvar_29;
  tmpvar_29 = (2.00000 * texture2D (unity_Lightmap, xlv_TEXCOORD2).xyz);
  lmFull_4 = tmpvar_29;
  lowp vec3 tmpvar_30;
  tmpvar_30 = (2.00000 * texture2D (unity_LightmapInd, xlv_TEXCOORD2).xyz);
  lmIndirect_3 = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = clamp (((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.000000, 1.00000);
  light_5.xyz = (tmpvar_28.xyz + mix (lmIndirect_3, lmFull_4, vec3(tmpvar_31)));
  mediump vec4 c_32;
  c_32.xyz = ((tmpvar_6 * light_5.xyz) + (light_5.xyz * (tmpvar_28.w * tmpvar_8)));
  c_32.w = tmpvar_9;
  c_2.w = c_32.w;
  c_2.xyz = c_32.xyz;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;
#define gl_ModelViewMatrix glstate_matrix_modelview0
uniform mat4 glstate_matrix_modelview0;

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp vec4 unity_LightmapST;


uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform highp vec4 _Diffuse_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_2 * 0.500000);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_2.zw;
  tmpvar_1.xyz = (((_Object2World * _glesVertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w);
  tmpvar_1.w = (-((gl_ModelViewMatrix * _glesVertex).z) * (1.00000 - unity_ShadowFadeCenterAndType.w));
  gl_Position = tmpvar_2;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _Diffuse_ST.xy) + _Diffuse_ST.zw);
  xlv_TEXCOORD1 = o_3;
  xlv_TEXCOORD2 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  xlv_TEXCOORD3 = tmpvar_1;
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD3;
varying highp vec2 xlv_TEXCOORD2;
varying highp vec4 xlv_TEXCOORD1;
varying highp vec2 xlv_TEXCOORD0;
uniform sampler2D unity_LightmapInd;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D unity_Lightmap;
uniform highp vec4 _Time;
uniform highp float _SpecularPower;
uniform highp vec4 _SpecularColor;
uniform sampler2D _Specular;
uniform highp vec4 _Rotation;
uniform highp vec4 _Pan;
uniform sampler2D _Normalmap;
uniform highp vec4 _MainColor;
uniform sampler2D _LightBuffer;
uniform sampler2D _Diffuse;
uniform highp float _Alpha;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 c_2;
  mediump vec3 lmIndirect_3;
  mediump vec3 lmFull_4;
  mediump vec4 light_5;
  mediump vec3 tmpvar_6;
  mediump vec3 tmpvar_7;
  mediump vec3 tmpvar_8;
  mediump float tmpvar_9;
  highp vec4 Tex2D1_10;
  highp vec4 Tex2DNormal0_11;
  highp vec4 Tex2D0_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = (xlv_TEXCOORD0.xxxx - _Rotation.xxxx);
  highp vec4 tmpvar_14;
  tmpvar_14 = ((_Rotation.zzzz * _Time) - vec4(3.14159, 3.14159, 3.14159, 3.14159));
  highp vec4 tmpvar_15;
  tmpvar_15 = cos(tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16 = (xlv_TEXCOORD0.yyyy - _Rotation.yyyy);
  highp vec4 tmpvar_17;
  tmpvar_17 = sin(tmpvar_14);
  highp vec4 tmpvar_18;
  tmpvar_18.x = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.xxxx * _Time)) + (_Rotation.xxxx - ((tmpvar_13 * tmpvar_15) - (tmpvar_16 * tmpvar_17)))).x;
  tmpvar_18.y = ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - (_Pan.yyyy * _Time)) + (_Rotation.yyyy - ((tmpvar_13 * tmpvar_17) + (tmpvar_16 * tmpvar_15)))).x;
  tmpvar_18.z = 0.000000;
  tmpvar_18.w = 0.000000;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_Diffuse, tmpvar_18.xy);
  Tex2D0_12 = tmpvar_19;
  highp vec4 tmpvar_20;
  tmpvar_20 = (vec4(1.00000, 1.00000, 1.00000, 1.00000) - ((vec4(1.00000, 1.00000, 1.00000, 1.00000) - Tex2D0_12.wwww) * vec4(_Alpha)));
  lowp vec3 normal_21;
  normal_21.xy = ((texture2D (_Normalmap, tmpvar_18.xy).wy * 2.00000) - 1.00000);
  normal_21.z = sqrt(((1.00000 - (normal_21.x * normal_21.x)) - (normal_21.y * normal_21.y)));
  lowp vec4 tmpvar_22;
  tmpvar_22.w = 1.00000;
  tmpvar_22.xyz = normal_21;
  Tex2DNormal0_11 = tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_Specular, tmpvar_18.xy);
  Tex2D1_10 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (mix (tmpvar_20, Tex2D0_12, tmpvar_20) * _MainColor).xyz;
  tmpvar_6 = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = Tex2DNormal0_11.xyz;
  tmpvar_7 = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = ((Tex2D1_10 * vec4(_SpecularPower)) * _SpecularColor).xyz;
  tmpvar_8 = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = tmpvar_20.x;
  tmpvar_9 = tmpvar_27;
  tmpvar_7 = normalize(tmpvar_7);
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2DProj (_LightBuffer, xlv_TEXCOORD1);
  light_5 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = max (light_5, vec4(0.00100000, 0.00100000, 0.00100000, 0.00100000));
  light_5.w = tmpvar_29.w;
  lowp vec4 tmpvar_30;
  tmpvar_30 = texture2D (unity_Lightmap, xlv_TEXCOORD2);
  lowp vec3 tmpvar_31;
  tmpvar_31 = ((8.00000 * tmpvar_30.w) * tmpvar_30.xyz);
  lmFull_4 = tmpvar_31;
  lowp vec4 tmpvar_32;
  tmpvar_32 = texture2D (unity_LightmapInd, xlv_TEXCOORD2);
  lowp vec3 tmpvar_33;
  tmpvar_33 = ((8.00000 * tmpvar_32.w) * tmpvar_32.xyz);
  lmIndirect_3 = tmpvar_33;
  highp float tmpvar_34;
  tmpvar_34 = clamp (((sqrt(dot (xlv_TEXCOORD3, xlv_TEXCOORD3)) * unity_LightmapFade.z) + unity_LightmapFade.w), 0.000000, 1.00000);
  light_5.xyz = (tmpvar_29.xyz + mix (lmIndirect_3, lmFull_4, vec3(tmpvar_34)));
  mediump vec4 c_35;
  c_35.xyz = ((tmpvar_6 * light_5.xyz) + (light_5.xyz * (tmpvar_29.w * tmpvar_8)));
  c_35.w = tmpvar_9;
  c_2.w = c_35.w;
  c_2.xyz = c_35.xyz;
  tmpvar_1 = c_2;
  gl_FragData[0] = tmpvar_1;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 4
//   opengl - ALU: 33 to 48, TEX: 3 to 5
//   d3d9 - ALU: 41 to 54, TEX: 3 to 5
SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Vector 2 [_SpecularColor]
Float 3 [_SpecularPower]
Float 4 [_Alpha]
Vector 5 [_Pan]
Vector 6 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightBuffer] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 37 ALU, 3 TEX
PARAM c[8] = { program.local[0..6],
		{ 3.1415927, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[6].z;
ADD R0.y, R0, -c[7].x;
COS R0.z, R0.y;
SIN R0.w, R0.y;
ADD R0.y, fragment.texcoord[0], -c[6];
MUL R1.x, R0.y, R0.w;
MUL R1.y, R0.z, R0;
ADD R0.y, fragment.texcoord[0].x, -c[6].x;
MAD R0.w, R0.y, R0, R1.y;
MAD R0.y, R0, R0.z, -R1.x;
ADD R0.z, -R0.w, c[6].y;
MAD R0.z, R0.x, -c[5].y, R0;
ADD R0.y, -R0, c[6].x;
MAD R0.x, R0, -c[5], R0.y;
ADD R0.y, R0.z, c[7];
ADD R0.x, R0, c[7].y;
TEX R1, R0, texture[0], 2D;
ADD R0.z, -R1.w, c[7].y;
MUL R0.z, -R0, c[4].x;
ADD R1.w, R0.z, c[7].y;
TEX R0.xyz, R0, texture[2], 2D;
MUL R2.xyz, R0, c[3].x;
TXP R0, fragment.texcoord[1], texture[3], 2D;
ADD R1.xyz, -R1.w, R1;
MAD R1.xyz, R1.w, R1, R1.w;
MUL R2.xyz, R2, c[2];
LG2 R0.w, R0.w;
MUL R2.xyz, -R0.w, R2;
LG2 R0.x, R0.x;
LG2 R0.z, R0.z;
LG2 R0.y, R0.y;
ADD R0.xyz, -R0, fragment.texcoord[2];
MUL R2.xyz, R0, R2;
MUL R1.xyz, R1, c[1];
MAD result.color.xyz, R1, R0, R2;
MOV result.color.w, R1;
END
# 37 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Vector 2 [_SpecularColor]
Float 3 [_SpecularPower]
Float 4 [_Alpha]
Vector 5 [_Pan]
Vector 6 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightBuffer] 2D
"ps_3_0
; 45 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
def c7, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c8, 6.28318501, -3.14159298, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
mov r0.x, c6.z
mul r0.x, c0, r0
add r0.x, r0, c7
mad r0.x, r0, c7.y, c7.z
frc r0.x, r0
mad r1.x, r0, c8, c8.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c6.y
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c6.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c6.y
mov r0.x, c5.y
mad r0.z, c0.x, -r0.x, r0
add r0.y, -r0, c6.x
mov r0.x, c5
mad r0.x, c0, -r0, r0.y
add r0.y, r0.z, c7.w
add r0.x, r0, c7.w
texld r1, r0, s0
add r0.z, -r1.w, c7.w
mul r0.z, -r0, c4.x
add r1.w, r0.z, c7
texld r0.xyz, r0, s2
mul r2.xyz, r0, c3.x
texldp r0, v1, s3
add r1.xyz, -r1.w, r1
mad r1.xyz, r1.w, r1, r1.w
mul r2.xyz, r2, c2
log_pp r0.w, r0.w
mul_pp r2.xyz, -r0.w, r2
log_pp r0.x, r0.x
log_pp r0.z, r0.z
log_pp r0.y, r0.y
add_pp r0.xyz, -r0, v2
mul_pp r2.xyz, r0, r2
mul r1.xyz, r1, c1
mad_pp oC0.xyz, r1, r0, r2
mov_pp oC0.w, r1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Vector 2 [_SpecularColor]
Float 3 [_SpecularPower]
Float 4 [_Alpha]
Vector 5 [_Pan]
Vector 6 [_Rotation]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 5 TEX
PARAM c[9] = { program.local[0..7],
		{ 3.1415927, 1, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[2], texture[5], 2D;
MUL R1.xyz, R0.w, R0;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
MUL R1.xyz, R1, c[8].z;
DP4 R1.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.x, R1.w;
MOV R0.w, c[0].x;
MUL R1.w, R0, c[6].z;
RCP R2.x, R2.x;
MAD R0.xyz, R0, c[8].z, -R1;
MAD_SAT R2.x, R2, c[7].z, c[7].w;
MAD R2.xyz, R2.x, R0, R1;
ADD R1.w, R1, -c[8].x;
COS R0.y, R1.w;
ADD R0.x, fragment.texcoord[0].y, -c[6].y;
SIN R0.z, R1.w;
MUL R1.x, R0, R0.z;
MUL R1.y, R0, R0.x;
ADD R0.x, fragment.texcoord[0], -c[6];
MAD R0.z, R0.x, R0, R1.y;
MAD R0.x, R0, R0.y, -R1;
TXP R1, fragment.texcoord[1], texture[3], 2D;
ADD R0.y, -R0.z, c[6];
MAD R0.y, R0.w, -c[5], R0;
ADD R0.x, -R0, c[6];
MAD R0.x, R0.w, -c[5], R0;
ADD R3.y, R0, c[8];
ADD R3.x, R0, c[8].y;
TEX R0, R3, texture[0], 2D;
ADD R0.w, -R0, c[8].y;
MUL R0.w, -R0, c[4].x;
ADD R0.w, R0, c[8].y;
ADD R0.xyz, -R0.w, R0;
MAD R0.xyz, R0.w, R0, R0.w;
LG2 R1.x, R1.x;
LG2 R1.y, R1.y;
LG2 R1.z, R1.z;
ADD R1.xyz, -R1, R2;
TEX R2.xyz, R3, texture[2], 2D;
MUL R2.xyz, R2, c[3].x;
MUL R2.xyz, R2, c[2];
LG2 R1.w, R1.w;
MUL R2.xyz, -R1.w, R2;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R0, c[1];
MAD result.color.xyz, R0, R1, R2;
MOV result.color.w, R0;
END
# 48 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Vector 2 [_SpecularColor]
Float 3 [_SpecularPower]
Float 4 [_Alpha]
Vector 5 [_Pan]
Vector 6 [_Rotation]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"ps_3_0
; 54 ALU, 5 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c8, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c9, 6.28318501, -3.14159298, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3
texld r0, v2, s4
mul_pp r0.xyz, r0.w, r0
texld r1, v2, s5
mul_pp r1.xyz, r1.w, r1
mul_pp r1.xyz, r1, c9.z
mad_pp r2.xyz, r0, c9.z, -r1
mov r0.w, c6.z
mul r0.w, c0.x, r0
add r0.w, r0, c8.x
mad r0.x, r0.w, c8.y, c8.z
frc r0.x, r0
dp4 r0.y, v3, v3
rsq r0.y, r0.y
mad r1.w, r0.x, c9.x, c9.y
rcp r2.w, r0.y
sincos r0.xy, r1.w
mad_sat r0.z, r2.w, c7, c7.w
mad_pp r2.xyz, r0.z, r2, r1
add r0.z, v0.y, -c6.y
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c6.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c6.y
texldp r1, v1, s3
mov r0.x, c5.y
mad r0.z, c0.x, -r0.x, r0
add r3.y, r0.z, c8.w
add r0.y, -r0, c6.x
mov r0.x, c5
mad r0.x, c0, -r0, r0.y
add r3.x, r0, c8.w
texld r0, r3, s0
add r0.w, -r0, c8
mul r0.w, -r0, c4.x
add r0.w, r0, c8
add r0.xyz, -r0.w, r0
mad r0.xyz, r0.w, r0, r0.w
log_pp r1.x, r1.x
log_pp r1.y, r1.y
log_pp r1.z, r1.z
add_pp r1.xyz, -r1, r2
texld r2.xyz, r3, s2
mul r2.xyz, r2, c3.x
mul r2.xyz, r2, c2
log_pp r1.w, r1.w
mul_pp r2.xyz, -r1.w, r2
mul_pp r2.xyz, r1, r2
mul r0.xyz, r0, c1
mad_pp oC0.xyz, r0, r1, r2
mov_pp oC0.w, r0
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Vector 2 [_SpecularColor]
Float 3 [_SpecularPower]
Float 4 [_Alpha]
Vector 5 [_Pan]
Vector 6 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightBuffer] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 33 ALU, 3 TEX
PARAM c[8] = { program.local[0..6],
		{ 3.1415927, 1 } };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R0.x, c[0];
MUL R0.y, R0.x, c[6].z;
ADD R0.y, R0, -c[7].x;
COS R0.z, R0.y;
SIN R0.w, R0.y;
ADD R0.y, fragment.texcoord[0], -c[6];
MUL R1.x, R0.y, R0.w;
MUL R1.y, R0.z, R0;
ADD R0.y, fragment.texcoord[0].x, -c[6].x;
MAD R0.w, R0.y, R0, R1.y;
MAD R0.y, R0, R0.z, -R1.x;
ADD R0.z, -R0.w, c[6].y;
MAD R0.z, R0.x, -c[5].y, R0;
ADD R0.y, -R0, c[6].x;
MAD R0.x, R0, -c[5], R0.y;
ADD R0.y, R0.z, c[7];
ADD R0.x, R0, c[7].y;
TEX R1, R0, texture[0], 2D;
ADD R0.z, -R1.w, c[7].y;
MUL R0.z, -R0, c[4].x;
ADD R1.w, R0.z, c[7].y;
TEX R0.xyz, R0, texture[2], 2D;
MUL R0.xyz, R0, c[3].x;
MUL R2.xyz, R0, c[2];
TXP R0, fragment.texcoord[1], texture[3], 2D;
ADD R1.xyz, -R1.w, R1;
MAD R1.xyz, R1.w, R1, R1.w;
ADD R0.xyz, R0, fragment.texcoord[2];
MUL R2.xyz, R0.w, R2;
MUL R2.xyz, R0, R2;
MUL R1.xyz, R1, c[1];
MAD result.color.xyz, R1, R0, R2;
MOV result.color.w, R1;
END
# 33 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Vector 2 [_SpecularColor]
Float 3 [_SpecularPower]
Float 4 [_Alpha]
Vector 5 [_Pan]
Vector 6 [_Rotation]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightBuffer] 2D
"ps_3_0
; 41 ALU, 3 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
def c7, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c8, 6.28318501, -3.14159298, 0, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1
dcl_texcoord2 v2.xyz
mov r0.x, c6.z
mul r0.x, c0, r0
add r0.x, r0, c7
mad r0.x, r0, c7.y, c7.z
frc r0.x, r0
mad r1.x, r0, c8, c8.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c6.y
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c6.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c6.y
mov r0.x, c5.y
mad r0.z, c0.x, -r0.x, r0
add r0.y, -r0, c6.x
mov r0.x, c5
mad r0.x, c0, -r0, r0.y
add r0.y, r0.z, c7.w
add r0.x, r0, c7.w
texld r1, r0, s0
add r0.z, -r1.w, c7.w
mul r0.z, -r0, c4.x
add r1.w, r0.z, c7
texld r0.xyz, r0, s2
mul r0.xyz, r0, c3.x
mul r2.xyz, r0, c2
texldp r0, v1, s3
add r1.xyz, -r1.w, r1
mad r1.xyz, r1.w, r1, r1.w
add_pp r0.xyz, r0, v2
mul_pp r2.xyz, r0.w, r2
mul_pp r2.xyz, r0, r2
mul r1.xyz, r1, c1
mad_pp oC0.xyz, r1, r0, r2
mov_pp oC0.w, r1
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Vector 2 [_SpecularColor]
Float 3 [_SpecularPower]
Float 4 [_Alpha]
Vector 5 [_Pan]
Vector 6 [_Rotation]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 44 ALU, 5 TEX
PARAM c[9] = { program.local[0..7],
		{ 3.1415927, 1, 8 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[2], texture[5], 2D;
MUL R1.xyz, R0.w, R0;
TEX R0, fragment.texcoord[2], texture[4], 2D;
MUL R0.xyz, R0.w, R0;
MUL R1.xyz, R1, c[8].z;
DP4 R1.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.x, R1.w;
MOV R0.w, c[0].x;
MUL R1.w, R0, c[6].z;
RCP R2.x, R2.x;
MAD R0.xyz, R0, c[8].z, -R1;
MAD_SAT R2.x, R2, c[7].z, c[7].w;
MAD R2.xyz, R2.x, R0, R1;
ADD R1.w, R1, -c[8].x;
COS R0.y, R1.w;
ADD R0.x, fragment.texcoord[0].y, -c[6].y;
SIN R0.z, R1.w;
MUL R1.x, R0, R0.z;
MUL R1.y, R0, R0.x;
ADD R0.x, fragment.texcoord[0], -c[6];
MAD R0.z, R0.x, R0, R1.y;
MAD R0.x, R0, R0.y, -R1;
ADD R0.y, -R0.z, c[6];
MAD R0.y, R0.w, -c[5], R0;
TXP R1, fragment.texcoord[1], texture[3], 2D;
ADD R0.x, -R0, c[6];
MAD R0.x, R0.w, -c[5], R0;
ADD R3.y, R0, c[8];
ADD R3.x, R0, c[8].y;
ADD R1.xyz, R1, R2;
TEX R0, R3, texture[0], 2D;
ADD R0.w, -R0, c[8].y;
TEX R2.xyz, R3, texture[2], 2D;
MUL R0.w, -R0, c[4].x;
ADD R0.w, R0, c[8].y;
MUL R2.xyz, R2, c[3].x;
MUL R2.xyz, R2, c[2];
ADD R0.xyz, -R0.w, R0;
MUL R2.xyz, R1.w, R2;
MAD R0.xyz, R0.w, R0, R0.w;
MUL R2.xyz, R1, R2;
MUL R0.xyz, R0, c[1];
MAD result.color.xyz, R0, R1, R2;
MOV result.color.w, R0;
END
# 44 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
Vector 0 [_Time]
Vector 1 [_MainColor]
Vector 2 [_SpecularColor]
Float 3 [_SpecularPower]
Float 4 [_Alpha]
Vector 5 [_Pan]
Vector 6 [_Rotation]
Vector 7 [unity_LightmapFade]
SetTexture 0 [_Diffuse] 2D
SetTexture 2 [_Specular] 2D
SetTexture 3 [_LightBuffer] 2D
SetTexture 4 [unity_Lightmap] 2D
SetTexture 5 [unity_LightmapInd] 2D
"ps_3_0
; 50 ALU, 5 TEX
dcl_2d s0
dcl_2d s2
dcl_2d s3
dcl_2d s4
dcl_2d s5
def c8, -3.14159274, 0.15915491, 0.50000000, 1.00000000
def c9, 6.28318501, -3.14159298, 8.00000000, 0
dcl_texcoord0 v0.xy
dcl_texcoord1 v1
dcl_texcoord2 v2.xy
dcl_texcoord3 v3
mov r0.x, c6.z
mul r0.x, c0, r0
add r0.x, r0, c8
mad r0.x, r0, c8.y, c8.z
frc r0.x, r0
mad r1.x, r0, c9, c9.y
sincos r0.xy, r1.x
add r0.z, v0.y, -c6.y
mul r0.w, r0.z, r0.y
mul r1.x, r0.z, r0
add r0.z, v0.x, -c6.x
mad r1.x, r0.z, r0.y, r1
mad r0.y, r0.z, r0.x, -r0.w
add r0.z, -r1.x, c6.y
mov r0.x, c5.y
mad r0.z, c0.x, -r0.x, r0
texld r1, v2, s5
mul_pp r1.xyz, r1.w, r1
add r3.y, r0.z, c8.w
mul_pp r1.xyz, r1, c9.z
add r0.y, -r0, c6.x
mov r0.x, c5
mad r0.x, c0, -r0, r0.y
add r3.x, r0, c8.w
texld r0, r3, s0
add r0.w, -r0, c8
mul r0.w, -r0, c4.x
add r2.w, r0, c8
add r0.xyz, -r2.w, r0
mad r2.xyz, r2.w, r0, r2.w
texld r0, v2, s4
mul_pp r0.xyz, r0.w, r0
dp4 r0.w, v3, v3
rsq r0.w, r0.w
texld r3.xyz, r3, s2
rcp r0.w, r0.w
mul r3.xyz, r3, c3.x
mad_pp r0.xyz, r0, c9.z, -r1
mad_sat r0.w, r0, c7.z, c7
mad_pp r0.xyz, r0.w, r0, r1
texldp r1, v1, s3
mul r3.xyz, r3, c2
add_pp r0.xyz, r1, r0
mul_pp r3.xyz, r1.w, r3
mul_pp r1.xyz, r0, r3
mul r2.xyz, r2, c1
mad_pp oC0.xyz, r2, r0, r1
mov_pp oC0.w, r2
"
}

SubProgram "gles " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "HDR_LIGHT_PREPASS_ON" }
"!!GLES"
}

}
	}

#LINE 162

	}
	Fallback "Diffuse"
}