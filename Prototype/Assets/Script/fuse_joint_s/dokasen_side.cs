using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class dokasen_side : MonoBehaviour
{

    public GameObject gameobject;
    public GameObject gameobject2;

    private bool fireFlag = false;
    private bool fireFlag2 = false;

    public bool tranceFrag = false;
    // Use this for initialization
    void Start()
    {

    }


    // Update is called once per frame
    void Update()
    {
        fireFlag = gameobject.GetComponent<dokasen_l>().hit_L;
        fireFlag2 = gameobject2.GetComponent<dokasen_r>().hit_R;
        if (fireFlag)
        {
            this.transform.localScale -= new Vector3(Time.deltaTime * 2, 0, 0);
            this.transform.position -= new Vector3(Time.deltaTime, 0, 0);

            if (this.transform.localScale.x < 0)
            {
                Destroy(this.gameObject);
            }
        }
        if (fireFlag2)
        {
            this.transform.localScale -= new Vector3(Time.deltaTime * 2, 0, 0);
            this.transform.position += new Vector3(Time.deltaTime, 0,0);

            if (this.transform.localScale.x < 0)
            {
                tranceFrag = true;
                Destroy(this.gameObject);
            }
        }
    }
}
