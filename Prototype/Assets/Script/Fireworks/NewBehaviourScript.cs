using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewBehaviourScript : MonoBehaviour {
    private GameObject FireworksSeed;
    private GameObject MakedFireworksSeed;
    private int cnt;
    Vector3 pos;
    private GameObject MakedFireworks;
    // Use this for initialization
    void Start () {
		
	}

    // Update is called once per frame
    void Update()
    {
        if (ChangeScene.OldScene == "StageSelect")//LogicMode
        {
            if (cnt < 4)
            {
                FireworksSeed = (GameObject)Resources.Load("Firework/FireworksSeed");
                pos = transform.position;
                pos.y = 0.5f;
                pos.x = Random.Range(-9, 9);
                MakedFireworks = Instantiate(FireworksSeed, pos, transform.rotation);

            }
            cnt++;
        }
    }
}
