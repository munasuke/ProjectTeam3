using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class fireworks : MonoBehaviour {

    
    private GameObject Fireworks;
    private GameObject MakedFireworks;
    private GameObject FireworksSeed;
    private GameObject MakedFireworksSeed;
    float time = 0f;
    Vector3 pos;
    float Up;
    float life;
    private int cnt;
        
    // Use this for initialization
    void Start()
    {
        time = 0;
        cnt = 0;       
        Up = Random.Range(0.03f, 0.05f);
        life = Random.Range(1.0f, 1.8f);
        //ChangeScene.OldScene = "StageSelect";
        FireworksSeed = (GameObject)Resources.Load("Firework/FireworksSeed");
        Fireworks = (GameObject)Resources.Load("Firework/Fworks");
        //MakedFireworks = Instantiate(FireworksSeed, pos, transform.rotation);

    }
    // Update is called once per frame
    void Update()
    {
       // logic();
        
            
    }    
    public void logic()
    {
        if (ChangeScene.OldScene == "StageSelect")//LogicMode
        {

            transform.position = new Vector3(transform.position.x, transform.position.y + Up, transform.position.z);
            time += Time.deltaTime;

            print(time);
            if (time > life)
            {

                Destroy(gameObject);
                MakedFireworks = Instantiate(Fireworks, transform.position, transform.rotation);
          
                pos = transform.position;
                pos.y = 0.5f;
                pos.x = Random.Range(-9, 9);
                MakedFireworks = Instantiate(FireworksSeed, pos, transform.rotation);
            }
        }
    }
    public void panic()
    {  if (ChangeScene.OldScene == "LevelSelect")//PanicMode
        {

        }
    }
}
