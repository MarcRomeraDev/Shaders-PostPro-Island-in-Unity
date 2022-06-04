using UnityEngine;
[ExecuteInEditMode]
public class CustomLight : MonoBehaviour
{
    public enum LightType { POINT,DIRECTIONAL};
    public Material mat;
    public LightType type;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        switch(type)
        {
            case LightType.POINT:
                mat.SetVector("_lightPos", transform.position);
                break;
            case LightType.DIRECTIONAL:
                mat.SetVector("_directionalLightDir",transform.forward);
                break;
            default:
                break;
        }
    }
}
