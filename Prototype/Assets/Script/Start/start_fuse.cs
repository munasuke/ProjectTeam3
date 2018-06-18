using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class start_fuse : MonoBehaviour {

    public int Cnt;
    public float fireSpeed;
    public bool startFlag = false;

    public GameObject start;
    // Use this for initialization
    void Start () {
        fireSpeed = 2;
        Cnt = 0;
        Fire.FireSum = 1;
    }
	
	// Update is called once per frame
	void Update () {

        //if (ChangeScene.OldScene == "StageSelect")
        //{
        //    startFlag = start.gameObject.GetComponent<botton_start>().startFlag;
        //    if (startFlag)
        //    {
        //        Cnt++;
        //        if (Cnt >= 60)
        //        {
        //            this.transform.localScale -= new Vector3(Time.deltaTime * fireSpeed, 0, 0);
        //            this.transform.Translate(Time.deltaTime * (fireSpeed / 2), 0, 0);
        //            if (this.transform.localScale.x < 0)
        //            {
        //                Cnt = 0;
        //                Destroy(this.gameObject);
        //            }
        //        }
        //    }
        //}
        //if (ChangeScene.OldScene == "LevelSelect")
        //{
            Cnt++;
            if (Cnt >= 180)
            {
                this.transform.localScale -= new Vector3(Time.deltaTime * fireSpeed, 0, 0);
                this.transform.Translate(Time.deltaTime * (fireSpeed / 2), 0, 0);
                if (this.transform.localScale.x < 0)
                {
                    Cnt = 0;
                    Destroy(this.gameObject);
                }
            }
        //}
    }
}
