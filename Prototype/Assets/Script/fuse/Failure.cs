using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Failure : MonoBehaviour {

    public GameObject[] panel;
    
    public bool startFlag;

    public bool[] OnFireFlag;
    //public bool[] OldOnFireFlag;
    
    public static bool FailureFlag = false;

    public int Cnt;
	// Use this for initialization
	void Start () {
        startFlag = false;
        Cnt = 0;
    }

    // Update is called once per frame
    void Update()
    {
        panel = new GameObject[transform.childCount];
        OnFireFlag = new bool[transform.childCount];
        //OldOnFireFlag = new bool[transform.childCount];

        Cnt = transform.childCount;

        for (int i = 0; i < panel.Length; i++)
        {
            panel[i] = transform.GetChild(i).Find("Fuse").Find("clossFuse").gameObject;
        }
        for (int i = 0; i < panel.Length ; i++)
        {
            OnFireFlag[i] = panel[i].gameObject.GetComponent<FireCheck>().OnFireFlag;
            if (OnFireFlag[i])
            {
                Cnt++;
            }
            else if(!OnFireFlag[i])
            {
                Cnt--;
            }
            if ((Cnt == 0) && (startFlag == true) && (!OnFireFlag[i])/*&&(!OldOnFireFlag[i])*/)
            {
                FailureFlag = true;
                Debug.Log("失敗");
            }
        }
        if (Cnt >= 1)
        {
            startFlag = true;
        }
        //for (int i = 0; i < panel.Length; i++)
        //{
        //    OldOnFireFlag[i] = OnFireFlag[i];
        //}
    }
}
