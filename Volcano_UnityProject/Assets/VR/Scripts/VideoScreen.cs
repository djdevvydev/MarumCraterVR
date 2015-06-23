using UnityEngine;
using System.Collections;

public class VideoScreen : MonoBehaviour {

    [SerializeField]
    int screenNumber;

    public GameObject playButton;
    public GameObject pauseButton;
    Vector3 currentScale;
    Vector3 targetIncreasedScale = new Vector3(22F, 13F, 1.0F);
    Vector3 targetDecreasedScale = new Vector3(1.0F, 1.0F, 1.0F);

    float duration = 3.0F;

    public void GrowVideoScreen()
    {
        StartCoroutine("FadeIn");
    }

    public void FadeVideoScreen()
    {
        StartCoroutine("FadeOut");
    }

    IEnumerator FadeOut()
    {
        //int scaleFactor = 100;
        //transform.localScale = targetDecreasedScale;
        Debug.Log("Decrease size of screen " + screenNumber);
        float counter = 0.0F;
        while (counter < 1.0F)
        {
            transform.localScale = Vector3.MoveTowards(transform.localScale, targetDecreasedScale, counter);
            counter += Time.deltaTime / duration;
            yield return new WaitForEndOfFrame();
        }
        transform.localScale = targetDecreasedScale;
        gameObject.SetActive(false);
    }

    IEnumerator FadeIn()
    {
        //int scaleFactor = 100;
        Debug.Log("transform.localScale = " + transform.localScale);
        float counter = 0.0F;
        while (counter < 1.0F)
        {
            transform.localScale = Vector3.MoveTowards(transform.localScale, targetIncreasedScale, counter);
            counter += Time.deltaTime / duration;
            yield return new WaitForEndOfFrame();
        }
        transform.localScale = targetIncreasedScale;
    }

    //Called by SightControl.cs - used to start playback on the video
    public void VideoScreenPlay()
    {
        //Use the array in SceneManager to populate the Video Player Manager's file name field
        SceneManager.instance.mediaPlayerCtrl.m_strFileName = SceneManager.instance.videoFilePaths[screenNumber];
        SceneManager.instance.mediaPlayerCtrl.m_TargetMaterial = gameObject; //Use this gameObject as the targetTexture for the video file
        SceneManager.instance.mediaPlayerCtrl.Play();
        playButton.SetActive(false);
        pauseButton.SetActive(true);
        Debug.Log("Playing video on screen " + screenNumber);
    }

    public void VideoScreenPause()
    {
        Debug.Log("Paused video on screen " + screenNumber);
        playButton.SetActive(true);
        pauseButton.SetActive(false);
        SceneManager.instance.mediaPlayerCtrl.Pause();
    }
}
