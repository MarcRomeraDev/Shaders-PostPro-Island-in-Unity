PBR SHADER SCENERY - by Ryan Palazón and Marc Romera


NOTE: The Tone Mapping, although in an advanced progress, is not finished and also causes memory leaks when Eye adaptation is on, so be cautious (:
---Post processing ---

	-Tone Mapping-
	Postprocess global volume in ToneMapping Gameobject, the idea is that we capture the scene and render it to a texture, then we gather all the pixels
	in an array and we calculate the luminosity of each with the (0.2126*R + 0.7152*G + 0.0722*B) formula.
	Then, we compare it to a desired luminosity level and we update an incremental value that is added to the exposure inside the shader.
	Located in Assets/Shaders/ToneMap
	
	-Vignetting/Pixelate-
	Postprocess volume in the water. If you sink while running the game, there is a "drowning" animation effect with a pixelated & vignette post-processes where the pixels get bigger over time with a sinusoidal animation and the vignette gets thinner and darker.
	Located in Assets/Shaders/Vignette & Assets/Shaders/Pixel


--- Shaders In Unity---


	-New features to our PBR shader-
	Our shader now accepts textures and also casts and receives shadows (following Unity's ShadowCaster Pass documentation), as you can see in the scene.
	Located in Assets/Shaders/Phong

	-Materials for the whole scene using our PBR shader-
	All materials used in the scene use our shader (Except transparent and emissive). Some of them have more roughness or less, depending on the type of material they are. For example the parasol has more specular reflection than the sand.
	Located in Assets/Shaders/Phong/Materials


--- Additional Implementations---


	-Vertex Shader Animation- 
	The shark has a sinusoidal vertex shader animation that represents its movement through the ocean. The shark also rotates around the island but that's just a "rotator" script as an extra.
	Located in Assets/Shaders/VertexAnimation

	-Texture Animation-
	All water materials (ocean & waterfall) have a simple UV displacement "flow" animation.
	Located in Assets/Shaders/Transparent

	-Emissive Mat & Transparent Mat-
	We use a material with an emitting surface shader for the lights and a transparent material for the water surrounding the island and for the waterfall.
	Located in Assets/Shaders/Emissive & Transparent


-Rogue Exercise --> Multiple light handling & spotlight-
	For the rogue exercise we have chosen to implement the spotlight and to be able to handle several lights of the same type.
	The spotlights are used as "lamp-like" light sources in the scene.
	We use an array to pass the data to the shader so we can have multiply light sources.
	Script for the light is located in Assets/Scripts/Light and the proper spotlight calculation is located in Assets/Shaders/Phong