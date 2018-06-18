using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameTimer : MonoBehaviour {
    int limitTime;//制限時間
    static int playTime;//プレイ時間

    void Awake() {
        limitTime = 50 * 60;
        playTime = 0;
    }

    // Use this for initialization
    void Start () {
        if (ChangeScene.OldScene == "StageSelect") {//パニックモードのみ表示
            gameObject.SetActive(false);
        }
	}
	
	// Update is called once per frame
	void Update () {
        limitTime--;
        playTime++;
        Debug.Log("limit : " + limitTime/60 + "play : " + playTime/60);
	}

    public int LimitTime {
        get {
            return limitTime;
        }
        set {
            limitTime += (value*60);
        }
    }

    public bool LimitOver() {
        if (limitTime <= 0) {
            limitTime = 0;
            return true;
        }
        else {
            return false;
        }
    }

    public static int PlayTime {
        get {
            return playTime/60;//秒で返す
        }
    }
}
