using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Generation_panel : MonoBehaviour {

    public Transform des_panel;
    public GameObject[] panel;

    public Vector3 Pos;
    public List<Vector3> poslist = new List<Vector3>();
    int Panel_MAX = 4;

    RandPanel i_Panel;
    RandPanel l_Panel;
    RandPanel x_Panel;
    RandPanel t_Panel;


    int cnt = 0;
    public bool create = false;
    // Use this for initialization
    void Start()
    {
    }
	
	// Update is called once per frame
	void Update ()
    {
        panel = new GameObject[transform.childCount];
        for (int i = 0; i < panel.Length; i++)
        {
            panel[i]= transform.GetChild(i).gameObject;
        }
        if (create)
        {
            //cnt++;
            //if (cnt == 20)
            //{
                for (int i = 0; i < poslist.Count; i++)
                {
                    gameObject.GetComponent<RandPanel>().MakePanel(poslist[i]);
                }
                create = false;
                cnt = 0;
                poslist.Clear();
            //}
        }
    }

    public bool AddList(Vector3 Pos)
    {
        poslist.Add(Pos);
        return true;
    }
}
