#!/bin/bash
if [ $# -eq 0 ]
then
	echo "Error de llamada. Usar el script $0 <directorio> <numero bytes>"
	exit 1
fi

if ! [ -d "$1" ]
then
	echo "Error. El primer argumento debe ser un directorio"
	exit 1
fi

# Cuando no se pasa el número de bytes
if [ $# -eq 1 ]
then
	contenido=$(find $(pwd $1))
fi

if [ $# -eq 2 ]
then
    contenido=$(find $(pwd $1) -size +"$2"c)
fi

for x in $contenido
do
    if ! [ -d $x ]
    then
        echo -n $(dirname $x)\;
        echo -n $(basename $x)\;
	    echo -n $(stat --format=%s\;%h\;%A\; $x)
	    if [ -x $x ]
	    then
	        echo 1
	    else
	        echo 0
	    fi
	fi
done
