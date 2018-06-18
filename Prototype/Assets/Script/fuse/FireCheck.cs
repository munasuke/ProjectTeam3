using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FireCheck : MonoBehaviour {

    public GameObject[] Fuse;
    public bool MasterFrag;
    public int FireCnt = 0;
    public bool DethFlag = false;

    public bool NowFlag = false; 
    public bool OldFlag;    // 1フレーム前

    public bool OnFireFlag;

    // Use this for initialization
    void Start () {
        MasterFrag = false;
        OnFireFlag = false;
    }

    // Update is called once per frame
    void Update()
    {
        Fuse = new GameObject[transform.childCount];
        for (int i = 0; i < Fuse.Length; i++)
        {
            Fuse[i] = transform.GetChild(i).gameObject;
        }
        FireCnt = 0;
        for (int i = 0; i < Fuse.Length; i++)
        {
            if (Fuse[i].gameObject != null)
            {
                if (Fuse[i].GetComponent<fuse_x_left>() != null)
                {
                    if (Fuse[i].GetComponent<fuse_x_left>().FireFuseFlag)
                    {
                        FireCnt++;
                    }
                }
                if (Fuse[i].GetComponent<fuse_x_right>() != null)
                {
                    if (Fuse[i].GetComponent<fuse_x_right>().FireFuseFlag)
                    {
                        FireCnt++;
                    }
                }
                if (Fuse[i].GetComponent<fuse_z_up>() != null)
                {
                    if (Fuse[i].GetComponent<fuse_z_up>().FireFuseFlag)
                    {
                        FireCnt++;
                    }
                }
                if (Fuse[i].GetComponent<fuse_z_down>() != null)
                {
                    if (Fuse[i].GetComponent<fuse_z_down>().FireFuseFlag)
                    {
                        FireCnt++;
                    }
                }
                if (Fuse[i].GetComponent<Center>() != null)
                {
                    if (Fuse[i].GetComponent<Center>().FireCenterFlag)
                    {
                        FireCnt++;
                    }
                }
                if (FireCnt > 0)
                {
                    DethFlag = true;
                }
            }
        }

        if ((FireCnt <= 5)&&(FireCnt >= 1))
        {
            NowFlag = true;
        }
        else
        {
            NowFlag = false;
        }

        //if((NowFlag == true) || (OldFlag == true))
        //{
        //    OnFireFlag = true;
        //}
        //else if ((NowFlag == false) && (OldFlag == false))
        //{
        //    OnFireFlag = false;
        //}

        if ((NowFlag == false)&&(OldFlag == false) && DethFlag)
        {
            MasterFrag = true;
        }
        OldFlag = NowFlag;
    }
}
