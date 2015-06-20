using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public class PathDefinition : MonoBehaviour {

    public Transform[] points; //Array of points used to hold positions for camera path to follow

    public int pathDirection = 1;

    public IEnumerator<Transform> GetPathsEnumerator()
    {
        if (points == null || points.Length < 1)
        {
            Debug.Log("Points is Null or Length < 1");
            yield break;

        }

        var index = 0;
        while(true)
        {
//            Debug.Log("points[index] = " + points[index].name);
            yield return points[index];

            index += pathDirection;
        }
    }

    //Draws gizmos in the scene view
    public void OnDrawGizmos()
    {
        if (points == null || points.Length < 2) //Sanity check for having 2 points to make a line
            return;

        for(var i = 1; i < points.Length; i++)
        {
            Gizmos.DrawLine(points[i - 1].position, points[i].position); //Connect the dots for our visualization of the path definition!
        }
    }
}
