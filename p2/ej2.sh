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

# Asigna los valores a cada umbral en función de los argumentos pasados
umbral1=10000
umbral2=100000

if [ $# -eq 2 ]
then
    umbral1=$2
elif [ $# -eq 3 ]
then
    umbral1=$2
    umbral2=$3
fi


# Accede al directorio en el que se va a trabajar
cd $1

echo "Trabajando en las carpetas pequenos, medianos y grandes"

# Se encarga de limpiar las carpetas de clasificación si ya existen o de
# crearlas si no existen
for dir in pequenos medianos grandes
do
    if [ -e $dir ]
    then
        rm -Ir $dir\/
    fi
    
    mkdir $dir
done

# # # # #
# Ahora se buscan todos los archivos que cumplan las condiciones de cada grupo
# por separado. Al comando *find* se le pasa la opción -L para que evalúe los
# enlaces simbólicos según las propiedades del archivo al que apuntan.
# La parte *! -type d* sirve para ignorar los directorios.
#
echo -e "\nMoviendo archivos pequeños\n"
for archivo in $(find -L . ! -type d -size -"$umbral1"c)
do
    cp $archivo ./pequenos
    echo $archivo
done

echo -e "\nMoviendo archivos medianos\n"
for archivo in $(find -L . ! -type d -size +"$umbral1"c -size -"$umbral2"c)
do
    cp $archivo ./medianos
    echo $archivo
done

echo -e "\nMoviendo archivos grandes\n"
for archivo in $(find -L . ! -type d -size +"$umbral2"c)
do
    cp $archivo ./grandes
    echo $archivo
done




































