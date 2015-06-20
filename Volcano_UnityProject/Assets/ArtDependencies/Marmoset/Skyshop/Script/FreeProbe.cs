// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
//using UnityEditor;
using System.Collections;
using System.Collections.Generic;

namespace mset {
	[RequireComponent(typeof(Camera))]
	public class FreeProbe : MonoBehaviour {
		private RenderTexture RT = null;

		public System.Action<float> ProgressCallback = null;
		public System.Action DoneCallback = null;
		public bool linear = true;
		public int maxExponent = 512;
		public Vector4 exposures = Vector4.one;
		public float convolutionScale = 1f;
		
		private Cubemap _targetCube = null;
		private Cubemap targetCube {
			get { return _targetCube; }
			set { 
				_targetCube = value;
				UpdateFaceTexture();
			}
		}
		
		private Texture2D faceTexture = null;
		private void UpdateFaceTexture() {
			if(_targetCube == null) return;
			if(faceTexture == null || faceTexture.width != _targetCube.width) {
				if(faceTexture) Texture2D.DestroyImmediate(faceTexture);
				faceTexture = new Texture2D(_targetCube.width, _targetCube.width, TextureFormat.ARGB32, true, false);
				
				//attempt to make an HDR render texture for RGBM capture
				RT = RenderTexture.GetTemporary(_targetCube.width, _targetCube.width, 24, RenderTextureFormat.ARGBHalf, RenderTextureReadWrite.Linear);
				RT.isCubemap = false;
				RT.useMipMap = false;
				RT.generateMips = false;
				if(!RT.IsCreated() && !RT.Create()) {
					Debug.LogWarning("Failed to create HDR RenderTexture, capturing in LDR mode.");
					RenderTexture.ReleaseTemporary(RT);
					RT = null;
				}		
			}
		}
		
		private void FreeFaceTexture() {
			if(faceTexture) {
				Texture2D.DestroyImmediate(faceTexture);
				faceTexture = null;
			}
			if(RT) {
				if(RenderTexture.active == RT) RenderTexture.active = null;
				RenderTexture.ReleaseTemporary(RT);
				RT = null;
			}
			probeQueue = null;
		}
		
		//state machine
		enum Stage {
			NEXTSKY,
			PRECAPTURE,
			CAPTURE,
			CONVOLVE,
			DONE
		};
		private Stage stage = Stage.DONE;
		
		//iterator for which face we're drawing this frame
		private int drawShot = 0;
		private int targetMip = 0;
		private int mipCount = 0;
		private int captureSize = 0;
		private bool captureHDR = true;
		private int progress = 0;
		private int progressTotal = 0;
		
		//camera axes for handling parented probe capture
		private Vector3 lookPos = Vector3.zero;
		private Quaternion lookRot = Quaternion.identity;
		
		private Vector3 forwardLook = Vector3.forward;
		private Vector3 rightLook = Vector3.right;
		private Vector3 upLook = Vector3.up;
		
		private class ProbeTarget {
			public Cubemap		cube = null;
			public bool 		HDR = false;
			public Vector3 		position = Vector3.zero;
			public Quaternion	rotation = Quaternion.identity;
		};
		private Queue<ProbeTarget> probeQueue = null;
		
		private int defaultCullMask = ~0;
		private Material sceneSkybox = null;
		private Material convolveSkybox = null;
		
		// Use this for initialization
		private void Start() {
			UpdateFaceTexture();
			convolveSkybox = new Material(Shader.Find("Hidden/Marmoset/RGBM Convolve"));
			convolveSkybox.name = "Internal Convolution Skybox";
		}
		
		private void Awake() {
			sceneSkybox = RenderSettings.skybox;		
			if(Camera.main != null) GetComponent<Camera>().CopyFrom(Camera.main);
		}
		
		public void QueueSkies(mset.Sky[] skiesToProbe) {
			if(this.probeQueue == null)	this.probeQueue = new Queue<ProbeTarget>();
			else 						this.probeQueue.Clear();
			foreach(mset.Sky sky in skiesToProbe) {
				if(sky != null && (sky.specularCube as Cubemap) != null) {
					QueueCubemap(sky.specularCube as Cubemap, sky.HDRSpec, sky.transform.position, sky.transform.rotation);
				}
			}
		}
		public void QueueCubemap(Cubemap cube, bool HDR, Vector3 pos, Quaternion rot) {
			if( cube != null ) {
				ProbeTarget target = new ProbeTarget();
				target.cube = cube;
				target.position = pos;
				target.rotation = rot;
				target.HDR = HDR;
				probeQueue.Enqueue(target);
				progressTotal++;
			}
		}
		private void ClearQueue() {
			this.probeQueue = null;
			progressTotal = 0;
			progress = 0;
		}
		
