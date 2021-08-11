# Práctica de Control - Asignatura Sistemas Operativos

## Enunciado
Este script permite localizar una serie de scripts y compararlos entre ellos para, al final, ofrecer un porcentaje de coincidencias entre los diferentes scripts comparados.

## Premisas de partida y adoptadas
### 1. Premisas del fichero de resultados:
- El script debe de guardar los resultados en un fichero (de texto) con extensión .data y cuyo nombre sea igual al del directorio que contiene al script.
- El fichero de resultados debe contener toda la información recopilada y calculada por el script de manera organizada y formateada.
### 2. Premisas del entorno adecuado de trabajo y filtrado:
Está previsto que el script se ejecute en un “entorno adecuado”, este entorno consiste en un directorio principal -en el que se encuentra el script a diseñar- con subdirectorios, cada uno de los cuales contendrá un script cuyo nombre coincida con el del subdirectorio que lo con-tiene. Estos scripts contenidos en subdirectorios son los scripts a comparar.
De este diseño del “entorno adecuado” de trabajo del script se extraen unas premisas o condicionantes de filtrado a la hora de buscar ficheros a comparar:
- El directorio principal puede contener otros ficheros o subdirectorios vacíos que el script en su búsqueda debe ignorar.
- Los subdirectorios pueden contener otros ficheros aparte del script a comparar y que comparte su nombre, así como otros subdirectorios que el script a diseñar ignorará.
- Si un subdirectorio no se encuentra vacío, pero no contiene ningún fichero cuyo nombre coincida exactamente (incluida la extensión) con el del subdirectorio, este subdirectorio y todo su contenido será ignorado.
### 3. Premisas de la comparación y tratamiento de la información:
- El script debe de comparar los scripts que encuentre tras el proceso de filtrado dos a dos. Así pues, la extensión de los resultados no es fija y depende del número de scripts a comparar encontrados tras el proceso de filtrado.
- Los parámetros a comparar deben de resumir la mayor información posible y propia de scripts: líneas comentadas, líneas de código, número de sentencias IF, FOR, etc.
### 4. Otras premisas adoptadas
Además de las premisas “impuestas” por el enunciado de la práctica, hemos decidido adoptar otras premisas orientadas al formato del propio script.
- No sólo el fichero de resultados sino el propio script a diseñar debe de estar correctamente estructurado y formateado
- Además, el script a diseñar estará correcta y detalladamente comentado para facilitar su lectura por terceros.
