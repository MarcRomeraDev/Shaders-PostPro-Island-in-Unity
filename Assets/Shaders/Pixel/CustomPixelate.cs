using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[SerializeField]
[PostProcess(renderer: typeof(CustomPixelateRender), PostProcessEvent.AfterStack, "Custom/Pixelate")]
public sealed class CustomPixelate : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Effect Intensity.")]
    public FloatParameter blend = new FloatParameter { value = 0.0f };

    [Range(0.1f, 100f), Tooltip("Target Pixel Size.")]
    public FloatParameter targetPixelSize = new FloatParameter { value = 0.1f };

    
    [Range(0f,1f), Tooltip("X Pivot")]
    public FloatParameter xPivot = new FloatParameter { value = 0.5f };
    [Range(0f, 1f), Tooltip("Y Pivot")]
    public FloatParameter yPivot = new FloatParameter { value = 0.5f };
    [Tooltip("Only works in Play Mode")]
    public BoolParameter animationPixelate = new BoolParameter { value = false };
    [Range(0f, 100f), Tooltip("How fast the pixels move")]
    public FloatParameter animationintensity = new FloatParameter { value = 0f };
    [Range(0f, 100f), Tooltip("How much the pixels move")]
    public FloatParameter animationSize = new FloatParameter { value = 10f };

    public BoolParameter randomPixelate = new BoolParameter { value = false };
    public BoolParameter drowningAnimation = new BoolParameter { value = false };
    
}

public class CustomPixelateRender : PostProcessEffectRenderer<CustomPixelate>
{
    public float timeSinceCollision = Time.timeSinceLevelLoad;
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Pixelate"));
        sheet.properties.SetFloat("_intensity", settings.blend);
        sheet.properties.SetFloat("_targetPixelSize", settings.targetPixelSize);
        sheet.properties.SetFloat("xPivot", settings.xPivot);
        sheet.properties.SetFloat("yPivot", settings.yPivot);
        sheet.properties.SetInt("randomPixelate", settings.randomPixelate ? 1 : 0);
        sheet.properties.SetInt("animationPixelate", settings.animationPixelate ? 1 : 0);
        sheet.properties.SetFloat("animationCurve", settings.animationintensity);
        sheet.properties.SetInt("drowningAnimation", settings.drowningAnimation ? 1 : 0);
        
        sheet.properties.SetFloat("deltaTime",  Time.timeSinceLevelLoad - timeSinceCollision);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}