Shader "Hidden/Custom/ToneMapping"
{
	HLSLINCLUDE
		// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

	float _intensity;
	float _gamma;
	float _exposure;

	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 hdrColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

		// exposure tone mapping
		float4 mapped = abs(float4(1.0,1.0,1.0,1.0) -exp(-hdrColor * _exposure));

		float gammaValue = 1.0 / _gamma;
		
		mapped = pow(mapped, float4(gammaValue, gammaValue, gammaValue, gammaValue));
		
		float4 FragColor = float4(mapped.rgb, 1.0);
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
