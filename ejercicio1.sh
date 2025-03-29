#!/bin/bash

archivo_log="guardado.log"
touch guardado.log 2>/dev/null
>"$archivo_log" 
usuario_actual=$(whoami) #utilizo el comando para ver que usuario es el que ejecuta el script 

if [ "$usuario_actual" = "root" ]; then 
	:
else
	echo "[ERROR]: El usuario que ejecuta el script no es el usuario root"
	exit
fi #condicion para ver si sigue el archivo o no

parametros=$# #aqui es para verificar que me estan dando lo que se necesita

if [ "$parametros" -ne 3 ]; then
	echo "Recuerde colocar el formato:./ejercicio1.sh usuario grupo ruta de acceso"
fi

usuario=$1 #aquí en estas 3 lineas se asignan las variables colocadas antes en el script 
grupo=$2
ruta=$3

if [ -e "$ruta" ]; then #este es el punto 3, donde se verifica que el archivo exista
   	 : #se coloca 2 puntos para que no haga nada
else
	echo "[ERROR]: El archivo que colocó no existe, generado el $(date +%d-%m-%Y) a las $(date +%H:%M)" >>"$archivo_log"
	cat guardado.log
	exit
fi

if grep -q "^$grupo" /etc/group; then
    echo "[INFO]: El grupo $grupo ya existe."
else
     addgroup "$grupo"
fi

if grep -q "^$usuario:" /etc/passwd; then
    echo "[INFO]: El usuario $usuario ya existe, agregandolo al grupo."
    usermod -a -G $grupo $usuario
else
     echo "El usuario no existe, creandolo y agregando al grupo..."
        adduser $usuario
        usermod -a -G $grupo $usuario

fi

chown $usuario:$grupo $ruta

chmod 740 $ruta
