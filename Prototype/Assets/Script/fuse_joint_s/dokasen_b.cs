using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class dokasen_b : MonoBehaviour {

    public bool hit_B;
    public GameObject gameobject;
    // Use this for initialization
    void Start () {
        hit_B = false;
    }
    public void OnCollisionEnter(Collision col)
    {
        if (col.gameObject.CompareTag("fire"))
        {
            hit_B = true;           
        }
    }

    void Update()
    {
        if(gameobject==null)
        {
            hit_B = true;
        }
    }
}
