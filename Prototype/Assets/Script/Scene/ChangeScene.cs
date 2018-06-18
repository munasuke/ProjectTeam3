using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ChangeScene : MonoBehaviour {
    GameObject[] goal;//ゴール数
    uint clear_num;
    static uint fire_flower_num;
    static string old_scene;//一つ前のシーン
    bool flg;
    GameObject fadeObj;
    FadeController fade;
    GameTimer time;

    void Awake() {
        clear_num = 0;
        fire_flower_num = 0;
        flg = false;
    }

    void Start() {
        fadeObj = GameObject.Find("FadePanel");
        fade = fadeObj.GetComponent<FadeController>();
        fade.outFlag = false;
        if (SceneManager.GetActiveScene().name == "main") {
            time = GameObject.Find("Timer").GetComponent<GameTimer>();//制限時間
        }
    }

    void Update() {
        switch (SceneManager.GetActiveScene().name) {
            case "Title":
                TitleScene();
                break;
            case "main":
                MainScene();
                break;
            case "Result":
                ResultScene();
                break;
            default:
                break;
        }
    }

    //タイトル
    void TitleScene() {
        if (Input.GetMouseButton(0)) {
            fade.outFlag = true;
        }
        OnFadeOut("Title", "ModeSelect");
    }

    //メイン
    void MainScene() {
        if (Input.GetKey(KeyCode.Z)) {//デバッグ用
            flg = true;
            fade.outFlag = true;
        }
        if (Input.GetKey(KeyCode.X)) {//デバッグ用
            old_scene = "StageSelect";
            SceneManager.LoadScene("Result");
        }
        goal = GameObject.FindGameObjectsWithTag("Goal");//goalPanelの数を取得
        ClearCheck(goal.Length);
    }

    //リザルト
    void ResultScene() {
        if (flg == true) {
            if (old_scene == "StageSelect") {
                OnFadeOut("Result", "StageSelect");
            }
            else if (old_scene == "LevelSelect") {
                OnFadeOut("Result", "LevelSelect");
            }
        }
    }

    public void SetFlag() {
        flg = true;
        fade.outFlag = true;
        Time.timeScale = 1;
    }

    //クリアチェック
    void ClearCheck(int max) {
        if (old_scene == "StageSelect") {//じっくりコトコトふぇすてぃばる
            if (clear_num == max || Failure.FailureFlag) {
                fade.outFlag = true;
                OnFadeOut("StageSelect", "Result");
            }
            else {
                flg = false;
                OnFadeOut("main", "StageSelect");
            }
            Debug.Log(max);
            Debug.Log("c:"+clear_num);
        }
        else {//パニックふぇすてぃばる
            if (time.LimitOver() || Failure.FailureFlag) {
                fade.outFlag = true;
                OnFadeOut("LevelSelect", "Result");
            }
            else {
                flg = false;
                OnFadeOut("main", "LevelSelect");
            }
            Debug.Log(old_scene);
        }
    }

    //フェードアウトしながら遷移する
    public void OnFadeOut(string old, string next) {
        if (fade.Flag == true) {
            fade.Flag = false;
            old_scene = old;
            SceneManager.LoadScene(next);
        }
    }

    //ゴール到達数をカウント
    public void AddClearNum() {
        clear_num++;
        fire_flower_num++;
    }

    public static uint FireFlowerNum {
        get {
            return fire_flower_num;
        }
    }

    //1つ前のシーンのGetSet
    public static string OldScene {
        get {
            return old_scene;
        }
        set {
            old_scene = value;
        }
    }
}
