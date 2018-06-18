using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawModeText : MonoBehaviour {
    ModeSelect obj;
    Vector3 firstPos;
    Vector3 firstPos1;
    int cnt;
    int cnt1;
    // Use this for initialization
    void Start () {
        obj = GameObject.Find("Main Camera").GetComponent<ModeSelect>();
        firstPos = transform.GetChild(1).transform.localPosition;
        firstPos1 = transform.GetChild(2).transform.localPosition;
        cnt = 0;
        cnt1 = 0;
    }
	
	// Update is called once per frame
	void Update () {
        if (obj.ChoiceLogic() == true) {//LogicMode
            transform.GetChild(1).gameObject.SetActive(true);
            transform.GetChild(0).gameObject.SetActive(false);
            transform.GetChild(2).gameObject.SetActive(false);

            transform.GetChild(2).transform.localPosition = firstPos1;
            cnt1 = 0;
            //TextScroll
            Vector3 target = new Vector3(-193.0f, firstPos.y, firstPos.z);
            if (transform.GetChild(1).transform.localPosition.x <= target.x) {
                transform.GetChild(1).transform.localPosition = firstPos;
                cnt = 0;
            }
            else {
                if (cnt >= 60) {
                    transform.GetChild(1).transform.localPosition = Vector3.MoveTowards(transform.GetChild(1).transform.localPosition, target, 30 * Time.deltaTime);
                }
            }
            cnt++;
        }
        else if (obj.ChoicePanic() == true) {//PanicMode
            transform.GetChild(2).gameObject.SetActive(true);
            transform.GetChild(0).gameObject.SetActive(false);
            transform.GetChild(1).gameObject.SetActive(false);

            transform.GetChild(1).transform.localPosition = firstPos;
            cnt = 0;
            //TextScroll
            Vector3 target = new Vector3(-208.0f, firstPos1.y, firstPos1.z);
            if (transform.GetChild(2).transform.localPosition.x <= target.x) {
                transform.GetChild(2).transform.localPosition = firstPos1;
                cnt1 = 0;
            }
            else {
                if (cnt1 >= 60) {
                    transform.GetChild(2).transform.localPosition = Vector3.MoveTowards(transform.GetChild(2).transform.localPosition, target, 30 * Time.deltaTime);
                }
            }
            cnt1++;
        }
        else {//Non
            transform.GetChild(0).gameObject.SetActive(true);
            transform.GetChild(1).gameObject.SetActive(false);
            transform.GetChild(2).gameObject.SetActive(false);
        }
    }
}
