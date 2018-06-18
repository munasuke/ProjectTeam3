using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class fuse_x_left : MonoBehaviour {

    public GameObject fusecheck;

    public GameObject Centercheck;

    public GameObject fuse_x_right;
    public GameObject fuse_z_up;
    public GameObject fuse_z_down;

    public bool FuseFlag = false;
    public bool FireFuseFlag = false;

    public float fireSpeed;

    private bool SpeedFlag = false;
    // Use this for initialization
    void Start () {
        fireSpeed = 2;
    }
	
	// Update is called once per frame
	void Update ()
    {
        if (SpeedButton.ButtonFlag == true)
        {
            fireSpeed = 10;
        }
        else if (SpeedButton.ButtonFlag == false)
        {
            fireSpeed = 2;
        }
        FuseFlag = fusecheck.GetComponent<tip_Manager>().fuseFlag;

        //左から当たると左から消えだす
        if (FuseFlag)
        {
            FireFuseFlag = true;
            this.transform.localScale -= new Vector3(Time.deltaTime * fireSpeed, 0, 0);
            this.transform.Translate(Time.deltaTime * (fireSpeed / 2), 0, 0);
            if (this.transform.localScale.x < 0)
            {
                Destroy(this.gameObject);
            }
        }

        //右から移った時
        if (Centercheck.gameObject == null && fuse_x_right.gameObject == null)
        {
            FireFuseFlag = true;
            this.transform.localScale -= new Vector3(Time.deltaTime * fireSpeed, 0, 0);
            this.transform.Translate(-Time.deltaTime * (fireSpeed / 2), 0, 0);
            if (this.transform.localScale.x < 0)
            {
                Destroy(this.gameObject);
            }
        }
        //上から移った時
        else if (Centercheck.gameObject == null && fuse_z_up.gameObject == null)
        {
            FireFuseFlag = true;
            this.transform.localScale -= new Vector3(Time.deltaTime * fireSpeed, 0, 0);
            this.transform.Translate(-Time.deltaTime * (fireSpeed / 2), 0, 0);
            if (this.transform.localScale.x < 0)
            {
                Destroy(gameObject);
            }
        }
        //下から移った時
        else if (Centercheck.gameObject == null && fuse_z_down.gameObject == null)
        {
            FireFuseFlag = true;
            this.transform.localScale -= new Vector3(Time.deltaTime * fireSpeed, 0, 0);
            this.transform.Translate(-Time.deltaTime * (fireSpeed / 2), 0, 0);
            if (this.transform.localScale.x < 0)
            {
                Destroy(gameObject);
            }
        }
    }
    public void OnUserAction(string tag)
    {
        Debug.Log("a");
    }
}
