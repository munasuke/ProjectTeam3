using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class fire : MonoBehaviour {
    // Use this for initialization
    void Start () {
        Debug.Log("I am alive");
    }
    public int speed = 3;
	// Update is called once per frame
	void Update () {
       if (Input.GetKey(KeyCode.UpArrow))
            {
            Debug.Log("うえ");
            this.transform.position += new Vector3(0, 0, speed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            Debug.Log("した");
            this.transform.position += new Vector3(0, 0, -speed * Time.deltaTime);
        }
        if (Input.GetKey(KeyCode.RightArrow))
        {
            Debug.Log("みぎ");
            this.transform.position += new Vector3(speed * Time.deltaTime, 0, 0);
        }
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            Debug.Log("ひだり");
            this.transform.position += new Vector3(-speed * Time.deltaTime, 0, 0);
        }
    }
}
