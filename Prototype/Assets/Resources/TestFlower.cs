using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestFlower : MonoBehaviour {
    //SpriteRenderer sprite;
	// Use this for initialization
	void Start () {
        //sprite = gameObject.GetComponent<SpriteRenderer>();
    }

    // Update is called once per frame
    void Update () {
        for(int i = 2; i < 22; i++) {
            gameObject.GetComponent<SpriteRenderer>().sprite = Resources.Load("fireworks_20f/fire_"+i, typeof(Sprite)) as Sprite;
            if (i >= 21) {
                i = 2;
            }
        }
    }
}
