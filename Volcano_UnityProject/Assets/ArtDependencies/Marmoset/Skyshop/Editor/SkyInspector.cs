// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using mset;

namespace mset {
	[CustomEditor(typeof(Sky))]
	public class SkyInspector : Editor {
		// Singleton cubemap references because Inspectors get
		// allocated like candy and this speeds up selection
		// exponentially.

		//Don't serialize singletons
		[NonSerialized] private static mset.CubemapGUI _refSKY = null;
		[NonSerialized] private static mset.CubemapGUI _refSIM = null;
		private static mset.CubemapGUI refSKY {
			get {
				if (_refSKY == null) {
					_refSKY = mset.CubemapGUI.create(mset.CubemapGUI.Type.SKY, true);
				} return _refSKY;
			}
		}
		private static mset.CubemapGUI refSIM {
			get {
				if (_refSIM == null) {
					_refSIM = mset.CubemapGUI.create(mset.CubemapGUI.Type.SIM, true);
				}
				return _refSIM;
			}
		}
				
		[SerializeField] private float camExposure = 1f;
		[SerializeField] private float masterIntensity = 1f;
		[SerializeField] private float skyIntensity = 1f;
		[SerializeField] private float diffIntensity = 1f;
		[SerializeField] private float specIntensity = 1f;
		
		[SerializeField] private float diffIntensityLM = 1f;
		[SerializeField] private float specIntensityLM = 1f;

		enum EditMode {
			TRANSFORM,
			PROBE,
			PROJECTOR,
			TRIGGER,
		};
		[SerializeField] private EditMode editMode = 0;

		[SerializeField] private Texture2D[] editIconListFull = null;
		[SerializeField] private Texture2D[] editIconListProj = null;
		[SerializeField] private Texture2D[] editIconListTrigger = null;
		[SerializeField] private Texture2D[] editIconListAdd = null;

		//used to keep track of the projection box position when moving the probe center around
		[SerializeField] private Vector3 projCenter = Vector3.zero;
		[SerializeField] private Vector3 appCenter = Vector3.zero;

		private static bool forceDirty = false;
		public  static void forceRefresh() { forceDirty = true; }

		public void OnEnable() {
			mset.Sky sky = target as mset.Sky;
			if(sky.SH == null) sky.SH = new mset.SHEncoding();

			camExposure = sky.CamExposure;
			masterIntensity = sky.MasterIntensity;
			skyIntensity =  sky.SkyIntensity;
			diffIntensity = sky.DiffIntensity;
			specIntensity = sky.SpecIntensity;
			diffIntensityLM = sky.DiffIntensityLM;
			specIntensityLM = sky.SpecIntensityLM;
			
			refSKY.HDR = sky.HDRSky;
			refSIM.HDR = sky.HDRSpec;

			refSKY.sky = sky;
			refSIM.sky = sky;

			if(sky.HasDimensions)	projCenter = sky.Dimensions.center;
			else 					projCenter = sky.transform.position;

			mset.SkyApplicator app = sky.gameObject.GetComponent<mset.SkyApplicator>();
			if(app) appCenter = app.TriggerDimensions.center;
			else 	appCenter = sky.transform.position;
			//forceDirty = true;
		}
		
		public void OnDisable() {
		}
		
		public void OnDestroy() {
			System.GC.Collect();
		}
		
		private static bool skyToGUI(Texture skyCube, bool skyHDR, mset.SHEncoding skySH, mset.CubemapGUI cubeGUI, bool updatePreview) {
			bool dirty = false;
			bool dirtyGUI = false;
			
			//sky -> cubeGUI
			dirtyGUI |= cubeGUI.HDR != skyHDR;
			cubeGUI.HDR = skyHDR;

			RenderTexture RT = skyCube as RenderTexture;
			if(cubeGUI.input != skyCube) {
				if(RT) {
					cubeGUI.setReference(RT, RT.useMipMap);
				} 
				else if(skyCube) {
					string path = AssetDatabase.GetAssetPath(skyCube);
					cubeGUI.setReference(path, cubeGUI.mipmapped);
				}
				else {
					cubeGUI.clear();
				}
				//dirty = true;
			}

			if(RT && skySH != null) {
				if(cubeGUI.SH != null && !skySH.equals(cubeGUI.SH)) {
					cubeGUI.SH.copyFrom(skySH);
					//dirty = true;
				}
			}

			if( dirtyGUI && updatePreview ) {
				cubeGUI.updatePreview();
			}
			return dirty;
		}

