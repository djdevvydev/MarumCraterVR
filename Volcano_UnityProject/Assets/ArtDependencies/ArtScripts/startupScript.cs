using UnityEngine;
using System.Collections;

public class startupScript : MonoBehaviour {

	// Use this for initialization
	void Start () {
		SetResolution ();
	}
	private void SetResolution()
	{
		#if UNITY_STANDALONE_OSX
		{
			// force correct resolution without mirroring
			Screen.fullScreen = false;
			Screen.SetResolution (1920, 1080, false);
		}
		#endif
		
	}	
	// Update is called once per frame
	void Update () {
	
	}
}
