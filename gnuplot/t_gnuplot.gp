set terminal png size 800,900
set output 'Img_t.png'
set style data histogram
set style fill solid 
set boxwidth 2
set ylabel "NB ROUTES"
set xlabel "TOWN NAMES" 
set title "Treatment T - Nb routes = f(Towns)" font ",14"
set xtics rotate by 45 center font ",12" right
set yrange [0:*]
set datafile separator ";"
plot 'temp/finalT.txt' using 2:xtic(1) lc "#C080FF" title "Total routes" , '' using 3 lc "#9450D3" title "First town" 
