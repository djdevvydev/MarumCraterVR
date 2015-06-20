#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using System.Collections;

[CustomEditor(typeof(DisableEnableChildrenScript))]
public class DisableEnableChildrenEditor : Editor
{

    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        DisableEnableChildrenScript myScript = (DisableEnableChildrenScript)target;
        if (GUILayout.Button("Disable Children!"))
        {
            myScript.DisableAllChildren();
        }
        if (GUILayout.Button("Enable Children!"))
        {
            myScript.EnableAllChildren();
        }
    }

}
#endif