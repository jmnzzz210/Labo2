#!/bin/bash
proceso=$1 # Toma la variable que se colocó

# Iniciar el proceso aunque sea en segundo plano
"$proceso" >/dev/null 2>&1 &  

archivolog="monitoreo.log"
grafica="grafica.gp"
tiempo=0

# Esperar a que el proceso se inicie
sleep 4

#Asegurarse que el archivolog este vacio, por si se ejecuto anteriormente borrar todo
> "$archivolog"
echo "Tiempo (s)|CPU (%)|RAM(%)|" >> "$archivolog"	 

#se obtiene el pid, en donde ordena la columna del cpu en orden de mayor a menor y se toma el primero y luego se extrae el pid
PID=$(ps -eo pid,%cpu,comm | grep -i "$proceso" | sort -k2 -rn | head -1 | awk '{print $1}')

#el bucle para ir tomando los datos de la cpu y de la memoria, además del contador.
while ps -p "$PID" >/dev/null 2>&1; do
    datos=$(ps -p "$PID" -o %cpu,%mem --no-header 2>/dev/null)
            cpu=$(echo "$datos" | awk '{print $1}')
       	 ram=$(echo "$datos" | awk '{print $2}')
        echo "$tiempo $cpu $ram" >> "$archivolog"
    sleep 1
    tiempo=$((tiempo + 1))
done

echo "El proceso ha terminado, generando gráfica..."

# Crear script el cual va a ir en el archivo grafica.gp y este lo que hace es personalizar la gráfica
cat > "$grafica" << 'GNUEOF'
set terminal png enhanced size 800,600
set output "grafico.png"
set title "Uso de Recursos del proceso ejecutado"
set xlabel "Tiempo (s)"
set ylabel "Uso (%)"
set grid
set yrange [0:*]
plot "monitoreo.log" using 1:2 with lines lw 2 title "CPU", \
     "monitoreo.log" using 1:3 with lines lw 2 title "RAM"
GNUEOF

#Aquí se genera la gráfica
if command -v gnuplot >/dev/null; then
    if gnuplot "$grafica"; then
        echo "Se generó la gráfica, se encuentra como grafico.png"
    fi
fi
