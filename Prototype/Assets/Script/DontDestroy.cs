using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DontDestroy : SingletonMonoBehaviour<DontDestroy> {

    // Use this for initialization
    void Start () {
        DontDestroyOnLoad(this);
    }
    void Update() {
    }
}
