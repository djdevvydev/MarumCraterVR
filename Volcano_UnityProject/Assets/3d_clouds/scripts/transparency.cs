using UnityEngine;
using System.Collections;

public class transparency : MonoBehaviour {
	private Transform cl1;
	private Transform cl2;
	private Transform cl3;
	private Transform cl4;
	private Transform cl5;
	private Transform cl6;
	public static float transp=1f;
	// Use this for initialization
	void Start () {
	
		
	}
	
	void OnGUI(){
		GUI.Label(new Rect(300,25,200,20),"Control Transparency:");
		transp = GUI.HorizontalSlider(new Rect(300,45,130,20),transp,0f,1f);
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
