using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class dokasen : MonoBehaviour {

    public GameObject gameobject1;
    public GameObject gameobject2;

    private bool fireFlag = false;
    private bool fireFlag2 = false;

    public bool tranceFrag=false;
    // Use this for initialization
    void Start () {
        
    }   

    // Update is called once per frame
    void Update () {
        fireFlag = gameobject1.GetComponent<dokasen_f>().hit_F;
        fireFlag2 = gameobject2.GetComponent<dokasen_b>().hit_B;
        if (fireFlag)
        {
            this.transform.localScale -= new Vector3(Time.deltaTime*2, 0, 0);
            this.transform.position -= new Vector3(0, 0, Time.deltaTime);

            if (this.transform.localScale.x < 0)
            {
                Destroy(this.gameObject);
            }
        }
        if (fireFlag2)
        {
            this.transform.localScale -= new Vector3(Time.deltaTime * 2, 0, 0);
            this.transform.position += new Vector3(0, 0, Time.deltaTime);

            if (this.transform.localScale.x < 0)
            {
                Destroy(this.gameObject);
            }
        }
    }
}
