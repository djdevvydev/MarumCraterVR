using UnityEngine;
using System.Collections;

public class DisableEnableThisNodeScript : MonoBehaviour
{

    public void DisableThisNode()
    {
        ProcessNode(false);
    }
    public void EnableThisNode()
    {
        ProcessNode(true);
    }

    public void ProcessNode(bool activeValue)
    {
        Transform curT = transform;
        while (curT != null)
        {
            curT.gameObject.SetActive(activeValue);
            curT = curT.parent;
        }

    }
}
