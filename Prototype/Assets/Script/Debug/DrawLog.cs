using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class DrawLog : MonoBehaviour {

    private void Update() {
        if (Input.GetMouseButtonUp(1)) {
            Debug.Log("Time = " + Time.time.ToString("000.0000"));
        }
    }
}
