using UnityEngine;
using System.Collections;

public class VideoScreen : MonoBehaviour {

    [SerializeField]
    int screenNumber;

    //Called by SightControl.cs - used to start playback on the video
    public void VideoScreenPlay()
    {
        //Use the array in SceneManager to populate the Video Player Manager's file name field
        SceneManager.instance.mediaPlayerCtrl.m_strFileName = SceneManager.instance.videoFilePaths[screenNumber];
        SceneManager.instance.mediaPlayerCtrl.m_TargetMaterial = gameObject; //Use this gameObject as the targetTexture for the video file
        SceneManager.instance.mediaPlayerCtrl.Play();
        Debug.Log("Playing video on screen " + screenNumber);
    }

    public void VideoScreenPause()
    {
        Debug.Log("Paused video on screen " + screenNumber);
        SceneManager.instance.mediaPlayerCtrl.Pause();
    }
}
