using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MainBackGround : MonoBehaviour {

	// Use this for initialization
	void Awake () {
        string fileName;
        if (SceneManager.GetActiveScene().name == "main") {
            fileName = ChangeScene.OldScene == "StageSelect" ? "LogicStageBack" : "PanicStageBack";
            Sprite sprite = Resources.Load("Image/BackGround/" + fileName, typeof(Sprite)) as Sprite;
            Image img = transform.GetChild(0).GetComponent<Image>();
            img.sprite = sprite;
        }
    }
}
