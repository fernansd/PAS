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
titulo="1"
for linea in $(cat $archivo)
do
    if [ $titulo ]
    then
        echo "<title>$linea</title>" >> tarea.html
        echo "<body>" >> tarea.html
        titulo=""
    fi
    echo "<p>$linea</p>" >> tarea.html
done

echo "</body>" >> tarea.html
echo "</html>" >> tarea.html

# Restaura los separadores de array a su valor por defecto
IFS=$OLDIFS
