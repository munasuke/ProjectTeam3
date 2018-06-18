using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CheckObject : MonoBehaviour {
    string[] panelTag = {
        "Panel",//ノーマル
        "Panel_fixed",//固定
        "Panel_union",//合体
        "Panel_rota",//回転
    };

    private int moveCnt = 0;
    public int MoveCNT
    {
        get
        {
            return moveCnt;
        }
        private set
        {
            moveCnt = value;
        }
    }

    bool _flag = false;

    public bool RFlag = false;

    int movve_Panel = 0;

    void FixedUpdate()
    {
        GameObject g = GameObject.Find("Checker");
        Move_Check c = g.GetComponent<Move_Check>();


        if (Input.GetMouseButtonDown(0) && RFlag == false)
        {
            if (c.Check() == true)
            {
                Ray ray = new Ray();
                RaycastHit hit = new RaycastHit();
                ray = Camera.main.ScreenPointToRay(Input.mousePosition);

                //Panelにhitしたか判定
                if (Physics.Raycast(ray.origin, ray.direction, out hit, Mathf.Infinity))
                {
                    if (_flag == false && movve_Panel == 0)
                    {
                        _flag = true;
                        string tag = hit.collider.GetComponent<move_panel>().tag;
                        hit.collider.GetComponent<move_panel>().OnUserAction(tag, _flag);
                    }
                    if (_flag == true)
                    {
                        RFlag = true;
                    }
                }
                else if (!Physics.Raycast(ray.origin, ray.direction, out hit, Mathf.Infinity))
                {
                    c.Check();
                }
            }
        }
        if (RFlag == true)
        {
            RFlag = false;
            _flag = false;
        }
    }
}
