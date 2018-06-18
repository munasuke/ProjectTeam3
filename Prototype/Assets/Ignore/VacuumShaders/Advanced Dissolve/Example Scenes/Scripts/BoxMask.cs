using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class BoxMask : MonoBehaviour
{
    public Material mat;
    public bool invert;


    Bounds bound;

    void Start()
    {
        bound = GetComponent<MeshFilter>().sharedMesh.bounds;
    }
    void Update()
    {
        if (mat != null)
        {
            mat.SetFloat("_DissolveAxisInvert", invert ? -1 : 1);


            //Need to scale bounds to support non-uniform scale
            mat.SetVector("_DissolveMaskBoxBoundsMin", Vector3.Scale(bound.min, transform.localScale));
            mat.SetVector("_DissolveMaskBoxBoundsMax", Vector3.Scale(bound.max, transform.localScale));

            //Scale in TRS matrix needs to be 'one'
            mat.SetMatrix("_DissolveMaskBoxTRS", Matrix4x4.TRS(transform.position, transform.rotation, Vector3.one).inverse);
        }

    }
}
