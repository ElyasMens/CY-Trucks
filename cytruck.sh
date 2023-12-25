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
	elif [ -f temp/* ]
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
	echo "option -d1: 10 premiers conducteurs [disponible]"
	echo "option -d2: 10 plus grandes distances [disponible]"
	echo "option -l: 10 trajets les plus longs [disponible]"
	echo "option -t: 10 villes les plus traversées [indisponible]"
	echo "option -s: statistiques sur les étapes [indisponible]"
	echo "option -h: Afficher les commandes du programmes [disponible]"
	
fi

if [ $trid1 -eq 1 ]
then	
	check_temp_and_images 
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
			}' | sort -t';' -k2 -n -r | head -10 > tmp.txt 
			mv tmp.txt temp
	echo "Driver;Nb Routes"
	cat temp/tmp.txt
fi

if [ $trid2 -eq 1 ]
then
	check_temp_and_images 
	#awk: Somme des distance en fonction de chaque conducteur puis tri par ordre décroissant
	tail -$nbLines $data| awk -F';' '{
		distance[$6]=distance[$6]+$5;
		} END {
			for ( driver in distance ) {
				print driver";"distance[driver]
			}
		}' | sort -t';' -k2 -n -r | head -10 > tmp.txt 
		 mv tmp.txt temp
	echo "Driver;Distance"	
	cat temp/tmp.txt

fi

if [ $triL -eq 1 ]
then 
	check_temp_and_images 
	#awk: Somme des distance en fonction de chaque route puis tri par ordre décroissant 
	tail -$nbLines $data | awk -F';' '{ 
		distance[$1]=distance[$1]+$5;
		} END { 
		for ( routeId in distance ) {
			print routeId";"distance[routeId]
		}
	}' | sort -t';' -k2 -n -r | head -10 | sort -t';' -k1 -n -r > tmp.txt 
	mv tmp.txt temp
	echo "Route Id;Distance"
	cat temp/tmp.txt

	

fi

if [ $triT -eq 1 ]
then
	check_temp_and_images 
	
	
fi

if [ $triS -eq 1 ]
then
	check_temp_and_images 
	echo "tri -s"
	

fi

echo "END"

