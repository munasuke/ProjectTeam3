using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class joint : MonoBehaviour {

    public GameObject gameobject;
    public Collider m_ObjectCollider;

    // Use this for initialization
    void Start () {
		
	}
    // Update is called once per frame
    void Update () {

        if (m_ObjectCollider.isTrigger)
        {
            Destroy(this.gameObject);
        }
        if (gameobject==null)
        {
            m_ObjectCollider.isTrigger = true;
        }
	}
}
