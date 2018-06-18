using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

//PaniccFestival
public class PanicFestival : MonoBehaviour {
    static string objName;
    string nextScene;
    GameObject fade;
    FadeController fd;
	// Use this for initialization
	void Start () {
        fade = GameObject.Find("FadePanel");
        fd = fade.GetComponent<FadeController>();
	}

    // Update is called once per frame
    void Update() {
        if (Input.GetMouseButtonUp(0)) {
            CheckHitObject();
        }
        if (fd.Flag) {
            fd.Flag = false;
            ChangeScene.OldScene = "LevelSelect";
            SceneManager.LoadScene(nextScene);
        }
    }

    void CheckHitObject() {
        Ray ray = new Ray();
        RaycastHit hit = new RaycastHit();
        ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray.origin, ray.direction, out hit, Mathf.Infinity)) {
            objName = hit.collider.gameObject.name;
            switch (objName) {
                case "Back":
                    fd.outFlag = true;
                    nextScene = "ModeSelect";
                    break;
                case "Level1":
                    fd.outFlag = true;
                    nextScene = "main";
                    break;
                default:
                    break;
            }
        }
    }

    public static string GetObjName() {
        return objName;
    }
}
