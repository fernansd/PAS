#!/bin/bash
# No es necesario poner el $1 entre comillas, pero se hace para evitar
# que falle en caso de que no se pase argumento
if [ "$1" == "1" ]
then
	echo "El argumento es 1"
elif [ "$1" == "2" ]
then
	echo "El argumento es 2"
else
	echo "Otra cosa"
fi
