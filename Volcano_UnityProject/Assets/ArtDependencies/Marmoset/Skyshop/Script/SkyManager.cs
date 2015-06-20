// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.CompilerServices;

namespace mset {
	[ExecuteInEditMode()]
	public class SkyManager : MonoBehaviour {
		//SkyManager can be treated as a singleton. Its instance comes from the scene hierarchy and is cached here.
		private static mset.SkyManager _Instance = null;
		public static mset.SkyManager Get() {
			if(_Instance == null) _Instance = GameObject.FindObjectOfType<mset.SkyManager>();
			return _Instance;
		}
					
		//CONFIG		
		public bool LinearSpace = true;

		[SerializeField]
		private bool _BlendingSupport = true;
		public bool BlendingSupport {
			get { return _BlendingSupport; }
			set {
				_BlendingSupport = value;
				//no blending support in edit mode
				#if UNITY_EDITOR
					if(Application.isPlaying) {
						mset.Sky.EnableBlendingSupport(value);
						if(!value) mset.Sky.EnableTerrainBlending(false); //turn terrain blending off in case it was ever on
					}
				#else
					mset.Sky.EnableBlendingSupport(value);
					if(!value) mset.Sky.EnableTerrainBlending(false); //turn terrain blending off in case it was ever on
				#endif
			}
		}

		[SerializeField]
		private bool _ProjectionSupport = true;
		public bool ProjectionSupport {
			get { return _ProjectionSupport; }
			set { _ProjectionSupport = value; mset.Sky.EnableProjectionSupport(value); }
		}

		public bool GameAutoApply = true;
		public bool	EditorAutoApply = true;

		//GLOBAL SKY & BLENDING
		[SerializeField]
		private mset.Sky _GlobalSky = null;
		public mset.Sky GlobalSky {
			get { return _GlobalSky; }
			set { 
				#if UNITY_EDITOR
					if(Application.isPlaying) {
						BlendToGlobalSky(value, 0f);
					} else {
						_GlobalSky = value;
					}
				#else
					BlendToGlobalSky(value, 0f);
				#endif
			}
		}
		public void BlendToGlobalSky(mset.Sky next) { BlendToGlobalSky(next, GlobalBlendTime); }
		public void BlendToGlobalSky(mset.Sky next, float blendTime) {
			if(next != null) {
				nextSky = next;
				#if UNITY_EDITOR
				nextBlendTime = Application.isPlaying ? blendTime : 0f;
				#else
				nextBlendTime = blendTime;
				#endif
			}
			//??? Harmless but weird? where did this come from?
			_GlobalSky = nextSky;
		}

		[SerializeField]
		private SkyBlender GlobalBlender = new mset.SkyBlender();
		private mset.Sky nextSky = null;
		private float nextBlendTime = 0f;
		public float LocalBlendTime = 0.25f;
		public float GlobalBlendTime = 0.25f;

		//DIRECT-LIGHT BLENDING
		//keep track of lights and target intensities for them when blending
		private Light[] prevLights = null;
		private Light[] nextLights = null;
		private float[] prevIntensities = null;
		private float[] nextIntensities = null;

		private void ResetLightBlend() {
			if( nextLights != null) {
				for(int i=0; i<nextLights.Length; ++i) {
					nextLights[i].intensity = nextIntensities[i];
					nextLights[i].enabled = true;
				}
				nextLights = null;
				nextIntensities = null; 
			} 
			if( prevLights != null ) {
				for(int i=0; i<prevLights.Length; ++i) {
					prevLights[i].intensity = prevIntensities[i];
					prevLights[i].enabled = false;
				}
				prevLights = null;
				prevIntensities = null;
			}
		}

		private void StartLightBlend(mset.Sky prev, mset.Sky next) {
			//get a list of lights and intensities from the sky we're blending away from
			prevLights = null;
			prevIntensities = null;
			if(prev) {
				prevLights = prev.GetComponentsInChildren<Light>();
				if(prevLights != null && prevLights.Length > 0) {
					prevIntensities = new float[prevLights.Length];
					for(int i=0; i<prevLights.Length; ++i) {
						prevLights[i].enabled = true;
						prevIntensities[i] = prevLights[i].intensity;
					}
				} 
			}

			nextLights = null;
			nextIntensities = null;
			if(next) {
				nextLights = next.GetComponentsInChildren<Light>();
				if(nextLights != null && nextLights.Length > 0) {
					nextIntensities = new float[nextLights.Length];
					for(int i=0; i<nextLights.Length; ++i) {
						nextIntensities[i] = nextLights[i].intensity;
						nextLights[i].enabled = true;
						nextLights[i].intensity = 0f;
					}
				}
			}
		}

