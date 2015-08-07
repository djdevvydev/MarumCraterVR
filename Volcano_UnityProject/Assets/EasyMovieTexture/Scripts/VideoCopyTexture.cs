using UnityEngine;
using System.Collections;

public class VideoCopyTexture : MonoBehaviour {
	
	public MediaPlayerCtrl m_srcVideo;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
		if(m_srcVideo != null)
		{
			if(transform.GetComponent<MeshRenderer>().material.mainTexture != m_srcVideo.GetVideoTexture())
			{
				transform.GetComponent<MeshRenderer>().material.mainTexture = m_srcVideo.GetVideoTexture();
			}
		}
	
	}
}
