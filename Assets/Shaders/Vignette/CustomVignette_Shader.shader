Shader "Hidden/Custom/Vignette"
{
	HLSLINCLUDE
		//StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

	float _intensity; 
	float _size;
	float4 _innerVignetteColor;
	float4 _outterVignetteColor;
	float _smoothness;
	bool _rounded;
	float2 _center;
	float2 _dimensions; // Scale
	bool _innerColor;
	bool _heartBeat;
	float _speed;



	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float2 darkCoord = (i.texcoord * (_dimensions * 2)) - (2*_center * _dimensions); //--> setting position of vignette on screen
		float factor;

		if (_rounded) // circle shape
		{
			//--> Fallof of start of vignette from center of screen
			factor = length(darkCoord * float2(_ScreenParams.x / _ScreenParams.y, 1.0));
		}
		else // Oval shape
		{
			darkCoord *= pow(abs(darkCoord), 32-_size); // Scaling with the screen

			//--> Fallof of start of vignette from center of screen
			factor = length(darkCoord);
		}

		factor = clamp(0, 1, pow(factor / 0.5, _smoothness)); //edge smoothness

		if (_heartBeat) // Heart Beat animation
		{
			//Simple red lerp on the outter color
			_outterVignetteColor.rgb = lerp(float3(0.9,0,0.04464197), float3(0.5,0,0.031), sin(_Time.y*_speed));
		}

		// Lerp of clean scene texture and scene texture with outter 
		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

		// Lerp with min to take alpha to account
		float4 color2 = float4(lerp(color.rgb, _outterVignetteColor.rgb, min(factor.xxx, _outterVignetteColor.a)),1);

		color.rgb = lerp(color.rgb, color2.rgb, _intensity.xxx); //lerp to blend

		if (_innerColor) // we do the same with the inner color
		{
			// Lerp with min to take alpha to account
			color2 = float4(lerp(color.rgb, _innerVignetteColor.rgb, min(1 - factor.xxx, _innerVignetteColor.a)), 1);
			//lerp to blend
			color.rgb = lerp(color.rgb, color2.rgb, _intensity.xxx);

		}
		//Return the result
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