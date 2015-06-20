// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
//using UnityEditor;
using System.Collections;

using System;

namespace mset {
	[Serializable]
	public class SkyBlender {
		public mset.Sky CurrentSky = null;
		public mset.Sky PreviousSky = null;

		[SerializeField]
		private float blendTime = 0.25f;
		public float BlendTime {
			get { return blendTime; }
			set { blendTime = value; }
		}

		private float currentBlendTime = 0.25f;
		private float endStamp = 0f;

		private float blendTimer {
			get { return endStamp - Time.time; }
			set { endStamp = Time.time + value; }
		}
		public float BlendWeight {
			get { return 1f - Mathf.Clamp01(blendTimer/currentBlendTime); }
		}

		public bool IsBlending {
			get { return endStamp > Time.time; }
		}

		//call on as many renderers as appropriate
		public void Apply() {
			if(IsBlending) {
				CurrentSky.Apply(0);
				PreviousSky.Apply(1);
				mset.Sky.SetBlendWeight(BlendWeight);
			} else {
				CurrentSky.Apply(0);
			}
		}
		//call on as many materials as appropriate
		public void Apply(Material target) {
			if(IsBlending) {
				mset.Sky.EnableBlending(target, true);
				mset.Sky.EnableProjection(target, CurrentSky.HasDimensions || PreviousSky.HasDimensions);
				CurrentSky.Apply(target, 0);
				PreviousSky.Apply(target, 1);
				mset.Sky.SetBlendWeight(target, BlendWeight);
			} else {
				mset.Sky.EnableBlending(target, false);
				mset.Sky.EnableProjection(target, CurrentSky.HasDimensions);
				CurrentSky.Apply(target,0);
			}
		}
		//call on as many renderers as appropriate
		public void Apply(Renderer target) {
			if(IsBlending) {
				mset.Sky.EnableBlending(target, true);
				mset.Sky.EnableProjection(target, CurrentSky.HasDimensions || PreviousSky.HasDimensions);
				CurrentSky.Apply(target, 0);
				PreviousSky.Apply(target, 1);
				mset.Sky.SetBlendWeight(target, BlendWeight);
			} else {
				mset.Sky.EnableBlending(target, false);
				mset.Sky.EnableProjection(target, CurrentSky.HasDimensions);
				CurrentSky.Apply(target,0);
			}
		}
		//call in addition to Apply()
		public void ApplyToTerrain() {
			if(IsBlending) {
				mset.Sky.EnableTerrainBlending(true);
				//TODO: tell tree billboards to update here
			} else {
				mset.Sky.EnableTerrainBlending(false);
			}
		}
		//call once
		public void SnapToSky(mset.Sky nusky) {
			if(nusky == null) return;
			CurrentSky = PreviousSky = nusky;
			blendTimer = 0f;
		}

		//call once
		public void BlendToSky(mset.Sky nusky) {
			if(nusky == null) return;
			if(CurrentSky != nusky) {
				//do some blending
				if(CurrentSky == null) {
					//nothing to blend from
					PreviousSky = CurrentSky = nusky;
					blendTimer = 0f;
				} 
				else {
					PreviousSky = CurrentSky;
					CurrentSky = nusky;
					currentBlendTime = blendTime;
					blendTimer = currentBlendTime;
				}
			}
		}
	}
}

