-PBR RENDERING- by Ryan Palazón and Marc Romera

En todos los componentes, donde calculamos a partir de un dot product el resultado, hacemos un max para que no se usen los vectores resultantes que van en dirección contraria a la cámara, para evitar efectos indeseados.

FRESNEL
Hemos partido de la aproximación de fresnel de Schlick:
_FresnelCoefficient + (1 - _FresnelCoefficient) * pow(1 - max(0.0, dot(h, l)), 5);

Partiendo de un valor que pasamos como parametro al material, al cual hemos llamado _FresnelCoefficient, incrementamos o reducimos su intensidad. Con la primera parte de la ecuación <<_FresnelCoefficient + (1 - _FresnelCoefficient)>> indicamos el índice de refracción del material según la incidencia normal de la luz.

La segunda parte de la formula es justamente la parte de la aproximación de Schlick del reflejo de fresnel, que aligera mucho la carga de rendering. Es una alternativa mucho más sencilla, barata y rápida de calcular que las ecuaciones originales.

DISTRIBUTION
Hemos usado el modelo GGX NDF (Normal distribution function).

Para el calculo de la distribución de microfacetas en la superfície, usamos un párametro de roughness que le pasamos al material con el que aumentamos o reducimos la distribución siguiendo la ecuación del modelo de GGX: clamp(roughness / (3.1415926535 * pow(sqNdotH * (roughness - 1) + 1, 2)),0,1);
Usamos el model GGX porqué después de documentarnos vimos que era de los más populares debido al buen highlight especular que tiene mientras mantiene una distribución decente en la superfície del objeto.

GEOMETRY
Hemos usado el modelo GGX GSF (Geometry shadowing function).

Este modelo separa el calculo de la componente de geometria en 2 ecuaciones diferentes
SmithL = (2 * NdotL) / (NdotL + sqrt(roughness + (1 - roughness) * pow(NdotL, 2)));
SmithV = (2 * NdotV) / (NdotV + sqrt(roughness + (1 - roughness) * pow(NdotV, 2)));

La primera depende del vector incidente de luz y conforma la parte del "shadowing".
La segunda depende de la view y conforma la parte del "masking".
Para el cálculo, pasamos también un valor de "Roughness" entre 0 y 1 con el que indicamos como se muestra la componente specular.
Si la roughness del material fuera 0, significaria que es un material rugoso y que por lo tanto la luz rebota de forma irregular, quedando solamente un highlight de la specular.
Cuando la roughness vale aprox 0.5 en el slider de nuestro código, el reflejo especular es mucho más claro y smooth ya que la luz rebota de forma regular contra una superfície no rugosa.
Esto juntamente con el distribution recrean el scatter de luz por la superfície del objeto.