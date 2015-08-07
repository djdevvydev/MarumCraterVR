using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class SceneManager : MonoBehaviour 
{
    public static SceneManager instance = null;

    public bool narrationEnabled = true;

    [SerializeField]
    Image fadeOverlay;

    public bool fading;

    public AudioManager audioManager;

    public GameObject[] videoScreens;

    void Awake()
    {
        if (instance == null)
        {
            //If instance hasn't been set yet, make this object the singleton of "instance"
            instance = this;
        }
        else if (instance != this)
        {
            //If this object is not the singleton of "instance", destroy yourself
            Destroy(gameObject);
        }
        if(fadeOverlay == null)
        {
            fadeOverlay = GameObject.Find("FadePanel").GetComponent<Image>();
        }
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        StartCoroutine("FadeIn");

        
    }

    IEnumerator FadeIn()
    {
        yield return new WaitForSeconds(1);
        while(fadeOverlay.color.a > 0)
        {
            fadeOverlay.color = new Color(fadeOverlay.color.r, fadeOverlay.color.g, fadeOverlay.color.b, fadeOverlay.color.a - (0.5F*Time.deltaTime));
            yield return new WaitForEndOfFrame();
        }
        videoScreens[audioManager.audioClipIndex].SetActive(true);
        videoScreens[audioManager.audioClipIndex].GetComponent<VideoScreen>().GrowVideoScreen();
        videoScreens[audioManager.audioClipIndex].GetComponent<VideoScreen>().VideoScreenPlay();
    }

    public IEnumerator FadeOut(string levelToLoad)
    {
        fading = true;
        while(fadeOverlay.color.a < 1)
        {
            fadeOverlay.color = new Color(fadeOverlay.color.r, fadeOverlay.color.g, fadeOverlay.color.b, fadeOverlay.color.a + (0.5F * Time.deltaTime));
            yield return new WaitForEndOfFrame();
        }
//        Debug.Log("Fade Out Complete");
        yield return new WaitForSeconds(1);
        fading = false;
        Application.LoadLevel(levelToLoad);
    }
	
}
