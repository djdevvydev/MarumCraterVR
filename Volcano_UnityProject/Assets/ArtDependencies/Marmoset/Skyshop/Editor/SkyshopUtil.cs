// Marmoset Skyshop
// Copyright 2013 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using System.Xml;
using System.Text;
using System.Collections; 
using System.Collections.Generic; 

//A collection of handy menu functions 
public class SkyshopUtil {	
	[MenuItem("Edit/Skyshop/Probe All Skies",false,1000)]
	public static void ProbeAllSkies(){	
		bool probeAll = false;
		bool probeIBL = true;
		Probeshop.ProbeSkies(null, GameObject.FindObjectsOfType<mset.Sky>(), probeAll, probeIBL, null);
	}

	[MenuItem("Edit/Skyshop/Probe Selected Skies",false,1001)]
	public static void ProbeSelSkies(){	
		bool probeAll = false;
		bool probeIBL = true;
		Probeshop.ProbeSkies(Selection.gameObjects, null, probeAll, probeIBL, null);
	}

	[MenuItem("Edit/Skyshop/Refresh Terrains %#t",false,1002)]
	public static void RefreshTerrains() {
		UnityEngine.Terrain[] terrains = UnityEngine.Object.FindObjectsOfType(typeof(Terrain)) as Terrain[];
		Debug.Log(terrains.Length + " terrains found");
		for( int i=0; i<terrains.Length; ++i ) {
			Terrain terr = terrains[i];
			/*Debug.Log(terr.terrainData.treePrototypes.Length + " trees found");
			for(int j=0; j<terr.terrainData.treePrototypes.Length; ++j) {
				TreePrototype tp = terr.terrainData.treePrototypes[j];
				Tree tree = tp.prefab.GetComponent<Tree>();
			}*/
			terr.terrainData.RefreshPrototypes();
		}
	}

	[MenuItem("Edit/Skyshop/Refresh Scene Skies %#r",false,1003)]
	public static void RefreshSkies() {
		mset.Sky[] skies = UnityEngine.Object.FindObjectsOfType(typeof(mset.Sky)) as mset.Sky[];

		mset.SkyManager mgr = mset.SkyManager.Get();
		mset.Sky currSky;
		if(mgr) currSky = mgr.GlobalSky;
		else 	currSky = null;

		if( skies.Length > 0 ) {
			Debug.Log("Refreshing " + skies.Length + " skies");
			mset.EditorUtil.RegisterUndo(skies as UnityEngine.Object[], "Refresh Skies");
			for(int i=0; i<skies.Length; ++i) {
				mset.Sky sky = skies[i];
				if( sky != null ) {
					//If this sky is an instance of a prefab, edit the prefab itself. 
					UnityEngine.Object po = PrefabUtility.GetPrefabParent(sky);
					mset.Sky psky = null;
					if(po && PrefabUtility.GetPrefabType(po) != PrefabType.None) {
						GameObject pgo = po as GameObject;
						psky = po as mset.Sky;
						if(pgo) {
							Debug.Log("Updating prefab GameObject: " + pgo.name);
							psky = pgo.GetComponent<mset.Sky>(); 
						} else if(psky) {
							Debug.Log("Updating prefab Sky " + psky.name);
						} else {
							Debug.Log ("No Sky found in prefab instance " + sky.name);
						}
					}

					if(psky) {
						mset.SkyInspector.detectColorSpace(ref psky);
						mset.SkyInspector.generateSH(ref psky);
						PrefabUtility.ResetToPrefabState(sky);
					} else {
						mset.SkyInspector.detectColorSpace(ref sky);
						mset.SkyInspector.generateSH(ref sky);
					}
					sky.Apply();
				}
			}
			if( currSky ) currSky.Apply();
		}
	}
		
	private static bool conversionWarning(string scope, bool toMobile)					 { return conversionWarning(scope,toMobile,-1); }
	private static bool conversionWarning(string scope, bool toMobile, int initialCount) {
		string shaderType = ""; 
		if( toMobile ) shaderType = "Marmoset Mobile";
		else           shaderType = "Marmoset Standard";
		
		string text = 
			"Converting all Marmoset materials in "+scope+" to use "+shaderType+
			" shaders may take several minutes and *cannot* be undone.\n\nAre you sure you wish to continue?";
		
		if( initialCount != -1 ) text = initialCount + " total materials found in " + scope + ".\n\n" + text;
		
		return EditorUtility.DisplayDialog(
			"Convert all Marmoset materials in "+scope+" to " + shaderType + "?", text,
			"Continue","Cancel");
	}

