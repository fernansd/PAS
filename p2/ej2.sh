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
