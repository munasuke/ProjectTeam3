using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlaneAndSphereMask : MonoBehaviour
{
    public Material material;

    Vector3 rotate;
    bool isSphereMask;
    float radius;

    public GameObject planeUI;
    public GameObject sphereUI;

    public Mesh planeMesh;
    public Mesh sphereMesh;

    // Use this for initialization
    void Start()
    {
        Reset();
    }

    void OnDisable()
    {
        Reset();
    }

    // Update is called once per frame
    void Update()
    {
        //Update mask position
        if(Input.GetKey(KeyCode.LeftControl))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit))
            {
                transform.position = new Vector3(hit.point.x, 1, hit.point.z); //Just a little bit height than hit point
            }
        }


        if(material)
        {
            material.SetVector("_DissolveMaskPosition", transform.position);
            material.SetVector("_DissolveMaskPlaneNormal", transform.up);
        }
    }



    private void Reset()
    {
        rotate = new Vector3(0, 225, 270);
        transform.eulerAngles = rotate;

        UINoiseChanged(0);
        UIToggleInvert(false);
        UIChangeRadius(4);
        UIChangeMask(0);       
    }

    public void UIRotateX(float value)
    {
        rotate.x = value;

        transform.eulerAngles = rotate;
    }

    public void UIRotateY(float value)
    {
        rotate.y = value;

        transform.eulerAngles = rotate;
    }

    public void UIRotateZ(float value)
    {
        rotate.z = value;

        transform.eulerAngles = rotate;
    }

    public void UINoiseChanged(float value)
    {
        if (material != null)
            material.SetFloat("_DissolveNoiseStrength", value);
    }

    public void UIToggleInvert(bool value)
    {
        if (material != null)
            material.SetFloat("_DissolveAxisInvert", value ? -1 : 1);
    }

    public void UIChangeMask(int value)
    {
        isSphereMask = value == 1 ? true : false;

        if (material != null)
        {
            //Just for safety reasons dissable all keywords
            material.DisableKeyword("_DISSOLVEMASK_NONE");
            material.DisableKeyword("_DISSOLVEMASK_AXIS_LOCAL");
            material.DisableKeyword("_DISSOLVEMASK_AXIS_GLOBAL");
            material.DisableKeyword("_DISSOLVEMASK_PLANE");
            material.DisableKeyword("_DISSOLVEMASK_SPHERE");


            //Enable Local or Global
            if (isSphereMask)
            {
                material.EnableKeyword("_DISSOLVEMASK_SPHERE");

                if(planeUI != null)
                    planeUI.SetActive(false);
                if(sphereUI != null)
                    sphereUI.SetActive(true);

                transform.GetComponent<MeshFilter>().sharedMesh = sphereMesh;
                transform.localScale = Vector3.one * radius * 2;
            }
            else
            {
                material.EnableKeyword("_DISSOLVEMASK_PLANE");

                if (planeUI != null)
                    planeUI.SetActive(true);
                if (sphereUI != null)
                    sphereUI.SetActive(false);

                transform.GetComponent<MeshFilter>().sharedMesh = planeMesh;
                transform.localScale = Vector3.one * 0.6f;
            }
        }
    }

    public void UIChangeRadius(float value)
    {
        radius = value;

        if (material != null)
            material.SetFloat("_DissolveMaskSphereRadius", radius);

        transform.localScale = Vector3.one * radius * 2;
    }

}
