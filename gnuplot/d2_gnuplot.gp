set terminal png size 800,900
set output 'tmpImg_d2.png'
set style data histogram
set style fill solid
set boxwidth 0.5
unset key
set xlabel 'DRIVER NAMES' rotate by 180 offset 0,-9
set y2label 'DISTANCE (Km)' offset 3,0
set ylabel 'Treatment D2 - Distance=f(Driver)' offset 4,0 font ",16"
set xtic rotate by 90 font '0,10.3' offset 0.5,-9.5
set ytic rotate by 90 offset 79,1
set yrange [0:*]
set datafile separator ';'
plot 'temp/tmp.txt' using 2:xticlabels(1) with boxes lc "#C080FF"
