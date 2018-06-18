using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DontMovePanel : MonoBehaviour {

    public GameObject start;
    public GameObject[] panel;
    public bool startFlag;
	// Use this for initialization
	void Start () {
        panel = new GameObject[transform.childCount];
        for(int i = 0;i < panel.Length; i++)
        {
            panel[i] = transform.GetChild(i).gameObject;
        }
	}
	
	// Update is called once per frame
	void Update () {
        startFlag = start.gameObject.GetComponent<botton_start>().startFlag;
        if (startFlag)
        {
            for (int i = 0; i < panel.Length; i++)
            {
                panel[i].GetComponent<move_panel>().enabled = false;
            }
        }
	}
}
