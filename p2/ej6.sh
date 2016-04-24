#!/bin/bash

# Tiempo de inicio del script
tiempo_inicio=$(date +%s.%3N)

#
# Control de errores
#
if [ $# -eq 0 ]
then
	echo "Se tomará la carpeta actual como directorio de trabajo:"
	dir=$PWD
	echo $dir
else
    # Controla que todos los path pasados sean directorios
    for path in $*
    do
        if ! [ -d $path ]
        then
            echo "Error. $path no es un directorio"
            exit 1
        fi
    done
    dir=$*
fi


#
# Funciones
#
mover_protegido () {
    origen=$1
    destino="$2/$(basename $1)"
    
    if [ -e $destino ]
    then
        read -e -n1 -p "El fichero $destino existe. ¿Desea sobreescribirlo? (s/n): " opt
        case opt in
            s)
                cp $origen $destino
            n)
                echo "Copia abortada para $destino"
        esac
    else
        cp $origen $destino
    fi
}


#
# Ahora se fijan los directorios a los que se copia cada tipo de archivo
#
read -e -p "Introduce directorio para ficheros ejecutables: " exe_dir
if [ -z $exe_dir ]
then
    exe_dir="$HOME/bin"
fi

read -e -p "Introduce directorio para librerías: " lib_dir
if [ -z $lib_dir ]
then
    lib_dir="$HOME/lib"
fi

read -e -p "Introduce directorio para imágenes: " img_dir
if [ -z $img_dir ]
then
    img_dir="$HOME/img"
fi

read -e -p "Introduce directorio para ficheros de cabecera: " h_dir
if [ -z $h_dir ]
then
    h_dir="$HOME/include"
fi

# Si no existen los directorios de destino se crean
for dir in $exe_dir $lib_dir $img_dir $h_dir
do
    if ! [ -e $dir ]
    then
        mkdir $dir
    fi
done


echo -e "\nSe va a usar los directorios:\n"
echo "$exe_dir para ficheros ejecutables"
echo "$lib_dir" para librerias
echo "$img_dir" para imágenes
echo "$h_dir" para ficheros de cabecera


#
# Búsqueda y copia de ficheros
#
for archivo in $(find $dir -executable -type f)
do
    mover_protegido $archivo $exe_dir
done

for archivo in $(find $dir -type f)
do
    libreria=$(basename $archivo | grep "^lib*")
    if ! [ -z $libreria ]
    then
        mover_protegido $libreria $lib_dir
    fi
done

for archivo in $(find $dir \( -path *.png -o -path *.jpg -o -path *.gif \))
do
    pdf=$(echo $archivo | sed 's/\(.*\.\)jpg/\1pdf/')
    convert $archivo $pdf
    mover_protegido $pdf $img_dir

done

for archivo in $(find $dir -path *.h ! -type d)
do
    mover_protegido $archivo $h_dir
done

# Tiempo de finalización del script
tiempo_fin=$(date +%s.%3N)


#
# Estadísticas del script
#
echo "Número de directorios procesados: $#"
echo "Tiempo necesario: $(echo "${tiempo_fin}-${tiempo_inicio}" | bc)"


