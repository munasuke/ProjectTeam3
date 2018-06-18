using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DrawPlayTime : MonoBehaviour {

    void Awake() {
        GetComponent<Text>().text = (GameTimer.PlayTime).ToString();
    }

    // Use this for initialization
    void Start () {
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
