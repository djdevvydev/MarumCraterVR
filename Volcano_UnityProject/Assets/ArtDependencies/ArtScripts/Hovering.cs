using UnityEngine;
using System.Collections;

public class Hovering : MonoBehaviour {
	
	public float speed = 4.0f;
	public float speedRange = 2f;
	public float speedOffset = .3f;
	public float height = 0.003f;
	public float heightRange = 2f;
	public Vector3 axes;
	
	void Start()
	{
		height = height * Random.Range(1f, heightRange);
		speed = speed * Random.Range(1f, speedRange);
	}
	
	void Update () 
	{
		// Set the y position to loop
		float offset = Mathf.Sin(Time.time * speed + speedOffset) * height;

		Vector3 axesMultiplier = axes * offset;
		Vector3 newPosition = new Vector3(transform.position.x, transform.position.y, transform.position.z);

		newPosition = newPosition + axesMultiplier;
		transform.position = newPosition;

//		transform.position = new Vector3(transform.position.x, transform.position.y + offset, transform.position.z);
	}
	
	
}