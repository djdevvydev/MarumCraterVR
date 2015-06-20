// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
//using UnityEditor;
using System.Collections;

using System;

namespace mset {
	public class SkyAnchor : MonoBehaviour {
		public enum AnchorBindType {Center, Offset, TargetTransform, TargetSky};
		public AnchorBindType BindType = AnchorBindType.Center;

		public Transform	AnchorTransform = null;
		public Vector3		AnchorOffset = Vector3.zero;
		public mset.Sky		AnchorSky = null;

		public mset.SkyApplicator	CurrentApplicator = null;
		public mset.Sky 			CurrentSky { 
			get { return Blender.CurrentSky; } 
		}

		public float BlendTime {
			get { return Blender.BlendTime; }
			set { Blender.BlendTime = value; }
		}


		//true if this anchor is assigned a local sky and should be calling Blender.Apply()
		//false if using the global sky and blender in SkyManager
		[SerializeField]
		private bool HasLocalSky = false;

		//true if gameObject has moved or needs to research applicators
		public bool HasChanged = true;

		[SerializeField]
		private mset.SkyBlender Blender = new mset.SkyBlender();
		private Vector3 LastPosition = Vector3.zero;

		// Use this for initialization
		void Start() {
			if(BindType != AnchorBindType.TargetSky) {
				//HACK: clear the property block for this renderer, good catch-all for old data
				GetComponent<Renderer>().SetPropertyBlock(new MaterialPropertyBlock());

				//instantly register and hook up skies to this anchor on creation
				mset.SkyManager skymgr = mset.SkyManager.Get();
				skymgr.RegisterNewRenderer(GetComponent<Renderer>());
				skymgr.ApplyCorrectSky(GetComponent<Renderer>());
				BlendTime = skymgr.LocalBlendTime;
				if(Blender.CurrentSky == null) Blender.SnapToSky(skymgr.GlobalSky);
			}

			LastPosition = transform.position;
			HasChanged = true;
		}

		private void LateUpdate() {
			//direct link to a sky
			if(BindType == AnchorBindType.TargetSky) {
				HasChanged = AnchorSky != Blender.CurrentSky;
			}
			// use a third-party transform for anchor checks
			else if(BindType == AnchorBindType.TargetTransform) {
				if(AnchorTransform && AnchorTransform.position != LastPosition) {
					HasChanged = true;
					LastPosition = AnchorTransform.position;
				}
			}
			else if(LastPosition != transform.position) {
				HasChanged = true;
				LastPosition = transform.position;
			}
			Apply();
		}

		public void SnapToSky(mset.Sky nusky) {
			if(nusky == null) return;
			if(BindType == AnchorBindType.TargetSky) return;			
			Blender.SnapToSky(nusky);
			HasLocalSky = true;
		}
		public void BlendToSky(mset.Sky nusky) {
			if(nusky == null) return;
			//ignore if swaps if we are glued to a specific sky
			if(BindType == AnchorBindType.TargetSky) return;
			Blender.BlendToSky(nusky);
			HasLocalSky = true;
		}

		public void SnapToGlobalSky(mset.Sky nusky) {
			SnapToSky(nusky);
			HasLocalSky = false;
		}
		public void BlendToGlobalSky(mset.Sky nusky) {
			if(HasLocalSky) BlendToSky(nusky);
			HasLocalSky = false;
		}

		public void Apply() {
			if(BindType == AnchorBindType.TargetSky) {
				//we don't want to check for null skies every frame for every object but for
				//targeted skies, we do a global sky backup here
				if(AnchorSky)	Blender.SnapToSky(AnchorSky);
				else			Blender.SnapToSky(SkyManager.Get().GlobalSky);
				Blender.Apply(GetComponent<Renderer>());
			}
			else if(HasLocalSky || Blender.IsBlending) {
				Blender.Apply(GetComponent<Renderer>());
			}
		}

		public Vector3 GetCenter() {
			Vector3 pos = transform.position;
			switch(BindType) {
			case AnchorBindType.TargetTransform:
				if(AnchorTransform) pos = AnchorTransform.position;
				break;
			case AnchorBindType.Center:
				pos = GetComponent<Renderer>().bounds.center;
				break;
			case AnchorBindType.Offset:
				pos = transform.localToWorldMatrix.MultiplyPoint3x4(this.AnchorOffset);
				break;
			case AnchorBindType.TargetSky:
				if(AnchorSky) pos = AnchorSky.transform.position;
				break;
			};
			return pos;
		}

	#if UNITY_EDITOR
		public void OnDrawGizmosSelected() {
			Gizmos.color = Color.cyan;
			Gizmos.DrawLine(transform.position, GetCenter());
			if(BindType == AnchorBindType.Offset) {
				Gizmos.color = new Color(0f,4f,4f);
				Gizmos.DrawSphere(GetCenter(), 0.15f);
			}
		}
	#endif
	}
}
