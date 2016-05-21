Memoria Práctica 4: Apache
==========================


1. Introducción (ej 1-3)
----------------------
Tras ejecutar el script de instalación, hay que añadir al $PATH el directorio
con los ejecutables de Apache, o ir a la carpeta y ejecutar directamente el
archivo.

Sin cambiar el puerto donde escucha el servidor, no se inicia al intentar
escuchar en el puerto 80, ya que está restringido el acceso. Para poder
iniciar el servidor hay que cambiar el puerto en el que el servidor escucha.
Para ello en el fichero https.conf dentro de la carpeta httpd/conf, buscamos
la línea *52*, y cambiamos la opción *Listen* de 80 a 8080 (o cualquier otro
puerto que queramos mientras esté libre).

Tras hacer esto ejecutamos el archivo apachectl dentro de la carpeta httpd/bin,
pasándole el argumento *start*: *./apachectl start*. A continuación, accedemos
en el navegador a la dirección **localhost:8080**. Debe salir el mensaje:
*"It works!"*.

![pagina-prueba-apache](img/it-works.jpg)

2. Directorio de archivos (ej 4-6)
----------------------------------
### Ej4
Para cambiar el directorio donde están los archivos que se sirven, hay que
cambiar en las opciones estas dos líneas, situadas en las líneas *214-215*:

    DocumentRoot "/home/i42sadef/httpd/htdocs"
    <Directory "/home/i42sadef/httpd/htdocs">

Cambiamos la carpeta en ambas líneas por el directorio deseado, en este caso:
*/home/i42sadef/httpd-docs*.

### Ej5
El archivo base que se sirve por defecto es *index.html*, y si no lo encuentra
devuelve un error de *404 Not Found*, para cambiar el nombre del archivo por
defecto se puede editar en el archivo de configuración la línea *248*:
`DirectoryIndex index.html`. Es posible poner varios archivos separados por
espacios, de forma que si no encuentra el primero, use el segundo y así
sucesivamente. Para probarlo podemos tener dos ficheros en el directorio
**httpd-docs**, uno *index.html* y otro *index.htm*. Si hemos configurado apache
de la siguiente forma: `DirectoryIndex index.html index.htm`. Entonces si
eliminamos *index.html* automáticamente servirá *index.htm*. Y en el momento
que volvamos a crear *index.html* comenzará a servir ese archivo.

### Ej6
Por defecto el directorio raiz incluye la **Indexes** en la linea *228*
`Options Indexes FollowSymLinks`. Esta opción es la que permite a Apache crear
automáticamente un listado de un directorio cuando no tiene un archivo de
índice *(ej. index.html)*. Para probar esta opción crearemos un directorio de
prueba dentro del directorio raiz. Y dentro creamos unos cuantos ficheros
de prueba con el comando `touch test{01..15}.txt`. A continuación accedemos
a la ruta **localhost:8080/midirectorio**. Y debe aparecer un listado de todos
los ficheros.

![index-midirectorio](img/index-midirectorio.png)

Si queremos evitar que se puedan listar los directorios basta con eliminar la
opción *Indexes* mencionada antes. Aunque si lo que queremos es que algún
directorio en concreto no se pueda mostrar se puede hacer añadiendo lo siguiente
al archivo de configuración. Lo cual desactiva la opción solo para
este directorio. Devolviendo un error de accesso prohibido *(Forbidden)* cuando
se intenta acceder a este directorio.

    <DirectoryMatch "/midirectorio">
        Options -Indexes
    </DirectoryMatch>

También se puede mejorar el aspecto visual de los índices descomentando la
línea *455*: `Include conf/extra/httpd-autoindex.conf`.

![mejora-index-midirectorio](img/mejora-index-midirectorio.png)


3. Conexión al servidor (ej7-10)
--------------------------------
### Ej7
Cuando iniciamos apache nos devuelve un mensaje con el siguiente contenido:
> AH00558: httpd: Could not reliably determine the server's fully qualified
 domain name, using 172.16.218.12. Set the 'ServerName' directive globally to
  suppress this message

Esto hace referencia a que no hemos puesto el nombre del servidor, y por lo
tanto tomará como valor por defecto la dirección IP. Para evitar que salga
este mensaje debemos configurar el nombre del servidor en la opción *ServerName*.
En torno a la línea *190* hay un comentario donde se explica esta opción. Así
que ponemos debajo la línea `ServerName localhost:8080`.

### Ej8
Para modificar el usuario y el grupo bajo los que corre el demonio *httpd*
debemos modificar las opciones `User` y `Group`. Estas opciones se encuentran
en torno a la línea *160*. Como explica el comentario, podemos especificar
tanto el nombre como el id del usuario/grupo, teniendo que usar de prefijo *#*
en caso de querer usar el id. Además también aclara que para poder usar un
usuario o grupo distintos es necesario comenzar la ejecución como *root*.

