using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StageMove : MonoBehaviour {
    // Use this for initialization
    float x;
    GameObject fadeObj;
    FadeController fade;
    string nextName;

    void Awake() {
    }

    void Start () {
        fadeObj = GameObject.Find("FadePanel");
        fade = fadeObj.GetComponent<FadeController>();
        fade.outFlag = false;
        switch (SelectStage.Page) {
            case 0:
                x = 0.0f;
                break;
            case 1:
                x = -170.0f;
                break;
            case 2:
                x = -340.0f;
                break;
            default:
                x = 0.0f;
                break;
        }
        transform.position += new Vector3(x, 0.0f, 0.0f);
	}
	
	// Update is called once per frame
	void Update () {
    }

    public void Action(ref string direction, uint page, int min, int max, Vector3 nextPos, ref bool flg, string stName) {
        float speed = 500.0f;

        switch (direction) {
            case "left":
                if (page >= min) {
                    transform.position = Vector3.MoveTowards(transform.position, nextPos, speed * Time.deltaTime);
                }
                break;
            case "right":
                if (page <= max - 1) {
                    transform.position = Vector3.MoveTowards(transform.position, nextPos, speed * Time.deltaTime);
                }
                break;
            case "touch":
                TouchAction(stName);
                break;
            case "non":
                break;
            default:
                break;
        }
        if (transform.position == nextPos) {
            direction = "non";
            flg = false;
        }
    }

    //タッチ時の行動
    void TouchAction(string name) {
        if (name == "<Back") {
            fade.outFlag = true;
            nextName = "ModeSelect";
        }
        for (int i = 0; i <= SelectStage.GetMax(); i++) {
            string num = (i).ToString();
            for (int j = 0; j < 10; j++) {
                if (name == num + j) {
                    fade.outFlag = true;
                    ChangeScene.OldScene = "StageSelect";
                    nextName = "main";
                }
            }
        }
    }

    //フェードアウトして遷移させる
    public void FadeToTheNext(string next) {
        if (fade.Flag == true) {
            fade.Flag = false;
            SceneManager.LoadScene(next);
        }
    }

    //次のシーンの名前を返す
    public string GetNextStageName() {
        return nextName;
    }

    public Vector3 GetStagePos() {
        return transform.position;
    }
}
