// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using System.Collections.Generic;
using mset;

namespace mset {
	[CustomEditor(typeof(SkyManager))]
	public class SkyManagerInspector : Editor {
		public void OnEnable() {
			mset.SkyManager mgr = target as mset.SkyManager;
			if(mgr.GlobalSky == null) {
				mgr.GlobalSky = GameObject.FindObjectOfType<mset.Sky>();
			}
			mgr.EditorApplySkies(true);
		}
		
		public override void OnInspectorGUI() {
			GUI.changed = false;

			mset.SkyManager skmgr = target as mset.SkyManager;
			mset.Sky nusky = EditorGUILayout.ObjectField("Global Sky", skmgr.GlobalSky, typeof(mset.Sky), true) as mset.Sky;
			if(skmgr.GlobalSky != nusky) {
				//TODO: is this necessary?
				if(!Application.isPlaying && nusky != null) {
					nusky.Apply();
				}
				if(nusky == null) {
					RenderSettings.skybox = null;
				}
				skmgr.GlobalSky = nusky;
			}

			skmgr.ShowSkybox = GUILayout.Toggle(skmgr.ShowSkybox, new GUIContent("Show Skybox", "Toggles rendering the global sky's background image in both play and edit modes"));

			EditorGUILayout.Space();
			skmgr.ProjectionSupport = GUILayout.Toggle(skmgr.ProjectionSupport, new GUIContent("Box Projection Support", "Optimization for disabling all box projected cubemap distortion at the shader level"));
			skmgr.BlendingSupport =	GUILayout.Toggle(skmgr.BlendingSupport, new GUIContent("Blending Support","Optimization for disabling blending transitions between skies at the shader level"));
			skmgr.LocalBlendTime = EditorGUILayout.FloatField( "Local Sky Blend Time", skmgr.LocalBlendTime);
			skmgr.GlobalBlendTime = EditorGUILayout.FloatField( "Global Sky Blend Time", skmgr.GlobalBlendTime);
			EditorGUILayout.Space();

			GUILayout.BeginHorizontal();
			skmgr.GameAutoApply = GUILayout.Toggle(skmgr.GameAutoApply, new GUIContent("Auto-Apply in Game", "If enabled for game mode, Sky Manager will keep and constantly update a list of dynamic renderers in the scene, applying local skies to them as they move around.\n\nRequired for dynamic sky binding and Sky Applicator triggers."));
			skmgr.EditorAutoApply = GUILayout.Toggle(skmgr.EditorAutoApply, new GUIContent("Auto-Apply in Editor (beta)","If enabled for edit mode, Sky Manager will apply local skies to renderers contained in their Sky Applicator trigger volumes.\n\nAffects editor viewport only."));
			GUILayout.EndHorizontal();

			GUILayout.BeginHorizontal();
			if(GUILayout.Button(new GUIContent("Preview Auto-Apply","Updates editor viewport to show an accurate representation of which renderers will be bound to which skies in the game.\n\nEditor Auto-Apply performs this every frame."), GUILayout.Width(140))) {
				skmgr.EditorApplySkies(true);
				SceneView.RepaintAll();
			}
			GUILayout.EndHorizontal();
			
			EditorGUILayout.Space();
			
			string dx11Tip = "Uses HDR render-textures to capture sky probes faster and with better quality.\n\nRequires project to be in Direct3D 11 mode while capturing.";
			if(PlayerSettings.useDirect3D11) {
				skmgr.ProbeWithCubeRT = GUILayout.Toggle(skmgr.ProbeWithCubeRT, new GUIContent("Probe Using Render-to-Cubemap",dx11Tip));
			} else {
				EditorGUI.BeginDisabledGroup(true);
				GUILayout.Toggle(false, new GUIContent("Probe Using Render-to-Cubemap (Requires Direct3D11)",dx11Tip));
				EditorGUI.EndDisabledGroup();
			}
			
			GUILayout.BeginHorizontal();
			if(GUILayout.Button(new GUIContent("Probe Skies (Direct)"), GUILayout.Width(140))) {
				bool probeNonProbes = false;
				bool probeIBL = false;
				Probeshop.ProbeSkies( null, GameObject.FindObjectsOfType<mset.Sky>(), probeNonProbes, probeIBL, null);

			}
			if(GUILayout.Button("Probe Skies (Direct+IBL)", GUILayout.Width(170))) {
				bool probeNonProbes = false;
				bool probeIBL = true;
				Probeshop.ProbeSkies( null, GameObject.FindObjectsOfType<mset.Sky>(), probeNonProbes, probeIBL, null);
			}			
			GUILayout.EndHorizontal();

			if(GUI.changed) {
				skmgr.EditorApplySkies(true);
				EditorUtility.SetDirty(target);
				SceneView.RepaintAll();
			}
		}
	}
}