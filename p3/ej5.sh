#!/bin/bash
OLDIFS=$IFS
IFS=$'\n'

echo "Modelo del procesador:$(cat /proc/cpuinfo | sed -nr 's/^model name.*:(.*)/\1/p')"
echo "Megahercios:$(cat /proc/cpuinfo | sed -nr 's/^cpu MHz.*:(.*)/\1/p')"
echo -n "Número de hilos máximo de ejecución:"
cat /proc/cpuinfo | sed -nr 's/^cpu cores.*:(.*)/\1/p'

echo "Puntos de montaje:"
cat /proc/mounts | sed -r 's/^([^ ]+) ([^ ]+) ([^ ]+) .+$/-> Punto de montaje: \2, Dispositivo: \1, Tipo de dispositivo: \3/ '

# Restaura los separadores de array a su valor por defecto
IFS=$OLDIFS