		public void RunQueue() {
			//mark end of queue with a null probe
			this.probeQueue.Enqueue(null);
			
			//uses same shader and importance sample table as SkyProbe class
			mset.SkyProbe.buildRandomValueTable();
			
			if(Camera.main != null) {
				GetComponent<Camera>().CopyFrom(Camera.main);
				defaultCullMask = GetComponent<Camera>().cullingMask;
			}
			
			foreach(Camera cam in Camera.allCameras) { cam.enabled = false; }
			
			GetComponent<Camera>().enabled = true;
			GetComponent<Camera>().fieldOfView = 90;
			GetComponent<Camera>().clearFlags = CameraClearFlags.Skybox;
			GetComponent<Camera>().cullingMask = defaultCullMask;
			GetComponent<Camera>().useOcclusionCulling = false;

			StartStage(Stage.NEXTSKY);
		}
		
		private void StartStage(Stage nextStage) {		
			if(this.probeQueue == null) {
				//designates an empty sky queue, we are done
				nextStage = Stage.DONE;
			}
			
			if(nextStage == Stage.NEXTSKY) {
				RenderSettings.skybox = this.sceneSkybox;
				//look for the next valid sky in the queue
				ProbeTarget pt = probeQueue.Dequeue();
				if(pt != null) {
					progress++;
					if(ProgressCallback != null && progressTotal > 0) {				
						ProgressCallback( (float)progress/(float)progressTotal );
					}
					targetCube = pt.cube;
					captureHDR = pt.HDR && (RT != null);
					lookPos = pt.position;
					lookRot = pt.rotation;
				} else {
					//last sky in the queue is null, we are done
					nextStage = Stage.DONE;
				}
			}
			
			if(nextStage == Stage.CAPTURE) {
				//throw away the first frame, the camera needs to stabilize first
				drawShot = -1;
				RenderSettings.skybox = this.sceneSkybox;
				this.targetMip = 0;
				this.captureSize = targetCube.width;
				this.mipCount = mset.QPow.Log2i(this.captureSize) - 1;
				GetComponent<Camera>().cullingMask = defaultCullMask;
			}
			
			if(nextStage == Stage.CONVOLVE) {
				Shader.SetGlobalVector("_UniformOcclusion", Vector4.one);
				drawShot = 0;
				this.targetMip = 1;
				if(this.targetMip < this.mipCount) {
					//render nothing but the background
					GetComponent<Camera>().cullingMask = 0;
					UnityEngine.RenderSettings.skybox = convolveSkybox;
					
					Matrix4x4 matrix = Matrix4x4.identity;
					//matrix.SetTRS(position, rotation, Vector3.one);			
					convolveSkybox.SetMatrix("_SkyMatrix", matrix);
					convolveSkybox.SetTexture("_CubeHDR", targetCube);
					
					//toggleKeywordPair("MARMO_LINEAR", "MARMO_GAMMA", this.linear);
					toggleKeywordPair("MARMO_RGBM_INPUT_ON", "MARMO_RGBM_INPUT_OFF", captureHDR && this.RT != null);
					toggleKeywordPair("MARMO_RGBM_OUTPUT_ON", "MARMO_RGBM_OUTPUT_OFF", captureHDR && this.RT != null);
					
					mset.SkyProbe.bindRandomValueTable(convolveSkybox, "_PhongRands", targetCube.width);
				}
			}
			
			if(nextStage == Stage.DONE) {
				RenderSettings.skybox = this.sceneSkybox;
				ClearQueue();
				FreeFaceTexture();
				if(DoneCallback != null) {
					
					DoneCallback();
					DoneCallback = null;
				}
			}
			stage = nextStage;
		}
		
