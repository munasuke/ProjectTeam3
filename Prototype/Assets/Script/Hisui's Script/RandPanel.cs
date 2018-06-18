using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandPanel : MonoBehaviour {
    public enum PanelNumber         // パネル番号
    {
        I_Panel,
        L_Panel,
        T_Panel,
        X_Panel,
        Panel_MAX
    };

    [SerializeField]
    private GameObject MakingPanel; // 作るパネルを入れる
    private GameObject MakedPanel;  // パネルを作る場所的な

    int PanelNum = 0;               // ランダムで取得したパネルの番号を入れる箱
    int PanelNumOld;
    Quaternion Rota = new Quaternion(0,0,0,0);
    // Use this for initialization
    void Start() {
        Rota = new Quaternion(0, 0, 0, 0);
    }

    // Update is called once per frame
    void Update() {
        if (Input.GetKey(KeyCode.C))
        {
            Debug.Log("強制的に生成します。");
            MakePanel(new Vector3(0, 0, 0));
        }

    }
    public void MakePanel(Vector3 pos)
    {
        PanelNum = Random.Range(0, (int)PanelNumber.Panel_MAX);
        // 引数で受け取った番号のパネルをプレハブから持ってくる
        Debug.Log("ランダム生成するよ！");
        switch (PanelNum)
        {            
            case (int)PanelNumber.I_Panel:
                Debug.Log("I");
                MakingPanel = (GameObject)Resources.Load("PanicPanel/I_fuse");
                break;
            case (int)PanelNumber.L_Panel:
                Debug.Log("L");
                MakingPanel = (GameObject)Resources.Load("PanicPanel/L_fuse");
                break;
            case (int)PanelNumber.T_Panel:
                Debug.Log("T");
                MakingPanel = (GameObject)Resources.Load("PanicPanel/T_fuse");
                break;
            case (int)PanelNumber.X_Panel:
                Debug.Log("X");
                MakingPanel = (GameObject)Resources.Load("PanicPanel/X_fuse");
                break;
            default:
                Debug.Log("生成できませんでした。\nPanelNumの取得に失敗しています。");
                break;
        }
        Rota.y = (Random.Range(0, 3))*90;
        MakedPanel = Instantiate(MakingPanel, pos, Rota,transform);
    }

    public void MakeGoal(Vector3 pos)
    {
        while (PanelNum == PanelNumOld)
        {
            PanelNum = Random.Range(0, (int)PanelNumber.Panel_MAX);
        }
        // 引数で受け取った番号のパネルをプレハブから持ってくる
        Debug.Log("ランダム生成するよ！");
        switch (PanelNum)
        {
            case (int)PanelNumber.I_Panel:
                Debug.Log("I");
                MakingPanel = (GameObject)Resources.Load("GoalPanel/I_fuse");
                Rota.y = (Random.Range(0, 3)) * 90;
                break;
            case (int)PanelNumber.L_Panel:
                Debug.Log("L");
                int i = gameObject.GetComponent<GoalCtl>().SetGoalCheck(pos, PanelNum);
                switch (i)
                {
                    // 角に詰むタイプのL字を置かない処理
                    case 0:
                        Rota.y = ((Random.Range(1, 3)) * 90) % 360;
                        break;
                    case 1:
                        Rota.y = ((Random.Range(0, 2)) * 90) % 360;
                        break;
                    case 2:
                        Rota.y = ((Random.Range(2, 4)) * 90) % 360;
                        break;
                    case 3:
                        Rota.y = ((Random.Range(3, 5)) * 90) % 360;
                        break;
                    default:
                        Debug.Log("失敗したよ！");
                        break;
                }
                MakingPanel = (GameObject)Resources.Load("GoalPanel/L_fuse");
                Rota.y = (Random.Range(0, 3)) * 90;
                break;
            case (int)PanelNumber.T_Panel:
                Debug.Log("T");
                MakingPanel = (GameObject)Resources.Load("GoalPanel/T_fuse");
                Rota.y = (Random.Range(0, 3)) * 90;
                break;
            case (int)PanelNumber.X_Panel:
                Debug.Log("X");
                MakingPanel = (GameObject)Resources.Load("GoalPanel/X_fuse");
                break;
            default:
                Debug.Log("生成できませんでした。\nPanelNumの取得に失敗しています。");
                break;
        }
        PanelNumOld = PanelNum;

        MakedPanel = Instantiate(MakingPanel, pos, Rota, transform);
    }
}
