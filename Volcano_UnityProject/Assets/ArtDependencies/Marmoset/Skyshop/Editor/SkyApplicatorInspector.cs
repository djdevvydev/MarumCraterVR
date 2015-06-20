using UnityEngine;
using UnityEditor;
using System.Collections;

namespace mset
{
	[CustomEditor(typeof(SkyApplicator))]
	public class SkyApplicatorInspector : Editor
	{
		private mset.SkyApplicator myapp;
		public void OnEnable() {
			myapp = target as mset.SkyApplicator;
		}

		public override void OnInspectorGUI() {
			GUI.changed = false;
			myapp = this.target as mset.SkyApplicator;

			bool isActive = EditorGUILayout.Toggle(new GUIContent("Use Trigger"), myapp.TriggerIsActive);
			myapp.HasChanged = myapp.TriggerIsActive != isActive;
			myapp.TriggerIsActive = isActive;

			if(myapp.TriggerIsActive) {
				EditorGUILayout.Space();
				Bounds dim = myapp.TriggerDimensions;
				dim.center = EditorGUILayout.Vector3Field("Trigger Center", dim.center);
				dim.size = EditorGUILayout.Vector3Field("Trigger Dimensions", dim.size);
				myapp.TriggerDimensions = dim;
				if(!Application.isPlaying) SceneView.RepaintAll();
			}
			if(GUI.changed) EditorUtility.SetDirty(target);
		}
		
		public void OnHierarchyChange(){
			myapp = this.target as mset.SkyApplicator;
			myapp.HasChanged = true;
		}
		
		float xscale = 1;
		float x2scale = 1;
		float yscale = 1;
		float y2scale = 1;
		float zscale = 1;
		float z2scale = 1;
		//	Vector3 dotPos;

		public static bool triggerEdit = false;
		public void OnSceneGUI(){
			myapp = this.target as mset.SkyApplicator;

			if(mset.SkyApplicatorInspector.triggerEdit && myapp.TriggerIsActive)
			{
				mset.Sky sky = myapp.GetComponent<mset.Sky>();
				Vector3 campos = Vector3.zero;
				if(Camera.current != null) campos = Camera.current.transform.position;

				Vector3 skyScale = sky.transform.lossyScale;
				if(skyScale.x == 0) skyScale.x = 0.001f;
				if(skyScale.y == 0) skyScale.y = 0.001f;
				if(skyScale.z == 0) skyScale.z = 0.001f;

				xscale = x2scale = myapp.TriggerDimensions.size.x * 0.5f * skyScale.x;
				yscale = y2scale = myapp.TriggerDimensions.size.y * 0.5f * skyScale.y;
				zscale = z2scale = myapp.TriggerDimensions.size.z * 0.5f * skyScale.z;
				
				Handles.color = new Color(1.0f, 0.5f, 0.0f, 0.9f);
				Vector3 dotpos;

				Vector3 boxcenter = sky.transform.localToWorldMatrix.MultiplyPoint(myapp.TriggerDimensions.center);

				dotpos = xscale * sky.transform.right + boxcenter;
				dotpos = Handles.Slider(dotpos, sky.transform.right, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
				xscale = (dotpos - boxcenter).magnitude;
				
				dotpos = (x2scale * -sky.transform.right) + boxcenter;
				dotpos = Handles.Slider(dotpos, -sky.transform.right, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
				x2scale = (dotpos - boxcenter).magnitude;
				
				dotpos = yscale * sky.transform.up + boxcenter;
				dotpos = Handles.Slider(dotpos, sky.transform.up, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
				yscale = (dotpos - boxcenter).magnitude;
				
				dotpos = y2scale * -sky.transform.up + boxcenter;
				dotpos = Handles.Slider(dotpos, -sky.transform.up, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
				y2scale = (dotpos - boxcenter).magnitude;
				
				dotpos = zscale * sky.transform.forward + boxcenter;
				dotpos = Handles.Slider(dotpos, sky.transform.forward, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
				zscale = (dotpos - boxcenter).magnitude;
				
				dotpos = z2scale * -sky.transform.forward + boxcenter;
				dotpos = Handles.Slider(dotpos, -sky.transform.forward, (dotpos-campos).magnitude / 10.0f, Handles.ArrowCap, 0.05f);
				z2scale = (dotpos - boxcenter).magnitude;

				Bounds dim = myapp.TriggerDimensions;

				float xposDiff = dim.size.x - (xscale / skyScale.x) * 2 - (dim.size.x - (x2scale / skyScale.x) * 2);
				float yposDiff = dim.size.y - (yscale / skyScale.y) * 2 - (dim.size.y - (y2scale / skyScale.y) * 2);
				float zposDiff = dim.size.z - (zscale / skyScale.z) * 2 - (dim.size.z - (z2scale / skyScale.z) * 2);

				dim.center += new Vector3(-xposDiff*0.25f, -yposDiff*0.25f, -zposDiff*0.25f);
				dim.size = new Vector3((xscale + x2scale) / skyScale.x, (yscale + y2scale) / skyScale.y, (zscale + z2scale) / skyScale.z);

				if( dim.center != myapp.TriggerDimensions.center || dim.size != myapp.TriggerDimensions.size ) {
					Undo.RecordObject(myapp, "Sky Trigger Resize");
					myapp.TriggerDimensions = dim;

					mset.SkyManager mgr = mset.SkyManager.Get();
					if(mgr && mgr.EditorAutoApply) {
						mgr.EditorApplySkies(true);
					}
					EditorUtility.SetDirty(target);
				}

				//Hammer this for now
				myapp.HasChanged = true;
			}
		}
	}
}