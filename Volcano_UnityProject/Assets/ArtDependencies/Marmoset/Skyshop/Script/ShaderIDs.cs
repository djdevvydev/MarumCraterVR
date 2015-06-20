// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

//#define MARMO_STRING_IDS

using UnityEngine;
using System.Collections;


namespace mset {
#if MARMO_STRING_IDS
	//shader parameters used for blending, multiple sets with different post-fixes can be declared and linked to the shader system
	public class ShaderIDs {
		public string specCubeIBL="";
		public string skyCubeIBL="";
		public string skyMatrix="";
		public string invSkyMatrix="";
		public string skySize="";
		public string skyMin="";
		public string skyMax="";
		public string[] SH = null;
		public string exposureIBL="";
		public string exposureLM="";
		public string oldExposureIBL ="";
		//shared IDs
		public string blendWeightIBL="";
		
		private bool _valid = false;
		public bool valid { get { return _valid; } }
		
		public ShaderIDs() {
			SH = new string[9];
		}
		public void Link() {
			Link("");
		}
		public void Link(string postfix) {
			specCubeIBL =  ("_SpecCubeIBL" + postfix);
			skyCubeIBL =  ("_SkyCubeIBL" + postfix);
			skyMatrix =    ("_SkyMatrix" + postfix);
			invSkyMatrix = ("_InvSkyMatrix" + postfix);
			skyMin = 	   ("_SkyMin" + postfix);
			skyMax = 	   ("_SkyMax" + postfix);
			exposureIBL =  ("_ExposureIBL" + postfix);
			exposureLM =   ("_ExposureLM" + postfix);
			for(int i=0; i<9; ++i) {
				SH[i] = ("_SH" + i + postfix);
			}
			//shared IDs don't get a postfix
			blendWeightIBL = ("_BlendWeightIBL");
			_valid = true;
		}
	}
#else
	//shader parameters used for blending, multiple sets with different post-fixes can be declared and linked to the shader system
	public class ShaderIDs {
		public int specCubeIBL=-1;
		public int skyCubeIBL=-1;
		public int skyMatrix=-1;
		public int invSkyMatrix=-1;
		public int skySize=-1;
		public int skyMin=-1;
		public int skyMax=-1;
		public int[] SH = null;
		public int exposureIBL=-1;
		public int exposureLM=-1;
		public int oldExposureIBL = -1;
		//shared IDs
		public int blendWeightIBL=-1;
		
		private bool _valid = false;
		public bool valid { get { return _valid; } }
		
		public ShaderIDs() {
			SH = new int[9];
		}
		public void Link() {
			Link("");
		}
		public void Link(string postfix) {
			specCubeIBL =  Shader.PropertyToID("_SpecCubeIBL" + postfix);
			skyCubeIBL =   Shader.PropertyToID("_SkyCubeIBL" + postfix);
			skyMatrix =    Shader.PropertyToID("_SkyMatrix" + postfix);
			invSkyMatrix = Shader.PropertyToID("_InvSkyMatrix" + postfix);
			skyMin = 	   Shader.PropertyToID("_SkyMin" + postfix);
			skyMax = 	   Shader.PropertyToID("_SkyMax" + postfix);
			exposureIBL =  Shader.PropertyToID("_ExposureIBL" + postfix);
			exposureLM =   Shader.PropertyToID("_ExposureLM" + postfix);
			for(int i=0; i<9; ++i) {
				SH[i] = Shader.PropertyToID("_SH" + i + postfix);
			}
			//shared IDs don't get a postfix
			blendWeightIBL = Shader.PropertyToID("_BlendWeightIBL");
			_valid = true;
		}
	}
#endif
}