### Ej9
Podemos simular peticiones al servidor mendiante el uso del protocolo **telnet**.
Para simular una petición estándar a la página principal debemos escribir:
`telnet localhost 8080`, y a continuación `GET / HTTP/1.0` seguido de dos veces
la tecla *intro*. Esto nos devolverá un mensaje con un contenido similar al
siguiente:

    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
    GET / HTTP/1.0

    HTTP/1.1 200 OK
    Date: Fri, 20 May 2016 10:35:10 GMT
    Server: Apache/2.4.20 (Unix)
    Last-Modified: Fri, 06 May 2016 11:43:34 GMT
    ETag: "9a-5322af7fb2600"
    Accept-Ranges: bytes
    Content-Length: 154
    Connection: close
    Content-Type: text/html

    <!DOCTYPE html>
    <html>
    <head>
    	<meta charset="UTF-8">
    	<title>Inicio</title>
    </head>
    <body>
    <h1>Nombre y Apellidos</h1>
    <p>Fernando Sánchez Delgado</p>
    </body>
    </html>
    Connection closed by foreign host.

Lo primero que hacemos es enviar una petición GET a la raíz del servidor usando
el protocolo *HTTP 1.0*. Tras esto el servidor nos devuelve un respuesta, con
el status `200 OK` usando el protocolo *HTTP 1.1*. Debajo se muestra el resto
de la cabecera del mensaje, donde se incluye información como el nombre del
servidor `Server: Apache/2.4.20 (Unix)` o el tipo de contenido del mensaje
`Content-Type: text/html`. En este caso el contenido es la página *index.html*
que habíamos definido antes en la raíz del servidor.

### Ej10
El servidor Apache permite definir páginas personalizadas para los distintos
errores que pueden surgir. Uno de los más comunes es el error 404:

    HTTP/1.1 404 Not Found
    Date: Fri, 20 May 2016 10:54:17 GMT
    Server: Apache/2.4.20 (Unix)
    Content-Length: 202
    Connection: close
    Content-Type: text/html; charset=iso-8859-1

Para configurar las páginas que se devuelven para los distintos tipos de
errores, en torno a la línea *420* del fichero *httpd.conf*, Apache ya trae
comentados algunos ejemplos. Vamos a definir mensajes para los errores `404`
y `501`. Para ello añadimos las líneas:

    ErrorDocument 404 "El URI que has pedido no lo podemos servir"
    ErrorDocument 501 "Método no implementado"

En caso que prefiramos devolver algo distinto a una cadena de caracteres,
podemos especificar una ruta en su lugar, por ejemplo:
`ErrorDocument 404 /404.html`.

4. Logs y redirecciones (ej11-13)
---------------------------------
### Ej11
Las directivas relacionadas con los logs de Apache se a partir de la línea *270*
aproximandamente. Por ejemplo `ErrorLog "logs/error_log"`.
Se pueden configurar cosas como la localización de los
archivos de log, hasta el formato en que deseamos que se realicen los mensajes.
Por defecto todos los archivos log de Apache se encuentran en el directorio
`httpd/logs/`. En concreto el archivo *access_log* es el que contiene las
peticiones al servidor.

    127.0.0.1 - - [20/May/2016:13:17:55 +0200] "GET / HTTP/1.1" 304 -
    127.0.0.1 - - [20/May/2016:13:19:05 +0200] "GET /asdf HTTP/1.1" 404 42
    127.0.0.1 - - [20/May/2016:13:19:35 +0200] "GET /midirectorio/test01.txt HTTP/1.1" 200 -

Al realizar una petición normal podemos obtener varios tipos de mensajes en el
log, en función de la situación que se haya encontrado el servidor. En la
primera línea del log de arriba el status es *304* lo cual hace referencia a
que el archivo que se pide no ha cambiado desde el último acceso, por lo que
se puede usar la copia almacenada en caché. En la tercera línea se accede a un
archivo que no está en la caché del navegador, por lo que el servidor responde
con un status *200* y el contenido que se ha pedido.

En cuanto a los mensajes resultantes de un acceso erróneo en la segunda línea
de arriba vemos un log con el status *404* ya que se ha solicitado un recurso
no existente.

### Ej12
Para redireccionar una ruta hacia otra dirección basta con añadir en el fichero
de configuración una directiva como la siguiente:
`Redirect /uco http://www.uco.es`.
De esta forma al acceder a la dirección *localhost:8080/uco*, seremos
redireccionados a *http://www.uco.es*. Los comentarios dentro del archivo
de configuración correspondientes a esta opción se encuentran en torno a la
línea *315*.

### Ej13
Para crear un host virtual que dependa de la dirección con la que el cliente
accede basta con añadir al fichero de configuración el siguiente contenido:

    <VirtualHost *:8080>
        DocumentRoot "/home/i42sadef/httpd-docs/"
        Servername localhost

        ErrorLog "logs/local-error.log"
        CustomLog "logs/local-access.log" common

    </VirtualHost>

    <VirtualHost *:8080>
        DocumentRoot "/home/i42sadef/httpd-docs/midirectorio"
        Servername 172.16.218.12

        ErrorLog "logs/ip-error.log"
        CustomLog "logs/ip-access.log" common

    </VirtualHost>

al lado de *VirtualHost* ponemos `*:8080` para asegurarnos de que siguen
escuchando en el puerto 8080. A continuación ponemos la nueva ruta para la
raíz de cada una de las direcciones y ponemos el nombre del servidor que
queremos que tenga.
