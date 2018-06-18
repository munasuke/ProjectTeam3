using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class corner2 : MonoBehaviour{

    public GameObject gameobject;
    public GameObject gameobject2;
    // Use this for initialization
    void Start () {

    }
    int i = 1;
    int tmpCnt = 0;
    // Update is called once per frame
    void Update()
    {
        if (gameobject == null)
        {
            tmpCnt++;
            if (tmpCnt <= 90)
            {
                this.transform.Rotate(0.0f, i, 0.0f);
            }
            else
            {
                Destroy(this.gameObject);
            }
        }
        if (gameobject2 == null)
        {
            tmpCnt++;
            if (tmpCnt <= 90)
            {
                this.transform.Rotate(0.0f, -i, 0.0f);
            }
            else
            {
                Destroy(this.gameObject);
            }
        }
    }
}
