// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
//using UnityEditor;
using System;
using System.IO;

namespace mset {
	//Unused class. As of Unity 4.3.4, Camera.RenderToCubemap is broken in D3D9 so all probing is done through FreeProbe.
	public class SkyProbe {
		public RenderTexture cubeRT = null;
		public int maxExponent = 512;
		public Vector4 exposures = Vector4.one;
		public bool generateMipChain = true;
		public bool highestMipIsMirror = true;
		public float convolutionScale = 1f;
		public RenderingPath renderPath = RenderingPath.Forward;

		private static int sampleCount = 128;
		private static Vector4[] randomValues = null;
		public static void buildRandomValueTable() {
			if( randomValues == null ) {
				float countf = (float)sampleCount;
				randomValues = new Vector4[sampleCount];
				float[] progression = new float[sampleCount];
				for( int i=0; i<sampleCount; ++i ) {
					randomValues[i] = new Vector4();
					progression[i] = randomValues[i].x = (i+1)/countf;
				}
				int pcount = sampleCount;
				for( int i=0; i<sampleCount; ++i ) {
					int chosen = UnityEngine.Random.Range(0, pcount-1);
					float phi = progression[chosen];
					progression[chosen] = progression[--pcount];
					randomValues[i].y = phi;
					randomValues[i].z = Mathf.Cos( 2f * Mathf.PI * phi );
					randomValues[i].w = Mathf.Sin( 2f * Mathf.PI * phi );
				}
			}
		}
		public static void bindRandomValueTable(Material mat, string paramName, int inputFaceSize) {
			for(int i=0; i<sampleCount; ++i) {
				mat.SetVector(paramName + i, randomValues[i]);
			}
			float imp = inputFaceSize*inputFaceSize/(float)sampleCount;
			imp = 0.5f*Mathf.Log(imp, 2f) + 0.5f; //+0.5 is a fudge factor, ideally 0, suggested at 1, we use 0.5
			mat.SetFloat("_ImportantLog", imp);
		}
		public static void buildRandomValueCode() {
			/*
			string run = "";
			string declare = "";

			declare += "#define SPECULAR_IMPORTANCE_SAMPLES " + sampleCount + "\n";
			declare += "//{ r1, r2, cos( 2*pi*r2 ), sin( 2*pi*r2 ) }\n\n";
			declare += "uniform float4\n";

			run = "spec = ";
			for(int i=0; i<sampleCount; ++i) {
				declare += " _PhongRands" + i;
				if(i != sampleCount-1) { 
					declare += ", ";
					if( i < 100 ) declare += " ";
					if( i < 10 )  declare += " ";
					if((i+1)%4 == 0) declare += "\n";
				}

				run += " importanceLookup(n, bx, by, bz, _PhongRands"+i+") ";
				if( i < 100 ) run += " ";
				if( i < 10 )  run += " ";

				if(i != sampleCount-1) { 
					run += "+ ";
					if((i+1)%4 == 0) run += "\n";
				}
			}
			declare += ";\n\n";
			run += ";\n\n";

			string path = Application.dataPath + "/importanceCode.txt";
			System.IO.StreamWriter w = File.CreateText(path);
			w.Write(declare);
			w.Write(run);
			w.Close();

			Debug.Log("created code at path " + path);
			*/
		}

		public SkyProbe() {
			buildRandomValueTable();
		}

