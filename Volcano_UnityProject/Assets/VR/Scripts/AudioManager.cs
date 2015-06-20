using UnityEngine;
using System.Collections;

public class AudioManager : MonoBehaviour {
    
    public AudioClip[] locationAudioClips; //Audio clips for arrival at a location
    public AudioClip[] trailAudioClips; //Audio clips for travel between locations

    public int audioClipIndex;

    public AudioSource vrAudioSource; //Attached to the cardboardMain object (we use this to plug in audio clips and play them)

}
