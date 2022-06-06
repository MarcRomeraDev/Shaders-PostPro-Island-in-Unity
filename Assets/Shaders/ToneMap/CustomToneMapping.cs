using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using System;

[SerializeField]
[PostProcess(renderer: typeof(CustomToneMappingRender), PostProcessEvent.AfterStack, "Custom/ToneMapping")]
public sealed class CustomToneMapping : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Effect Intensity.")]
    public FloatParameter blend = new FloatParameter { value = 0.0f };

    [Range(0f, 2f), Tooltip("Gamma")]
    public FloatParameter gamma = new FloatParameter { value = 1f };

    [Range(0f, 5f), Tooltip("Exposure")]
    public FloatParameter exposure = new FloatParameter { value = 1f };
    [Header("Auto Exposure")]
    [Range(0f, 5f), Tooltip("Exposure")]
    public BoolParameter EyeAdaptation = new BoolParameter { value = false };

}

public class CustomToneMappingRender : PostProcessEffectRenderer<CustomToneMapping>
{
    public float incrementValue = 0f;
    public float desiredLightLevel = 100;
    public float lightLevel = 0;
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/ToneMapping"));
        var luminosityMainTexture = RenderTexture.GetTemporary(context.width, context.height);
        if (Time.frameCount % 30 == 0)
        {
            System.GC.Collect();
        }

        sheet.properties.SetFloat("_intensity", settings.blend);
        sheet.properties.SetFloat("_gamma", settings.gamma);

        sheet.properties.SetFloat("_exposure", settings.exposure);
        sheet.properties.SetFloat("_incrementalValue", 0);
        //context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
        if (settings.EyeAdaptation)
        {
            Texture2D lumiTexture = new Texture2D(luminosityMainTexture.width, luminosityMainTexture.height);
            lumiTexture.Apply();
            Color32[] colors = lumiTexture.GetPixels32();
            lightLevel = 0f;
            for (int i = 0; i < colors.Length; i++)
            {
                lightLevel += (0.2126f * colors[i].r) + (0.7152f * colors[i].g) + (0.0722f * colors[i].b);
            }

            lightLevel /= colors.Length;

            //lightLevel -= 259330f;
             incrementValue = (lightLevel - desiredLightLevel);


            sheet.properties.SetFloat("_incrementalValue", incrementValue);
            
        }
           
           context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0); 
        RenderTexture.ReleaseTemporary(luminosityMainTexture);

      //  sheet.properties.SetFloat("_eyeAdaptation", settings.EyeAdaptation ? 1:0);
      
     

    }
}