		public void blur(Cubemap targetCube, Texture sourceCube, bool dstRGBM, bool srcRGBM, bool linear) {
			if( sourceCube == null || targetCube == null ) return;
			//buildRandomValueCode();
			
			GameObject go = new GameObject("_temp_probe");
			go.hideFlags = HideFlags.HideInHierarchy | HideFlags.HideAndDontSave;
			go.SetActive(true);
			Camera cam = go.AddComponent<Camera>();		
			cam.renderingPath = renderPath;
			cam.useOcclusionCulling = false;
			
			//render cubeRT converting it to RGBM
			Material skyMat = new Material(Shader.Find("Hidden/Marmoset/RGBM Cube"));			
			Matrix4x4 matrix = Matrix4x4.identity;
			int me = this.maxExponent;
			bool mip = this.generateMipChain;
			//HACK: run the convolution twice at a higher exponent, better results on older shader models with fewer samples
			this.maxExponent = 8*me;
			this.generateMipChain = false;
			this.convolve_internal(targetCube,	sourceCube,	dstRGBM, srcRGBM, linear, cam, skyMat, matrix);
			this.convolve_internal(targetCube,	targetCube,	dstRGBM, dstRGBM, linear, cam, skyMat, matrix);

		#if UNITY_EDITOR
			//HACK: force reimport to rebuild mipmap because RenderToCubemap destroys our mipmap and pixel copy gamma is broken in d3d11
			string path = UnityEditor.AssetDatabase.GetAssetPath(targetCube);
			if(path!=null && path.Length>0) UnityEditor.AssetDatabase.ImportAsset(path);
		#endif

			this.maxExponent = me;
			this.generateMipChain = mip;

			//make sure the old sky and matrix vars are bound again
			mset.SkyManager mgr = mset.SkyManager.Get();
			if(mgr) mgr.GlobalSky = mgr.GlobalSky;
			Material.DestroyImmediate(skyMat);
			
			GameObject.DestroyImmediate(go);
		}

		public void convolve(Cubemap targetCube, Texture sourceCube, bool dstRGBM, bool srcRGBM, bool linear) {
			if( targetCube == null ) return;
			//buildRandomValueCode();
			/*
			bool tempRT = false;
			if(cubeRT == null) {
				tempRT = true;
				//everything's rendered in HDR render buffer for now
				cubeRT = RenderTexture.GetTemporary(targetCube.width, targetCube.width, 24, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
				cubeRT.isCubemap = true;
				cubeRT.useMipMap = true;
				cubeRT.generateMips = true;
			}
			*/

			GameObject go = new GameObject("_temp_probe");
			go.hideFlags = HideFlags.HideInHierarchy | HideFlags.HideAndDontSave;
			go.SetActive(true);
			Camera cam = go.AddComponent<Camera>();		
			cam.renderingPath = renderPath;
			cam.useOcclusionCulling = false;

			Material skyMat = new Material(Shader.Find("Hidden/Marmoset/RGBM Cube"));
			
			Matrix4x4 matrix = Matrix4x4.identity;
			this.copy_internal(targetCube,	sourceCube,	dstRGBM, srcRGBM, linear, cam, skyMat, matrix);
			//NOTE: cubeRT is needed to make sure sourceCube is mipmapped (for importance sampling), however cubeRT cannot be used because D3D9 renders skybox gamma wrong >_<
			/*
			this.copy_internal(cubeRT, 		sourceCube, false,   srcRGBM, linear, cam, skyMat, matrix);
			this.convolve_internal(targetCube,	cubeRT,	dstRGBM, false,   linear, cam, skyMat, matrix);
			this.copy_internal		(targetCube, sourceCube, dstRGBM, srcRGBM, linear, cam, skyMat, matrix);
			*/
			int me = this.maxExponent;
			//HACK: dx11 seems to be the only shader model that supports 128 texture samples, convolve twice on all other platforms
			this.maxExponent = 2*me;
			this.convolve_internal	(targetCube, sourceCube, dstRGBM, srcRGBM, linear, cam, skyMat, matrix);
			this.maxExponent = 8*me;
			this.convolve_internal	(targetCube, targetCube, dstRGBM, dstRGBM, linear, cam, skyMat, matrix);
			this.maxExponent = me;

			//make sure the old sky and matrix vars are bound again
			mset.SkyManager mgr = mset.SkyManager.Get();
			if(mgr) mgr.GlobalSky = mgr.GlobalSky;
			Material.DestroyImmediate(skyMat);

			//if(tempRT) RenderTexture.ReleaseTemporary(cubeRT);
			GameObject.DestroyImmediate(go);
		}


