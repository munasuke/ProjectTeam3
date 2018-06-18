using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class corner : MonoBehaviour {

    public GameObject Up_or_Down;
    public GameObject Right_or_Left;

    public bool FireCenterFlag = false;
    // Use this for initialization
    void Start () {
        
    }
    int i = 2;
    int tmpCnt=0;
	// Update is called once per frame
	void Update () { 
        if (Up_or_Down == null)
        {
            FireCenterFlag = true;
            tmpCnt++;
            if (tmpCnt <= 90/i)
            {
                this.transform.Rotate(0.0f, -i, 0.0f);
            }
            else
            {
                Destroy(this.gameObject);
            }
        }
        if (Right_or_Left == null)
        {
            FireCenterFlag = true;
            tmpCnt++;
            if (tmpCnt <= 90/i)
            {
                this.transform.Rotate(0.0f, i, 0.0f);
            }
            else
            {
                Destroy(this.gameObject);
            }
        }
    }
}
