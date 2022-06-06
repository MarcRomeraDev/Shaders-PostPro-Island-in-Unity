Shader "Unlit/Phong"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}

		 _objectColor("Main color",Color) = (0,0,0,1)
		 _ambientInt("Ambient int", Range(0,1)) = 0.25
		 _ambientColor("Ambient Color", Color) = (0,0,0,1)

		 _diffuseInt("Diffuse int", Range(0,1)) = 1

		_pointLightPos("Point light Pos",Vector) = (0,0,0,1)
		_pointLightColor("Point light Color",Color) = (0,0,0,1)
		_pointLightIntensity("Point light Intensity",Float) = 1

		 _spotLightPos("Spot light Pos",Vector) = (0,0,0,1)
		 _spotLightDir ("Spot light Dir",Vector) = (0,0,0,1)
		 _spotLightColor("Spot light Color",Color) = (0,0,0,1)
		_spotLightIntensity("Spot light Intensity",Float) = 1

		_directionalLightDir("Directional light Dir",Vector) = (0,1,0,1)
		_directionalLightColor("Directional light Color",Color) = (0,0,0,1)
		_directionalLightIntensity("Directional light Intensity",Float) = 1

		_Roughness("Roughness", Range(0, 1)) = 1
		_FresnelCoefficient("Fresnel Coeficient", Range(0, 1)) = 0.5

			  

	}

	SubShader
	{
		Pass
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert			
			#pragma fragment frag
			#pragma multi_compile __ POINT_LIGHT_ON 
			#pragma multi_compile __ DIRECTIONAL_LIGHT_ON
			#pragma multi_compile __ SPOT_LIGHT_ON
			#include "UnityCG.cginc"
			#include "Lighting.cginc" 
			#pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
			#include "AutoLight.cginc"

				 struct appdata
				 {
					 float4 vertex : POSITION;
					 float2 uv : TEXCOORD0;
					 float3 normal : NORMAL;
				 };

				 struct v2f
				 {
					 float2 uv : TEXCOORD0;
					 SHADOW_COORDS(1)
					 float4 pos : SV_POSITION;
					 float3 worldNormal : TEXCOORD2;
					 float3 wPos : TEXCOORD3;
				 };

				 fixed4 _objectColor;

				 float _ambientInt;
				 fixed4 _ambientColor;
				 float _diffuseInt;

				 float4 _pointLightPos;
				 float4 _pointLightColor;
				 float _pointLightIntensity;

				 float4 _spotLightPos;
				 float4 _spotLightDir;
				 float4 _spotLightColor;
				 float _spotLightIntensity;

				 float4 _directionalLightDir;
				 float4 _directionalLightColor;
				 float _directionalLightIntensity;

				
				
				
				
				

				 float _Roughness, _FresnelCoefficient;

				 float GGXNDF(float roughness, float3 n, float3 h) // n = normal
				 {
					 roughness = pow(roughness, 2);
					 float sqNdotH = pow(max(0.0, dot(n, h)), 2); //El max es para que no se usen los vectores que van en direccion contraria a la camara	  

					 return clamp(roughness / (3.1415926535 * pow(sqNdotH * (roughness - 1) + 1, 2)),0,1);
				 }

				 float FresnelSchlick(float3 l, float3 h)
				 {
					 return _FresnelCoefficient + (1 - _FresnelCoefficient) * pow(1 - max(0.0, dot(h, l)), 5); //--> FresnelCoefficient is the reflectance at normal incidence
				 }

				 float GGXGSF(float roughness, float3 l, float3 h, float3 v, float3 n) // l =light Vec; h = half Vec; v = view Vec; n = normal Vec
				 {
					 roughness = pow(roughness, 2);

					 float NdotL = max(0.0, dot(n, l));
					 float NdotV = max(0.0, dot(n, v));

					 float SmithL = (2 * NdotL) / (NdotL + sqrt(roughness + (1 - roughness) * pow(NdotL, 2))); //Shadowing
					 float SmithV = (2 * NdotV) / (NdotV + sqrt(roughness + (1 - roughness) * pow(NdotV, 2))); //Masking

					 return (SmithL * SmithV);
				 }

				 v2f vert(appdata v)
				 {
					 v2f o;
					 o.pos = UnityObjectToClipPos(v.vertex);
					 o.uv = v.uv;
					 o.worldNormal = UnityObjectToWorldNormal(v.normal);
					 o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					 TRANSFER_SHADOW(o);
					 return o;
				 }

				 sampler2D _MainTex;

				 fixed4 frag(v2f i) : SV_Target
				 {
					 //3 phong model light components
					 //We assign color to the ambient term		
					 fixed4 ambientComp = _ambientColor * _ambientInt;//We calculate the ambient term based on intensity
					 fixed4 finalColor = tex2D(_MainTex, i.uv) * ambientComp;
					 fixed shadow = SHADOW_ATTENUATION(i);
					 float lightDist;
					 float3 viewVec;
					 float3 halfVec;
					 float3 difuseComp = float4(0, 0, 0, 1);
					 float3 specularComp = float4(0, 0, 0, 1);
					 float constant = 1.0;
					 float linearVal = 0.07;
					 float quadratic = 0.017;
					 float spotLightAngle = 20.0;
					 float cutOff = 0.4;
					 float3 lightColor;
					 float3 lightDir;
					 float BRDF;

	 #if DIRECTIONAL_LIGHT_ON

					 //Directional light properties
					 lightColor = _directionalLightColor.xyz;
					 lightDir = normalize(_directionalLightDir);

					 //Diffuse componenet
					 difuseComp = lightColor * _diffuseInt * clamp(dot(lightDir, i.worldNormal), 0, 1) * shadow;

					 viewVec = normalize(_WorldSpaceCameraPos - i.wPos);

					 //blinnPhong				
					 halfVec = normalize(viewVec + lightDir);

					 BRDF = (FresnelSchlick(lightDir, halfVec) *
						 GGXNDF(_Roughness, i.worldNormal, halfVec) *
						 GGXGSF(_Roughness, lightDir, halfVec, viewVec, i.worldNormal)) / (4.0 * dot(i.worldNormal, lightDir) * dot(i.worldNormal, viewVec));

					 //Specular component	
					 specularComp = lightColor * BRDF;

					 //Sum
					 finalColor.rgb += clamp(float4(_directionalLightIntensity * (difuseComp + specularComp),1),0,1);
	 #endif
	 #if POINT_LIGHT_ON
					 //Point light properties
					 lightColor = _pointLightColor.xyz;
					 lightDir = _pointLightPos - i.wPos;
					 lightDist = length(lightDir);
					 lightDir = lightDir / lightDist;
					 //lightDir *= 4 * 3.14;

					 //Diffuse componenet
					 difuseComp = lightColor * _diffuseInt * clamp(dot(lightDir, i.worldNormal), 0, 1) / lightDist * shadow;

					 viewVec = normalize(_WorldSpaceCameraPos - i.wPos);

					 //blinnPhong
					 halfVec = normalize(viewVec + lightDir);
					 BRDF = (FresnelSchlick(lightDir, halfVec) *
						 GGXNDF(_Roughness, i.worldNormal, halfVec) *
						 GGXGSF(_Roughness, lightDir, halfVec, viewVec, i.worldNormal)) / (4.0 * dot(i.worldNormal, lightDir) * dot(i.worldNormal, viewVec));

					 //Specular component	
					 specularComp = _pointLightColor * BRDF / lightDist;

					 //Sum
					 finalColor += clamp(float4(_pointLightIntensity * (difuseComp + specularComp),1),0,1);
	 #endif
	 #if SPOT_LIGHT_ON
					

						 lightColor = _spotLightColor.xyz;
						 lightDir = _spotLightPos - i.wPos;
						 lightDist = length(lightDir);
						 lightDir = lightDir / lightDist;
						 lightDir = normalize(lightDir);


						 float theta = dot(lightDir, normalize(_spotLightDir));
						 if (theta > cutOff) {
							 // DIFFUSE

							 difuseComp = lightColor * _diffuseInt * max(dot(lightDir, i.worldNormal), 0) / lightDist * shadow;
							 viewVec = normalize(_WorldSpaceCameraPos - i.wPos);

							 // SPECULAR
							 halfVec = normalize(viewVec + lightDir);
							 BRDF = (FresnelSchlick(lightDir, halfVec) *
								 GGXNDF(_Roughness, i.worldNormal, halfVec) *
								 GGXGSF(_Roughness, lightDir, halfVec, viewVec, i.worldNormal)) / (4.0 * dot(i.worldNormal, lightDir) * dot(i.worldNormal, viewVec));

							 //Specular component	
							 specularComp = _spotLightColor * BRDF / lightDist;

							 float distance = length(_spotLightPos - i.wPos);

							 float attenuation = 1.0 / (constant + linearVal * distance + quadratic * (distance * distance));
							 difuseComp = difuseComp * attenuation;
							 specularComp = specularComp * attenuation;

							 finalColor += clamp(float4(_spotLightIntensity * (difuseComp + specularComp), 1), 0, 1);
						 }
 #endif

				 return finalColor * _objectColor;
			 }
			 ENDCG
		 }
					 // shadow casting support
					 UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
				 }
		 }