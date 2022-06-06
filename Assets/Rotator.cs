using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotator : MonoBehaviour
{
    private void FixedUpdate()
        {
            transform.Rotate(0, -5f * Time.fixedDeltaTime, 0);
    }
}
