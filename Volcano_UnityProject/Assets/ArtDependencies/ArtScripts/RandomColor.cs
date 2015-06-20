using UnityEngine;
using System.Collections;

public class RandomColor : MonoBehaviour {

	// Use this for initialization
	void Start () {
		// pick a random color
		Color newColor = new Color( Random.value, Random.value, Random.value, 1.0f );
		
		// apply it on current object's material
		GetComponent<Renderer>().material.color = newColor;    
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
