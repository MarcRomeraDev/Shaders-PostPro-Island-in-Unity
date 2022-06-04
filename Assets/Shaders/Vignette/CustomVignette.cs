using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using System;

[SerializeField]
[PostProcess(renderer: typeof(CustomVignetteRender), PostProcessEvent.AfterStack, "Custom/Vignette")]

public sealed class CustomVignette : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Effect Intensity.")]
    public FloatParameter blend = new FloatParameter { value = 0.0f };

    [Range(0f, 32f), Tooltip("Vignette Size.")]
    public FloatParameter vignetteSize = new FloatParameter { value = 2.0f };

    [Range(.5f, 64f), Tooltip("Edge Smoothness.")]
    public FloatParameter smoothness = new FloatParameter { value = 4.0f };

    public Vector2Parameter center = new Vector2Parameter { value = new Vector2(0.5f, 0.5f) };

    public Vector2Parameter scale = new Vector2Parameter { value = new Vector2(1.0f, 1.0f) };


    public BoolParameter useInnerColor = new BoolParameter { value = false };
    public ColorParameter innerVignetteColor = new ColorParameter { value = Color.white };

    public ColorParameter outterVignetteColor = new ColorParameter { value = Color.black };

    public BoolParameter isRounded = new BoolParameter { value = false };
    [Tooltip("Animation when player is in low health\n(Only works in Play Mode)")]
    public BoolParameter heartBeatAnim = new BoolParameter { value = false };
    [Range(0f, 100f), Tooltip("Animation speed for heart beat.")]
    public FloatParameter heartBeatSpeed = new FloatParameter { value = 3f };
   
    public BoolParameter drowningAnimation = new BoolParameter { value = false };
    [HideInInspector] public FloatParameter timeSinceCollision = new FloatParameter { value = 0f };
}

public class CustomVignetteRender : PostProcessEffectRenderer<CustomVignette>
{
    
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Vignette"));
        sheet.properties.SetFloat("_intensity", settings.blend);
        sheet.properties.SetFloat("_size", settings.vignetteSize);
        sheet.properties.SetFloat("_smoothness", settings.smoothness);
        sheet.properties.SetVector("_center", settings.center);
        sheet.properties.SetVector("_dimensions", settings.scale);
        sheet.properties.SetInt("_innerColor", settings.useInnerColor ? 1 : 0);
        sheet.properties.SetColor("_innerVignetteColor", settings.innerVignetteColor);
        sheet.properties.SetColor("_outterVignetteColor", settings.outterVignetteColor);
        sheet.properties.SetInt("_rounded", settings.isRounded ? 1 : 0);
        sheet.properties.SetInt("_heartBeat", settings.heartBeatAnim ? 1 : 0);
    
        sheet.properties.SetFloat("_speed", settings.heartBeatSpeed);
        sheet.properties.SetInt("drowningAnimation", settings.drowningAnimation ? 1 : 0);
        sheet.properties.SetFloat("deltaTime", Time.timeSinceLevelLoad - settings.timeSinceCollision);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}