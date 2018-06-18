using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HideObject : MonoBehaviour {
    bool flg;
    int num;
    // Use this for initialization
    void Start () {
        flg = true;
        num = 0;
    }

    // Update is called once per frame
    void Update () {
        if (GetEnd()) {
            transform.GetChild(num).gameObject.SetActive(false);
        }
        else {
            transform.GetChild(num).gameObject.SetActive(true);
        }
        flg =! flg;
        num = flg ? 0 : 1;
    }

    //ステージ選択の端にいるか見る
    bool GetEnd() {
        if (num == 0) {
            if (SelectStage.Page == GetComponent<SelectStage>().GetMin()) {//左端か見る
                return true;
            }
            else {
                return false;
            }
        }
        else {
            if (SelectStage.Page == SelectStage.GetMax() - 1) {//右端か見る
                return true;
            }
            else {
                return false;
            }
        }
    }
}