		//pre-draw
		private void OnPreCull () {
			if(stage == Stage.CAPTURE || stage == Stage.CONVOLVE || stage == Stage.PRECAPTURE) {
				if(stage == Stage.CONVOLVE) {
					//prepare mip
					this.captureSize = 1 << (this.mipCount-this.targetMip);
					//float mipExp = 4f*captureSize;
					float mipExp = mset.QPow.clampedDownShift(this.maxExponent, (this.targetMip-1), 1);
					convolveSkybox.SetFloat("_SpecularExp", mipExp);
					convolveSkybox.SetFloat("_SpecularScale", this.convolutionScale);
				}
				if(stage == Stage.CAPTURE || stage == Stage.PRECAPTURE) {
					Shader.SetGlobalVector("_UniformOcclusion", this.exposures);
				}
				
				//setup camera
				int mapsize = this.captureSize;
				float xsize = (float)mapsize / Screen.width;
				float ysize = (float)mapsize / Screen.height;
				GetComponent<Camera>().rect = new Rect(0, 0, xsize, ysize);
				GetComponent<Camera>().pixelRect = new Rect(0, 0, mapsize, mapsize);
				
				this.transform.position = this.lookPos;
				this.transform.rotation = this.lookRot;
				
				if(stage == Stage.CAPTURE || stage == Stage.PRECAPTURE) {
					this.upLook = 		this.transform.up;
					this.forwardLook =	this.transform.forward;
					this.rightLook =	this.transform.right;
				} else {
					this.upLook = 		Vector3.up;
					this.forwardLook =	Vector3.forward;
					this.rightLook =	Vector3.right;
				}
				
				if(drawShot == 0)
				{
					transform.LookAt(lookPos + forwardLook, upLook);
				}
				else if(drawShot == 1)
				{
					transform.LookAt(lookPos - forwardLook, upLook);
					
				}
				else if(drawShot == 2)
				{
					transform.LookAt(lookPos - rightLook, upLook);
				}
				else if(drawShot == 3)
				{
					transform.LookAt(lookPos + rightLook, upLook);
				}
				else if(drawShot == 4)
				{
					transform.LookAt(lookPos + upLook, forwardLook);
				}
				else if(drawShot == 5)
				{
					transform.LookAt(lookPos - upLook, -forwardLook);
				}
				GetComponent<Camera>().ResetWorldToCameraMatrix();
			}
		}
		
		int frameID = 0;
		private void Update() {
			frameID++;
			if(RT && captureHDR && stage == Stage.CAPTURE) {
				//in-place state change to capture an HDR buffer and render it back in RGBM for the CAPTURE stage
				stage = Stage.PRECAPTURE;
				bool prevHDR = GetComponent<Camera>().hdr;
				GetComponent<Camera>().hdr = true;
				RenderTexture.active = RenderTexture.active;
				RenderTexture.active = RT;
				GetComponent<Camera>().targetTexture = RT;
				GetComponent<Camera>().Render();
				GetComponent<Camera>().hdr = prevHDR;
				GetComponent<Camera>().targetTexture = null;
				RenderTexture.active = null;
				
				stage = Stage.CAPTURE;
			}
		}
		