		private static bool GUIToSky(ref Texture skyCube, ref bool skyHDR, mset.SHEncoding skySH, mset.CubemapGUI cubeGUI) {
			//cubeGUI -> sky
			bool prevHDR = cubeGUI.HDR;
			Texture prevInput = cubeGUI.input;
			cubeGUI.drawGUI();
			
			skyCube = cubeGUI.input;
			skyHDR = cubeGUI.HDR;

			bool dirty = false;

			//copy spherical harmonics if they've changed
			if( skySH != null ) {
				if(cubeGUI.SH == null) {
					skySH.clearToBlack();
					dirty = true;
				} else if(!skySH.equals(cubeGUI.SH)) {
					skySH.copyFrom(cubeGUI.SH);
					dirty = true;
				}
			}

			//return true if the cubeGUI gui changed any parameters
			dirty |= prevHDR != cubeGUI.HDR;
			dirty |= prevInput != cubeGUI.input;	
			return dirty;
		}

		public static void detectColorSpace(ref mset.Sky sky) {
			sky.LinearSpace = PlayerSettings.colorSpace == ColorSpace.Linear;
			#if UNITY_IPHONE || UNITY_ANDROID
				sky.LinearSpace = false; // no sRGB on mobile
			#endif
		}

		public static void generateSH(ref mset.Sky sky) {
			skyToGUI(sky.skyboxCube, sky.HDRSky, null, refSKY, false);
			skyToGUI(sky.specularCube, sky.HDRSpec, null, refSIM, false);
			
			if( refSIM.cube != null ) {
				refSIM.update();
				//refSIM.updateBuffers(); //Slow. Surely this is done after every change?
				sky.SH.copyFrom( refSIM.SH );
				mset.SHUtil.convolve(ref sky.SH);
			}
			//Don't compute from the sky, it's going to be very slow
			/*else if( refSKY.cube != null ) {
				refSKY.update();
				//refSKY.updateBuffers(); //Slow. Surely this is done after every change?
				sky.SH.copyFrom( refSKY.SH );
				mset.SHUtil.convolve(ref sky.SH);
			}*/

			if( sky.SH != null ) {
				sky.SH.copyToBuffer();
			}
		}

		float xscale = 1;
		float x2scale = 1;
		float yscale = 1;
		float y2scale = 1;
		float zscale = 1;
		float z2scale = 1;

