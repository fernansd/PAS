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

# Apartado 1
echo -e "\nLista de los ficheros ocultos en $HOME"

for archivo in $(ls -1a $HOME | grep '\..*')
do
    echo "$(echo $archivo | wc -m) $archivo"
done | sort -s -n -k 1,1 | sed -nr 's/[0-9]+ (.+)/\1/p'
echo "======="

# Apartado 2
echo "El fichero a procesar es $archivo"
echo "El fichero sin líneas vacías se ha guardado en $archivo.sinLineasVacias"
cat $archivo | sed '/^\s*$/d' > "$archivo.sinLineasVacias"
echo "======="

# Apartado 3
ps -o ruser,pid,start_time,cmd | grep "^$USER" \
| sed -nr 's/^.+ ([0-9]+) ([0-9]{2}\:[0-9]{2}) (.+)/PID: "\1" Hora:"\2" Ejecutable: "\3"/p'




# Restaura los separadores de array a su valor por defecto
IFS=$OLDIFS
