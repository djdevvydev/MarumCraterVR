using UnityEngine;
using System.Collections;

public class Loader : MonoBehaviour {

    public GameObject sceneManager;

    void Start () 
    {
	    if(SceneManager.instance == null)
        {
            Instantiate(sceneManager);
        }
	}
}
