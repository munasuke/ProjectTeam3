using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StageSetup : MonoBehaviour {
    string stage = SelectStage.GetStage();
    string level = PanicFestival.GetObjName();
    GameObject spre;//ステージ
    GameObject Camera;

    void Start () {
        Camera = GameObject.Find("Main Camera");
        if (SceneManager.GetActiveScene().name != "main") {
            return;
        }
        if (ChangeScene.OldScene == "StageSelect") {//じっくり
            for (int j = 0; j <= SelectStage.GetMax(); j++) {
                string num = (j).ToString();//10の位を文字列に変換
                for (int i = 0; i < 10; i++) {
                    if (stage == num + i) {
                        CameraPosSet(j, i);
                        spre = (GameObject)Resources.Load("stages/Stage" + num + i);
                        break;
                    }
                }
            }
        }
        else if (ChangeScene.OldScene == "LevelSelect") {//ぱにっく
            switch (level) {
                case "Level1":
                    Camera.transform.position = new Vector3(25.0f, 49.0f, 5.0f);
                    spre = (GameObject)Resources.Load("panics/Panic01");
                    break;
                default:
                    break;
            }
        }
        if (spre != null) {
            Instantiate(spre);//Prefabの呼び出し
        }
    }

    void CameraPosSet(int j, int i) {
        Vector3[] camPos = {
            new Vector3(19.0f, 40.0f, 10.0f),//4x4
            new Vector3(25.0f, 49.0f, 5.0f),//5x5
            new Vector3(30.0f, 62.0f, 0.0f)//6x6?
        };
        if (j == 1 && i == 0) {//10
            Camera.transform.position = camPos[0];
        }
        else if (j == 2 && i == 0) {//20
            Camera.transform.position = camPos[1];
        }
        else if (j == 3 && i == 0) {//30
            Camera.transform.position = camPos[2];
        }
        else {
            if (j == 0) {//01～
                Camera.transform.position = camPos[0];
            }
            else if (j == 1) {//11～
                Camera.transform.position = camPos[1];
            }
            else if (j == 2) {//21～
                Camera.transform.position = camPos[2];
            }
        }
    }
}
