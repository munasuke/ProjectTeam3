using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoalRandom : MonoBehaviour {

    public bool GeneratFlag = false;
    GameObject ChangePanel;
    public bool NowFlag;
    public bool OldFlag;
    int DebugCnt = 0;
	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        if (GeneratFlag)
        {
            do
            {                
                ChangePanel = gameObject.GetComponent<Generation_panel>().panel[Random.Range(0, transform.childCount)];
                NowFlag = ChangePanel.transform.GetChild(0).GetChild(1).GetComponent<FireCheck>().NowFlag;
                OldFlag = ChangePanel.transform.GetChild(0).GetChild(1).GetComponent<FireCheck>().OldFlag;
                if (DebugCnt > 0)
                {
                    Debug.Log("再度ゴールにするマスを選びます");
                }
                DebugCnt++;
            } while ((NowFlag == true) || (OldFlag == true));
            
            Vector3 Pos = ChangePanel.transform.position;
            Destroy(ChangePanel);
            gameObject.GetComponent<RandPanel>().MakeGoal(Pos);
            GeneratFlag = false;
        }
    }
}
