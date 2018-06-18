using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class test : MonoBehaviour {

    public bool curb = false;
    public GameObject gameobject;

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
    public void OnCollisionExit(Collision col)
    {
        if (col.gameObject.CompareTag("fuge"))
        {
            gameobject = col.gameObject;
        }
    }
}
