// Place this script in an Editor folder
// Builds an asset bundle from the selected objects in the project view.
// Once compiled go to "Menu" -> "Assets"
// to build the Asset Bundle

using UnityEngine;
using UnityEditor;
using System.IO;

public class ExportSceneAsAssetBundle {
	[MenuItem("Assets/Build Scene As AssetBundle From Selection - Track dependencies")]
	static void ExportResource () {
		// Bring up save panel
		string path = EditorUtility.SaveFilePanel ("Save Resource", "", "New Resource", "unity3d");
		if (path.Length != 0) {
			// Build the resource file from the active selection.
			// TODO: test with multiple scenes, test with scripts
			Object[] selection = Selection.GetFiltered(typeof(Object), SelectionMode.DeepAssets);
			string assetPath = AssetDatabase.GetAssetPath (Selection.activeObject);
			
			// check if it is a scene file (.unity extension, there is no scene type)
			string extension = Path.GetExtension(assetPath);
			Debug.Log(extension);
			bool isScene = string.Equals(extension, ".unity");
			if(isScene)
			{
				string[] scenes  = {assetPath};
				// Export Asset
				BuildPipeline.BuildStreamedSceneAssetBundle(scenes, path, BuildTarget.StandaloneWindows); 
			}
			else
			{
				Debug.Log("Selection is not a scene");
			}
			// if you want to export a prefab instead of a scene
			//            BuildPipeline.BuildAssetBundle(Selection.activeObject, selection, path, 
			//                                         BuildAssetBundleOptions.CollectDependencies | BuildAssetBundleOptions.CompleteAssets);
			
		}
	}
}