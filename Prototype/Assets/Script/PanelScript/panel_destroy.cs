using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class panel_destroy : MonoBehaviour {

    public bool desflag = false;
    public bool fireflag = false;
    public bool NowFlag;
    public bool OldFlag;
    
    public Vector3 pos;
    public GameObject clossfuse;
    public GameObject Floor;
    // Use this for initialization
    void Start () {
        
    }
	
	// Update is called once per frame
	void Update ()
    {
        clossfuse = transform.GetChild(0).GetChild(1).gameObject;

        NowFlag = clossfuse.gameObject.GetComponent<FireCheck>().NowFlag;
        OldFlag = clossfuse.gameObject.GetComponent<FireCheck>().OldFlag;
        
        Floor = transform.parent.gameObject;
        fireflag = clossfuse.gameObject.GetComponent<FireCheck>().MasterFrag;

        if(fireflag)
        {
            if (tag == ("Goal"))
            {
                Floor.gameObject.GetComponent<GoalRandom>().GeneratFlag = true;
            }
                
            Floor.gameObject.GetComponent<Generation_panel>().AddList(transform.position);
            BroadcastMessage("Explode");
            GameObject.Destroy(gameObject);
            Vector3 pos = transform.position;
            pos.y += 0.2f;
            transform.position = pos;
            Floor.gameObject.GetComponent<Generation_panel>().create = true;
        }
    }
}
