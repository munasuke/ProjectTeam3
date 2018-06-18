using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SphereMove : MonoBehaviour
{

    Vector3 targetPosition;
    float time;
    float speed;

    void Start()
    {
        Init();
    }

    void Update()
    {
        time += Time.deltaTime * speed;
        transform.position = Vector3.Lerp(transform.position, targetPosition, time);

        if (Vector3.Distance(transform.position, targetPosition) < 0.05f)
            Init();
    }

    void Init()
    {
        time = 0;
        speed = Random.Range(0.005f, 0.015f);
        targetPosition = new Vector3(Random.Range(-5.5f, 5.5f), 0, Random.Range(-5.5f, 5.5f));
    }
}
