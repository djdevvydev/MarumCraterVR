// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using UnityEditor;
using System.Collections;

namespace mset
{
	[CustomEditor(typeof(mset.SkyAnchor))]
	public class SkyAnchorInspector : Editor
	{
		private mset.SkyAnchor myanchor;
		public void OnEnable() {
			myanchor = (mset.SkyAnchor)target;
		}

		[SerializeField]
		bool skyPickMode = false;
		mset.Sky[] currentSkies;

		
		public void OnSceneGUI()
		{
			if(myanchor.BindType == mset.SkyAnchor.AnchorBindType.Offset)
			{
				Vector3 prevPos = myanchor.transform.localToWorldMatrix.MultiplyPoint3x4(myanchor.AnchorOffset);
				Quaternion rot = Tools.pivotRotation == PivotRotation.Local ? myanchor.transform.rotation : Quaternion.identity;
				Vector3 pos = Handles.DoPositionHandle(prevPos, rot);

				myanchor.HasChanged = false;
				if(!pos.Equals(prevPos)) {
					Undo.RecordObject(myanchor, "Sky Anchor Change");
					myanchor.HasChanged = true;
					myanchor.AnchorOffset = myanchor.transform.worldToLocalMatrix.MultiplyPoint3x4(pos);
				}
			}
		}

	//	SerializedProperty damageProp;
		public override void OnInspectorGUI()
		{
			serializedObject.Update();

			GUI.changed = false;
			mset.SkyAnchor.AnchorBindType nubind = (mset.SkyAnchor.AnchorBindType)EditorGUILayout.EnumPopup(
				new GUIContent(	"Sky Bind Type","Sky Bind Type -\n"+myanchor.BindType),
				(mset.SkyAnchor.AnchorBindType)myanchor.BindType,
				GUILayout.Width(300)
			);
			myanchor.HasChanged = myanchor.BindType != nubind;
			myanchor.BindType = nubind;

			if(myanchor.BindType == mset.SkyAnchor.AnchorBindType.Center)
			{
				myanchor.HasChanged |= myanchor.transform.hasChanged;
			}
			else if(myanchor.BindType == mset.SkyAnchor.AnchorBindType.Offset)
			{
				Vector3 offset = EditorGUILayout.Vector3Field("Local Offset", myanchor.AnchorOffset);
				myanchor.HasChanged |= !myanchor.AnchorOffset.Equals(offset);
				myanchor.AnchorOffset = offset;
			}
			else if(myanchor.BindType == mset.SkyAnchor.AnchorBindType.TargetTransform)
			{
				Transform targetT = (Transform)EditorGUILayout.ObjectField(myanchor.AnchorTransform, typeof(Transform), true);

				myanchor.HasChanged |= (targetT != myanchor.AnchorTransform);
				if(targetT) myanchor.HasChanged |= targetT.hasChanged;
				myanchor.AnchorTransform = targetT;
			}
			else if(myanchor.BindType == SkyAnchor.AnchorBindType.TargetSky)  //sky bind
			{
				mset.Sky prevSky = myanchor.AnchorSky;
		//		myanchor.AnchorSky = (mset.Sky)EditorGUILayout.ObjectField(myanchor.AnchorSky, typeof(mset.Sky), true);
				skyPickMode = true;
				if(!skyPickMode)
				{
					skyPickMode = GUILayout.Button("Pick Sky", GUILayout.Width(100));
					if(skyPickMode)
					{
					}
				}
				else
				{
					currentSkies = GameObject.FindObjectsOfType<mset.Sky>();
					if(currentSkies != null && currentSkies.Length == 0)
					{
						GUILayout.Label("No Skies in Scene", GUILayout.Width(200));
					}
					else if(myanchor.AnchorSky == null)
					{
						foreach(mset.Sky _sky in currentSkies)
						{
							if(GUILayout.Button(_sky.transform.name, GUILayout.Width(200)))
							{
								myanchor.AnchorSky = _sky;
							}
						}
					}
					else
					{
						EditorGUILayout.ObjectField(myanchor.AnchorSky, typeof(mset.Sky), true, GUILayout.Width(200));
						if(GUILayout.Button("Change", GUILayout.Width(150)))
						{
							myanchor.AnchorSky = null;
						}
					}
				}
				myanchor.HasChanged |= prevSky != myanchor.AnchorSky;
			}
			if(GUI.changed) EditorUtility.SetDirty(target);
		}
	}
}