// Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'

// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

#ifndef MARMOSET_SURF_CGINC
#define MARMOSET_SURF_CGINC

half3 blendedDiffuseIBL(float3 worldN) {
	float3 skyN = worldN;
	skyN = skyRotate(_SkyMatrix, skyN);
	skyN = normalize(skyN);
	
	#ifdef MARMO_DIFFUSE_SCATTER
		float3 band0, band1, band2;
		SHLookup(skyN, band0, band1, band2);
		float4 scatter = _Scatter * _ScatterColor;
		half3 diffIBL = SHConvolve(band0, band1, band2, scatter.rgb);
	#else
		half3 diffIBL = SHLookup(skyN);	
	#endif
	
	#ifdef MARMO_SKY_BLEND
		skyN = skyRotate(_SkyMatrix1, worldN);
		skyN = normalize(skyN);
		half3 diffIBL1 = SHLookup1(skyN);
		diffIBL = lerp(diffIBL1, diffIBL, _BlendWeightIBL);
	#endif
	return diffIBL;
}

void MarmosetVert(inout appdata_full v, out Input o) {
	UNITY_INITIALIZE_OUTPUT(Input,o);
	#ifdef MARMO_CUSTOM_TILING
		o.texcoord = v.texcoord.xy;
	#endif
	#ifdef MARMO_OCCLUSION
		o.texcoord1 = v.texcoord1.xy;
	#endif
	#if defined(MARMO_VERTEX_COLOR) || defined(MARMO_VERTEX_LAYER_MASK)
		o.color = v.color;
	#elif defined(MARMO_VERTEX_OCCLUSION)
		o.color = v.color.rg;
	#endif
	#ifdef MARMO_BOX_PROJECTION
		o.worldPos = mul(_Object2World, v.vertex);
	#endif
		
	float3 worldN = mul((float3x3)_Object2World, v.normal * 1.0);
	
	#ifndef MARMO_NORMALMAP
		o.worldN = worldN;
	#endif
	
	#ifdef MARMO_DIFFUSE_VERTEX_IBL
		o.vertexIBL = blendedDiffuseIBL(worldN);
	#endif
}

