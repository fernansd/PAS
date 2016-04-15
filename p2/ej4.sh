#!/bin/bash
if [ $# -ne 1 ]
then
	echo "Error. Llama el script así: <nombre-script> <fichero o carpeta a cifrar>"
	exit 1
fi

if [ -f $1 ]
then
	gpg --symmetric -o $1.gpg $1
elif [ -d $1 ]
then
	comprimido=$1.tar.gz
	tar czf $comprimido $1
	gpg --symmetric -o $1.gpg $comprimido
	rm $comprimido
fi
