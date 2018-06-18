using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ModeSelect : MonoBehaviour {
    static string objName;
    string nextScene;
    GameObject fade;
    FadeController fd;
    bool choiceLogic;
    bool choicePanic;
    // Use this for initialization
    void Start() {
        fade = GameObject.Find("FadePanel");
        fd = fade.GetComponent<FadeController>();
        choiceLogic = false;
        choicePanic = false;
    }

    // Update is called once per frame
    void Update() {
        if (Input.GetMouseButtonUp(0)) {
            CheckHitObject();
        }
        if (fd.Flag) {
            fd.Flag = false;
            ChangeScene.OldScene = "ModeSelect";
            SceneManager.LoadScene(nextScene);
        }
    }

    void CheckHitObject() {
        Ray ray = new Ray();
        RaycastHit hit = new RaycastHit();
        ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray.origin, ray.direction, out hit, Mathf.Infinity)) {
            objName = hit.collider.gameObject.name;
            Debug.Log(objName);
            switch (objName) {
                case "Back":
                    NextScene("Title");
                    break;
                case "LogicMode":
                    if (choiceLogic == false) {
                        choiceLogic = true;
                        choicePanic = false;
                        break;
                    }
                    else {
                        NextScene("StageSelect");//2Click目で遷移させる
                    }
                    break;
                case "PanicMode":
                    if (choicePanic == false) {
                        choicePanic = true;
                        choiceLogic = false;
                        break;
                    }
                    else {
                        NextScene("LevelSelect");
                    }
                    break;
                case "TutorialMode":
                    NextScene("Tutorial");
                    break;
                default:
                    break;
            }
        }
    }

    void NextScene(string name) {
        fd.outFlag = true;
        nextScene = name;
    }

    public bool ChoiceLogic() {
        return choiceLogic;
    }

    public bool ChoicePanic() {
        return choicePanic;
    }
}
