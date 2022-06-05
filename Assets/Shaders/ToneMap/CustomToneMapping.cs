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
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/ToneMapping"));
        sheet.properties.SetFloat("_intensity", settings.blend);
        sheet.properties.SetFloat("_gamma", settings.gamma);
        sheet.properties.SetFloat("_exposure", settings.exposure);
        sheet.properties.SetFloat("_eyeAdaptation", settings.EyeAdaptation ? 1:0);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}