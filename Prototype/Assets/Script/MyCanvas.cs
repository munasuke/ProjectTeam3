using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class MyCanvas : MonoBehaviour
{

    static Canvas _canvas;

	// Use this for initialization
	void Start ()
    {
        _canvas = GetComponent<Canvas>();
	}

    public static void SetActive(string name, bool b)
    {
        foreach (Transform child in _canvas.transform)
        {
            if (child.name == name)
            {
                child.gameObject.SetActive(b);
                return;
            }
        }
    }
}
