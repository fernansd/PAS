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

# 1. Mostrar títulos de las series
echo -e "\n1) Títulos de series:"
grep -E '[0-9]+\. ' $archivo
echo "****************"

# 2. Mostrar líneas que contienen el nombre de la cadena que produce la serie
echo -e "\n2) Nombres de productoras:"
grep -E '^\*.+\*' $archivo
echo "****************"

# 3. Igual que el 2. pero quitando asteriscos y espacios
echo -e "\n3) Sin espacios ni asteriscos:"
grep -E '^\*.+\*' $archivo | sed -nr 's/\* +(.+) +\*/\1/p'
echo "****************"

# 4. Imprimir fichero sin líneas de sinopsis
echo -e "\n4) Fichero sin sinopsis"
sed -r '/^SINOPSIS.+$/d' $archivo
echo "****************"

# 5. Eliminar líneas vacías
echo -e "\n5) Fichero sin líneas vacías"
sed -r '/^$/d' $archivo
echo "****************"

# 6. Contar cúantas series produce una cadena
echo -e "\n6) Números de producciones por cadena:"
for nombre in $(grep -E '^\*.+\*' $archivo | sort | uniq -c )
do
	echo $nombre | sed -nr 's/^ +([0-9]) +\* +(.+) +\*/\2->\1/p'
done
echo "****************"

# 7. Mostrar líneas con mayúsculas entre paréntesis
echo -e "\n7) Líneas con máyusculas entre paréntesis"
grep -E '\(.*[A-Z].+\)' $archivo
echo "****************"

# 8. Emparejamientos de palabras repetidas en la misma línea:
echo -e "\n8) Palabras repetidas en la misma línea"

