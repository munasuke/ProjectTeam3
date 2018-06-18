using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class MultiplePlaneMask : MonoBehaviour {

    public Transform mask1;
    public Transform mask2;
    public Transform mask3;
    public Transform mask4;

    public Material material;


    void Start()
    {
        UIChangeInvert(false);
        UIChangeCount(3);
        UIChangeNoise(0);
    }

    // Update is called once per frame
    void Update () {

        material.SetVector("_DissolveMaskPosition", mask1.position);
        material.SetFloat("_DissolveMaskSphereRadius", mask1.localScale.x * 0.5f);

        material.SetVector("_DissolveMask2Position", mask2.position);
        material.SetFloat("_DissolveMask2SphereRadius", mask2.localScale.x * 0.5f);

        material.SetVector("_DissolveMask3Position", mask3.position);
        material.SetFloat("_DissolveMask3SphereRadius", mask3.localScale.x * 0.5f);

        material.SetVector("_DissolveMask4Position", mask4.position);
        material.SetFloat("_DissolveMask4SphereRadius", mask4.localScale.x * 0.5f);
    }



    public void UIChangeInvert(bool value)
    {
        material.SetFloat("_DissolveAxisInvert", value ? 1 : -1);
    }

    public void UIChangeCount(int value)
    {
        //For safety reasons disable all
        material.DisableKeyword("_DISSOLVEMASK_COUNT_TWO");
        material.DisableKeyword("_DISSOLVEMASK_COUNT_THREE");
        material.DisableKeyword("_DISSOLVEMASK_COUNT_FOUR");


        //UI slider returns index number
        value += 1;

        if (value == 2)
            material.EnableKeyword("_DISSOLVEMASK_COUNT_TWO");
        else if (value == 3)
            material.EnableKeyword("_DISSOLVEMASK_COUNT_THREE");
        else if (value == 4)
            material.EnableKeyword("_DISSOLVEMASK_COUNT_FOUR");
    }

    public void UIChangeNoise(float value)
    {
        material.SetFloat("_DissolveNoiseStrength", value);
    }
}
 