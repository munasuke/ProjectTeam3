using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FlowerNum : MonoBehaviour {

    void Awake() {
        GetComponent<Text>().text = (ChangeScene.FireFlowerNum).ToString();
    }

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