		private void UpdateLightBlend() {
			if( this.GlobalBlender.IsBlending ) {
				float nextWeight = this.GlobalBlender.BlendWeight;
				float prevWeight = 1f - nextWeight;
				
				for(int i=0; i<prevLights.Length; ++i) {
					prevLights[i].intensity = prevWeight * prevIntensities[i];
				}
				
				for(int i=0; i<nextLights.Length; ++i) {
					nextLights[i].intensity = nextWeight * nextIntensities[i];
				}
			} else {
				//done blending, reset.
				ResetLightBlend();
			}
		}

		//delayed setup for blending between global skies
		private void HandleGlobalSkyChange() {
			//Switch skies
			if( nextSky != null ) {
				ResetLightBlend();
				if( BlendingSupport && nextBlendTime > 0f ) {
					//BLEND
					mset.Sky currSky = GlobalBlender.CurrentSky;
					GlobalBlender.BlendTime = nextBlendTime;
					GlobalBlender.BlendToSky(nextSky);

					mset.Sky[] allSkies = GameObject.FindObjectsOfType<mset.Sky>();
					foreach(mset.Sky sky in allSkies) {
						sky.ToggleChildLights(false);
					}
					
					StartLightBlend(currSky, nextSky);
				} else {
					//SNAP
					GlobalBlender.SnapToSky(nextSky);
					nextSky.Apply(0);
					nextSky.Apply(1);
					mset.Sky[] allSkies = GameObject.FindObjectsOfType<mset.Sky>();
					foreach(mset.Sky sky in allSkies) {
						sky.ToggleChildLights(false);
					}
					nextSky.ToggleChildLights(true);
				}

				_GlobalSky = nextSky;
				nextSky = null;

				if(!Application.isPlaying) {
					this.EditorApplySkies(true);
				}
			}

			//Update
			UpdateLightBlend();
		}

		//SKYBOX
		private Material _SkyboxMaterial = null;
		private Material SkyboxMaterial {
			get {
				if(_SkyboxMaterial == null) {
					_SkyboxMaterial = Resources.Load<Material>("skyboxMat");
					if(!_SkyboxMaterial) Debug.LogError("Failed to find skyboxMat material in Resources folder!");
				}
				return _SkyboxMaterial;
			}
		}

		[SerializeField]
		private bool _ShowSkybox = true;
		public bool ShowSkybox {
			get { return _ShowSkybox; }
			set {
				if(value && SkyboxMaterial) {
					if(RenderSettings.skybox != SkyboxMaterial) RenderSettings.skybox = SkyboxMaterial;
				} else if(RenderSettings.skybox != null) {
					//only clear skyboxes we've set
					if(RenderSettings.skybox == _SkyboxMaterial || RenderSettings.skybox.name == "Internal IBL Skybox") { //name check is for legacy scenes
						RenderSettings.skybox = null;
					}
				}
				_ShowSkybox = value;
			}
		}

		//AUTO-APPLY
		private HashSet<Renderer> staticRenderers = new HashSet<Renderer>();
		private HashSet<Renderer> dynamicRenderers = new HashSet<Renderer>();
		private HashSet<Renderer> globalSkyChildren = new HashSet<Renderer>();
		private HashSet<mset.SkyApplicator> skyApplicators = new HashSet<mset.SkyApplicator>();

		// Use this for initialization
		void Start() {
			if(_GlobalSky == null) _GlobalSky = gameObject.GetComponent<mset.Sky>();
			if(_GlobalSky == null) _GlobalSky = GameObject.FindObjectOfType<mset.Sky>();
			GlobalBlender.SnapToSky(_GlobalSky);
			//force some setters and getters to run
			_SkyboxMaterial = SkyboxMaterial;		//get
			ShowSkybox = _ShowSkybox;				//set
			BlendingSupport = _BlendingSupport; 	//set
			ProjectionSupport = _ProjectionSupport; //set
		}

		public void RegisterApplicator(mset.SkyApplicator app) {
			skyApplicators.Add(app);
			foreach(Renderer rend in dynamicRenderers) {
				app.RendererInside(rend);
			}
			foreach(Renderer rend in staticRenderers) {
				app.RendererInside(rend);
			}
		}

