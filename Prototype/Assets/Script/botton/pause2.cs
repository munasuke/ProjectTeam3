using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pause2 : MonoBehaviour {

    [SerializeField]
    private GameObject PauseUI;
    
    public void OnClick()
    {
        PauseUI.SetActive(!PauseUI.activeSelf);

        if (PauseUI.activeSelf)
        {
            Time.timeScale = 0.0f;
        }
    }

    public void OnClick2()
    {
        if (PauseUI.activeSelf)
        {
            PauseUI.SetActive(!PauseUI.activeSelf);
            Time.timeScale = 1.0f;
        }
    }
}
