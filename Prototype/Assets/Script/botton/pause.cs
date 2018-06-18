using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class pause : MonoBehaviour
{

    [SerializeField]
    private GameObject PauseUI;
    private GameObject PauseUI_Ins;

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        Stop();
    }
    
    public void Stop()
    {

        if (GameObject.Find("PauseButton"))
        {
            if (PauseUI_Ins == null)
            {
                PauseUI_Ins = GameObject.Instantiate(PauseUI) as GameObject;
                Time.timeScale = 0.0f;
            }
        }

        if (GameObject.Find("RestartButton"))
        {
            Destroy(PauseUI_Ins);
            Time.timeScale = 1.0f;
        }
    }
}
    //public void Restart()
    //{
        
    //}

