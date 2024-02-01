set terminal png size 1600,1200
set output 'Img_s.png'
set style data lines

set xlabel "ROUTE ID" font ",16" offset -1,-2
set ylabel "DISTANCE (km)" font ",16"
set title "Option S - Distance = f(Route)" font ",18"
set xtics rotate by 45 center font ",12" offset -1,-1 
set xrange [0:*]
set yrange [0:1000]
set ytics 100
set datafile separator ";"
plot 'temp/finalS.txt' using 0:2:4:xticlabels(1) with filledcurve lc "#C080FF" title "Distance Min/Max (Km)", \
     '' using 0:3:xticlabels(1) smooth mcs lw 5 lc "#9450D3" title "Distance average"