using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FadeController : MonoBehaviour {
    Image img;
    float speed = 0.02f;
    float red, green, blue, alpha;//rgba
    public bool outFlag = false;
    public bool inFlag = false;
    public bool flag = false;
    void Awake() {
    }
    // Use this for initialization
    void Start () {
        inFlag = true;
        img = GetComponent<Image>();
        red = img.color.r;
        green = img.color.g;
        blue = img.color.b;
        alpha = img.color.a;
	}
	
	// Update is called once per frame
	void Update () {
		if (outFlag) {
            FadeOut();
        }
        if (!outFlag) {
            FadeIn();
        }
	}

    //フェードアウト
    void FadeOut() {
        img.enabled = true;
        SetColor();
        if (alpha >= 1) {
            outFlag = false;
            flag = true;
        }
        else {
            alpha += speed;
        }
    }
    
    //フェードイン
    void FadeIn() {
        SetColor();
        if (alpha <= 0) {
            inFlag = false;
            img.enabled = false;
        }
        else {
            alpha -= speed;
        }
    }

    void SetColor() {
        img.color = new Color(red, green, blue, alpha);
    }

    public bool Flag {
        get {
            return flag;
        }
        set {
            flag = value;
        }
    }
}
