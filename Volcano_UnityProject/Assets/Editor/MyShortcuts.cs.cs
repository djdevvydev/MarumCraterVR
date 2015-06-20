using UnityEditor;
using UnityEngine;

public class MyShortcuts : Editor
{
	[MenuItem("GameObject/ActiveToggle _a")]
	static void ToggleActivationSelection()
	{
		var go = Selection.activeGameObject;
		go.SetActive(!go.activeSelf);
	}
}