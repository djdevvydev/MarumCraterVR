// Marmoset Skyshop
// Copyright 2014 Marmoset LLC
// http://marmoset.co

using UnityEngine;
using System;
namespace mset {
	public class GLUtil {

		private static Vector3 prevStripVertex = Vector3.zero;
		public static void StripFirstVertex(Vector3 v) { prevStripVertex = v; }
		public static void StripFirstVertex3(float x, float y, float z) { prevStripVertex.Set(x,y,z); } 
		
		public static void StripVertex3(float x, float y, float z) {
			GL.Vertex(prevStripVertex);
			GL.Vertex3(x,y,z);
			prevStripVertex.Set(x,y,z);
		}
		public static void StripVertex(Vector3 v) {
			GL.Vertex(prevStripVertex);
			GL.Vertex(v);
			prevStripVertex = v;
		}
		

		public static void DrawCube(Vector3 pos, Vector3 radius) {
			Vector3 min = pos - radius;
			Vector3 max = pos + radius;
			GL.Begin(GL.QUADS);
			//bottom
			GL.Vertex3(min.x,min.y,min.z);
			GL.Vertex3(max.x,min.y,min.z);
			GL.Vertex3(max.x,min.y,max.z);
			GL.Vertex3(min.x,min.y,max.z);
			
			//top
			GL.Vertex3(max.x,max.y,min.z);
			GL.Vertex3(min.x,max.y,min.z);
			GL.Vertex3(min.x,max.y,max.z);
			GL.Vertex3(max.x,max.y,max.z);

			//left
			GL.Vertex3(max.x,min.y,min.z);
			GL.Vertex3(max.x,max.y,min.z);
			GL.Vertex3(max.x,max.y,max.z);
			GL.Vertex3(max.x,min.y,max.z);
			
			//right
			GL.Vertex3(min.x,max.y,min.z);
			GL.Vertex3(min.x,min.y,min.z);
			GL.Vertex3(min.x,min.y,max.z);
			GL.Vertex3(min.x,max.y,max.z);
			
			//back
			GL.Vertex3(max.x,max.y,max.z);
			GL.Vertex3(min.x,max.y,max.z);
			GL.Vertex3(min.x,min.y,max.z);
			GL.Vertex3(max.x,min.y,max.z);
			
			//front
			GL.Vertex3(min.x,max.y,min.z);
			GL.Vertex3(max.x,max.y,min.z);
			GL.Vertex3(max.x,min.y,min.z);
			GL.Vertex3(min.x,min.y,min.z);			
			GL.End();
		}

		public static void DrawWireCube(Vector3 pos, Vector3 radius) {
			Vector3 min = pos - radius;
			Vector3 max = pos + radius;

			GL.Begin(GL.LINES);
			//bottom
			mset.GLUtil.StripFirstVertex3(min.x,min.y,min.z);
			mset.GLUtil.StripVertex3(max.x,min.y,min.z);
			mset.GLUtil.StripVertex3(max.x,min.y,max.z);
			mset.GLUtil.StripVertex3(min.x,min.y,max.z);
			
			//top
			mset.GLUtil.StripFirstVertex3(max.x,max.y,min.z);
			mset.GLUtil.StripVertex3(min.x,max.y,min.z);
			mset.GLUtil.StripVertex3(min.x,max.y,max.z);
			mset.GLUtil.StripVertex3(max.x,max.y,max.z);
			
			//left
			mset.GLUtil.StripFirstVertex3(max.x,min.y,min.z);
			mset.GLUtil.StripVertex3(max.x,max.y,min.z);
			mset.GLUtil.StripVertex3(max.x,max.y,max.z);
			mset.GLUtil.StripVertex3(max.x,min.y,max.z);
			
			//right
			mset.GLUtil.StripFirstVertex3(min.x,max.y,min.z);
			mset.GLUtil.StripVertex3(min.x,min.y,min.z);
			mset.GLUtil.StripVertex3(min.x,min.y,max.z);
			mset.GLUtil.StripVertex3(min.x,max.y,max.z);
			
			//back
			mset.GLUtil.StripFirstVertex3(max.x,max.y,max.z);
			mset.GLUtil.StripVertex3(min.x,max.y,max.z);
			mset.GLUtil.StripVertex3(min.x,min.y,max.z);
			mset.GLUtil.StripVertex3(max.x,min.y,max.z);
			
			//front
			mset.GLUtil.StripFirstVertex3(min.x,max.y,min.z);
			mset.GLUtil.StripVertex3(max.x,max.y,min.z);
			mset.GLUtil.StripVertex3(max.x,min.y,min.z);
			mset.GLUtil.StripVertex3(min.x,min.y,min.z);			
			GL.End();
		}
	}
}

