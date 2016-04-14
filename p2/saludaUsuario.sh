#!/bin/bash
read -p "Introduce nombre de usuario: " nombre
if [ "$nombre" == $USER ]
then
	echo "Bievenido $USER "
else
	echo "Eso es mentira"
fi
