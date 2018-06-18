using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Center : MonoBehaviour {

    public GameObject fuse_x_right;
    public GameObject fuse_x_left;
    public GameObject fuse_z_up;
    public GameObject fuse_z_down;

    public float fireSpeed;

    private bool SpeedFlag = false;

    public bool FireCenterFlag = false;
	// Use this for initialization
	void Start ()
    {
        fireSpeed = 2;
	}
	
	// Update is called once per frame
	void Update ()
    {
        if (Input.GetMouseButtonDown(1))
        {
            if (SpeedFlag == false)
            {
                fireSpeed = 10;
                SpeedFlag = true;
            }
            else if (SpeedFlag == true)
            {
                fireSpeed = 2;
                SpeedFlag = false;
            }
        }

        //右から移った時
        if (fuse_x_right.gameObject == null)
        {
            FireCenterFlag = true;
            this.gameObject.transform.localScale -= new Vector3(Time.deltaTime * fireSpeed, 0, 0);
            this.gameObject.transform.position -= new Vector3(Time.deltaTime, 0, 0);
            if(this.transform.localScale.x < 0)
            {
                Destroy(gameObject);
            }
        }

        //左から移った時
        if (fuse_x_left.gameObject == null)
        {
            FireCenterFlag = true;
            this.gameObject.transform.localScale -= new Vector3(Time.deltaTime * fireSpeed, 0, 0);
            this.gameObject.transform.position += new Vector3(Time.deltaTime, 0, 0);
            if (this.transform.localScale.x < 0)
            {
                Destroy(gameObject);
            }
        }

        //上から移った時
        if(fuse_z_up.gameObject == null)
        {
            FireCenterFlag = true;
            this.gameObject.transform.localScale -= new Vector3(0, 0, Time.deltaTime * fireSpeed);
            this.gameObject.transform.position -= new Vector3(0, 0, Time.deltaTime);
            if(this.transform.localScale.z < 0)
            {
                Destroy(gameObject);
            }
        }

        //下から移った時
        if(fuse_z_down.gameObject == null)
        {
            FireCenterFlag = true;
            this.gameObject.transform.localScale -= new Vector3(0, 0, Time.deltaTime * fireSpeed);
            this.gameObject.transform.position += new Vector3(0, 0, Time.deltaTime);
            if (this.transform.localScale.z < 0)
            {
                Destroy(gameObject);
            }
        }
    }
}
