#if UNITY_EDITOR
using UnityEngine;
using UnityEditor;
using System.Collections;

[CustomEditor(typeof(DisableEnableThisNodeScript))]
public class DisableEnableThisNodeEditor : Editor
{

    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        DisableEnableThisNodeScript myScript = (DisableEnableThisNodeScript)target;
        if (GUILayout.Button("Disable This Node!"))
        {
            myScript.DisableThisNode();
        }
        if (GUILayout.Button("Enable This Node!"))
        {
            myScript.EnableThisNode();
        }
    }

}
#endif