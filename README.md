PBR SHADER SCENERY - by Ryan Palazón and Marc Romera


-Tone Mapping-


-Vignetting/Pixelate-
Postprocess volume in the water. If you sink while running the game, there is a "drowning" effect with a pixelated & vignette post-processing.
Located in Assets/Shaders/Vignette & Assets/Shaders/Pixel

-New features to our PBR shader-
Our shader now accepts textures and also casts and receives shadows, as you can see in the scene.
Located in Assets/Shaders/Phong

-Materials for the whole scene using our PBR shader-
All materials used in the scene use our shader (Except transparent and emissive). Some of them have more roughness or less, depending on the type of material they are. For example the parasol has more specular reflection than the sand.
Located in Assets/Shaders/Phong/Materials

-GPU particle system-


-Emissive Mat & Transparent Mat-
We use a material with an emitting surface shader for the lights and a transparent material for the water surrounding the island and for the waterfall.
Located in Assets/Shaders/Emissive & Transparent

-Rogue Exercise --> Multiple light handling & spotlight-
For the rogue exercise we have chosen to implement the spotlight and to be able to handle several lights of the same type.
The spotlights are used for the lamp lights in the scene.
Script for the light is located in Assets/Scripts/Light and the proper spotlight calculation is located in Assets/Shaders/Phong