#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Error. Llama el script así: <nombre-script> <directorio-1> <directorio-2>"
	exit 1
fi

# Obtiene los path absolutos de cada directorio
origen="$(pwd $1)/$1"
destino="$(pwd $2)/$2"

# Si no existe la carpeta destino la crea
if ! [ -e $destino ]
then
    mkdir $destino
fi

cd $destino

# Crea todos los directorios y excluye del find el directorio base
for dir in $(find $origen ! -path $origen -type d)
do
    # Elimina si la carpeta no existe
    carpeta=$(echo ${dir#$origen\/} | tr 'a-z' 'A-Z')
    if ! [ -e $carpeta ]
    then
	    mkdir $carpeta
	fi
done

for archivo in $(find $origen ! -type d)
do
    cp $archivo $(echo ${archivo#$origen\/} | tr 'a-z' 'A-Z')
done
