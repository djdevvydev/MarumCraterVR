using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using Tango;

public class CameraFollowPath : MonoBehaviour 
{
    public PathDefinition path;
    public float speed = 5F;
    public float maxDistanceToPoint = 0.1F;

    public int targetPathPoint = 0;
    public bool cameraMoveAlongPath = false;

    public AudioClip windSound;
    public AudioClip lavaSound;
    public AudioClip rockFallSound;

    public AudioSource environmentNoise;

    public Image empStateBuilding;

    [SerializeField]
    SightControl sightControlScript;

    private IEnumerator<Transform> _currentPointOnPath;

    void Start()
    {
        InitializePath();
    }

    public void InitializePath()
    {
        if(path == null)
        {
            return;
        }

        _currentPointOnPath = path.GetPathsEnumerator();
        _currentPointOnPath.MoveNext();

        if(_currentPointOnPath.Current == null || _currentPointOnPath == null)
        {
            return;
        }
        transform.position = _currentPointOnPath.Current.position;
    }

    public void FixedUpdate()
    {
        if(_currentPointOnPath == null || _currentPointOnPath.Current == null)
        {
            return;
        }
        if(cameraMoveAlongPath == true)
        {
            transform.position = Vector3.MoveTowards(transform.position, _currentPointOnPath.Current.position, Time.deltaTime * speed);
            if (_currentPointOnPath.Current.name == "PathPoint" + targetPathPoint)
            {
                speed -= (2*Time.deltaTime)/3;
                if (speed < 2) speed = 2;
            }
            var distanceSquared = (transform.position - _currentPointOnPath.Current.position).sqrMagnitude;
            if (distanceSquared < maxDistanceToPoint * maxDistanceToPoint)
            {
                if (_currentPointOnPath.Current.name == "PathPoint" + targetPathPoint)
                {
                    speed = 5F;
                    transform.position = _currentPointOnPath.Current.position;

                    GetComponent<CustomTangoController>().m_startPosition = _currentPointOnPath.Current.position;

                    cameraMoveAlongPath = false;
                    sightControlScript.scanning = true;
                    //Debug.Log("Reached our point!");
                    if (SceneManager.instance.videoScreens[SceneManager.instance.audioManager.audioClipIndex] != null)
                    {
                        SceneManager.instance.videoScreens[SceneManager.instance.audioManager.audioClipIndex].SetActive(true);
                        SceneManager.instance.videoScreens[SceneManager.instance.audioManager.audioClipIndex].GetComponent<VideoScreen>().GrowVideoScreen();
                    }
                    
                    if (SceneManager.instance.audioManager.audioClipIndex != 0 && SceneManager.instance.narrationEnabled == true)
                    {
                        //Load up the LOCATION audio clip from the audioManager using the audioIndex
                        SceneManager.instance.audioManager.vrAudioSource.clip = SceneManager.instance.audioManager.locationAudioClips[SceneManager.instance.audioManager.audioClipIndex];
                        //Begin playing audio
                        SceneManager.instance.audioManager.vrAudioSource.Play();
//                        Debug.Log("Play LOCATION audio clip");
                        PointSpecificRoutinesCheck();
                    }
                    if (SceneManager.instance.audioManager.audioClipIndex >= 6)
                    {
                        TurnOnLastPoints();
                        SceneManager.instance.narrationEnabled = false;
                        if (SceneManager.instance.audioManager.audioClipIndex > 6)
                        {
                            Debug.Log("turn off " + _currentPointOnPath.Current.name);
                            _currentPointOnPath.Current.gameObject.SetActive(false);
                            _currentPointOnPath.Current.GetComponent<BoxCollider>().enabled = false;
                        }
                    }
                }
                else
                {
                    _currentPointOnPath.MoveNext();
                }
            }
        }

        
    }   

    void PointSpecificRoutinesCheck()
    {
        if (SceneManager.instance.audioManager.audioClipIndex == 1)
        {
            StartCoroutine("EmpireStateBuilding");
        }
        else if (SceneManager.instance.audioManager.audioClipIndex == 2)
        {
            StartCoroutine("RockFall");
        }
        else if(SceneManager.instance.audioManager.audioClipIndex == 4)
        {
            environmentNoise.clip = lavaSound;
            environmentNoise.volume = 1.0F;
        }
        else if(SceneManager.instance.audioManager.audioClipIndex > 6)
        {
            environmentNoise.clip = windSound;
            environmentNoise.volume = 0.04F;
        }

    }

    IEnumerator RockFall()
    {
        yield return new WaitForSeconds(24.0F);
        environmentNoise.clip = rockFallSound;
        float oldVolume = environmentNoise.volume;
        environmentNoise.volume = 1;
        yield return new WaitForSeconds(10.0F);
        environmentNoise.clip = windSound;
        environmentNoise.volume = oldVolume;

    }
	
    void TurnOnLastPoints()
    {
        for(int i = 72; i < 75; i++)
        {
            path.points[i].gameObject.SetActive(true);

            path.points[i].gameObject.GetComponent<BoxCollider>().enabled = true;
        }
    }

    IEnumerator EmpireStateBuilding()
    {
        yield return new WaitForSeconds(22.0F);
        
        while(empStateBuilding.fillAmount < 1)
        {
            empStateBuilding.fillAmount += (Time.deltaTime * 0.5f);
            yield return new WaitForEndOfFrame();
        }

        yield return new WaitForSeconds(3.0F);
        while (empStateBuilding.fillAmount > 0)
        {
            empStateBuilding.fillAmount -= (Time.deltaTime * 0.5f);
            yield return new WaitForEndOfFrame();
        }
    }

}
