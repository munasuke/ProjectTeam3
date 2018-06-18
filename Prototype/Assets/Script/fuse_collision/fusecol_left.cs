using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class fusecol_left : MonoBehaviour
{
    public float raydistance;
    public GameObject fuse;
    public LayerMask Mask;
    int RayCnt;
    // Use this for initialization
    void Start()
    {
        raydistance = 10.0f;
        RayCnt = 0;
    }

    // Update is called once per frame
    void Update()
    {
        Ray ray = new Ray(transform.position, transform.right);
        Debug.DrawRay(transform.position, transform.right, Color.red ,10f);
        RaycastHit[] hits = Physics.RaycastAll(ray, raydistance, Mask);
        int LayerMask = 1 << 8;
        LayerMask = ~LayerMask;


        if (fuse.gameObject == null)
        {
            RayCnt++;
            if (RayCnt <= 10)
            {
                for (int i = 0; i < hits.Length; i++)
                {
                    RaycastHit hit = hits[i];
                    if (Physics.Raycast(ray, out hit, raydistance, LayerMask))
                    {
                        if (hit.collider.gameObject.CompareTag("tip") && hit.collider)
                        {
                            hit.collider.GetComponent<tip_Manager>().fuseFlag = true;
                            hit.collider.transform.parent.parent.GetComponent<FireCheck>().OnFireFlag = true;
                        }
                        else if (hit.collider.gameObject.CompareTag("trigger"))
                        {
                            Destroy(hit.collider.gameObject);
                            Destroy(gameObject);
                        }
                        else
                        {
                            Debug.Log("Destroy");
                            Destroy(gameObject);
                        }
                    }
                }
            }
        }
    }       
}