		public void UnregisterApplicator(mset.SkyApplicator app, HashSet<Renderer> renderersToClear) {
			skyApplicators.Remove(app);
			foreach(Renderer rend in renderersToClear) {
				if(_GlobalSky != null) _GlobalSky.Apply(rend);
			}
		}

		public void RegisterNewRenderer(Renderer rend) {
			if(rend.gameObject.activeInHierarchy && !dynamicRenderers.Contains(rend) && !staticRenderers.Contains(rend)) {
				if(rend.gameObject.isStatic) {
					staticRenderers.Add(rend);
					ApplyCorrectSky(rend);
				} else {
					dynamicRenderers.Add(rend);
					if(rend.GetComponent<mset.SkyAnchor>() == null) {
						rend.gameObject.AddComponent(typeof(mset.SkyAnchor));
					}
				}
			}
		}

		public void SeekNewRenderers() {
			object[] renderers = FindObjectsOfType(typeof(Renderer));
			for(int iter = 0; iter < renderers.Length; iter++) {
				Renderer rend = ((Renderer)renderers[iter]);
				RegisterNewRenderer(rend);
			}
		}

		public void ApplyCorrectSky(Renderer rend) {
			bool localCube = false;

			//if the anchor is a direct link to a sky, ignore applicators all together
			mset.SkyAnchor anchor = rend.GetComponent<SkyAnchor>();
			if(anchor && anchor.BindType == SkyAnchor.AnchorBindType.TargetSky) {
				anchor.Apply();
				localCube = true;	
			}

			//look for localized applicators to bind this renderer to
			foreach(mset.SkyApplicator app in skyApplicators) {
				if(localCube) app.RemoveRenderer(rend);
				else if(app.RendererInside(rend)) localCube = true;
			}

			//no local applicator found, but we have a global sky
			if(!localCube && _GlobalSky != null) {
				if(anchor != null) {
					if(anchor.CurrentApplicator != null) {
						anchor.CurrentApplicator.RemoveRenderer(rend);
						anchor.CurrentApplicator = null;
					}
					//start last blend to global sky and tell the anchor it's gone global
					anchor.BlendToGlobalSky(_GlobalSky);
				} else {
					_GlobalSky.Apply(rend);
				}

				if(!globalSkyChildren.Contains(rend)) globalSkyChildren.Add(rend);
			}

			//if a local cube was found or there is no global sky, remove rend
			if(localCube || _GlobalSky == null) { 
				if(globalSkyChildren.Contains(rend)) {
					globalSkyChildren.Remove(rend);
				}
			}
		}

		private void EditorUpdate() {
			//blending will not work in the editor viewport, this only complicates things.
			mset.Sky.EnableBlendingSupport(false);
			mset.Sky.EnableTerrainBlending(false);
			if(_GlobalSky) {
				_GlobalSky.Apply(0);
				_GlobalSky.Apply(1);
				if(SkyboxMaterial) {
					_GlobalSky.Apply(SkyboxMaterial, 0);
					_GlobalSky.Apply(SkyboxMaterial, 1);
				}
				_GlobalSky.Dirty = false;
			}
			HandleGlobalSkyChange();
			if(EditorAutoApply) EditorApplySkies(false);
		}

