#!/bin/bash
if [ $# -ne 2 ]
then
	echo "Error. Llama el script así: <nombre-script> <directorio-1> <directorio-2>"
	exit 1
fi

#mkdir $2

for dir in $(find $1 -type d)
do
	
done
