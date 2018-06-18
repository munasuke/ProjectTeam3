using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class srite : MonoBehaviour {

   private int num;
    
	// Use this for initialization
	void Start () {
        num = 6;
        
	}

    // Update is called once per frame
    void Update()
    {
        if (num % 3 == 0)
        {
            gameObject.GetComponent<SpriteRenderer>().sprite = Resources.Load("Image/pink_fw/pfw" + num, typeof(Sprite)) as Sprite;
        }
        if (num > 99)
        {
            Destroy(gameObject);
        }
        num++;
    }
}
