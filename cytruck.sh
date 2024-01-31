#!/bin/bash

#Checks the program execution command
if [ $# -lt 1 ] || [ $# -lt 2 ] 
then
	echo "Pour de l'aide faites la commande suivante: bash script [nom_fichier] -h"
	exit 1	
fi

#check if the entry file exists 
if [ ! -f $1 ]
then 
	echo "le fichier n'existe pas"
	echo "Pour de l'aide faites la commande suivante: bash script [nom_fichier] -h"
	exit 2
fi

#check if the dir demo exists
if [ ! -d demo ]
then
	mkdir demo
fi

#check if the dir data_dir exists
if [ ! -d data_dir ]
then
	mkdir data_dir
elif [ -f data_dir/* ]
then
	rm -f data_dir/*
fi

#check if the dir images is empty
function check_images {
if [ -f images/* ]
then
	mv images/* demo
fi
}
#check if the dir images exists
if [ ! -d images ]
then
	mkdir images
else
	check_images
fi

#check if the dir temp exists 
function check_temp_and_images {
	if [ ! -d temp ]
	then
		#echo "tmpdir created"
		mkdir temp
	elif [ "-f temp/*" ]
	then	
		#echo "remove all tmp"
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
i=$((i+1))break;; 
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
#prend tu temps sur le pc de l'ecole
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
	check_temp_and_images 
 	echo "Début du traitement D1..."
	the_begin=$(date +%s)
	echo > tmp.txt | mv tmp.txt temp
	# le if du awk ignore les doublons 
	# sort pour le tri par ordre décroissant
	tail -n $nbLines $data | awk -F';' '{
    		if (!driver_route[$1";"$6]++) {
       			nbRoutes[$6]++;
    	}
	} END {
    		for (driver in nbRoutes) {
        		print driver ";" nbRoutes[driver];
    		}	
	}' | sort -t';' -k2 -n -r | head -10 > temp/tmp.txt
 
 	#Gnuplot -d1
	gnuplot "gnuplot/d1_gnuplot.gp"
	convert 'tmpImg_d1.png' -rotate 90 'Img_d1.png'
	mv Img_d1.png images
	mv tmpImg_d1.png temp 
	
	the_end=$(date +%s)
	the_time=$((the_end - the_begin))
 	
  	echo "L'image 'Img_d1.png' a été enregistré dans le dossier images."
	echo "Durée du traitement: $the_time s."
fi

#Tri -d2
if [ $trid2 -eq 1 ]
then
	check_temp_and_images 
	echo "Début du traitement D2..."
	the_begin=$(date +%s)
	echo > tmp.txt | mv tmp.txt temp
	#awk: Somme des distance en fonction de chaque conducteur puis tri par ordre décroissant
	tail -$nbLines $data| awk -F';' '{
		distance[$6]=distance[$6]+$5;
		} END {
			for ( driver in distance ) {
				print driver";"distance[driver]
			}
		}' | sort -t';' -k2 -n -r | head -10 > temp/tmp.txt 	
	
 	#Gnuplot -d2
	gnuplot "gnuplot/d2_gnuplot.gp"
	convert 'tmpImg_d2.png' -rotate 90 'Img_d2.png'
	mv Img_d2.png images
	mv tmpImg_d2.png temp 
	
	the_end=$(date +%s)
	the_time=$((the_end - the_begin))
	
 	echo "L'image 'Img_d2.png' a été enregistré dans le dossier images."
 	echo "Durée du traitement: $the_time s."
fi

#Tri -l
if [ $triL -eq 1 ]
then 
	check_temp_and_images 
 	echo "Début du traitement L..."
	the_begin=$(date +%s)
	echo > tmp.txt | mv tmp.txt temp
	#awk: Somme des distance en fonction de chaque route puis tri par ordre décroissant 
	tail -$nbLines $data | awk -F';' '{ 
		distance[$1]=distance[$1]+$5;
		} END { 
			for ( routeId in distance ) {
				print routeId";"distance[routeId]
		}
	}' | sort -t';' -k2 -n -r | head -10 | sort -t';' -k1 -n -r > temp/tmp.txt  
	
 	#Gnuplot -l
	gnuplot "gnuplot/l_gnuplot.gp"
	mv Img_l.png images
	
	the_end=$(date +%s)
	the_time=$((the_end - the_begin))

 	echo "L'image 'Img_l.png' a été enregistré dans le dossier images."
	echo "Durée du traitement: $the_time s."
fi

#Tri -t
if [ $triT -eq 1 ]
then
	check_temp_and_images
 	echo "Début du traitement T..."
	the_begin=$(date +%s)
	echo > tmp.txt | mv tmp.txt temp
	#awk: Cree un fichier avec les villes, le nombre de traversé et de depart depuis $data
	tail -$nbLines $data | awk -F';' '{
			if(!seen[$1,$3]++) town_a[$3]++;
			if(!seen[$1,$4]++) town_b[$4]++;
			if($2==1 && !depart_seen[$1,$3]++) depart[$3]++;
		} END {
			for(town in town_a)
				print town ";" town_a[town]+town_b[town]";"depart[town]
	}' >> temp/tmp.txt
 	
  	#Compilation et execution du C
  	#(cd ./progc && make && ./C_sorting -t)
	
 	#Gnuplot -t
	#gnuplot "gnuplot/t_gnuplot.gp"
 	#mv Img_t images
  
  	the_end=$(date +%s)
	the_time=$((the_end - the_begin))

 	#echo "L'image 'Img_t.png' a été enregistré dans le dossier images."
 	echo "Durée du traitement: $the_time s."
	
fi

#Tri -s
if [ $triS -eq 1 ]
then
	check_temp_and_images
   	echo "Début du traitement S..."
	the_begin=$(date +%s)
	echo > tmp.txt | mv tmp.txt temp
	#awk: Cree un fichier avec les routes id, le min, le max et la moyenne depuis
	tail -$nbLines $data | awk -F";" '{
			if (min[$1] == "" || $5 < min[$1]) min[$1] = $5;
			if (max[$1] == "" || $5 > max[$1]) max[$1] = $5;
			sum[$1] += $5; count[$1]++ 
		} 
		END {
			for (id in min)
				print id";"min[id]";"max[id]";"sum[id]/count[id] 
	}' >> temp/tmp.txt
	grep "172705" temp/tmp.txt
 	
  	#Compilation et execution du C
  	#(cd ./progc && make && ./C_sorting -s)
	
 	#Gnuplot -s
 	#gnuplot "gnuplot/s_gnuplot.gp
	#mv Img_s images
	
 	the_end=$(date +%s)
	the_time=$((the_end - the_begin))
 	
  	#echo "L'image 'Img_s.png' a été enregistré dans le dossier images."
	echo "Durée du traitement: $the_time s."

fi

if [ "-f temp/*" ]
then	
	echo "Suppression des fichiers tmp..."
	rm -f temp/*
fi
echo "END"