	[MenuItem("Edit/Skyshop/Convert Scene to Mobile", false, 1100)]
	public static void SceneToMobile() {
		toggleSceneToMobile(true);
	}
	
	[MenuItem("Edit/Skyshop/Convert Scene to Standard", false, 1101)]
	public static void SceneToStandard() {
		toggleSceneToMobile(false);
	}

	[MenuItem("Edit/Skyshop/Convert Project to Mobile", false, 1200)]
	public static void ProjectToMobile() {
		toggleProjectToMobile(true);	
	}
	
	[MenuItem("Edit/Skyshop/Convert Project to Standard", false, 1201)]
	public static void ProjectToStandard() {
		toggleProjectToMobile(false);	
	}

	
	// // //
	
	[MenuItem("Edit/Skyshop/Convert Scene to Marmoset Trees", false, 1300)]
	public static void SceneToMarmoTrees() {
		toggleSceneToMarmoTrees(true);	
	}
	
	[MenuItem("Edit/Skyshop/Convert Scene to Unity Trees", false, 1301)]
	public static void SceneToUnityTrees() {
		toggleSceneToMarmoTrees(false);	
	}
	
	[MenuItem("Edit/Skyshop/Convert Project to Marmoset Trees", false, 1400)]
	public static void ProjectToMarmoTrees() {
		toggleProjectToMarmoTrees(true);	
	}
	
	[MenuItem("Edit/Skyshop/Convert Project to Unity Trees", false, 1401)]
	public static void ProjectToUnityTrees() {
		toggleProjectToMarmoTrees(false);	
	}
	
	// // //
	
	//returns true only if the material is a marmoset one and requires toggling to or from mobile
	private static bool needsToggleMobile(Material mat, bool toMobile) {
		string name = mat.shader.name;
		string marmoPrefix = "Marmoset/";
		string mobilePrefix = "Marmoset/Mobile/";
		bool marmoset = name.StartsWith(marmoPrefix);
		
		if( marmoset ) {
			bool isMobile = name.StartsWith(mobilePrefix);
			return isMobile != toMobile; //requires toggling if target doesn't match current state
		}
		return false;
	}
	
	//converts one material to or from using marmoset mobile shaders
	private static bool toggleMobile(ref Material mat, bool toMobile) {
		string name = mat.shader.name;
		string marmoPrefix = "Marmoset/";
		string mobilePrefix = "Marmoset/Mobile/";
		
		//shader type is derived from the name prefix
		bool marmoset = name.StartsWith(marmoPrefix);
		if( marmoset ) {
			bool isMobile = name.StartsWith(mobilePrefix);
			//change prefix to desired string
			if( toMobile && !isMobile ) {
				name = mobilePrefix + name.Substring(marmoPrefix.Length);
			} else if( !toMobile && isMobile ) {
				name = marmoPrefix + name.Substring(mobilePrefix.Length);
			} else {
				return false;
			}
			
			//swap!
			Shader newShader = Shader.Find(name);
			if(newShader) {
				mat.shader = newShader;
				return true;
			}
		}
		return false;
	}

	//converts one material to or from using marmoset mobile shaders
	private static bool toggleMarmoTrees(ref Material mat, bool toMarmo) {
		string name = mat.shader.name;
		string marmoPrefix, unityPrefix;
		marmoPrefix = "Marmoset/Nature/Tree";
		unityPrefix = "Nature/Tree";

		//shader type is derived from the name prefix
		bool isUnity = name.StartsWith(unityPrefix);
		bool isMarmo = name.StartsWith(marmoPrefix);
		//change prefix to desired string
		if( !toMarmo && isMarmo ) {
			name = unityPrefix + name.Substring(marmoPrefix.Length);
		} else if( toMarmo && isUnity ) {
			name = marmoPrefix + name.Substring(unityPrefix.Length);
		} else {
			return false;
		}
		
		//swap!
		Shader newShader = Shader.Find(name);
		if(newShader) {
			mat.shader = newShader;
			return true;
		}
		return false;
	}
	