	//	Vector3 dotPos;
		public void OnSceneGUI(){
			mset.Sky sky = target as mset.Sky;

			if(this.editMode == EditMode.TRIGGER) return;

			if(sky.HasDimensions) {
				Vector3 campos = Vector3.zero;
				if(Camera.current != null) campos = Camera.current.transform.position;

				Vector3 skyScale = sky.transform.lossyScale;
				if(skyScale.x == 0) skyScale.x = 0.001f;
				if(skyScale.y == 0) skyScale.y = 0.001f;
				if(skyScale.z == 0) skyScale.z = 0.001f;

				xscale = x2scale = sky.Dimensions.size.x * 0.5f * skyScale.x;
				yscale = y2scale = sky.Dimensions.size.y * 0.5f * skyScale.y;
				zscale = z2scale = sky.Dimensions.size.z * 0.5f * skyScale.z;

				if( this.editMode == EditMode.PROJECTOR ) {
					Handles.color = new Color(0.2f, 0.8f, 1f, 0.9f);
					Vector3 dotpos;

					Vector3 boxcenter = sky.transform.localToWorldMatrix.MultiplyPoint(sky.Dimensions.center);

					dotpos = boxcenter + xscale * sky.transform.right;
					dotpos = Handles.Slider(dotpos, sky.transform.right, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
					xscale = ((dotpos - boxcenter)).magnitude;
					
					dotpos = boxcenter + x2scale * -sky.transform.right;
					dotpos = Handles.Slider(dotpos, -sky.transform.right, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
					x2scale = ((dotpos - boxcenter)).magnitude;

					dotpos = boxcenter + yscale * sky.transform.up;
					dotpos = Handles.Slider(dotpos, sky.transform.up, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
					yscale = ((dotpos - boxcenter)).magnitude;

					dotpos = boxcenter + y2scale * -sky.transform.up;
					dotpos = Handles.Slider(dotpos, -sky.transform.up, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
					y2scale = ((dotpos - boxcenter)).magnitude;

					dotpos = boxcenter + zscale * sky.transform.forward;
					dotpos = Handles.Slider(dotpos, sky.transform.forward, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
					zscale = ((dotpos - boxcenter)).magnitude;

					dotpos = boxcenter + z2scale * -sky.transform.forward;
					dotpos = Handles.Slider(dotpos, -sky.transform.forward, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
					z2scale = ((dotpos - boxcenter)).magnitude;

					float xposDiff = sky.Dimensions.size.x - (xscale / skyScale.x) * 2 - (sky.Dimensions.size.x - (x2scale / skyScale.x) * 2);
					float yposDiff = sky.Dimensions.size.y - (yscale / skyScale.y) * 2 - (sky.Dimensions.size.y - (y2scale / skyScale.y) * 2);
					float zposDiff = sky.Dimensions.size.z - (zscale / skyScale.z) * 2 - (sky.Dimensions.size.z - (z2scale / skyScale.z) * 2);

					Bounds dim = sky.Dimensions;
					dim.center += new Vector3(-xposDiff*0.25f, -yposDiff*0.25f, -zposDiff*0.25f);
					dim.size = new Vector3((xscale + x2scale) / skyScale.x, (yscale + y2scale) / skyScale.y, (zscale + z2scale) / skyScale.z);

					if(!dim.center.Equals(sky.Dimensions.center) || !dim.size.Equals(sky.Dimensions.size)) {
						Undo.RecordObject(sky, "Sky Projection Resize");
						sky.Dimensions = dim;
						mset.SkyManager mgr = mset.SkyManager.Get();
						if(mgr && mgr.EditorAutoApply) mgr.EditorApplySkies(true);
					}
				}
			}

			mset.SkyApplicator app = sky.gameObject.GetComponent<mset.SkyApplicator>();
			if(this.editMode == EditMode.PROBE) {
				//moving probe around, recompute local-space sky dimensions from world-space, cached centers
				Bounds dim = sky.Dimensions;
				dim.center = sky.transform.worldToLocalMatrix.MultiplyPoint(projCenter);

				if( dim.center != sky.Dimensions.center ) {
					if(app) {
						UnityEngine.Object[] undoList = {sky, app};
						Undo.RecordObjects(undoList, "Probe Center Move");
					} else {
						Undo.RecordObject(sky, "Probe Center Move");
					}
				}

				sky.Dimensions = dim;
				if(app) {
					dim = app.TriggerDimensions;
					dim.center = sky.transform.worldToLocalMatrix.MultiplyPoint(appCenter);
					app.TriggerDimensions = dim;
				}
			} else {
				//moving everything around, cache world-space centers of bounds
				projCenter = sky.transform.localToWorldMatrix.MultiplyPoint(sky.Dimensions.center);
				if(app) appCenter = sky.transform.localToWorldMatrix.MultiplyPoint(app.TriggerDimensions.center);
				else 	appCenter = sky.transform.position;
			}
		}

		public override void OnInspectorGUI() {
			GUI.changed = false;
			bool dirty = false;		//flag for changed sky parameters
			bool dirtyRef = false;	//flag for changed sky cubemap references (causes SH recompute and preview refresh)

			mset.Sky sky = target as mset.Sky;
			mset.SkyApplicator app = sky.gameObject.GetComponent<mset.SkyApplicator>();			
			mset.SkyManager skymgr = mset.SkyManager.Get();

			//sync GUI from sky
			camExposure = sky.CamExposure;
			masterIntensity = sky.MasterIntensity;
			skyIntensity = sky.SkyIntensity;
			diffIntensity = sky.DiffIntensity;
			specIntensity = sky.SpecIntensity;
			diffIntensityLM = sky.DiffIntensityLM;
			specIntensityLM = sky.SpecIntensityLM;
			
			//sync and sync from CubeGUIs

			dirtyRef |= skyToGUI(sky.skyboxCube, sky.HDRSky, sky.SH, refSKY, true);
			bool prevHDR = sky.HDRSky;
			bool currHDR = sky.HDRSky;
			dirtyRef |= GUIToSky(ref sky.skyboxCube, ref currHDR, null, 	 refSKY);
			if(currHDR != prevHDR) sky.HDRSky = currHDR;


			dirtyRef |= skyToGUI(sky.specularCube, sky.HDRSpec, sky.SH, refSIM, true);
			prevHDR = sky.HDRSpec;
			currHDR = sky.HDRSpec;
			dirtyRef |= GUIToSky(ref sky.specularCube,  ref currHDR, sky.SH, refSIM);
			if(currHDR != prevHDR) sky.HDRSpec = currHDR;

			GUIStyle buttonStyle = new GUIStyle("Button");
			buttonStyle.padding.top = buttonStyle.padding.bottom = 0;
			buttonStyle.padding.left = buttonStyle.padding.right = 0;

			EditorGUILayout.Space();
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			EditorGUILayout.Space();

			GUILayout.BeginHorizontal();
			//Global button
			if(skymgr != null) {
				bool alreadyGlobal = skymgr.GlobalSky == sky;
				EditorGUI.BeginDisabledGroup(alreadyGlobal);
				bool setAsGlobal = GUILayout.Button(new GUIContent("Make Global Sky","Sets this sky as the global sky in the Sky Manager."), GUILayout.Width(120));
				if(setAsGlobal) {
					skymgr.GlobalSky = sky;
					SceneView.RepaintAll();
				}
				EditorGUI.EndDisabledGroup();
			}
			//Local Apply button
			EditorGUI.BeginDisabledGroup( app == null || !app.TriggerIsActive );
			string trigTip = "Applies this sky locally only to renderers contained within its Sky Applicator trigger volume.";
			if(app == null || !app.TriggerIsActive) trigTip = "Requires Sky Applicator component with active trigger.";

			if( GUILayout.Button(new GUIContent("Preview Apply", trigTip), GUILayout.Width(100)) ) {
				Renderer[] all = GameObject.FindObjectsOfType<Renderer>();
				foreach(Renderer r in all) {
					app.ApplyInside(r);
				}
			}
			EditorGUI.EndDisabledGroup();			
			GUILayout.EndHorizontal();

			//color detection is (hopefully) not a thing anymore
			/*
			bool detect = EditorGUILayout.Toggle(new GUIContent("Auto-Detect Color Space","If enabled, attempts to detect the project's gamma correction setting and enables/disables the Linear Space option accordingly"), sky.AutoDetectColorSpace);
			if( detect != sky.AutoDetectColorSpace ) {
				mset.EditorUtil.RegisterUndo(sky, "Color-Space Detection Change");
				sky.AutoDetectColorSpace = detect;
			}			
			bool prevLinear = sky.LinearSpace;
			*/
			if( sky.AutoDetectColorSpace ) {
				detectColorSpace(ref sky);
			}


			/*
			EditorGUI.BeginDisabledGroup(sky.AutoDetectColorSpace);
				bool userLinearSpace = EditorGUILayout.Toggle(new GUIContent("Linear Space","Enable if gamma correction is enabled for this project (Edit -> Project Settings -> Player -> Color Space: Linear)"), sky.LinearSpace);
				if( userLinearSpace != sky.LinearSpace ) {
					mset.EditorUtil.RegisterUndo(sky, "Color-Space Change");
					sky.LinearSpace = userLinearSpace;
				}
			EditorGUI.EndDisabledGroup();
			if( prevLinear != sky.LinearSpace ){
			//	dirty = true;
			}
			*/

			sky.IsProbe = EditorGUILayout.Toggle(new GUIContent("Is Probe", "Enable if this sky has been rendered from within the scene. The \"Probe All Skies\" feature will only process skies marked as probes."), sky.IsProbe);

			bool prevProj = sky.HasDimensions;
			bool boxProj = EditorGUILayout.Toggle(new GUIContent("Box Projected", "Use transform scale as the box projection dimensions of this sky. Only affects box-projected shaders for now."), sky.HasDimensions);
			if( boxProj != prevProj ) {
				mset.EditorUtil.RegisterUndo(sky, "Box Projection Toggle");
				sky.HasDimensions = boxProj;
			}

			bool hasTrigger = app && app.TriggerIsActive;

			EditMode prevMode = editMode;
			EditorGUILayout.Space();
			Bounds dim = sky.Dimensions;
			dim.center = EditorGUILayout.Vector3Field("Projector Center", dim.center);
			dim.size = EditorGUILayout.Vector3Field("Projector Size", dim.size);
			sky.Dimensions = dim;

			EditorGUILayout.Space();
			EditorGUILayout.Space();

			GUIStyle style = new GUIStyle();
			style.richText = true;
			GUILayout.Label("<b>Viewport Edit Mode</b>", style);

			if( editIconListFull == null ) {
				editIconListFull = new Texture2D[] {
					Resources.Load<Texture2D>("editTrans"),
					Resources.Load<Texture2D>("editProbe"),
					Resources.Load<Texture2D>("editProjection"),
					Resources.Load<Texture2D>("editTrigger")
				};

				editIconListAdd = new Texture2D[] {
					editIconListFull[0],
					editIconListFull[1],
					Resources.Load<Texture2D>("addProjection"),
					Resources.Load<Texture2D>("addTrigger")
				};

				editIconListProj = new Texture2D[] {
					editIconListFull[0],
					editIconListFull[1],
					editIconListFull[2],
					editIconListAdd[3] //no trigger
				};

				editIconListTrigger = new Texture2D[] {
					editIconListFull[0],
					editIconListFull[1],
					editIconListAdd[2], //no projection
					editIconListFull[3]
				};
			}

			int barWidth = 340;
							
			//reset edit mode if we've lost the tools we need for this sky configuration
			if(editMode == EditMode.PROJECTOR && !boxProj) editMode = EditMode.TRANSFORM;
			if(editMode == EditMode.TRIGGER && !hasTrigger) editMode = EditMode.TRANSFORM;

			if(hasTrigger && boxProj) {
				editMode = (EditMode)GUILayout.Toolbar((int)editMode, editIconListFull,	GUILayout.Width(barWidth));
			} else if(boxProj) {
				editMode = (EditMode)GUILayout.Toolbar((int)editMode, editIconListProj,	GUILayout.Width(barWidth));
			} else if(hasTrigger) {
				editMode = (EditMode)GUILayout.Toolbar((int)editMode, editIconListTrigger,	GUILayout.Width(barWidth));
			} else {
				editMode = (EditMode)GUILayout.Toolbar((int)editMode, editIconListAdd,	GUILayout.Width(barWidth));
			}

			if( !boxProj && editMode == EditMode.PROJECTOR ) {
				boxProj = true;
				sky.HasDimensions = true;
				editMode = EditMode.PROJECTOR;
			}

			if( !hasTrigger && editMode == EditMode.TRIGGER) {
				hasTrigger = true;
				if( !app ) app = sky.gameObject.AddComponent<mset.SkyApplicator>();
				app.TriggerIsActive = true;
			}

			EditorGUILayout.BeginHorizontal(GUILayout.Width(barWidth));
			GUILayout.Label("Transform", GUILayout.Width(82));
			GUILayout.Label("Probe Origin", GUILayout.Width(82));
			if(boxProj) GUILayout.Label("Projector", GUILayout.Width(86));
			else 		GUILayout.Label("Add Projector", GUILayout.Width(86));
			if(hasTrigger)	GUILayout.Label("Trigger", GUILayout.Width(60));
			else 			GUILayout.Label("Add Trigger", GUILayout.Width(80));
			EditorGUILayout.EndHorizontal();
		
			//edit mode has changed, sync or sync from stored bound centers
			if( prevMode != editMode ) {
				projCenter = sky.transform.localToWorldMatrix.MultiplyPoint(sky.Dimensions.center);
				if(app) {
					appCenter = sky.transform.localToWorldMatrix.MultiplyPoint(app.TriggerDimensions.center);
				} else {
					appCenter = sky.transform.position;
				}
			}
			//turn on applicator resize handle drawing
			mset.SkyApplicatorInspector.triggerEdit = editMode == EditMode.TRIGGER;
					
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			
			//sync sky from GUI
			EditorGUILayout.LabelField(new GUIContent("Master Intensity","Multiplier on the Sky, Diffuse, and Specular cube intensities"));
			masterIntensity = EditorGUILayout.Slider(masterIntensity, 0f, 10f);
			if(sky.MasterIntensity != masterIntensity) {
				mset.EditorUtil.RegisterUndo(sky,"Intensity Change");
				sky.MasterIntensity = masterIntensity;
			}
			
			EditorGUILayout.LabelField(new GUIContent("Skybox Intensity", "Brightness of the skybox"));
			skyIntensity = EditorGUILayout.Slider(skyIntensity, 0f, 10f);
			if(sky.SkyIntensity != skyIntensity) {
				mset.EditorUtil.RegisterUndo(sky,"Intensity Change");
				sky.SkyIntensity = skyIntensity;
			}
			
			EditorGUILayout.LabelField(new GUIContent("Diffuse Intensity", "Multiplier on the diffuse light put out by this sky"));
			diffIntensity = EditorGUILayout.Slider(diffIntensity, 0f, 10f);
			if(sky.DiffIntensity != diffIntensity) {
				mset.EditorUtil.RegisterUndo(sky,"Intensity Change");
				sky.DiffIntensity = diffIntensity;
			}
			
			EditorGUILayout.LabelField(new GUIContent("Specular Intensity", "Multiplier on the specular light put out by this sky"));
			specIntensity = EditorGUILayout.Slider(specIntensity, 0f, 10f);
			if(sky.SpecIntensity != specIntensity) {
				mset.EditorUtil.RegisterUndo(sky,"Intensity Change");
				sky.SpecIntensity = specIntensity;
			}
			
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			
			EditorGUILayout.LabelField(new GUIContent("Camera Exposure","Multiplier on all light coming into the camera, including IBL, direct light, and glow maps"));
			camExposure = EditorGUILayout.Slider(camExposure, 0f, 10f);
			if(sky.CamExposure != camExposure) {
				mset.EditorUtil.RegisterUndo(sky,"Exposure Change");
				sky.CamExposure = camExposure;
			}
			
			EditorGUILayout.Space();
			EditorGUILayout.Space();
			
			EditorGUILayout.LabelField(new GUIContent("Lightmapped Diffuse Multiplier", "Multiplier on the diffuse intensity for lightmapped surfaces"));
			diffIntensityLM = EditorGUILayout.Slider(diffIntensityLM, 0f, 1f);
			if(sky.DiffIntensityLM != diffIntensityLM) {
				mset.EditorUtil.RegisterUndo(sky,"Multiplier Change");
				sky.DiffIntensityLM = diffIntensityLM;
			}
			
			EditorGUILayout.LabelField(new GUIContent("Lightmapped Specular Multiplier", "Multiplier on the specular intensity for lightmapped surfaces"));
			specIntensityLM = EditorGUILayout.Slider(specIntensityLM, 0f, 1f);
			if(sky.SpecIntensityLM != specIntensityLM) {
				mset.EditorUtil.RegisterUndo(sky,"Multiplier Change");
				sky.SpecIntensityLM = specIntensityLM;
			}

			dirty |= GUI.changed;

			if( forceDirty ) {
				refSKY.reloadReference();
				refSIM.reloadReference();

				dirtyRef = true;
				forceDirty = false;
				dirty = true;
				Repaint();
			}
					
			//guess input path
			if( dirtyRef ) {				
				string inPath = refSKY.fullPath;
				if( inPath.Length == 0 ) inPath = refSIM.fullPath;
				if( inPath.Length > 0 ) {
					int uscore = inPath.LastIndexOf("_");
					if( uscore > -1 ) {
						inPath = inPath.Substring(0,uscore);
					} else {
						inPath = Path.GetDirectoryName(inPath) + "/" + Path.GetFileNameWithoutExtension(inPath);
					}
					refSKY.inputPath = 
					refSIM.inputPath = inPath;
				} else {
					refSKY.inputPath = 
					refSIM.inputPath = "";
				}
				dirty = true;
			}

			if(GUI.changed) {
				EditorUtility.SetDirty(target);
			}

			//reapply and repaint with manager
			mset.SkyManager mgr = mset.SkyManager.Get();

			if( !Application.isPlaying ) {
				if( mgr && mgr.GlobalSky == sky ) {
					sky.Apply();
					mgr.EditorApplySkies(true);
					SceneView.RepaintAll();
				}

				if( dirty ) {
					if(mgr && mgr.EditorAutoApply) {
						mgr.EditorApplySkies(true);
						SceneView.RepaintAll();
					}
				}
			}
		}
	};
}