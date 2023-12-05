# Clave_Secreta_SED

El mecanismo contará con dos modos, se seleccionarán con uno de los switches. Un modo servirá para introducir una nueva contraseña
y el otro modo para simular un desbloqueo, teniendo la clave introducida que coincir con la establecida previamente en el otro modo.

Cada modo actuará de forma diferente, en ambos cada botón representa un numero, del 0 al 3, para una contraseña de 4 digitos, habrá un 
total de 256 claves posibles. El botón central se usará para indicar que se ha introducido la contraseña.

-Modo ESTABLECER CONTRASEÑA
En este modo, según se vayan pulsando los botones apareceran los dígitos seleccionados en el display de 7 segmentos.
Mientras se esté en este modo estará encendido un LED RGB de la placa de color azul.

-Modo DESBLOQUEAR
En este modo no se sabrá que dígito has introducido, pero se irán encendiendo LEDS verdes para indicar cuantos dígitos se han introducido.
Finalmemnte se encendera un LED RGB verde si esta coincide con la clave anterior y rojo si no coincide.