		//Brute-force through all applicators and test all renderers against them. This method is used in editor mode because
		//it does not rely on SkyAnchors being added to everything that gets touched.
		public void EditorApplySkies(bool forceApply) {
			Shader.SetGlobalVector("_UniformOcclusion", Vector4.one);

			Renderer[] rends = GameObject.FindObjectsOfType<Renderer>();
			mset.SkyApplicator[] apps = GameObject.FindObjectsOfType<mset.SkyApplicator>();			

			foreach(Renderer rend in rends) {
				if(!rend.gameObject.activeInHierarchy) continue;

				//HACK: force clear all property blocks just in case
				if(forceApply) {
					MaterialPropertyBlock pb = new MaterialPropertyBlock();
					pb.Clear();
					rend.SetPropertyBlock(pb);
				}

				mset.SkyAnchor anchor = rend.gameObject.GetComponent<mset.SkyAnchor>();
				if(anchor && !anchor.enabled) anchor = null;
				
				bool rendHasChanged = rend.transform.hasChanged || (anchor && anchor.HasChanged);
				bool localFound = false;
				
				if(anchor && anchor.BindType == mset.SkyAnchor.AnchorBindType.TargetSky) {
					anchor.Apply();
					localFound = true;
				}
				//trigger stuff is only processed if the game will auto apply as well
				if(GameAutoApply && !localFound) {
					foreach(mset.SkyApplicator app in apps) {
						if(!app.gameObject.activeInHierarchy) continue;
						if(app.TargetSky) {
							if(forceApply || app.HasChanged || app.TargetSky.Dirty || rendHasChanged) {
								localFound |= app.ApplyInside(rend);
								app.TargetSky.Dirty = false;
							}
						}
						app.HasChanged = false;
					}
				}
				
				if(!localFound && _GlobalSky) {
					if(forceApply || _GlobalSky.Dirty || rendHasChanged) {
						_GlobalSky.Apply(rend);
					}
				}
				//HACK: we are checking and clearing hasChanged in a weird place during the editor loop. Hopefully that won't conflict with other plugins?
				rend.transform.hasChanged = false;
				if(anchor) anchor.HasChanged = false;
			}

			//this is always called in EditorUpdate, only run if forced externally
			if(forceApply && _GlobalSky) {
				_GlobalSky.Apply();
				if(_SkyboxMaterial) {
					_GlobalSky.Apply(_SkyboxMaterial, 0);
				}
				_GlobalSky.Dirty = false;
			}
		}
		
		// Update is called once per frame
		private float seekTimer = 0f;
		private float lastTimestamp = -1f;
		private int renderCheckIterator = 0;
		private bool firstFrame = true;

		#if UNITY_EDITOR
		public void Update() {
			if(!Application.isPlaying) EditorUpdate();
		}
		#endif

		public void LateUpdate() {
			if(firstFrame) {
				if(_GlobalSky) {
					firstFrame = false;
					_GlobalSky.Apply(0);
					_GlobalSky.Apply(1);

					if(_SkyboxMaterial) {
						_GlobalSky.Apply(_SkyboxMaterial, 0);
						_GlobalSky.Apply(_SkyboxMaterial, 1);
					}
				}
			}

			#if UNITY_EDITOR
			if(!Application.isPlaying) return;
			#endif

			float dt = 0f;
			if(lastTimestamp > 0 ) dt = Time.realtimeSinceStartup - lastTimestamp;
			lastTimestamp = Time.realtimeSinceStartup;
			seekTimer -= dt;

			HandleGlobalSkyChange();
			GameApplySkies(false);
		}

		public void GameApplySkies(bool forceApply) {
			GlobalBlender.ApplyToTerrain();
			GlobalBlender.Apply();
			if(_SkyboxMaterial) GlobalBlender.Apply(_SkyboxMaterial);

			if( this.GameAutoApply || forceApply ) {
				if(seekTimer <= 0 || forceApply) {
					SeekNewRenderers();
					seekTimer = 0.5f;
				}

				List<mset.SkyApplicator> skiesToRemove = new List<mset.SkyApplicator>();
				foreach(mset.SkyApplicator app in skyApplicators) {
					if(app == null || app.gameObject == null) skiesToRemove.Add(app); //clear deleted skys (if that ever happens...)
				}
				foreach(mset.SkyApplicator app in skiesToRemove) {
					skyApplicators.Remove(app);
				}
			
				foreach(Renderer rend in globalSkyChildren) {
					if(!rend) continue;
					GlobalBlender.Apply(rend);
				}
			
				int renderCheckCount = 0;
				int currentIterator = 0;
				List<Renderer> rendsToRemove = new List<Renderer>();
				foreach(Renderer rend in dynamicRenderers) 
				{
					currentIterator++;
					if(!forceApply && currentIterator < renderCheckIterator) {
						continue;
					}

					if(rend == null || rend.gameObject == null) {
						rendsToRemove.Add(rend); //clear deleted renderers (this will totally happen)
					}
					else {
						renderCheckIterator++;
						if(!forceApply && renderCheckCount > 50) {
							renderCheckCount = 0;
							renderCheckIterator--;
							break;
						}

						mset.SkyAnchor anchor = rend.GetComponent<mset.SkyAnchor>();
						if(anchor.HasChanged) {
							renderCheckCount++;
							anchor.HasChanged = false;
							ApplyCorrectSky(rend);
						}
					}
				}
				foreach(Renderer rend in rendsToRemove) {
					dynamicRenderers.Remove(rend);
				}

				if(renderCheckIterator >= dynamicRenderers.Count) {
					renderCheckIterator = 0;
				}
			}
		}

