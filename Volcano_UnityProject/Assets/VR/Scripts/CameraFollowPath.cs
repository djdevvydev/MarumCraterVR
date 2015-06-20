using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class CameraFollowPath : MonoBehaviour 
{
    public PathDefinition path;
    public float speed = 5F;
    public float maxDistanceToPoint = 0.1F;

    public int targetPathPoint = 0;
    public bool cameraMoveAlongPath = false;

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

    public void Update()
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
                    cameraMoveAlongPath = false;
                    sightControlScript.scanning = true;
                    SceneManager.instance.videoScreens[SceneManager.instance.audioManager.audioClipIndex].SetActive(true);
                    SceneManager.instance.mediaPlayerCtrl.m_strFileName = SceneManager.instance.videoFilePaths[SceneManager.instance.audioManager.audioClipIndex];
                    SceneManager.instance.mediaPlayerCtrl.m_TargetMaterial = SceneManager.instance.videoScreens[SceneManager.instance.audioManager.audioClipIndex];
                    if (SceneManager.instance.audioManager.audioClipIndex != 0 && SceneManager.instance.narrationEnabled == true)
                    {
                        //Load up the LOCATION audio clip from the audioManager using the audioIndex
                        SceneManager.instance.audioManager.vrAudioSource.clip = SceneManager.instance.audioManager.locationAudioClips[SceneManager.instance.audioManager.audioClipIndex];
                        //Begin playing audio
                        SceneManager.instance.audioManager.vrAudioSource.Play();
                        Debug.Log("Play LOCATION audio clip");
                    }
                }
                else
                {
                    _currentPointOnPath.MoveNext();
                }
            }
        }

        
    }
	
}
