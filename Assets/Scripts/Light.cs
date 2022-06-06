using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Light : MonoBehaviour
{
    public enum LightType { Point, Directional, Spotlight };
    public LightType type;
    public List<GameObject> spotLights = new List<GameObject>();
    public List<Color> colors = new List<Color>();
    public Color color;
    public float intensity;

    Material lightMat;
    public List<Material> mats;

    // Start is called before the first frame update
    void OnEnable()
    {
        //  direction = transform.forward;
        //mat = ;
        if (type == LightType.Point)
        {
            Shader.EnableKeyword("POINT_LIGHT_ON");
            // lightMat = GetComponent<Renderer>().sharedMaterial;
        }
        if (type == LightType.Directional)
            Shader.EnableKeyword("DIRECTIONAL_LIGHT_ON");
        if (type == LightType.Spotlight)
        {
            Shader.EnableKeyword("SPOT_LIGHT_ON");
            //  lightMat = GetComponent<Renderer>().sharedMaterial;
        }

    }
    private void OnDisable()
    {
        if (type == LightType.Point)
            Shader.DisableKeyword("POINT_LIGHT_ON");
        if (type == LightType.Directional)
            Shader.DisableKeyword("DIRECTIONAL_LIGHT_ON");
        if (type == LightType.Spotlight)
            Shader.DisableKeyword("SPOT_LIGHT_ON");
    }
    private void OnDrawGizmos()
    {
        // for (int i = 0; i < spotLights.Count; i++)
        // {
        //     directions[i] = -spotLights[i].transform.forward;
        //     positions[i] = spotLights[i].transform.position;
        // }
    }


    // Update is called once per frame
    void Update()
    {
        Vector4[] direction_Shader = new Vector4[spotLights.Count];
        Vector4[] position_Shader = new Vector4[spotLights.Count];
        Color[] colors_shader = new Color[spotLights.Count];
        Debug.Log(spotLights.Count);
        for (int i = 0; i < spotLights.Count; i++)
        {
            position_Shader[i] = spotLights[i].transform.position;
            direction_Shader[i] = -spotLights[i].transform.forward;
            colors_shader[i] = colors[i];
        }

        //direction = transform.forward;
        foreach (Material mat in mats)
        {
            if (type == LightType.Directional)
            {
                mat.SetVector("_directionalLightDir", -transform.forward);
                mat.SetColor("_directionalLightColor", color);

            }
            else if (type == LightType.Point)
            {
                mat.SetVector("_pointLightPos", transform.position);
                mat.SetColor("_pointLightColor", color);
                // lightMat.SetColor("_EmissionColor", color * 20 * intensity);
            }
            else if (type == LightType.Spotlight)
            {


                mat.SetVectorArray("_spotLightPos", position_Shader);
                mat.SetVectorArray("_spotLightDir", direction_Shader);
                mat.SetColorArray("_spotLightColor", colors_shader);
                mat.SetInt("_size", spotLights.Count);
                //  lightMat.SetColor("_EmissionColor", color * 20 * intensity);
            }
        }
    }
}
