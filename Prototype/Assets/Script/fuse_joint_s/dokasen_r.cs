using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class dokasen_r : MonoBehaviour
{
    public bool hit_R;
    public GameObject gameobject;
    // Use this for initialization
    void Start()
    {
        hit_R = false;
    }
    public void OnCollisionEnter(Collision col)
    {
        if (col.gameObject.CompareTag("fire"))
        {
            hit_R = true;
        }
    }
    private void OnTriggerEnter(Collider col)
    {
        hit_R = true;
    }
    void Update()
    {
        if (gameobject == null)
        {
            hit_R = true;
        }
    }
}