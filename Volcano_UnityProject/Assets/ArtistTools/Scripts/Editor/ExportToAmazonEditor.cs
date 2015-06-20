using UnityEngine;
using UnityEditor;
using System.IO;
using System.Threading;


[CustomEditor(typeof(ExportToAmazonScript))]
public class ExportToAmazonEditor : Editor
{
    private string tmpSceneFile = "";
    private string assetBundlePath = "";

    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        ExportToAmazonScript myScript = (ExportToAmazonScript)target;

        //display properties as uneditable labels
        GUILayout.BeginVertical();
        {
            GUILayout.BeginHorizontal();
            GUILayout.Label("bucketName");
            GUILayout.Label(myScript.bucketName);
            GUILayout.Space(10f);
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
            GUILayout.Label("cognitoRegion");
            GUILayout.Label(myScript.cognitoRegion.ToString());
            GUILayout.Space(10f);
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
            GUILayout.Label("s3Region");
            GUILayout.Label(myScript.s3Region.ToString());
            GUILayout.Space(10f);
            GUILayout.EndHorizontal();

            GUILayout.BeginHorizontal();
            GUILayout.Label("cognitoIdentityPool");
            GUILayout.Label(myScript.cognitoIdentityPool.ToString());
            GUILayout.Space(10f);
            GUILayout.EndHorizontal();
        }

        if (GUILayout.Button("Make Asset Bundle!"))
        {
            if (!InitializeAmazonFilePaths(myScript.assetBundleName))
            {
                Debug.LogError("Unable to save out scene, could not upload to S3.");
                return;
            }
            //save out tmp scene
            if (!SaveOutScene())
            {
                Debug.LogError("Ran into error trying to save out scene.");
                return;
            }

            //convert scene into asset bundle
            if (!SaveOutAssetBundle(myScript))
            {
                Debug.LogError("Unable to save out scene, could not upload to S3.");
                return;
            }
        }
        GUILayout.EndVertical();

        if (GUILayout.Button("Upload Asset Bundle to Amazon!"))
        {

            //check that we are not in the middle of another export
            if (myScript.uploadLock)
            {
                Debug.LogError("Cannot start another upload until previous one finishes!");
                return;
            }
            
            if (!EditorApplication.isPlaying)
            {
                Debug.LogError("You must Play the UnityEditor first in order to upload to Amazon S3!");
                return;
            }


            if (!InitializeAmazonFilePaths(myScript.assetBundleName))
            {
                Debug.LogError("Unable to save out scene, could not upload to S3.");
                return;
            }
            myScript.upload(assetBundlePath);
        }
    }

    public bool InitializeAmazonFilePaths(string assetBundleName)
    {
        if (assetBundleName == "")
        {
            Debug.LogError("Must provide a name or path for unity3d file to be save and uploaded!");
            return false;
        }

        string[] exportDirParts = { "Assets", "Scenes", "amazonExportTmpFiles" };
        string amazonExportDir = string.Join(Path.DirectorySeparatorChar.ToString(), exportDirParts);
        if (!Directory.Exists(amazonExportDir))
        {
            Directory.CreateDirectory(amazonExportDir);
        }

        tmpSceneFile = amazonExportDir + Path.DirectorySeparatorChar + assetBundleName + ".unity";
        assetBundlePath = amazonExportDir + Path.DirectorySeparatorChar + assetBundleName + ".unity3d";

        return true;
    }

    public bool SaveOutScene()
    {
        //TODO - clean up gameobjects that do not have ExportToAmazonScript component

        return EditorApplication.SaveScene(tmpSceneFile, true);
    }

    public bool SaveOutAssetBundle(ExportToAmazonScript exportScript)
    {
        if (tmpSceneFile.Length != 0)
        {
            string[] scenes = { tmpSceneFile };
            //TODO - check that the BuildTarget type is correct
            Debug.Log("scenes: " + scenes.Length + ": " + scenes[0]);
            Debug.Log("assetBundlePath: " + assetBundlePath);
            BuildPipeline.BuildStreamedSceneAssetBundle(scenes, assetBundlePath, BuildTarget.StandaloneWindows);
            Debug.Log("END building!!!");
            return true;
        }


        return false;

        //TODO - when switch to unity 5, need to replace this with AssetBundle build system
        //BuildPipeline.BuildAssetBundle(exportScript.gameObject, null, exportScript.assetBundlePath);
        //Debug.Log("Saved file as: " + exportScript.assetBundlePath);
        //return true;
    }

}
