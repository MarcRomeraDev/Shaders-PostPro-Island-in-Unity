using System.Collections;
using System.Collections.Generic;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine;

public class UpdateTimeForAnimation : MonoBehaviour
{
    // Start is called before the first frame update

    [SerializeField] PostProcessVolume volume;
  
    void OnTriggerEnter(Collider collision)
    {
        if (collision.gameObject.tag == "PostPro")
        {
            if (volume.profile.TryGetSettings<CustomVignette>(out var vignette))
            {
                vignette.timeSinceCollision.Override(Time.timeSinceLevelLoad);
            }
            if (volume.profile.TryGetSettings<CustomPixelate>(out var pixelate))
            {
                pixelate.timeSinceCollision.Override(Time.timeSinceLevelLoad);
            }
        }
    }

}
