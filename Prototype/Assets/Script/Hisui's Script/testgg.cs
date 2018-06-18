using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class testgg : MonoBehaviour {
    public GameObject inst;
    public GameObject inst2;

    Quaternion rota;
    // Use this for initialization
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        rota = transform.rotation;
        rota.y = 180;
        transform.rotation = rota;
        inst2 = Instantiate(inst, transform.position, transform.rotation);
    }
}
