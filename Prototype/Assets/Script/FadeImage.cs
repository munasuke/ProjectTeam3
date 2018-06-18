using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FadeImage : MonoBehaviour {

    Image t_mesh;
    public float speed = 0.01f;
    float red, green, blue, alpha;//rgba
    bool flg;

    // Use this for initialization
    void Start() {
        t_mesh = GetComponent<Image>();
        red = t_mesh.color.r;
        green = t_mesh.color.g;
        blue = t_mesh.color.b;
        alpha = 1;//alpha 0～1
        flg = true;
    }

    // Update is called once per frame
    void Update() {
        t_mesh.color = new Color(red, green, blue, alpha);
        if (alpha <= 0) {
            flg = false;
        }
        else if (alpha >= 1) {
            flg = true;
        }
        alpha += flg ? -speed : speed;
    }
}
