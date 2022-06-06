Shader "Custom/TransparentShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_ScrollXSpeed("X Scroll Speed", Range(-1,1)) = -0.05
		_ScrollYSpeed("Y Scroll Speed", Range(-1,1)) = 0.1
	}
	SubShader
	{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent"} //Changing queue type makes sure the material is rendered later than the opaque materials
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite off //Transparent object doesn't need to occlude objects behind it
	
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows alpha:fade //alpha:fade enables fade-transparency
		#pragma target 3.0
	
		sampler2D _MainTex;
		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;
	
		struct Input
		{
			float2 uv_MainTex;
		};
	
		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
	
		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed2 scrolledUV = IN.uv_MainTex;

			fixed xScrollValue = _ScrollXSpeed * _Time; //Scroll UVS for water animation
			fixed yScrollValue = _ScrollYSpeed * _Time;

			scrolledUV += fixed2(xScrollValue, yScrollValue);

			fixed4 c = tex2D(_MainTex, scrolledUV) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}