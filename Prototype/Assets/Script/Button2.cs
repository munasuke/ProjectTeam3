﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Button2 : MonoBehaviour {

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    public void OnClick()
    {
        gameObject.SetActive(false);
        MyCanvas.SetActive("Button", true);
        SpeedButton.ButtonFlag = false;
    }
}
