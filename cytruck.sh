#!/bin/bash

#Verifie si la commande d'execution du programme est correctement écrite
if [ $# -lt 1 ] || [ $# -lt 2 ] 
then
	echo "Pour de l'aide faites la commande suivante: bash script [nom_fichier] -h"
	exit 1	
fi

#Verifie si le fichier en entrée existe 
if [ ! -f $1 ]
then 
	echo "le fichier n'existe pas"
	echo "Pour de l'aide faites la commande suivante: bash script [nom_fichier] -h"
	exit 2
fi

#Verifie l'existence du dossier demo
if [ ! -d demo ]
then
	mkdir demo
fi

#Verifie l'existence du dossier data_dir
if [ ! -d data_dir ]
then
	mkdir data_dir
elif [ -f data_dir/* ]
then
	rm -f data_dir/*
fi

#Verifie que le dossier images est vide
function check_images {
if [ -f images/* ]
then
	mv images/* demo
fi
}
#Verifie l'existence du dossier img
if [ ! -d images ]
then
	mkdir images
else
	check_images
fi

#Verifie si le dossier temp existe et s'il contient des fichier temporaire / appelle la fonction check_images
function check_temp_and_images {
	if [ ! -d temp ]
	then
		#echo "tmpdir crée"
		mkdir temp
	elif [ "-f temp/*" ]
	then	
		#echo "supprime les tmp"
		rm -f temp/*
	fi
	check_images
}

help=0
trid1=0
trid2=0
triL=0
triT=0
triS=0
for i in `seq 2 $#` 
do
case ${!i} in
'-h')help=1
i=$((i+1))break;; # ignore les autres commandes si -h est en paramètre
'-d1')trid1=1
i=$((i+1));;
'-d2')trid2=1
i=$((i+1));;
'-l')triL=1
i=$((i+1));;
'-t')triT=1
i=$((i+1));;
'-s')triS=1
i=$((i+1));;
*) 
esac
done

#Copie du fichier data dans le dossier data_dir 
cp $1 data_dir
data="data_dir/$1" 
nbLines=`cat $data | wc -l`
nbLines=$((nbLines -1)) 

#-h: Afficher les commandes du programmes
if [ $help -eq 1 ]
then
	echo "Pour executer le programme: bash script [nom_fichier] [option]"
	echo " "
	echo "option -h: Afficher les commandes du programmes [disponible]"
	echo "option -d1: 10 premiers conducteurs [disponible]"
	echo "option -d2: 10 plus grandes distances [disponible]"
	echo "option -l: 10 trajets les plus longs [disponible]"
	echo "option -t: 10 villes les plus traversées [indisponible]"
	echo "option -s: statistiques sur les étapes [indisponible]"
	
fi

#Tri -d1
if [ $trid1 -eq 1 ]
then	
	the_begin=$(date +%s)
	check_temp_and_images 
	echo > tmp.csv | mv tmp.csv temp
	# 1er et 2e awk: Recuperation des colones 1 et 6 et Elimination des doublons 
	# 3e awk: Calcul du nombre de route par conducteur puis tri par ordre décroissant
	tail -$nbLines $data | awk '{
		split($0, tab,";"); 
		print tab[1]";"tab[6]
	}' | awk '{
			tab[$0]++
		} END {
		for (line in tab) {
			print line
		}
	}' | awk -F';' '{	
				nbRoutes[$2]++;	
				} END { 
				for (driver in nbRoutes) {
				 	print driver";"nbRoutes[driver]   
				 }
			}' | sort -t';' -k2 -n -r | head -10 > temp/tmp.csv 
	#gnuplot
	echo > tmp_gnuplot.gp | mv tmp_gnuplot.gp temp
	echo "set terminal png size 800,900" > tmp_gnuplot.gp
	echo "set output 'tmpImg_d1.png'" >> tmp_gnuplot.gp

	echo "set style data histogram" >> tmp_gnuplot.gp
	echo "set style fill solid" >> tmp_gnuplot.gp
	echo "set boxwidth 0.5" >> tmp_gnuplot.gp
	echo "set style fill solid border -1" >> tmp_gnuplot.gp

	echo "unset key" >> tmp_gnuplot.gp

	echo "set xlabel 'DRIVER NAMES' rotate by 180 offset 0,-9" >> tmp_gnuplot.gp
	echo "set y2label 'NB ROUTES' offset 3,0" >> tmp_gnuplot.gp
	echo "set ylabel 'Nom=f(Nbr trajets)' offset 4,0 " >> tmp_gnuplot.gp
	echo "set xtic rotate by 90 font '0,10' offset 0.5,-9.5" >> tmp_gnuplot.gp
	echo "set ytic rotate by 90 font '0,10' offset 79,1" >> tmp_gnuplot.gp

	echo "set yrange [0:*]" >> tmp_gnuplot.gp
	echo "set datafile separator ';'" >> tmp_gnuplot.gp
	echo "plot 'temp/tmp.csv' using 2:xticlabels(1) with boxes" >> tmp_gnuplot.gp
	gnuplot -persist -c "tmp_gnuplot.gp"
	#----------------------------------
	convert 'tmpImg_d1.png' -rotate 90 'Img_d1.png'
	mv tmpImg_d1.png temp 
	mv Img_d1.png images
	
	the_end=$(date +%s)
	the_time=$((the_end - the_begin))
	echo "Durée du traitement: $the_time s."
fi

#Tri -d2
if [ $trid2 -eq 1 ]
then
	the_begin=$(date +%s)
	check_temp_and_images 
	echo > tmp.csv | mv tmp.csv temp
	#awk: Somme des distance en fonction de chaque conducteur puis tri par ordre décroissant
	tail -$nbLines $data| awk -F';' '{
		distance[$6]=distance[$6]+$5;
		} END {
			for ( driver in distance ) {
				print driver";"distance[driver]
			}
		}' | sort -t';' -k2 -n -r | head -10 > temp/tmp.csv 	
	#gnuplot
	echo > tmp_gnuplot.gp | mv tmp_gnuplot.gp temp
	echo "set terminal png size 800,900" > tmp_gnuplot.gp
	echo "set output 'tmpImg_d2.png'" >> tmp_gnuplot.gp

	echo "set style data histogram" >> tmp_gnuplot.gp
	echo "set style fill solid" >> tmp_gnuplot.gp
	echo "set boxwidth 0.5" >> tmp_gnuplot.gp
	echo "set style fill solid border -1" >> tmp_gnuplot.gp

	echo "unset key" >> tmp_gnuplot.gp

	echo "set xlabel 'DRIVER NAMES' rotate by 180 offset 0,-9" >> tmp_gnuplot.gp
	echo "set y2label 'DISTANCE (Km)' offset 3,0" >> tmp_gnuplot.gp
	echo "set ylabel 'Distance=f(Driver)' offset 4,0 " >> tmp_gnuplot.gp
	echo "set xtic rotate by 90 font '0,10.3' offset 0.5,-9.5" >> tmp_gnuplot.gp
	echo "set ytic rotate by 90 offset 79,1" >> tmp_gnuplot.gp

	echo "set yrange [0:*]" >> tmp_gnuplot.gp
	echo "set datafile separator ';'" >> tmp_gnuplot.gp
	echo "plot 'temp/tmp.csv' using 2:xticlabels(1) with boxes" >> tmp_gnuplot.gp
	gnuplot -persist -c "tmp_gnuplot.gp"
	#----------------------------------
	convert 'tmpImg_d2.png' -rotate 90 'Img_d2.png'
	mv tmpImg_d2.png temp 
	mv Img_d2.png images
	
	the_end=$(date +%s)
	the_time=$((the_end - the_begin))
	echo "Durée du traitement: $the_time s."
fi

#Tri -l
if [ $triL -eq 1 ]
then 
	the_begin=$(date +%s)
	check_temp_and_images 
	echo > tmp.csv | mv tmp.csv temp
	#awk: Somme des distance en fonction de chaque route puis tri par ordre décroissant 
	tail -$nbLines $data | awk -F';' '{ 
		distance[$1]=distance[$1]+$5;
		} END { 
		for ( routeId in distance ) {
			print routeId";"distance[routeId]
		}
	}' | sort -t';' -k2 -n -r | head -10 | sort -t';' -k1 -n -r > temp/tmp.csv  
	#Avec chatgpt
	echo > tmp_gnuplot.gp | mv tmp_gnuplot.gp temp
	echo "set terminal png size 900,800" > tmp_gnuplot.gp
	echo "set output 'Img_l.png'" >> tmp_gnuplot.gp

	echo "set style data histogram" >> tmp_gnuplot.gp
	echo "set style fill solid border -1" >> tmp_gnuplot.gp
	echo "set boxwidth 0.5" >> tmp_gnuplot.gp

	echo "set xlabel 'Route ID'" >> tmp_gnuplot.gp
	echo "set ylabel 'Distance (en km)'" >>tmp_gnuplot.gp
	echo "set title 'Nombre de routes'" >> tmp_gnuplot.gp
	echo "unset key" >> tmp_gnuplot.gp

	echo "set yrange [0:*]" >> tmp_gnuplot.gp
	echo "set datafile separator ';'" >> tmp_gnuplot.gp
	echo "plot 'temp/tmp.csv' using 2:xtic(1) with boxes" >> tmp_gnuplot.gp
	# Exécute Gnuplot avec le script généré
	gnuplot -persist -c "tmp_gnuplot.gp"
	#----------------------------------
	mv Img_l.png images
	
	the_end=$(date +%s)
	the_time=$((the_end - the_begin))
	echo "Durée du traitement: $the_time s."
fi

#Tri -t
if [ $triT -eq 1 ]
then
	check_temp_and_images
	echo > tmp.csv | mv tmp.csv temp 
	
fi

#Tri -s
if [ $triS -eq 1 ]
then
	check_temp_and_images 
	echo "tri -s"
	

fi

if [ "-f temp/*" ]
then	
	#echo "supprime les tmp"
	rm -f temp/*
fi
echo "END"

