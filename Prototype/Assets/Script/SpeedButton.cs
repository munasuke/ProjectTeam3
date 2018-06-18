using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpeedButton : MonoBehaviour
{
    public static bool ButtonFlag;
    static string Button;

    Vector3 pos;

    // Use this for initialization
    void Start()
    {
        ButtonFlag = false;
        pos = transform.position;
    }

    // Update is called once per frame
    void Update()
    {
    }
    public void OnClick()
    {
        gameObject.SetActive(false);

        MyCanvas.SetActive("Button2", true);
        ButtonFlag = true;
    }
}