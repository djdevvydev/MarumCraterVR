using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class SceneManager : MonoBehaviour 
{
    public static SceneManager instance = null;

    public bool narrationEnabled = true;

    [SerializeField]
    Image fadeOverlay;

    public MediaPlayerCtrl mediaPlayerCtrl;
    public AudioManager audioManager;

    public string[] videoFilePaths;
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
            //If this object is not the singleton of "instance", destroy ourself
            Destroy(gameObject);
        }
        if(fadeOverlay == null)
        {
            fadeOverlay = GameObject.Find("FadePanel").GetComponent<Image>();
        }
        StartCoroutine("FadeIn");
        mediaPlayerCtrl.m_strFileName = videoFilePaths[audioManager.audioClipIndex];
        instance.mediaPlayerCtrl.m_TargetMaterial = videoScreens[audioManager.audioClipIndex];
        videoScreens[audioManager.audioClipIndex].SetActive(true);
    }

    IEnumerator FadeIn()
    {
        yield return new WaitForSeconds(1);
        while(fadeOverlay.color.a > 0)
        {
            fadeOverlay.color = new Color(fadeOverlay.color.r, fadeOverlay.color.g, fadeOverlay.color.b, fadeOverlay.color.a - (0.5F*Time.deltaTime));
            yield return new WaitForEndOfFrame();
        }
//        Debug.Log("Fade In Complete");
    }

    public IEnumerator FadeOut(string levelToLoad)
    {
        while(fadeOverlay.color.a < 1)
        {
            fadeOverlay.color = new Color(fadeOverlay.color.r, fadeOverlay.color.g, fadeOverlay.color.b, fadeOverlay.color.a + (0.5F * Time.deltaTime));
            yield return new WaitForEndOfFrame();
        }
//        Debug.Log("Fade Out Complete");
        yield return new WaitForSeconds(1);
        Application.LoadLevel(levelToLoad);
    }
	
}
