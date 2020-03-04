# Muntatge de la salà d'informàtica 

La sala d'informàtica consta de:

* 21 ordinadors (+2 extres)
* Connexió a internet cablejada a través d'un switch de 24 ports
* Possibilitat de connexió wireless via un accès point.
* Servidor amb continguts educatius i amb possibilitat d'accés remot via ssh desde l'exterior.
* Projector
* Router (Ubiquiti EdgeRouterX amb possiblitat de limitar l'accés d'internet.

**Mapa de la sala**
![reverse-ssh](/docs/img/carte_salle_informatique.png)

## Bloque router+servidor

**Función**

El bloque router + servidor sirve para dar accesso a los ordenadores a los servicios montados en el servidor y a internet. En caso sea necesaria una conexión inalámbrica (wifi) puntualmente para profesores o personal del centro, el AP puede también ofrecer conexión internet vía wifi.

**Correcto uso/mantenimiento**

En ningún caso se puede manipular la configuración del bloque (quitar, cambiar cables) o dejara de servir la función anterior de manera no reversible. En caso se necesite, se puede apagar directamente por la regleta y encender cuando se dé clase. La regleta puesta sirve para proteger de saltos de tension. Por favor no quitarla. En caso se pinte la pared, proteger el bloque para que la pintura no entre en los enchufes. no pintar el bloque ya que la pintura podria penetrar y dañarlo o tapar la ventilacion.

## Switch

**Función**

El switch sirve como amplificador de la conexión desde el bloque router + servidor al resto de ordenadores de la sala.

**Correcto uso/mantenimiento**

En caso de desconexión de la alimentación o de los cables ethernet los ordenadores se quedaran sin internet. Si algún ordenador se queda sin conexión averiguar que todos los cables esten bien ubicados en el switch. En caso se pinte la pared, proteger switch y cable para que la pintura no entre en los enchufes. no pintar el switch ya que la pintura podria penetrar y dañarlo o tapar la ventilacion.

## Cablaje ethernet

**Función**
cada tub/gulotte lleva 7 cables que alimentan diferentes ordenadores de la sala segun el esquema. Cada tubo/grupo de cable, tiene una longitud limitada a cubrir la sala segun el esquema. Cualquier otra configuración de la sala podría dejar algun ordenador sin cable.

**Correcto utilizo/mantenimiento**

No pisar, doblar tubos o cables(cuidado con las sillas). No tirar los cables. Si no llegan al ordenador, acercar la mesa y el ordenador al cable. En caso se modifique la disposición de la sala y se quieran recoger los cables ethernet, asegurarse que todos los cables estén desenchufados de los ordenadores, liberar los tubos de los hilos de hierro que los aguantan a las mesas. Recoger los tubos enrollandolos sin doblarlos/dañarlos. Al reinstalar los tubos como se muestra en el esquema, según las etiquetas.

## Cablaje eletricidad

**Función**
Cada alargo/regleta tiene una longitud específica para llegar a una mesa específica (en cada una hay un número distinto de pcs). Hay 3 de 5 para mesas azules y 2 de 4 para mesas rosas. Cada regleta va con su alargo identificado segun el esquema (el patrón sigue los números de los tubos).Cualquier otra configuración de la sala podría dejar algun ordenador sin eletricidad.

**Correcto utilizo/mantenimiento**
No pisar, doblar cables (cuidado con las sillas). No tirar los cables. Si no llegan al ordenador, acercar mesa y ordenador al cable. En caso se modifique la disposicion de la sala y se quieran recoger los cables alargos, asegurarse que todos los ordenadores esten apagados. recoger los cables y alargos sin doblarlos/dañarlos y guardarlos al armario (cuidado raton). Al reinstalar los tubos seguir el esquema, segun las etiquetas
Ordenadores
Funcion
Los ordenadores montan Lubuntu con plataformas pedagogicas seleccionadas por Labdoo. Cada ordenador tiene tres cuentas: 
guest, para estudiantes del centro fatim konte o para usuarios que puedan conectarse puntualmente. No mantiene memoria ni contraseña y tiene look un poco diferente a las demas cuentas
student, para estudiantes del proyecto Origen, con posibilidad de mantener memoria, es decir, permite guardar documentos de word, excel, powerpoint, pdf, etc. tiene contraseña xxxxxx

1) admin, para profes y admin de red. Contiene herramientas extra para la gestion de las demas cuentas del ordenador, aunque hay que usarlas bien o es posible cargarse las otras cuentas. tiene contraseña xxxxxx. No dar a otras personas que no sean responsables del mantenimiento de los ordenadores o a profesores. Por ejemplo pondremos script toogle internet para profesores en cada cuenta admin.
Correcto utilizo/mantenimiento

Los ordenadores tienen especificaciones distintas y hay que respectar las info abajo para que cada uno funcione correctamente (teclado, adaptador ethernet, bateria, etc, ver excel resumen). Todos los ordenadores tienen que estar ocnectados al cable ethernet para tener accesso a los servicios de servidor y de internet y a la electricidad para encenderse. Proteger del polvo con funda y dejar en el armario (cuidado raton). Borrar ficheros de vez en cuando para que no se llenen y vayan mas lentos. Si algo no va en un solo ordenador poneros en contacto con nuestro correo xxxxxxx y señalar el ID labdoo del ordenador quee no va. encenderlo y conectarlo a su cable ethernet para que podamos entrar y ver lo que no va. Si algo no va en todos los ordenadores revisar que la sala este bien instalada (bloque router/servidor con regleta encendida, switch, cable ethernet, electricidad y sus conexiones). En caso extremo intentar hacer on/off regleta bloque router/servidor. Por ultimo contactar con nosotros al xxxxxxx