	//converts all materials referenced by the current scene to or from marmoset mobile shaders
	private static void toggleSceneToMobile(bool toMobile) {
		//warn the user before changing a bunch of material files
		bool k = conversionWarning("this scene", toMobile);
		if(!k) return;
		
		//go through all renderers in the scene and change their materials to use mobile shaders 
		Renderer[] all = GameObject.FindObjectsOfType(typeof(Renderer)) as Renderer[];
		int count = 0;
		for(int i=0; i<all.Length; ++i) {
			Renderer r = all[i];
			if(r) {
				Material[] mats = r.sharedMaterials;
				for(int m=0; m<mats.Length; ++m) {
					if( toggleMobile(ref mats[m], toMobile) ) count++;
				}
			}
		}
		if( toMobile )  EditorUtility.DisplayDialog("Done Converting!", count + " Marmoset materials converted to Marmoset Mobile materials.", "Ok");
		else            EditorUtility.DisplayDialog("Done Converting!", count + " Marmoset Mobile materials converted to Marmoset Standard materials.", "Ok");
	}
	
	private static void toggleProjectToMobile(bool toMobile) {
		string[] all = AssetDatabase.GetAllAssetPaths();		
		//count material files in the asset database
		int matCount = 0;
		for(int i=0; i<all.Length; ++i) {
			if( Path.GetExtension(all[i]).ToLowerInvariant() == ".mat" ) {
				matCount++;
			}
		}
		//warn the user before changing a whole bunch of material files
		bool k = conversionWarning("this project", toMobile, matCount); 
		if( !k ) return;
		
		// go through all material assets in the asset database and convert their shaders
		int count = 0;
		for(int i=0; i<all.Length; ++i) {
			if( Path.GetExtension(all[i]).ToLowerInvariant() == ".mat" ) {
				Material mat = AssetDatabase.LoadAssetAtPath(all[i], typeof(Material)) as Material;
				if(mat) {
					if( toggleMobile(ref mat, toMobile) ) count++;
				}
			}
		}
		if(count > 0 ) AssetDatabase.Refresh();
		if( toMobile ) {
			EditorUtility.DisplayDialog("Done Converting!", count + " materials switched to using Marmoset Mobile shaders.", "Ok");
		} else {
			EditorUtility.DisplayDialog("Done Converting!", count + " materials switched to using Marmoset Standard shaders.", "Ok");
		}
		//for good measure
		RefreshSkies();
	}

	//converts all materials referenced by the current scene to or from marmoset mobile shaders
	private static void toggleSceneToMarmoTrees(bool toMarmo) {
		//warn the user before changing a bunch of material files
		bool k = conversionWarning("this scene", toMarmo);
		if(!k) return;
		
		//go through all renderers in the scene and change their materials to use mobile shaders 
		Renderer[] all = GameObject.FindObjectsOfType(typeof(Renderer)) as Renderer[];
		int count = 0;
		for(int i=0; i<all.Length; ++i) {
			Renderer r = all[i];
			if(r) {
				Material[] mats = r.sharedMaterials;
				for(int m=0; m<mats.Length; ++m) {
					if( toggleMarmoTrees(ref mats[m], toMarmo) ) count++;
				}
			}
		}
		if( toMarmo )  EditorUtility.DisplayDialog("Done Converting!", count + " Unity Trees converted to Marmoset Tree materials.", "Ok");
		else           EditorUtility.DisplayDialog("Done Converting!", count + " Marmoset Trees converted to Unity Tree materials.", "Ok");

		RefreshTerrains();
	}

	private static void toggleProjectToMarmoTrees(bool toMarmo) {
		string[] all = AssetDatabase.GetAllAssetPaths();		
		//count material files in the asset database
		int matCount = 0;
		for(int i=0; i<all.Length; ++i) {
			if( Path.GetExtension(all[i]).ToLowerInvariant() == ".mat" ) {
				matCount++;
			}
		}

		//warn the user before changing a whole bunch of material files
		bool k = conversionWarning("this project", toMarmo, matCount); 
		if( !k ) return;
		
		// go through all material assets in the asset database and convert their shaders
		int count = 0;
		for(int i=0; i<all.Length; ++i) {
			if( Path.GetExtension(all[i]).ToLowerInvariant() == ".mat" ) {
				Material mat = AssetDatabase.LoadAssetAtPath(all[i], typeof(Material)) as Material;
				if(mat) {
					//if( toggleMarmoTrees(ref mat, toMarmo) ) { count++; }
					if( toggleMarmoTrees(ref mat, toMarmo) ) count++;
				}
			}
		}
		if(count > 0 ) AssetDatabase.Refresh();
		if( toMarmo ) {
			EditorUtility.DisplayDialog("Done Converting!", count + " materials switched to using Marmoset Tree shaders.", "Ok");
		} else {
			EditorUtility.DisplayDialog("Done Converting!", count + " materials switched to using Unity Tree shaders.", "Ok");
		}

		RefreshTerrains();

		//for good measure
		RefreshSkies();
	}
}