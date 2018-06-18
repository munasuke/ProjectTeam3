using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move_Check : MonoBehaviour
{
    public CheckObject CheckObject;
    public move_panel  move_panel;
   
    public int move_Check;
    public bool returnflag;

    private void Start()
    {
        GameObject g = GameObject.Find("Checker");
        CheckObject c = g.GetComponent<CheckObject>();
        move_Check = c.MoveCNT;

    }

    // Update is called once per frame
    public bool Check()
    {
        if(move_Check == 0)
        {
            move_Check = 1;
            returnflag = true;
            return returnflag;
        }
        else if(move_Check == 1)
        {
            move_Check = 0;
            returnflag = false;
            return returnflag;
        }
        return false;
    }
}
