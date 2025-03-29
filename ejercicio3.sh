#!/bin/bash

directorio="/home/brandon/Downloads" #se selecciona el directorio
monitor="/home/brandon/Documents/Laboratorios/Laboratorio2/acciones.log" #se asigna la ruta absoluta del archivo .log

if [ -d $directorio ]; then 
        inotifywait -m -e create,modify,delete,move "$directorio" | #se coloca que este monitoreando constantemente creaciones, modificaciones, eliminaciones y cambios
                while read -r dir accion archivo; do
                echo "[$(date '+%d/%m/%y %H:%M:%S')] Accion ocurrida: $accion en el archivo $archivo">>"$monitor"
done
else
	echo "El directorio $directorio, no existe"
fi
