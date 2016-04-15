#!/bin/bash
if [ $# -ne 2 ]
then
	echo "Error. Llama el script así: <nombre-script> <resumen> <numero-caracteres>"
	exit 1
fi

# Tarda demasiado en evaluar contraseñas más largas
if [ $2 -gt 3 ]
then
	echo "Error. Contraseña demasiado larga. El máximo son 3 caracteres"
	exit 1
fi

for i in $(seq $2)
do
	expresion+="{a..z}"
done

for palabra in $(eval echo $expresion)
do
	if [ $1 == $(echo $palabra | sha1sum | tr -d '-') ]
	then
		echo "Contraseña encontrada!"
		echo "La contraseña es: $palabra"
		exit 0
	fi
done

echo "No se ha encontrado la contraseña..."
exit 1
