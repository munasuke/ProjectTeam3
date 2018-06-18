using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GifTextureFolderScript : MonoBehaviour
{

    public GameObject obj;
    public float changeFrameSecond;
    public string folderName;
    public string headText;
    public int imageLength;
    private int firstFrameNum;
    private float dTime;

    // Use this for initialization
    void Start()
    {
        firstFrameNum = 2;
        dTime = 0.0f;
    }

    // Update is called once per frame
    void Update()
    {
        dTime += Time.deltaTime;
        if (changeFrameSecond < dTime)
        {
            dTime = 0.0f;
            firstFrameNum++;
            if (firstFrameNum > imageLength)
            {
                Destroy(gameObject);
            }
        }
        Texture tex = Resources.Load(folderName + "/" + headText + firstFrameNum) as Texture;
        obj.GetComponent<Renderer>().material.SetTexture("_MainTex", tex);
       
    }
}