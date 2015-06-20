// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System.Collections;

namespace mset {
	public class SkyDebug : MonoBehaviour {
		public bool printToGUI = true;
		public bool printToConsole = false;
		public bool printOnce = false;
		public bool printConstantly = false;
		public bool printInEditor = true;

		public string debugString = "";
		MaterialPropertyBlock block = null;
		GUIStyle debugStyle = null;

		private static int debugCounter = 0;
		private int debugID = 0;
		// Use this for initialization
		void Start () {	
			debugID = debugCounter;
			debugCounter++;
		}
		
		// Update is called once per frame
		void LateUpdate () {

			bool printNow = printOnce || printConstantly;

			if(this.GetComponent<Renderer>()) {
				if(printNow) {
					printOnce = false;
					debugString = GetDebugString();
					if(printToConsole) Debug.Log (debugString);
				}
			}
		}

		public string GetDebugString() {
			string str = "<b>SkyDebug Info - " + this.name + "</b>\n";
			Material mat = null;
			if(Application.isPlaying)	mat = GetComponent<Renderer>().material;
			else 						mat = GetComponent<Renderer>().sharedMaterial;

			str += mat.shader.name + "\n";
			str += "is supported: " + mat.shader.isSupported + "\n";
			mset.ShaderIDs[] bids = {new mset.ShaderIDs(), new mset.ShaderIDs()};
			bids[0].Link();
			bids[1].Link("1");
			
			if(block == null) block = new MaterialPropertyBlock();
			block.Clear();
			this.GetComponent<Renderer>().GetPropertyBlock(block);
			
			for(int i=0; i<2; ++i) {
				str += "Renderer Property block - blend ID " + i;
				
				str += "\nexposureIBL  " + block.GetVector(bids[i].exposureIBL);
				str += "\nexposureLM   " + block.GetVector(bids[i].exposureLM);
				
				str += "\nskyMin       " + block.GetVector(bids[i].skyMin);
				str += "\nskyMax       " + block.GetVector(bids[i].skyMax);			
				
				str += "\ndiffuse SH\n";
				for(int j=0; j<4; ++j) {
					str += block.GetVector(bids[i].SH[j]) + "\n";
				}
				str += "...\n";
				
				Texture spec = block.GetTexture(bids[i].specCubeIBL);
				Texture sky = block.GetTexture(bids[i].skyCubeIBL);
				str += "\nspecCubeIBL  "; if(spec) str += spec.name; else str += "none";
				str += "\nskyCubeIBL   "; if(sky)  str += sky.name;  else str += "none";
				
				str += "\nskyMatrix\n" + block.GetMatrix(bids[i].skyMatrix);
				str += "\ninvSkyMatrix\n" + block.GetMatrix(bids[i].invSkyMatrix);
				
				if(i==0) {
					str += "\nblendWeightIBL " + block.GetFloat(bids[i].blendWeightIBL);
				}
				str += "\n\n";
			}
			return str;
		}

		void OnDrawGizmosSelected() {
			bool printNow = printOnce || printConstantly;
			if(this.GetComponent<Renderer>() && this.printInEditor && this.printToConsole) {
				if(printNow) {
					printOnce = false;
					string str = GetDebugString();
					Debug.Log (str);
				}
			}
		}

		void OnGUI() {
			if(printToGUI) {
				Rect menuRect = Rect.MinMaxRect(3,3,360,1024);
				if(Camera.main) menuRect.yMax = Camera.main.pixelHeight;
				menuRect.xMin += debugID * menuRect.width;
				GUI.color = Color.white;
				if(debugStyle == null) {
					debugStyle = new GUIStyle();
					debugStyle.richText = true;
				}
				string styleStart = "<color=\"#000\">";
				string styleEnd = "</color>";
				GUI.TextArea(menuRect, styleStart + debugString + styleEnd, debugStyle);
				styleStart = "<color=\"#FFF\">";
				menuRect.xMin -= 1;
				menuRect.yMin -= 2;
				GUI.TextArea(menuRect, styleStart + debugString + styleEnd, debugStyle);

			}
		}
	}
}