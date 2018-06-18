using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class dokasen_l : MonoBehaviour
{
    public bool hit_L;
    public GameObject gameobject;
    // Use this for initialization
    void Start()
    {
        hit_L = false;
    }
    public void OnCollisionEnter(Collision col)
    {
        if (col.gameObject.CompareTag("fire"))
        {
            hit_L = true;
        }
    }
    void Update()
    {
        if (gameobject == null)
        {
            hit_L = true;
        }
     }
}