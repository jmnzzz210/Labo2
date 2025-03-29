#!/bin/bash

directorio="/home/brandon/Downloads"
monitor="/home/brandon/Documents/Laboratorios/Laboratorio2/acciones.log"

if [ -d $directorio ]; then
        inotifywait -m -e create,modify,delete,move "$directorio" |
                while read -r dir accion archivo; do
                echo "[$(date '+%d/%m/%y %H:%M:%S')] Accion ocurrida: $accion en el archivo $archivo">>"$monitor"
done
else
	echo "El directorio $directorio, no existe"
fi
