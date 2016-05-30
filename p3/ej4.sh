#!/bin/bash
OLDIFS=$IFS
IFS=$'\n'

if [ $# -eq 0 ]
then
	echo "Error de llamada. Usar el script $0 <fichero>"
	exit 1
fi

if [ ! -f $1 ]
then
	echo "Error el argumento debe ser un fichero"
fi

archivo=$1

echo "<html>" > tarea.html

# Sustituye la primera ocurrencia de una línea que acabe en :
cat $archivo | sed -r '0,/.*\:$/ s/(.*)\:$/\<title>\1<\/title>\n<body>/' \
| sed -r '/^[^<].*$/,$ s/^(.*)$/<p>\1<\/p>/' >> tarea.html
# A partir de la primera línea que acaba en : añade etiqueta <p>

echo "</body>" >> tarea.html
echo "</html>" >> tarea.html

# Restaura los separadores de array a su valor por defecto
IFS=$OLDIFS
