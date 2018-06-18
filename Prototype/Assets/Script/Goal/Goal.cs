using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Goal : MonoBehaviour {
    public GameObject GoalObject;
    public uint a;
    // Use this for initialization
    void Start () {
        a = 0;
    }

    // Update is called once per frame
    void Update()
    {
        GameObject SceneChanger = GameObject.Find("SceneChanger");
        //ChangeScene scene = SceneChanger.GetComponent<ChangeScene>();

        if ((GoalObject.gameObject == null)&&(a == 0))
        {
            SceneChanger.GetComponent<ChangeScene>().AddClearNum();
            a++;
        }
    }

}
