using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class animchange : MonoBehaviour {

    Renderer rend;
   // Color color;
    float alpfa;
	// Use this for initialization
	void Start () {
        rend = GetComponent<Renderer>();
        alpfa = 0;
        //color = GetComponent<Color>();
		
	}
	
	// Update is called once per frame
	void Update () {
        rend.material.color = new Color(1.0f,1.0f, 1.0f, alpfa);
        alpfa += 1;
	}
}
