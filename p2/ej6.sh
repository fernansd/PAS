#!/bin/bash

mover_protegido () {
    origen=$1
    destino=$2
    
    if [ -e $destino ]
    then
        read -e -p "El fichero $destino existe. ¿Desea sobreescribirlo? (s/n): " opt
        case opt in
            s)
                mv $origen $destino
            n)
                echo "Copia abortada para $destino"
    else
        mv $origen $destino
    fi
}

mytime () {
    t1=$(date +%s.%3N)
    eval $1
    t2=$(date +%s.%3N)
    echo "$(echo "${t2}-${t1}" | bc)"
}

if [ $# -eq 0 ]
then
	echo "Se tomará la carpeta actual como directorio de trabajo:"
	dir=$PWD
	echo $dir
else
    dir=$*
fi

# Controlaa que todos los path pasados sean directorios
for dir in $*
do
    if ! [ -d $dir ]
    then
        echo ":: $dir no es un directorio"
        exit 1
    fi
done

for archivo in $(find $* -e)







echo $prueba




