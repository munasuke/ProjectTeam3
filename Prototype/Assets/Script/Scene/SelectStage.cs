using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SelectStage : MonoBehaviour {

    Vector3 touchPosStart;
    Vector3 touchPosEnd;
    bool CamMoveFlag;//カメラが動いているか見る
    Vector3 touchStagePos;//指を離したときのステージの座標

    static string stName;//ステージ名
    string direction;//フリックとタッチを判別
    Vector3 nextPos;

    GameObject stages;
    StageMove st;//スクリプト参照用
    static uint page;//現在のページ
    int min;
    static int max;

    void Awake() {
        CamMoveFlag = false;
        touchStagePos = Vector3.zero;
        stName = "Non";
        page = ChangeScene.OldScene == "Result" || ChangeScene.OldScene == "main" ? page : 0;
        direction = "non";
        nextPos = Vector3.zero;
        stages = GameObject.Find("stages");
        st = stages.GetComponent<StageMove>();
        min = 0;
        max = stages.transform.childCount / 10;
    }

    void Update() {
        if (!CamMoveFlag) {
            if (Input.GetMouseButtonDown(0)) {//タッチした位置を取得
                touchPosStart = new Vector3(Input.mousePosition.x, Input.mousePosition.y, Input.mousePosition.z);
            }
            if (Input.GetMouseButtonUp(0)) {//離した位置を取得
                touchPosEnd = new Vector3(Input.mousePosition.x, Input.mousePosition.y, Input.mousePosition.z);
                touchStagePos = st.GetStagePos();
                CamMoveFlag = true;
                GetDir(touchPosEnd, touchPosStart);
            }
        }
        else {
            st.Action(ref direction, page, min, max, nextPos, ref CamMoveFlag, stName);
        }
        st.FadeToTheNext(st.GetNextStageName());
    }

    //移動量に応じた行動をとる
    void GetDir(Vector3 endPos, Vector3 startPos) {
        Vector3 dir = new Vector3(endPos.x - startPos.x, 0.0f, 0.0f);//移動量を取得
        float x = 0.0f;
        if (40.0f < dir.x) {//左にフリック
            if (page > min) {
                direction = "left";
                x = 170.0f;
                page--;
            }
        }
        else if (-40.0f > dir.x) {//右にフリック
            if (page < max - 1) {
                direction = "right";
                x = -170.0f;
                page++;
            }
        }
        else if (touchPosStart == touchPosEnd) {//タッチ
            direction = "touch";
            Ray ray = new Ray();
            RaycastHit hit = new RaycastHit();
            ray = Camera.main.ScreenPointToRay(touchPosEnd);

            if (Physics.Raycast(ray.origin, ray.direction, out hit, Mathf.Infinity)) {
                stName = hit.collider.gameObject.name;//hitしたオブジェクトの名前を取得
                Debug.Log(stName);
                if (stName == "<<") {
                    int a = 0;
                    if (page > min) {
                        direction = "left";
                        x = 170.0f;
                        page--;
                    }
                }
                else if (stName == ">>") {
                    if (page < max - 1) {
                        direction = "right";
                        x = -170.0f;
                        page++;
                    }
                }
            }
        }
        nextPos = touchStagePos + new Vector3(x, 0.0f, 0.0f);//移動先を設定
    }

    //ステージ名を返す
    public static string GetStage() {
        return stName;
    }
    //ページを返す
    public static uint Page {
        get {
            return page;
        }
        set {
            page = value;
        }
    }
    //最小を返す
    public int GetMin() {
        return min;
    }
    //最大を返す
    public static int GetMax() {
        return max;
    }
}