		public bool capture(Cubemap targetCube, Vector3 position, Quaternion rotation, bool HDR, bool linear, bool convolve) {
			if(targetCube == null) return false;

			bool tempRT = false;
			if(cubeRT == null) {
				tempRT = true;
				//everything's captured to an HDR buffer right now
				cubeRT = RenderTexture.GetTemporary(targetCube.width, targetCube.width, 24, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
				cubeRT.isCubemap = true;
				cubeRT.useMipMap = true;
				cubeRT.generateMips = true;
				if(!cubeRT.IsCreated() && !cubeRT.Create()) {
					cubeRT = RenderTexture.GetTemporary(targetCube.width, targetCube.width, 24, RenderTextureFormat.Default, RenderTextureReadWrite.Linear);
					cubeRT.isCubemap = true;
					cubeRT.useMipMap = true;
					cubeRT.generateMips = true;
				}
			}

			if(!cubeRT.IsCreated() && !cubeRT.Create()) return false;

			GameObject go = new GameObject("_temp_probe");
			go.hideFlags = HideFlags.HideInHierarchy | HideFlags.HideAndDontSave;
			Camera cam = go.AddComponent<Camera>();
			if(Camera.main) cam.CopyFrom(Camera.main);
			cam.renderingPath = renderPath;
			cam.useOcclusionCulling = false;
			cam.hdr = true;
			go.SetActive(true);			
			go.transform.position = position;

			//capture entire scene in HDR
			Shader.SetGlobalVector("_UniformOcclusion", this.exposures);
			cam.RenderToCubemap(cubeRT);
			Shader.SetGlobalVector("_UniformOcclusion", Vector4.one);

			Matrix4x4 matrix = Matrix4x4.identity;
			matrix.SetTRS(position, rotation, Vector3.one);

			//render cubeRT converting it to RGBM
			Material skyMat = new Material(Shader.Find("Hidden/Marmoset/RGBM Cube"));

			bool dstRGBM = HDR;
			bool srcRGBM = false;
			copy_internal(targetCube, cubeRT, dstRGBM, srcRGBM, linear, cam, skyMat, matrix);
			if( convolve ) {
				convolve_internal(targetCube, cubeRT, HDR, false, linear, cam, skyMat, matrix);
			}

			//make sure the old sky and matrix vars are bound again
			mset.SkyManager mgr = mset.SkyManager.Get();
			if(mgr) mgr.GlobalSky = mgr.GlobalSky;
			Material.DestroyImmediate(skyMat);

			GameObject.DestroyImmediate(go);

			if(tempRT) RenderTexture.ReleaseTemporary(cubeRT);
			return true;
		}

		private static void toggleKeywordPair(string on, string off, bool yes) {
			if(yes) {
				Shader.EnableKeyword(on);
				Shader.DisableKeyword(off);
			} else {
				Shader.EnableKeyword(off);
				Shader.DisableKeyword(on);
			}
		}
		private static void toggleKeywordPair(Material mat, string on, string off, bool yes) {
			if(yes) {
				mat.EnableKeyword(on);
				mat.DisableKeyword(off);
			} else {
				mat.EnableKeyword(off);
				mat.DisableKeyword(on);
			}
		}

		private void copy_internal(Texture dstCube, Texture srcCube, bool dstRGBM, bool srcRGBM, bool linear, Camera cam, Material skyMat, Matrix4x4 matrix) {

			bool prevHDR = cam.hdr;
			CameraClearFlags prevFlags = cam.clearFlags;
			int prevMask = cam.cullingMask;
			cam.clearFlags = CameraClearFlags.Skybox;
			cam.cullingMask = 0;
			cam.hdr = !dstRGBM; // might need HDR camera buffer when we're not rendering to RGBM encoded pixels

			skyMat.name = "Internal HDR to RGBM Skybox";
			skyMat.shader = Shader.Find("Hidden/Marmoset/RGBM Cube");

			//toggleKeywordPair("MARMO_LINEAR", "MARMO_GAMMA", linear);
			toggleKeywordPair("MARMO_RGBM_INPUT_ON", "MARMO_RGBM_INPUT_OFF", srcRGBM);
			toggleKeywordPair("MARMO_RGBM_OUTPUT_ON", "MARMO_RGBM_OUTPUT_OFF", dstRGBM);
			
			skyMat.SetMatrix("_SkyMatrix", matrix);
			skyMat.SetTexture("_CubeHDR", srcCube);

			Material prevSkyMat = UnityEngine.RenderSettings.skybox;
			UnityEngine.RenderSettings.skybox = skyMat;

			RenderTexture RT = dstCube as RenderTexture;
			Cubemap cube = dstCube as Cubemap;
			if(RT)  		cam.RenderToCubemap(RT);
			else if(cube)	cam.RenderToCubemap(cube);

			cam.hdr = prevHDR;
			cam.clearFlags = prevFlags;
			cam.cullingMask = prevMask;
			UnityEngine.RenderSettings.skybox = prevSkyMat;
		}
		private void convolve_internal(Cubemap dstCube, Texture srcCube, bool dstRGBM, bool srcRGBM, bool linear, Camera cam, Material skyMat, Matrix4x4 matrix) {

			bool prevHDR = cam.hdr;
			CameraClearFlags prevFlags = cam.clearFlags;
			int prevMask = cam.cullingMask;
			cam.clearFlags = CameraClearFlags.Skybox;
			cam.cullingMask = 0;
			cam.hdr = !dstRGBM; // might need HDR camera buffer when we're not rendering to RGBM encoded pixels

			skyMat.name = "Internal Convolve Skybox";
			skyMat.shader = Shader.Find("Hidden/Marmoset/RGBM Convolve");

			//toggleKeywordPair("MARMO_LINEAR", "MARMO_GAMMA", linear);
			toggleKeywordPair("MARMO_RGBM_INPUT_ON", "MARMO_RGBM_INPUT_OFF", srcRGBM);
			toggleKeywordPair("MARMO_RGBM_OUTPUT_ON", "MARMO_RGBM_OUTPUT_OFF", dstRGBM);

			skyMat.SetMatrix("_SkyMatrix", matrix);
			skyMat.SetTexture("_CubeHDR", srcCube);
			bindRandomValueTable(skyMat,"_PhongRands", srcCube.width);

			Material prevSkyMat = UnityEngine.RenderSettings.skybox;
			UnityEngine.RenderSettings.skybox = skyMat;			

			if( generateMipChain ) { 
				int mipCount = mset.QPow.Log2i(dstCube.width) - 1;
				int mip = highestMipIsMirror ? 1 : 0;
				for( ; mip<mipCount; ++mip ) {
					int mipSize = 1 << (mipCount-mip);
					float mipExp = mset.QPow.clampedDownShift(this.maxExponent, highestMipIsMirror ? (mip-1) : mip, 1);
					skyMat.SetFloat("_SpecularExp", mipExp);
					skyMat.SetFloat ("_SpecularScale", this.convolutionScale);
					Cubemap mipCube = new Cubemap(mipSize, dstCube.format, false);						
					cam.RenderToCubemap(mipCube);

					for(int f=0; f<6; ++f) {
						CubemapFace face = (CubemapFace)f;
						dstCube.SetPixels(mipCube.GetPixels(face), face, mip);
					}
					Cubemap.DestroyImmediate(mipCube);
				}
				dstCube.Apply(false);
			} else {
				skyMat.SetFloat("_SpecularExp", this.maxExponent);
				skyMat.SetFloat ("_SpecularScale", this.convolutionScale);
				cam.RenderToCubemap(dstCube);
			}

			cam.clearFlags = prevFlags;
			cam.cullingMask = prevMask;
			cam.hdr = prevHDR;
			UnityEngine.RenderSettings.skybox = prevSkyMat;
		}
	};
}