void MarmosetSurf(Input IN, inout MarmosetOutput OUT) {
	#ifdef MARMO_CUSTOM_TILING
		#define uv_diff  (IN.texcoord.xy * _MainTexTiling.xy +  _MainTexTiling.zw)
		#define uv_diff1 (IN.texcoord.xy * _MainTex1Tiling.xy + _MainTex1Tiling.zw)
		#define uv_diff2 (IN.texcoord.xy * _MainTex2Tiling.xy + _MainTex2Tiling.zw)
		#define uv_diff3 (IN.texcoord.xy * _MainTex3Tiling.xy + _MainTex3Tiling.zw)
		
		#define uv_spec  (IN.texcoord.xy * _SpecTexTiling.xy +  _SpecTexTiling.zw)
		#define uv_spec1 (IN.texcoord.xy * _SpecTex1Tiling.xy + _SpecTex1Tiling.zw)
		#define uv_spec2 (IN.texcoord.xy * _SpecTex2Tiling.xy + _SpecTex2Tiling.zw)
		#define uv_spec3 (IN.texcoord.xy * _SpecTex3Tiling.xy + _SpecTex3Tiling.zw)
		
		#define uv_bump  (IN.texcoord.xy * _BumpMapTiling.xy +  _BumpMapTiling.zw)
		#define uv_bump1 (IN.texcoord.xy * _BumpMap1Tiling.xy + _BumpMap1Tiling.zw)
		#define uv_bump2 (IN.texcoord.xy * _BumpMap2Tiling.xy + _BumpMap2Tiling.zw)
		#define uv_bump3 (IN.texcoord.xy * _BumpMap3Tiling.xy + _BumpMap3Tiling.zw)
		
		#ifdef MARMO_TEXTURE_LAYER_MASK_UV1
			#define uv_mask  (IN.texcoord1.xy * _LayerMaskTiling.xy + _LayerMaskTiling.zw)
		#else
			#define uv_mask  (IN.texcoord.xy * _LayerMaskTiling.xy + _LayerMaskTiling.zw)
		#endif
		
		#define uv_glow (IN.texcoord.xy * _IllumTiling.xy   + _IllumTiling.zw)
		#define uv_occ  (IN.texcoord1.xy * _OccTexTiling.xy  + _OccTexTiling.zw)
	#else
		#define uv_diff  IN.uv_MainTex
		#define uv_diff1 IN.uv_MainTex
		#define uv_diff2 IN.uv_MainTex
		#define uv_diff3 IN.uv_MainTex
		
		#define uv_spec  IN.uv_MainTex
		#define uv_spec1 IN.uv_MainTex
		#define uv_spec2 IN.uv_MainTex
		#define uv_spec3 IN.uv_MainTex
		
		#define uv_bump  IN.uv_MainTex
		#define uv_bump1 IN.uv_MainTex
		#define uv_bump2 IN.uv_MainTex
		#define uv_bump3 IN.uv_MainTex
		
		#ifdef MARMO_TEXTURE_LAYER_MASK_UV1
			#define uv_mask  IN.texcoord1
		#else
			#define uv_mask  IN.uv_MainTex
		#endif
		
		#define uv_glow  IN.uv_MainTex
		#define uv_occ   IN.texcoord1
	#endif

	#ifdef MARMO_SKY_BLEND
		float skyWeight = _BlendWeightIBL;
	#endif
	
	half4 exposureIBL = _ExposureIBL;
	#if LIGHTMAP_ON
		exposureIBL.xy *= _ExposureLM;
	#endif
	#ifdef MARMO_SKY_BLEND
		half4 exposureIBL1 = _ExposureIBL1;
		#if LIGHTMAP_ON
			exposureIBL1.xy *= _ExposureLM1;
		#endif		
		exposureIBL = lerp(exposureIBL1, exposureIBL, skyWeight);
	#endif
	
	exposureIBL.xy *= _UniformOcclusion.xy;
	half4 baseColor = _Color;
	#ifdef MARMO_VERTEX_COLOR
		baseColor *= IN.color;
	#endif
	
	#if defined(MARMO_VERTEX_LAYER_MASK)
		half4 layerWeight = IN.color;
	#elif defined(MARMO_TEXTURE_LAYER_MASK)
		half4 layerWeight = tex2D(_LayerMask, uv_mask);
	#else
		half4 layerWeight = half4(1.0,0.0,0.0,0.0);
	#endif
	
	#if defined(MARMO_VERTEX_LAYER_MASK) || defined(MARMO_TEXTURE_LAYER_MASK)
		half layerSum = dot(layerWeight, half4(1.0,1.0,1.0,1.0));
		layerWeight /= max(1.0, layerSum);
	#endif

	#ifdef MARMO_DIFFUSE_SPECULAR_COMBINED
		half4 diffspec = half4(1.0,1.0,1.0,1.0);
	#endif
		
	//DIFFUSE
	#if defined(MARMO_DIFFUSE_DIRECT) || defined(MARMO_DIFFUSE_IBL)
		//Layered diffuse
		#if defined(MARMO_DIFFUSE_4_LAYER)
			//TODO: per-pixel weight normalize here?
			half4 diff;
			diff  = layerWeight.r * tex2D( _MainTex,  uv_diff ) * baseColor;
			diff += layerWeight.g * tex2D( _MainTex1, uv_diff1 ) * _Color1;
			diff += layerWeight.b * tex2D( _MainTex2, uv_diff2 ) * _Color2;
			diff += layerWeight.a * tex2D( _MainTex3, uv_diff3 ) * _Color3;
		#elif defined(MARMO_DIFFUSE_2_LAYER)
			half4 diff;
			diff  = layerWeight.r * tex2D( _MainTex,  uv_diff ) * baseColor;
			diff += layerWeight.g * tex2D( _MainTex1, uv_diff1 ) * _Color1;
		#else
			half4 diff = tex2D( _MainTex, uv_diff ) * baseColor;
		#endif
		
		#ifdef MARMO_DIFFUSE_SPECULAR_COMBINED
			diffspec = diff.aaaa;
		#endif
		
		//NOTE: this was the old way of doing it to separate vertex and base color from combined diff-spec alpha
		//diff *= baseColor;
		
		//camera exposure is built into OUT.Albedo
		diff.rgb *= exposureIBL.w;
		#ifdef MARMO_SIMPLE_GLASS
			diff.rgb *= diff.a;
		#endif
		OUT.Albedo = diff.rgb;		
		OUT.Alpha = diff.a;
	#else
		#ifdef MARMO_DIFFUSE_DIRECT
			OUT.Albedo = baseColor.rgb;
		#else
			// we don't want any lights if direct diffuse is turned off
			OUT.Albedo = half3(0.0,0.0,0.0);
		#endif
		OUT.Alpha = baseColor.a;
		#ifdef MARMO_SIMPLE_GLASS
			OUT.Albedo.rgb *= baseColor.a;
		#endif
	#endif
	
	//AMBIENT OCC
	#if defined(MARMO_VERTEX_OCCLUSION) || defined(MARMO_OCCLUSION)
		half4 occ = half4(1.0,1.0,1.0,1.0);
		#ifdef MARMO_OCCLUSION
			occ = tex2D(_OccTex, uv_occ);
		#endif
		#ifdef MARMO_VERTEX_OCCLUSION
			occ.rg *= IN.color.rg;
		#endif
		occ = lerp(half4(1.0,1.0,1.0,1.0),occ, _OccStrength);
		//TODO: occlude lightprobe SH by diffuse AO
		exposureIBL.xy *= occ.rg;
	#endif
	
	//NORMALS	
	#ifdef MARMO_NORMALMAP
		#if defined(MARMO_NORMALMAP_4_LAYER)
			half4 norm;
			norm  = layerWeight.r * tex2D( _BumpMap,  uv_bump );
			norm += layerWeight.g * tex2D( _BumpMap1, uv_bump1 );
			norm += layerWeight.b * tex2D( _BumpMap2, uv_bump2 );
			norm += layerWeight.a * tex2D( _BumpMap3, uv_bump3 );
			float3 localN = UnpackNormal(norm);
			localN = normalize(localN);
		#elif defined(MARMO_NORMALMAP_3_LAYER)
			half4 norm;
			norm  = layerWeight.r * tex2D( _BumpMap,  uv_bump );
			norm += layerWeight.g * tex2D( _BumpMap1, uv_bump1 );
			norm += layerWeight.b * tex2D( _BumpMap2, uv_bump2 );
			float3 localN = UnpackNormal(norm);
			localN = lerp(localN, float3(0.0,0.0,1.0), layerWeight.a);
			localN = normalize(localN);
		#elif defined(MARMO_NORMALMAP_2_LAYER)
			half4 norm;
			norm  = layerWeight.r * tex2D( _BumpMap,  uv_bump );
			norm += layerWeight.g * tex2D( _BumpMap1, uv_bump1 );
			float3 localN = UnpackNormal(norm);
			localN = lerp(localN, float3(0.0,0.0,1.0), layerWeight.b + layerWeight.a);
			localN = normalize(localN);
		#else
			float3 localN = UnpackNormal(tex2D( _BumpMap, uv_bump ));
			#ifdef MARMO_HQ
				localN = normalize(localN);
			#endif			
		#endif
		//localN and viewDir are in tangent-space
		OUT.Normal = localN;
		float3 worldN = WorldNormalVector(IN,localN);
	#else
		float3 worldN = IN.worldN;
		#ifdef MARMO_HQ
			worldN = normalize(worldN);
		#endif
		#if defined(UNITY_PASS_PREPASSFINAL)
			float3 localN = float3(0.0,0.0,1.0);
			//localN and viewDir are in tangent-space
		#else
			float3 localN = worldN;
			//localN and viewDir are in world-space
		#endif
	#endif
	
	//SPECULAR
	#if defined(MARMO_SPECULAR_DIRECT) || defined(MARMO_SPECULAR_IBL)
		#ifdef MARMO_DIFFUSE_SPECULAR_COMBINED
			half4 spec = diffspec;			
		#else
			#if defined(MARMO_SPECULAR_4_LAYER)
				half4 spec;
				spec  = layerWeight.r * tex2D( _SpecTex,  uv_spec );
				spec += layerWeight.g * tex2D( _SpecTex1, uv_spec1 );
				spec += layerWeight.b * tex2D( _SpecTex2, uv_spec2 );
				spec += layerWeight.a * tex2D( _SpecTex3, uv_spec3 );
			#elif defined(MARMO_SPECULAR_3_LAYER)
				half4 spec;
				spec  = layerWeight.r * tex2D( _SpecTex,  uv_spec );
				spec += layerWeight.g * tex2D( _SpecTex1, uv_spec1 );
				spec += layerWeight.b * tex2D( _SpecTex2, uv_spec2 );
			#elif defined(MARMO_SPECULAR_2_LAYER)
				half4 spec;
				spec  = layerWeight.r * tex2D( _SpecTex,  uv_spec );
				spec += layerWeight.g * tex2D( _SpecTex1, uv_spec1 );
			#else
				half4 spec = tex2D( _SpecTex, uv_spec );
			#endif
		#endif
		
		//fresnel layering
		#if defined(MARMO_SPECULAR_4_LAYER)
			half4 fresnelLayers = half4(_Fresnel, _Fresnel1, _Fresnel2, _Fresnel3);				
			half _fresnel = dot(layerWeight, fresnelLayers);
		#elif defined(MARMO_SPECULAR_3_LAYER)
			half3 fresnelLayers = half3(_Fresnel, _Fresnel1, _Fresnel2);
			half _fresnel = dot(layerWeight.rgb, fresnelLayers.rgb);
		#elif defined(MARMO_SPECULAR_2_LAYER)
			half2 fresnelLayers = half2(_Fresnel, _Fresnel1);
			half _fresnel = dot(layerWeight.rg, fresnelLayers.rg);
		#else
			half _fresnel = _Fresnel;
		#endif
		
		float3 localE = IN.viewDir;
		#ifdef MARMO_HQ
			localE = normalize(localE);
			half fresnel = splineFresnel(localN, localE, _SpecInt, _fresnel);
		#else
			half fresnel = fastFresnel(localN, localE, _SpecInt, _fresnel);		
		#endif
			
		spec.rgb *= _SpecColor.rgb;

		//filter the light that reaches diffuse reflection by specular intensity		
		#ifdef MARMO_SPECULAR_FILTER
			//Light reaching diffuse is filtered by 1-specColor*specIntensity
			half3 specFilter = half3(1.0,1.0,1.0) - spec.rgb * _SpecInt;
			
			//If the material exhibits strong fresnel, bias the filter some.
			specFilter += _fresnel.xxx*0.5;
			
			//don't let it get t crazy, clamp 0-1 and apply
			OUT.Albedo *= saturate(specFilter);
		#endif
		
		//camera exposure is built into OUT.Specular
		spec.rgb *= fresnel * exposureIBL.w;		
		half glossLod = glossLOD(spec.a, _Shininess);		
		#ifdef MARMO_SPECULAR_DIRECT
			OUT.SpecularRGB = spec.rgb;
			OUT.Specular = glossExponent(glossLod);
			//conserve energy by dividing out specular integral (direct lighting only)
			OUT.SpecularRGB *= specEnergyScalar(OUT.Specular);
			OUT.Specular *= 0.00390625; // 1/256
		#endif
	#endif
	
	//GLOW
	#ifdef MARMO_GLOW
		half4 glow = tex2D(_Illum, uv_glow);
		#ifdef MARMO_SIMPLE_GLASS
			glow *= OUT.Alpha;
		#endif
		glow.rgb *= _GlowColor.rgb;
		glow.rgb *= _GlowStrength;
		glow.rgb *= exposureIBL.w;
		glow.a *= _EmissionLM;
		//NOTE: camera exposure is already in albedo from above
		glow.rgb += OUT.Albedo * glow.a;		
		OUT.Emission += glow.rgb;
	#endif
		
	#ifdef MARMO_BOX_PROJECTION
		float3 worldP = IN.worldPos;
	#else
		float3 worldP = float3(0.0,0.0,0.0);
	#endif
	
	//SPECULAR IBL
	#ifdef MARMO_SPECULAR_IBL
		#ifdef MARMO_SPECULAR_REFRACTION
			float4 localF = specularRefract(-localE, localN, fresnel);
			float3 skyR = WorldNormalVector(IN, localF.xyz);
			
			//lerp reflection color to white and refraction color to specular RGB
			spec.rgb = lerp(half3(_SpecInt,_SpecInt,_SpecInt), spec.rgb, localF.w);
		#else 
			float3 skyR = WorldReflectionVector(IN, localN);
		#endif
		
		#ifdef MARMO_SKY_BLEND
			float3 skyR1 = skyR;
			skyR1 = skyProject(_SkyMatrix1, _InvSkyMatrix1, _SkyMin1, _SkyMax1, worldP, skyR1);
		#endif
		
		skyR = skyProject(_SkyMatrix, _InvSkyMatrix, _SkyMin, _SkyMax, worldP, skyR);
		#ifdef MARMO_MIP_GLOSS
			half3 specIBL = glossCubeLookup(_SpecCubeIBL, skyR, glossLod);
		#else
			half3 specIBL =  specCubeLookup(_SpecCubeIBL, skyR)*spec.a;
		#endif
		
		#ifdef MARMO_SKY_BLEND			
			#ifdef MARMO_MIP_GLOSS
				half3 specIBL1 = glossCubeLookup(_SpecCubeIBL1, skyR1, glossLod);
			#else
				half3 specIBL1 =  specCubeLookup(_SpecCubeIBL1, skyR1)*spec.a;
			#endif
			specIBL = lerp(specIBL1, specIBL, skyWeight);
		#endif		
		OUT.Emission += specIBL.rgb * spec.rgb * exposureIBL.y;
	#endif
	
	//PEACH-FUZZ
	#ifdef MARMO_DIFFUSE_FUZZ
		float eyeDP = dot(localE, localN);			
		eyeDP = 1.0 - eyeDP;
		float dp4 = eyeDP * eyeDP; dp4 *= dp4;
		float fuzz = _Fuzz * lerp(dp4, eyeDP*0.4, _FuzzScatter); //0.4 is energy conserving integral
		
		//HACK: modify albedo and direct lighting gets fresnel also
		OUT.Albedo.rgb *= 1.0 + fuzz * _FuzzColor.rgb;
	#endif
	
	//DIFFUSE IBL
	#ifdef MARMO_DIFFUSE_VERTEX_IBL
		//diffuseIBL comes from vertex shader
		OUT.Emission += IN.vertexIBL * OUT.Albedo.rgb * exposureIBL.x;
	#else
		//per-fragment diffuse lookup
		half3 diffIBL = blendedDiffuseIBL(worldN);
		OUT.Emission += diffIBL * OUT.Albedo.rgb * exposureIBL.x;
	#endif
		
	#ifndef MARMO_ALPHA
		OUT.Alpha = 1.0;
	#endif
}

#endif