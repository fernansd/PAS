#!/bin/bash
OLDIFS=$IFS
IFS=$'\n'

if [ $# -eq 0 ]
then
	echo "Error de llamada. Usar el script $0 <fichero>"
	exit 1
fi

if [ $# -neq 1 ]
then
	echo "Error de llamada. Usar el script $0 <fichero>"
	exit 1
fi

if [ ! -f $1 ]
then
	echo "Error el argumento debe ser un fichero"
fi

archivo=$1

cat $archivo | sed '/^\s*$/d' | sed -r '/=+/d' \
| sed -r 's/(^[0-9].+) \((.+)\)/\1\n\|-> Año de la serie: \2/' \
| sed -r 's/^([0-9]+) TEMPORADAS/\|-> Número de temporadas: \1/' \
| sed -r 's/^\* (.+) \*/\|-> Productora de la serie: \1/' \
| sed -r 's/^SINOPSIS: (.+) Ver mas$/\|-> Sinopsis: \1/' \
| sed -r 's/^Ha recibido ([0-9]+) puntos/\|-> Número de puntos: \1/'



# Restaura los separadores de array a su valor por defecto
IFS=$OLDIFS
