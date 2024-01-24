set terminal png size 900,800
set output 'img_l.png'
set style data histogram
set style fill solid border -1
set boxwidth 0.5
set xlabel 'Route ID'
set ylabel 'Distance (en km)'
set title 'Nombre de routes'
unset key
set yrange [0:*]
set datafile separator ';'
plot 'temp/tmp.txt' using 2:xtic(1) with boxes
