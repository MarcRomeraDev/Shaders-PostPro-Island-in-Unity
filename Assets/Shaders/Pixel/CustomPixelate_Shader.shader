Shader "Hidden/Custom/Pixelate"
{
	HLSLINCLUDE
	// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
	
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	
	float _intensity;
	float _targetPixelSize;
	float2 N;
	float xPivot;
	float yPivot;
	int randomPixelate;
	int animationPixelate;
	float animationIntensity = 10;
	float animationCurve = 2;
	float deltaTime = 0;
	int drowningAnimation;

	float4 Frag(VaryingsDefault i) : SV_Target
	{
		_targetPixelSize = _targetPixelSize + (deltaTime * 0.7);
		if (drowningAnimation == 1)
		{
		}
		if (randomPixelate == 1) // Create a random pixelate effect
		{
			N = float2(_ScreenParams.x / (_targetPixelSize* (abs(xPivot - i.texcoord.x) +1)), _ScreenParams.y / (_targetPixelSize* (abs(yPivot - i.texcoord.y) + 1)));
		}
		else
			N = float2(_ScreenParams.x / _targetPixelSize,_ScreenParams.y / _targetPixelSize);
	

		float2 G = float2(xPivot /N[0], yPivot /N[1]); // Indicates an offset 
		

		float2 uv = floor(((i.texcoord + G) * N)) / N;  // selects a pixel for each specified group

		//animation pixelate is a "bool", so if it's 0 "false", the anim will not play as it's multiplied by it. 
		float2 anim = float2(0, (animationPixelate * ((sin(_Time.y+(i.texcoord.x* animationCurve)) + 1) / 2) / (10 - animationIntensity)));

		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		float4 color2 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv + anim); 
		// lerp for blend
		color.rgb = lerp(color.rgb, color2.rgb, _intensity.xxx);
		
		// Return the result
		return color;
	}
	ENDHLSL
	
	SubShader
	{
		Cull Off ZWrite Off ZTest Always
			Pass
		{
			HLSLPROGRAM
				#pragma vertex VertDefault
				#pragma fragment Frag
			ENDHLSL
		}
	}
}