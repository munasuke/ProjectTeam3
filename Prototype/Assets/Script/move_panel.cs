using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class move_panel : MonoBehaviour {

    public Move_Check Move_Check;

    Vector3[] vec = {
            Vector3.back,//Down
            Vector3.forward,//Up
            Vector3.right,//Left
            Vector3.left//Right
        };
    public Vector3 _tmp;
    public Vector3 _tmp2;
    public bool moveFlag;
    public bool fireCheckflag;

    public FireCheck FireFlag;

    private void FixedUpdate()
    {
        //fireCheckflag = FireFlag.MasterFrag;

        GameObject g = GameObject.Find("Checker");
        CheckObject c = g.GetComponent<CheckObject>();
        GameObject h = GameObject.Find("Checker");
        Move_Check d = h.GetComponent<Move_Check>();
        if (moveFlag == true)
        {
            //if (fireCheckflag == false)
            //{
                if (tag == "Panel" || tag == "Panel_union")
                {
                    //   transform.position += vec[i] * 10;
                    if (transform.position != _tmp2)
                    {
                        transform.position = Vector3.MoveTowards(transform.position, _tmp2, 100 * Time.deltaTime);
                    }
                    if (transform.position == _tmp2)
                    {
                        moveFlag = false;
                        c.RFlag = true;
                        if (d.move_Check == 1)
                        {
                            d.Check();
                        }
                    }
                }
            //}
        }
    }

    public void OnUserAction (string tag , bool flag)
    {
        int cnt = 0;
        Vector3 rota = new Vector3(0.0f, 90.0f, 0.0f);
        GameObject g = GameObject.Find("Checker");
        CheckObject c = g.GetComponent<CheckObject>();
        GameObject h = GameObject.Find("Checker");
        Move_Check d = h.GetComponent<Move_Check>();

        if(tag =="Start" || tag == "Goal" || tag == "Wall")
        {
            if (d.move_Check == 1)
            {
                d.Check();
            }
        }

        for (int i = 0; i < 4; i++) {
            if (CheckMove(vec[i], tag) == true)
            {
                if (moveFlag == false)
                {
                    _tmp = vec[i];
                    _tmp2 = transform.position + vec[i] * 10;
                    moveFlag = true;
                }
                if (tag == "Panel_rota")
                {
                    transform.Rotate(rota);
                    c.RFlag = true;
                    d.Check();
                }
                //Debug.Log(tag);
                break;
            }
            if (!CheckMove(vec[i], tag) == true)
            {
                cnt++;
                if (cnt == 4 && d.move_Check == 1)
                {
                    d.Check();
                    cnt = 0;
                }
            }
                //else if(CheckMove(vec[i], tag) == false && c.GetComponent<CheckObject>().RFlag == false && moveFlag == false)
                //{
                //    c.GetComponent<CheckObject>().RFlag = true;
                //}
            }
        }

    //周囲を検索
    bool CheckMove(Vector3 dir, string tag) {

        int layerMask = 1 << 8;//マスク

        if (tag == "Panel_rota")
        {
            return true;
        }
        if (tag != "Panel_union")
        {
            if (Physics.Raycast(transform.position, dir, 10.0f, layerMask) == true)
            {
                return false;
            }
        }
        else {
            if (transform.localScale.x == 2)
            {//横長
                if (Physics.Raycast(transform.position + new Vector3(5.0f, 0.0f, 0.0f), dir, 10.0f, layerMask) == true)
                {
                    return false;
                }
                if (Physics.Raycast(transform.position + new Vector3(-5.0f, 0.0f, 0.0f), dir, 10.0f, layerMask) == true)
                {
                    return false;
                }
            }
            else if (transform.localScale.z == 2)
            {//縦長
                if (Physics.Raycast(transform.position + new Vector3(0.0f, 0.0f, 5.0f), dir, 10.0f, layerMask) == true)
                {
                    return false;
                }
                if (Physics.Raycast(transform.position + new Vector3(0.0f, 0.0f, -5.0f), dir, 10.0f, layerMask) == true)
                {
                    return false;
                }
            }
        }
        return true;
    }
}
