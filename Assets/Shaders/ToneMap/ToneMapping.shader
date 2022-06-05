Shader "Hidden/Custom/ToneMapping"
{
	HLSLINCLUDE
		// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

	float _intensity;
	float _gamma;
	float _exposure;
	int _eyeAdaptation;
	float _incrementalValue = 0;
	bool doOnce = true;
	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 hdrColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		// exposure tone mapping
		float4 mapped = abs(float4(1.0, 1.0, 1.0, 1.0) - exp(-hdrColor * (_exposure + _incrementalValue)));

		float gammaValue = 1.0 / _gamma;
		
		mapped = pow(mapped, float4(gammaValue, gammaValue, gammaValue, gammaValue));

		float4 FragColor = float4(mapped.rgb, 1.0);
		if (_eyeAdaptation == 1)
		{
			float avgLuminosityOfUntouchedPixel= dot(hdrColor.rgb, float3(0.2126729, 0.7151522, 0.0721750));
			float avgLuminosityOfPixel = dot(FragColor.rgb, float3(0.2126729, 0.7151522, 0.0721750));
			_incrementalValue = (avgLuminosityOfUntouchedPixel - avgLuminosityOfPixel);
			hdrColor.rgb = lerp(FragColor.rgb, avgLuminosityOfUntouchedPixel.xxx, _incrementalValue.xxx);
		}
		else
		{
			_incrementalValue = 0.f;
		}

		hdrColor.rgb = lerp(hdrColor.rgb, FragColor.rgb, _intensity.xxx);
		// Return the result
		return hdrColor;
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
