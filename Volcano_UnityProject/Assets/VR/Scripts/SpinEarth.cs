using UnityEngine;
using System.Collections;

public class SpinEarth : MonoBehaviour {
//    Vector3 endRotate = new Vector3(28, 260, -17);

    float step;
    float speed = 10;

	// Update is called once per frame
	void Update () 
    {
	    if(SceneManager.instance.fading == true)
        {
            transform.Translate(Vector3.back * Time.deltaTime * 100, Space.World);
            transform.Rotate(Vector3.up * Time.deltaTime * speed);
        }
        else
        {
            transform.Rotate(Vector3.up * Time.deltaTime * speed);
        }
	}
}
