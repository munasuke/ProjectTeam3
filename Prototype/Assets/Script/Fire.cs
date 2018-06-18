using System.Collections;
using System.Collections.Generic;
using UnityEngine.SceneManagement;
using UnityEngine;

public class Fire : MonoBehaviour
{
    [SerializeField]
    public static bool fireFlag;
    public static int FireSum;
    public int sum;
    public bool flag;
    public GameObject[] FuseCheck;
    public FireCheck fireCheck;

    private void Start()
    {
        FuseCheck = new GameObject[transform.childCount];
        for (int i = 0; i < FuseCheck.Length; i++)
        {
            FuseCheck[i] = transform.GetChild(i).gameObject;
        }
    }

    // Update is called once per frame
    void Update()
    {
        sum = FireSum;
        flag = fireFlag;
        if (FireSum == 0)
        {
            SceneManager.LoadScene("Result");
        }
        for (int i = 0; i < FuseCheck.Length; i++)
        {
            if (FuseCheck[i].gameObject != null)
            {
                if (FuseCheck[i].GetComponent<fuse_x_left>() != null)
                {
                    if (FuseCheck[i].GetComponent<fuse_x_left>().FireFuseFlag && fireFlag == false)
                    {
                        fireFlag = true;
                        FireSum++;
                    }
                }
                if (FuseCheck[i].GetComponent<fuse_x_right>() != null)
                {
                    if (FuseCheck[i].GetComponent<fuse_x_right>().FireFuseFlag && fireFlag == false)
                    {
                        fireFlag = true;
                        FireSum++;
                    }
                }
                if (FuseCheck[i].GetComponent<fuse_z_up>() != null)
                {
                    if (FuseCheck[i].GetComponent<fuse_z_up>().FireFuseFlag && fireFlag == false)
                    {
                        fireFlag = true;
                        FireSum++;
                    }
                }
                if (FuseCheck[i].GetComponent<fuse_z_down>() != null)
                {
                    if (FuseCheck[i].GetComponent<fuse_z_down>().FireFuseFlag && fireFlag == false)
                    {
                        fireFlag = true;
                        FireSum++;
                    }
                }
                if (FuseCheck[i].GetComponent<Center>() != null)
                {
                    if (FuseCheck[i].GetComponent<Center>().FireCenterFlag && fireFlag == false)
                    {
                        fireFlag = true;
                        FireSum++;
                    }
                }
            }
        }
    }

}
