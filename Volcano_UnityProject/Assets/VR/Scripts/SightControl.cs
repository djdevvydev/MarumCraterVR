using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using Tango;

public class SightControl : MonoBehaviour 
{
    public bool scanning;

   
    public GameObject tangoManager;

    [SerializeField]
    Image gazeTimerImage;
    [SerializeField]
    Image targetReticleImage;

    [SerializeField]
    CameraFollowPath camFollowPathScript;

    [SerializeField]
    PathDefinition pathDefScript;

    [SerializeField]
    GameObject currentTarget;

    GameObject lastTarget;
    float lookTimer = 0;

    [SerializeField]
    float lookTimerMax = 2.0F;

	// Update is called once per frame
	void Update () 
    {
        if (lookTimer >= lookTimerMax) //If looktimer is >= 1, we mean to select this object
        {
            scanning = false;
            gazeTimerImage.fillAmount = 0;
            lookTimer = 0;

            //Check which type of interactable our target is
            switch(currentTarget.GetComponent<InteractableInfo>().interactableType)
            {
                case InteractableInfo.InteractableType.VideoPlay:
                    //Debug.Log("VideoScreen");
                    currentTarget.GetComponentInParent<VideoScreen>().VideoScreenPlay();
                    scanning = true;
                    break;
                case InteractableInfo.InteractableType.VideoPause:
                    Debug.Log("VideoScreenPause");
                    currentTarget.GetComponentInParent<VideoScreen>().VideoScreenPause();
                    scanning = true;
                    break;
                case InteractableInfo.InteractableType.TrailSign:
                    //Debug.Log("TrailSign");
                    int targetPathPoint = currentTarget.GetComponent<TrailPoint>().targetPoint;
                    //Based on what that trail sign's target path point is, we go forward or backward along the path
                    pathDefScript.pathDirection = targetPathPoint > camFollowPathScript.targetPathPoint ? 1 : -1;
                    camFollowPathScript.speed = currentTarget.GetComponent<TrailPoint>().travelSpeed; //Set the travelSpeed based on the trail point
                    camFollowPathScript.targetPathPoint = targetPathPoint; //Tell the camera the target path point we want to hit
                    
                    //Disable motion tracking?
                        

                    camFollowPathScript.cameraMoveAlongPath = true; //Start moving

                    if (SceneManager.instance.videoScreens[SceneManager.instance.audioManager.audioClipIndex] != null)
                    SceneManager.instance.videoScreens[SceneManager.instance.audioManager.audioClipIndex].GetComponent<VideoScreen>().FadeVideoScreen();
                    //If audio is playing, stop playback
                    if (SceneManager.instance.audioManager.vrAudioSource.isPlaying)
                    {
                        SceneManager.instance.audioManager.vrAudioSource.Stop();
                    }

                    if(SceneManager.instance.narrationEnabled == true)
                    {
                        //Load up the trail audio clip in the audioManager using the audioIndex
                        if(pathDefScript.pathDirection == -1)
                        {
                            SceneManager.instance.audioManager.audioClipIndex -= 1;
                        }
                        SceneManager.instance.audioManager.vrAudioSource.clip = SceneManager.instance.audioManager.trailAudioClips[SceneManager.instance.audioManager.audioClipIndex];
                        //Begin playing audio
                        if(pathDefScript.pathDirection == 1)
                        {
                            SceneManager.instance.audioManager.audioClipIndex += 1;
                        }
                        SceneManager.instance.audioManager.vrAudioSource.Play();
                    }
            
                    break;
                case InteractableInfo.InteractableType.MenuItemStart:
                    //Debug.Log("MenuItemStart");
                    SceneManager.instance.StartCoroutine("FadeOut", "Volcano"); //Go to the Volcano scene
                    break;
                case InteractableInfo.InteractableType.MenuItemCredits:
                    //Debug.Log("MenuItemStart");
                    SceneManager.instance.StartCoroutine("FadeOut", "Credits"); //Go to the credits scene
                    break;
                case InteractableInfo.InteractableType.MenuItemHome:
                    //Debug.Log("MenuItemStart");
                    SceneManager.instance.StartCoroutine("FadeOut", "Menu"); //Go back to the main menu
                    break;
                default:
                    break;
            }
        }
	    if(scanning)
        {
            RaycastHit hit;

            Vector3 rayDirection = Camera.main.transform.TransformDirection(Vector3.forward);
            Vector3 rayStart = Camera.main.transform.position;
            //Debug.DrawRay(rayStart, rayDirection * 100, Color.green);
            if (Physics.Raycast(rayStart, rayDirection, out hit)) //Gear/Tango version
            //Debug.DrawRay(transform.position, transform.TransformDirection(Vector3.forward), Color.blue  );
            //if(Physics.Raycast(transform.position, transform.TransformDirection(Vector3.forward), out hit, 1000.0F))
            {
                //Debug.Log("Hit: " + hit.collider.name);
                currentTarget = hit.collider.gameObject;
                if(currentTarget != lastTarget) //Looking at something new...
                {
                    if(lastTarget != null)
                    {
                        lookTimer = 0;
                    }
                    lastTarget = currentTarget;
                }
                else //Otherwise we're still fixated on our target
                {
                    if(currentTarget.tag == ("Interactable")) //FIXME OPTIMIZATION
                    {
                        lookTimer += Time.deltaTime; //Increment lookTimer
                        //Fill the target reticle image on the canvas by % based on lookTimer
                        gazeTimerImage.fillAmount += Time.deltaTime / lookTimerMax;
                        //Debug.Log("Looktimer = " + lookTimer);
                    }
                    else
                    {
                        if (lookTimer > 0) 
                        { 
                            lookTimer -= Time.deltaTime; 
                        }
                        if (gazeTimerImage.fillAmount > 0) 
                        { 
                            gazeTimerImage.fillAmount -= Time.deltaTime / lookTimerMax; 
                        }
                    }
                }
            }
            else
            {
                if (lookTimer > 0)
                {
                    lookTimer -= Time.deltaTime;
                }
                if (gazeTimerImage.fillAmount > 0)
                {
                    gazeTimerImage.fillAmount -= Time.deltaTime / lookTimerMax;
                }
            }
        }
	}
}
