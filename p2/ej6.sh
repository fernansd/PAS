#!/bin/bash

# Nombre del archivo donde se va a guardar el log del script
archivo_log="ejercicio6.log"

# Añade log del inicio del script
echo "$(date +[%d-%m-%y]-%H:%M:%S) INICIO DEL SCRIPT" >> $archivo_log

# Tiempo de inicio del script
tiempo_inicio=$(date +%s.%3N)

#
# Control de errores
#
if [ $# -eq 0 ]
then
	echo "Se tomará la carpeta actual como directorio de trabajo:"
	dirs=$PWD
	echo $dirs
	dir_num=1
else
    # Controla que todos los path pasados sean directorios
    for path in $*
    do
        if ! [ -d $path ]
        then
            echo "Error. $path no es un directorio"
            exit 1
        fi
        (( dir_num++ ))
    done
    dirs=$*
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
        case $opt in
            s)
                cp $origen $destino
                echo 1 # return
                ;;
            n)
                echo 0 # return
                ;;
        esac
    else
        cp $origen $destino
        echo 1 # return
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
        echo "$(date +[%d-%m-%y]-%H:%M:%S) Creado directorio: $dir" >> $archivo_log
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
echo "Procesando archivos..."

for archivo in $(find $dirs -executable -type f)
do
    exito=$(mover_protegido $archivo $exe_dir)
    if [ $exito -eq 1 ]
    then
        (( exe_num++ ))
        echo "$(date +[%d-%m-%y]-%H:%M:%S) Copiado archivo $archivo en $exe_dir" >> $archivo_log
    fi
done

for archivo in $(find $dirs -type f)
do
    libreria=$(basename $archivo | grep "^lib*")
    if ! [ -z $libreria ]
    then
        exito=$(mover_protegido $archivo $lib_dir)
        if [ $exito -eq 1 ]
        then
            (( lib_num++ ))
            echo "$(date +[%d-%m-%y]-%H:%M:%S) Copiado archivo $archivo en $lib_dir" >> $archivo_log
        fi
    fi
done

for archivo in $(find $dirs \( -name '*.png' -o -name '*.gif' -o -name '*.jpg' \))
do
    pdf=$(echo $archivo | sed -r 's/(.*\.)(png|jpg|gif)/\1pdf/')
    convert $archivo $pdf
    echo "$(date +[%d-%m-%y]-%H:%M:%S) Convertido $archivo a $pdf" >> $archivo_log
    
    exito=$(mover_protegido $archivo $img_dir)
    if [ $exito -eq 1 ]
    then
        (( img_num++ ))
        echo "$(date +[%d-%m-%y]-%H:%M:%S) Copiado archivo $archivo en $img_dir" >> $archivo_log
    fi
    
    exito=$(mover_protegido $pdf $img_dir)
    if [ $exito -eq 1 ]
    then
        (( img_num++ ))
        echo "$(date +[%d-%m-%y]-%H:%M:%S) Copiado archivo $pdf en $img_dir" >> $archivo_log
    fi

done

for archivo in $(find $dirs -path *.h ! -type d)
do
    exito=$(mover_protegido $archivo $h_dir)
    if [ $exito -eq 1 ]
    then
        (( h_num++ ))
        echo "$(date +[%d-%m-%y]-%H:%M:%S) Copiado archivo $archivo en $h_dir" >> $archivo_log
    fi
done

# Tiempo de finalización del script
tiempo_fin=$(date +%s.%3N)


#
# Estadísticas del script
#
echo "Número de directorios procesados: $dir_num"
echo "Número de ficheros ejecutables: $exe_num"
echo "Número de librerías: $lib_num"
echo "Número de imágenes: $img_num"
echo "Número de ficheros de cabecera: $h_num"
echo "Tiempo necesario: $(echo "${tiempo_fin}-${tiempo_inicio}" | bc)"

# Añade un log de la finalización del script
echo "$(date +[%d-%m-%y]-%H:%M:%S) FIN DEL SCRIPT" >> $archivo_log


