using UnityEngine;
using System.Collections;

public class VideoScreen : MonoBehaviour {

    [SerializeField]
    int screenNumber;
    [SerializeField]
    string fileToPlay;
    public GameObject playButton;
    public GameObject pauseButton;
    Vector3 currentScale;

    public GameObject trailPoints;

    public MediaPlayerCtrl mediaControlScr;

    Vector3 targetIncreasedScale = new Vector3(22F, 13F, 1.0F);
    Vector3 targetDecreasedScale = new Vector3(1.0F, 1.0F, 1.0F);

    float duration = 3.0F;

    public void GrowVideoScreen()
    {
        StartCoroutine("FadeIn");
        trailPoints.SetActive(false);
    }

    public void FadeVideoScreen()
    {
        StartCoroutine("FadeOut");
    }

    IEnumerator FadeOut()
    {
        VideoScreenPause();
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
        SceneManager.instance.audioManager.vrAudioSource.Pause();
        mediaControlScr.Load(fileToPlay);
        mediaControlScr.Play();
        playButton.SetActive(false);
        pauseButton.SetActive(true);
        trailPoints.SetActive(false);
        Debug.Log("Playing video on screen " + screenNumber);
    }

    public void VideoScreenPause()
    {
        Debug.Log("Paused video on screen " + screenNumber);
        trailPoints.SetActive(true);
        mediaControlScr.Pause();
        playButton.SetActive(true);
        pauseButton.SetActive(false);
//        SceneManager.instance.mediaPlayerCtrl.Pause();
    }
    /*
    void OnGUI()
    {
        string text;
        switch (mediaControlScr.GetCurrentState())
        {
            case MediaPlayerCtrl.MEDIAPLAYER_STATE.NOT_READY:
                text = "Not Ready";
                break;
            case MediaPlayerCtrl.MEDIAPLAYER_STATE.ERROR:
                text = "ERROR";
                break;
            case MediaPlayerCtrl.MEDIAPLAYER_STATE.PLAYING:
                text = "PLAYING";
                break;
            case MediaPlayerCtrl.MEDIAPLAYER_STATE.STOPPED:
                text = "STOPPED";
                break;
            case MediaPlayerCtrl.MEDIAPLAYER_STATE.END:
                text = "END";
                break;
            case MediaPlayerCtrl.MEDIAPLAYER_STATE.PAUSED:
                text = "PAUSED";
                break;
            default:
                text = "No State? DEFAULT";
                break;
        }
        
        GUI.Box(new Rect(Screen.width /2 , Screen.height/2, 200, 30), text);
        if (GUI.Button(new Rect(Screen.width / 3, Screen.height/3, 100, 100), "Load"))
        {
            mediaControlScr.Load("EasyMovieTexture");
        }

        if (GUI.Button(new Rect(Screen.width / 4, Screen.height / 4, 100, 100), "Play"))
        {
            mediaControlScr.Play();
        }
     
    }*/ 
}
