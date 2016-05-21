#!/bin/bash
OLDIFS=$IFS
IFS=$'\n'

if [ $# -eq 0 ]
then
	echo "Error de llamada. Usar el script $0 <directorio>"
	exit 1
fi

if [ ! -d $1 ]
then
	echo "Error el argumento debe ser un directorio"
fi

dir=$1

echo "**************************"
echo "Número de enlaces simbólicos: $(find $dir -type l | wc -l)"
echo "Número de directorios: $(find $dir -type d | wc -l)"
echo "Número de ficheros convecionales ejecutables: $(find $dir -type f -executable | wc -l)"
echo "**************************"


# Restaura los separadores de array a su valor por defecto
IFS=$OLDIFS
