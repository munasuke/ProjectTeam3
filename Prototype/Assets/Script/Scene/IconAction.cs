using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IconAction : MonoBehaviour {
    Vector3 pos;
	// Use this for initialization
	void Start () {
        pos = transform.position;
    }
	
	// Update is called once per frame
	void Update () {
        switch (transform.name) {
            case "<<":
            case ">>":
                PageMoveAction();
                break;
            default:
                break;
        }
	}

    void PageMoveAction() {
        Vector3 target;
        if (transform.name == "<<") {
            target = new Vector3(pos.x + -0.5f, pos.y, pos.z);
            transform.position = Vector3.MoveTowards(transform.position, target, 0.8f * Time.deltaTime);
            if (transform.position == target) {
                transform.position = pos;
            }
        }
        else {
            target = new Vector3(pos.x + 0.5f, pos.y, pos.z);
            transform.position = Vector3.MoveTowards(transform.position, target, 0.8f * Time.deltaTime);
            if (transform.position == target) {
                transform.position = pos;
            }
        }
    }
}
