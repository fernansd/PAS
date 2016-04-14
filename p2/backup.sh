#!/bin/bash
if [ $# -ne 1 ]
then
	echo "No se ha pasado nombre de archivo"
	exit 1
fi

if [ -f "$1" ]
then
	cp "$1" "$1.bak_$(date +%d-%m-%y)"
else
	echo "El argumento no es un fichero"
	exit 1
fi