		//post-draw
		Material blitMat = null;
		private void OnPostRender () {
			//can't use OnRenderObject, it comes in the midst of tree billboard rendering
			//private void OnRenderObject() {
			if(captureHDR && RT && stage == Stage.CAPTURE) {
				int s = RT.width;
				int x = 0;
				int y = 0;
				if(!blitMat) blitMat = new Material(Shader.Find("Hidden/Marmoset/RGBM Blit"));
				toggleKeywordPair("MARMO_RGBM_INPUT_ON", "MARMO_RGBM_INPUT_OFF", false);
				toggleKeywordPair("MARMO_RGBM_OUTPUT_ON", "MARMO_RGBM_OUTPUT_OFF", true);
				GL.PushMatrix();
				GL.LoadPixelMatrix(0,s,s,0);
				Graphics.DrawTexture(new Rect(x,y,s,s), RT, blitMat);
				GL.PopMatrix();
			}
			
			if(stage == Stage.NEXTSKY) {
				if( targetCube != null ) {
					StartStage(Stage.CAPTURE);
					return;
				} else {
					StartStage(Stage.DONE);
					return;
				}
			}
			else if(stage == Stage.CAPTURE || stage == Stage.CONVOLVE) {
				int mapsize = this.captureSize;
				//convert LDR to HDR compiliant cubes as well
				bool convertHDR = !this.captureHDR; //this.captureHDR && RT == null;
				
				if( mapsize > Screen.width || mapsize > Screen.height ) {
					Debug.LogWarning("<b>Skipping Cubemap</b> - The viewport is too small (" + Screen.width + "x" + Screen.height + ") to probe the cubemap \"" + this.targetCube.name + "\" (" + mapsize + "x" + mapsize + ")");
					StartStage(Stage.NEXTSKY);
					return;
				}
				
				if(drawShot == 0)
				{
					faceTexture.ReadPixels(new Rect(0, 0, mapsize, mapsize), 0, 0);
					faceTexture.Apply();
					SetFacePixels(targetCube, CubemapFace.PositiveZ, faceTexture, targetMip, false, true, convertHDR);
				}
				else if(drawShot == 1)
				{
					faceTexture.ReadPixels(new Rect(0, 0, mapsize, mapsize), 0, 0);
					faceTexture.Apply();
					SetFacePixels(targetCube, CubemapFace.NegativeZ, faceTexture, targetMip, false, true, convertHDR);
				}
				else if(drawShot == 2)
				{
					faceTexture.ReadPixels(new Rect(0, 0, mapsize, mapsize), 0, 0);
					faceTexture.Apply();
					SetFacePixels(targetCube, CubemapFace.NegativeX, faceTexture, targetMip, false, true, convertHDR);
				}
				else if(drawShot == 3)
				{
					faceTexture.ReadPixels(new Rect(0, 0, mapsize, mapsize), 0, 0);
					faceTexture.Apply();
					SetFacePixels(targetCube, CubemapFace.PositiveX, faceTexture, targetMip, false, true, convertHDR);
				}
				else if(drawShot == 4)
				{
					faceTexture.ReadPixels(new Rect(0, 0, mapsize, mapsize), 0, 0);
					faceTexture.Apply();
					SetFacePixels(targetCube, CubemapFace.PositiveY, faceTexture, targetMip, true, false, convertHDR);
				}
				else if(drawShot == 5)
				{
					faceTexture.ReadPixels(new Rect(0, 0, mapsize, mapsize), 0, 0);
					faceTexture.Apply();
					SetFacePixels(targetCube, CubemapFace.NegativeY, faceTexture, targetMip, true, false, convertHDR);
					
					if(stage == Stage.CAPTURE) {
						targetCube.Apply(true,false);
						StartStage(Stage.CONVOLVE);
						return;
					} else {
						targetCube.Apply(false,false);
						this.targetMip++;
						if(this.targetMip < this.mipCount) {
							//next mip, stay in the same stage
							drawShot = 0;
							return;
						} else {
							//last mip
							StartStage(Stage.NEXTSKY);
							return;
						}
					}
				}
				drawShot++;
			}
		}
		
		//helper stuff
		private static void SetFacePixels(Cubemap cube, CubemapFace face, Texture2D tex, int mip, bool flipHorz, bool flipVert, bool convertHDR) {
			Color[] pixels = tex.GetPixels();
			Color temp = Color.black;
			
			Color[] dstPixels;
			int tw = tex.width >> mip;
			int th = tex.height >> mip;
			
			//we read a sub-rectangle of tex into the cubemap mip
			dstPixels = new Color[tw*th];
			for(int x=0; x<tw; ++x) {
				for(int y=0; y<th; ++y) {
					int i = x + y*tex.width;
					int dst_i = x + y*tw;
					dstPixels[dst_i] = pixels[i];
					//this forces LDR data to be compliant with HDR rendering by setting a lowest non-zero exposure in the alpha channel
					if(convertHDR)  dstPixels[dst_i].a = 1f/6f;
				}
			}
			
			if(flipHorz) {
				for(int x=0; x<tw/2; ++x) {
					for(int y=0; y<th; ++y) {
						int swap_x = tw - x - 1;
						int i = x + y*tw;
						int swap_i = swap_x + y*tw;
						temp = dstPixels[swap_i];
						dstPixels[swap_i] = dstPixels[i];
						dstPixels[i] = temp;
					}
				}
			}
			if(flipVert) {
				for(int x=0; x<tw; ++x) {
					for(int y=0; y<th/2; ++y) {
						int swap_y = th - y - 1;
						int i = x + y*tw;
						int swap_i = x + swap_y*tw;
						temp = dstPixels[swap_i];
						dstPixels[swap_i] = dstPixels[i];
						dstPixels[i] = temp;
					}
				}
			}
			cube.SetPixels(dstPixels, face, mip);
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
	}
}