		#if UNITY_EDITOR
		private void DrawDoubleLine(Vector3 a, Vector3 b, float width_a, float width_b) {
			if( Camera.current != null ) {
				Vector3 screen_a = Vector3.zero;
				Vector3 screen_b = Vector3.zero;
				Vector3 delta = Vector3.zero;
				Vector3 delta_a = Vector3.zero;
				Vector3 delta_b = Vector3.zero;

				screen_a = Camera.current.WorldToScreenPoint(a);
				screen_b = Camera.current.WorldToScreenPoint(b);
				delta = (screen_b-screen_a);
				delta = Vector3.Cross(delta, Vector3.forward);
				delta = delta.normalized;
				delta_a = a - Camera.current.ScreenToWorldPoint(screen_a + delta*width_a);
				delta_b = b - Camera.current.ScreenToWorldPoint(screen_b + delta*width_b);
				Gizmos.DrawLine(a + delta_a, b + delta_b);
				Gizmos.DrawLine(a - delta_a, b - delta_b);
			} else {
				Gizmos.DrawLine(a, b);
			}
		}

		//HACK: get DrawGizmos to call first EditorUpdate() because the editor window sure won't >_<
		private bool NeedsGizmoUpdate = true;
		private int FrameCounter = 0;

		public void OnDrawGizmos() {
			if(!Application.isPlaying && NeedsGizmoUpdate) {
				if(FrameCounter > 2 ) NeedsGizmoUpdate = false;
				EditorUpdate();
				if(EditorAutoApply) {
					//force it for good measure, without this coming back from play == local skies
					EditorApplySkies(true);
				}
				FrameCounter++;
			}

			Vector3 pos = transform.position;
			if(this.GetComponent<mset.Sky>() != null) pos.y += 1f;
			Gizmos.DrawIcon(pos, "manager.tga", true);


			//draw hierarchy of skies
			mset.Sky[] skies = GameObject.FindObjectsOfType<mset.Sky>();
			Gizmos.color = new Color(0.4f, 1f, 0.7f, 0.4f);
			Vector3 a = Vector3.zero;
			Vector3 b = Vector3.zero;

			for(int i=0;   i<skies.Length; ++i)
			for(int j=i+1; j<skies.Length; ++j) {
				a = skies[i].transform.position;
				b = skies[j].transform.position;
				Gizmos.color = new Color(0.4f, 0.7f, 1f, 0.4f);
				if 		(skies[i].transform.parent == skies[j].transform) DrawDoubleLine(a,b, 0f, 4f);
				else if (skies[j].transform.parent == skies[i].transform) DrawDoubleLine(b,a, 0f, 4f);
			}
		}
		#endif

		//PROBING
		#if UNITY_EDITOR
		public mset.Sky[] SkiesToProbe = null;
		public Vector4 ProbeExposures = Vector4.one;
		public bool ProbeWithCubeRT = true;

		//Probes all skies in list of skies, and all sky components in list of game objects. Either list can be null when convenient.
		//If probeAll is false, only skies marked as "Is Probe" are considered
		public void ProbeSkies(GameObject[] objects, mset.Sky[] skies, bool probeAll, bool probeIBL) {		
			int skipCount = 0;
			List<mset.Sky> probes = new List<mset.Sky>();
			string notProbes = "";
			if(skies != null) {
				foreach(mset.Sky sky in skies) {
					if(sky) {
						if(probeAll || sky.IsProbe) probes.Add(sky);
						else {
							skipCount++;
							notProbes += sky.name + "\n";
						}
					}
				}
			}
			if(objects != null) {
				foreach(GameObject obj in objects) {
					mset.Sky sky = obj.GetComponent<mset.Sky>();
					if(sky) {
						if(probeAll || sky.IsProbe) probes.Add(sky);
						else {
							skipCount++;
							notProbes += sky.name + "\n";
						}
					}
				}
			}
			if(skipCount > 0) {
				bool k = UnityEditor.EditorUtility.DisplayDialog(skipCount + " skies not probes", "The following skies are not marked as probes and will be skipped:\n"+notProbes, "Ok", "Cancel");
				if(!k) return;
			}
			if(probes.Count > 0) {				
				this.ProbeExposures = probeIBL ? Vector4.one : Vector4.zero;
				this.SkiesToProbe = new mset.Sky[probes.Count];
				for(int i = 0; i < probes.Count; ++i) {
					this.SkiesToProbe[i] = probes[i];
				}
			}
		}
		#endif
	}
}
