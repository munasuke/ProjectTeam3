using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TestCompornent : MonoBehaviour {

    public Text l_text;
    private RectTransform panel;

    private void Start() {
        panel = GetComponent<RectTransform>();
    }

    private void Update() {

    }

    private void OnEnable() {
        Application.logMessageReceived += Log;
    }

    private void OnDisable() {
        Application.logMessageReceived -= Log;
    }

    public void Log(string logString, string stackTrace, LogType type) {
        Text logLine = Instantiate(l_text, Vector3.zero, Quaternion.identity, panel);
        logLine.name = "LogLine";
        logLine.text = logString;

        if (20 < panel.transform.childCount) {
            Transform child = panel.GetChild(1);
            GameObject.Destroy(child.gameObject);
        }
    }
}
