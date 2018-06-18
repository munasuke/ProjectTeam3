using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CheckResult : MonoBehaviour {
    bool flg = true;
    int num = 1;

    GameObject backEffect;
    Vector3 target;
    Vector3 pos;
    bool turnFlag;
    public float speed;
    // Use this for initialization
    void Start () {
		if (num > 0) {
            flg = true;
        }
        backEffect = transform.GetChild(1).gameObject;
        pos = backEffect.GetComponent<RectTransform>().localPosition;
        turnFlag = true;
        speed = 80.0f;

        //アクティブ切り替え
        if (ChangeScene.OldScene == "StageSelect") {
            if (!Failure.FailureFlag) {//成功
                SetBackImage("LogicCrealBack", "LogicclearBack1");
                transform.GetChild(2).gameObject.SetActive(true);
                transform.GetChild(3).gameObject.SetActive(false);
            }
            else {//失敗
                SetBackImage("LogicNotclearBack", "LogicNotclearBack2");
                transform.GetChild(2).gameObject.SetActive(false);
                transform.GetChild(3).gameObject.SetActive(true);
            }
            transform.GetChild(4).gameObject.SetActive(false);
            transform.GetChild(5).gameObject.SetActive(false);
        }
        else if (ChangeScene.OldScene == "LevelSelect") {
            transform.GetChild(0).GetComponent<Image>().sprite = Resources.Load("Image/BackGround/PanicResult", typeof(Sprite)) as Sprite;
            transform.GetChild(1).gameObject.SetActive(false);
            transform.GetChild(2).gameObject.SetActive(false);
            transform.GetChild(3).gameObject.SetActive(false);
        }
    }

    // Update is called once per frame
    void Update () {
        if (ChangeScene.OldScene == "StageSelect") {
            if (!Failure.FailureFlag) {
                EffectAction();
            }
        }
    }

    void SetBackImage(string back, string backEF) {
        Sprite[] backImg = {
            Resources.Load("Image/BackGround/" + back, typeof(Sprite)) as Sprite,//背景
            Resources.Load("Image/BackGround/" + backEF, typeof(Sprite)) as Sprite//背景効果
        };
        for (int i = 0; i < backImg.Length; i++) {
            transform.GetChild(i).GetComponent<Image>().sprite = backImg[i];
        }
    }


    void EffectAction() {
        if (turnFlag) {
            target = new Vector3(pos.x, pos.y + 10f, pos.z);
            backEffect.GetComponent<RectTransform>().localPosition = Vector3.MoveTowards(backEffect.GetComponent<RectTransform>().localPosition, target, speed * Time.deltaTime);
            if (backEffect.GetComponent<RectTransform>().localPosition == target) {
                turnFlag = false;
            }
        }
        else {
            target = new Vector3(pos.x, pos.y - 10f, pos.z);
            backEffect.GetComponent<RectTransform>().localPosition = Vector3.MoveTowards(backEffect.GetComponent<RectTransform>().localPosition, target, (speed + 20.0f) * Time.deltaTime);
            if (backEffect.GetComponent<RectTransform>().localPosition == target) {
                turnFlag = true;
            }
        }
    }
}
