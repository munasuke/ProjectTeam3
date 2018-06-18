using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class dokasen_f : MonoBehaviour
{
    public bool hit_F;
    public GameObject hit;

    // Use this for initialization
    void Start () {
        hit_F = false;
    }
    public void OnCollisionEnter(Collision col)
    {
        if (col.gameObject.CompareTag("fire"))
        {
            hit_F = true;
        }
    }
    private void OnTriggerEnter(Collider col)
    {
        hit_F = true;
    }

    void Update()
    {

    }
}

