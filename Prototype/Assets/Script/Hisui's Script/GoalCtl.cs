using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GoalCtl : MonoBehaviour {
    
    public int PANEL_X = 5;    // 横のマス数(初期値５)
    public int PANEL_Y = 5;    // 縦のマス数(初期値５)

    private Vector3 L_UP;
    private Vector3 R_UP;
    private Vector3 L_DOWN;
    private Vector3 R_DOWN;

    private const int PANEL_SIZE = 10;
    private const int Offset = 5;
    
    // Use this for initialization
    void Start () {
        R_UP = new Vector3((PANEL_X - 1) * PANEL_SIZE + Offset,0, (PANEL_Y - 1) * PANEL_SIZE + Offset);
        L_UP = new Vector3(Offset,0, (PANEL_Y-1) * PANEL_SIZE + Offset);
        R_DOWN = new Vector3((PANEL_X - 1) * PANEL_SIZE + Offset, 0, Offset);
        L_DOWN = new Vector3(Offset, 0, Offset);
    }
	
	// Update is called once per frame
	void Update () {
		
	}

    public int SetGoalCheck(Vector3 pos,int GoalNum)
    {
        if (pos == R_UP)
        {
            return 0;
        }
        if (pos == L_UP)
        {
            return 1;
        }
        if (pos == R_DOWN)
        {
            return 2;
        }
        if (pos == L_DOWN)
        {
            return 3;
        }
        return -1;
    }
}
