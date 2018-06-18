using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GlobalController : MonoBehaviour
{


    [Space, Range(0f, 1f)]
    public float edgeSize = 0.1f;
    [ColorUsageAttribute(true, true, 0f, 99f, 0.125f, 3f)]
    public Color edgeColor = Color.white;


    public bool invert = false;



    //public enum AXIS { X, Y, Z } 

    //[Space]
    //public AXIS axis = AXIS.X;
    //public float offset = 0;

    //[Range(0f, 1f)]
    //public float dissolve;


    void Update()
    {
        //Just rotating transform for animation
        if (Application.isPlaying)
        {
            transform.rotation = Quaternion.Euler(90, 0, Time.realtimeSinceStartup * 25);
        }

        

        Shader.SetGlobalVector("_DissolveMaskPosition_Global", transform.position);
        Shader.SetGlobalVector("_DissolveMaskPlaneNormal_Global", transform.up);


        Shader.SetGlobalFloat("_DissolveEdgeSize_Global", edgeSize);
        Shader.SetGlobalColor("_DissolveEdgeColor_Global", edgeColor);


        Shader.SetGlobalFloat("_DissolveAxisInvert_Global", invert ? -1 : 1);




        //Shader.SetGlobalFloat("_DissolveCutoffAxis_Global", (int)axis);
        //Shader.SetGlobalFloat("_DissolveMaskOffset_Global", offset);        

        //Shader.SetGlobalFloat("_DissolveCutoff_Global", dissolve);
    }
}
