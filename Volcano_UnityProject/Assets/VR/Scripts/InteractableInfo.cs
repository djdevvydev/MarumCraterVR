using UnityEngine;
using System.Collections;

public class InteractableInfo : MonoBehaviour {

    public InteractableType interactableType; //Set per object in the editor

    public enum InteractableType //Used to know what type of interactable an object is for Raycast purposes
    {
        VideoPlay,
        VideoPause,
        TrailSign,
        MenuItemStart,
        MenuItemHome,
        MenuItemCredits
    };

}
