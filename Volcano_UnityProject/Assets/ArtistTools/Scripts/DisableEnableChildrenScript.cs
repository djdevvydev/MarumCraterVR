using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class DisableEnableChildrenScript : MonoBehaviour {

    public void DisableAllChildren()
    {
        ProcessAllChildren(false);
    }
    public void EnableAllChildren()
    {
        ProcessAllChildren(true);
    }

    public void ProcessAllChildren(bool activeValue){
        List<Transform> tList = new List<Transform>();
        tList.Add(transform);

        while (tList.Count > 0)
        {
            for (int i = 0; i < tList[0].childCount; i++)
            {
                tList.Add(tList[0].GetChild(i));
            }
            tList[0].gameObject.SetActive(activeValue);
            tList.RemoveAt(0);
        }

    }
}
