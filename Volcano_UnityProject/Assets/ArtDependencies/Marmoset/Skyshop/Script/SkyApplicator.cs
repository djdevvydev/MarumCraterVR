// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace mset {
	[RequireComponent(typeof(mset.Sky))]
	public class SkyApplicator : MonoBehaviour {
		public mset.Sky	TargetSky = null;
		public bool		TriggerIsActive = true;

		[SerializeField]
		private Bounds triggerDimensions = new Bounds(Vector3.zero, Vector3.one); //relative to local space
		public Bounds TriggerDimensions {
			get { return triggerDimensions; }
			set { HasChanged = true; triggerDimensions = value; }
		}

		public bool		HasChanged = true;

		public SkyApplicator 		ParentApplicator = null;
		public List<SkyApplicator>	Children = new List<SkyApplicator>();

		private HashSet<Renderer>	AffectedRenderers = new HashSet<Renderer>();
		private Vector3 			LastPosition = Vector3.zero;

		void Awake() {
			TargetSky = GetComponent<mset.Sky>();
		}

		void Start() {
		}

		void OnEnable () {
			gameObject.isStatic = true;
			transform.root.gameObject.isStatic = true;
			LastPosition = transform.position;

			if(ParentApplicator == null && transform.parent != null) {
				if(transform.parent.GetComponent<SkyApplicator>() != null) ParentApplicator = transform.parent.GetComponent<SkyApplicator>();
			}

			if(ParentApplicator != null) ParentApplicator.Children.Add(this);
			else {
				mset.SkyManager skymgr = mset.SkyManager.Get();
				if(skymgr != null) skymgr.RegisterApplicator(this);
			}
		}
		void OnDisable() {
			if(ParentApplicator != null) ParentApplicator.Children.Remove(this);

			mset.SkyManager skymgr = mset.SkyManager.Get();
			if(skymgr) {
				skymgr.UnregisterApplicator(this, AffectedRenderers);
				AffectedRenderers.Clear();
			}
		}

		public void RemoveRenderer(Renderer rend) {
			if(AffectedRenderers.Contains(rend)) {
				AffectedRenderers.Remove(rend);
				mset.SkyAnchor anchor = rend.GetComponent<mset.SkyAnchor>();
				if(anchor && anchor.CurrentApplicator == this) anchor.CurrentApplicator = null;
			}
		}
		public void AddRenderer(Renderer rend) {
			mset.SkyAnchor anchor = rend.GetComponent<mset.SkyAnchor>();
			if(anchor != null) {
				if(anchor.CurrentApplicator != null) anchor.CurrentApplicator.RemoveRenderer(rend);
				anchor.CurrentApplicator = this;
			}
			AffectedRenderers.Add(rend);
		}

		//Directly applies sky to renderers within the bounds of this applicator or its Children
		//For editor use.
		public bool ApplyInside(Renderer rend) {
			if(this.TargetSky == null || !TriggerIsActive) return false;

			Vector3 rendCenter = rend.bounds.center;
			mset.SkyAnchor anchor = rend.gameObject.GetComponent<mset.SkyAnchor>();
			if( anchor ) {
				//TODO: is this necessary? this was never running before
				if( anchor.BindType == mset.SkyAnchor.AnchorBindType.TargetSky && anchor.AnchorSky == TargetSky ) {
					this.TargetSky.Apply(rend);
					anchor.Apply();
					return true;
				}
			}

			//TODO: a bounds check against fat, child-inclusive bounds here could early-out before recursion
			//recurse
			foreach(SkyApplicator childApp in Children) {
				if(childApp.ApplyInside(rend)) return true;
			}

			if( anchor ) rendCenter = anchor.GetCenter();
			rendCenter = transform.worldToLocalMatrix.MultiplyPoint(rendCenter);

			if( TriggerDimensions.Contains(rendCenter) ) {
				this.TargetSky.Apply(rend);
				return true;
			}
			return false;
		}

		public bool RendererInside(Renderer rend) {
			//direct binding
			mset.SkyAnchor anchor = rend.gameObject.GetComponent<mset.SkyAnchor>();
			if(anchor && 
			   anchor.BindType == mset.SkyAnchor.AnchorBindType.TargetSky) {
				if(anchor.AnchorSky == TargetSky) {
					AddRenderer(rend);
					anchor.Apply();
					return true;
				}
			}

			//trigger volume binding
			if(!TriggerIsActive) return false;

			foreach(SkyApplicator childApp in Children) {
				if(childApp.RendererInside(rend)) return true;
			}

			if( anchor == null) {
				anchor = rend.gameObject.AddComponent(typeof(mset.SkyAnchor)) as mset.SkyAnchor;
			}

			Vector3 rendCenter = anchor.GetCenter();
			rendCenter = transform.worldToLocalMatrix.MultiplyPoint(rendCenter);

			if(TriggerDimensions.Contains(rendCenter)) {
				if(!AffectedRenderers.Contains(rend)) {
					AddRenderer(rend);
					anchor.BlendToSky(TargetSky);
				}
				return true;
			}

			RemoveRenderer(rend);
			return false;
		}

		
		//All applicator stuff happens in LateUpdate, after things are done moving
		void LateUpdate() {
			if(TargetSky.Dirty) {
				foreach(Renderer rend in AffectedRenderers) {
					if(rend == null) continue;
					//This should never be missing
					//if(rend.GetComponent<SkyAnchor>() == null) TargetSky.Apply(rend);
					//else
					//rend.GetComponent<SkyAnchor>().BlendToSky(TargetSky);
					//BlendToSky does not work here right now, it currently ignores the TargetSky == currSky case
					TargetSky.Apply(rend);
				}
				TargetSky.Dirty = false;
			}
			
			if(transform.position != LastPosition) {
				HasChanged = true;
			}
		}

		#if UNITY_EDITOR
		private void OnDrawGizmosSelected() {
			if(TargetSky == null) TargetSky = GetComponent<mset.Sky>();

			if(TriggerIsActive) {
				Color c = new Color(1.0f, 0.5f, 0.0f, 0.5f);
				Gizmos.color = c;
				Matrix4x4 mat = new Matrix4x4();
				mat = this.transform.localToWorldMatrix;

				Gizmos.matrix = mat;
				if(UnityEditor.Selection.activeGameObject == this.gameObject) {
					Gizmos.DrawCube(TriggerDimensions.center, -TriggerDimensions.size);
					Gizmos.DrawCube(TriggerDimensions.center, TriggerDimensions.size);
				}
				c.a = 1f;
				Gizmos.color = c;
				Gizmos.DrawWireCube(TriggerDimensions.center, TriggerDimensions.size);
			}
			//UnityEditor.SceneView.onSceneGUIDelegate();
		}
		#endif
	}
}
