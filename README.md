# ***CY-Trucks***

**Cy-Trucks** est un programme qui vous permettra d’afficher des données consolidées sur votre activité. </br>
En d’autres termes, Cy-trucks va analyser le contenu d'un fichier de données et générer des graphiques résumant le contenu de ce fichier. </br> Les graphiques diffèrent en fonction des traitements demandés lors de l'exécution. 
## Compatibilité système

Le programme est compatible avec les dernières versions de **Ubuntu**.

## Technologies utilisées

* Langage de programmation : <code>C</code>, <code>Bash</code>, <code>gnuplot</code>
* Logiciel utilisé : **Visual Studio Code**

## Téléchargement
* Télécharger [<code>CY-Trucks</code>](https://github.com/ElyasMens/Projet/archive/refs/heads/main.zip) et extraire le fichier.
* Télécharger une version récente de [<code>-make</code>], [<code>-gcc</code>] et [<code>gnuplot</code>]  (si cela n'est pas déjà fait).

## Lancement
Afin d'utiliser le programme, veuillez ouvrir un terminal dans le dossier <code>PROJET-MAIN/</code> </br> Assurez-vous d'avoir votre fichier de données dans le dossier <code>PROJET-MAIN/</code></br>
Exécuter la commande <code>bash cytruck.sh arg1 arg2</code> avec <code>arg1</code> le nom du fichier de données et <code>arg2</code> l'option voulue </br>
Il est possible de mettre des options voulues en argument supplémentaire par exemple <code>bash cytruck.sh arg1 arg2 arg3 arg4</code>
  
## Options

* <code>-h</code> : afficher les commandes du programme **[disponible]**
* <code>-d1</code> : 10 premiers conducteurs **[disponible]**
* <code>-d2</code> : 10 plus grandes distances **[disponible]**
* <code>-l</code> : 10 trajets les plus longs **[disponible]**
* <code>-t</code> : 10 villes les plus traversées **[disponible]**
* <code>-s</code> : statistiques sur les étapes **[disponible]**

Si l'option <code>-h</code> est exécutée, les autres options seront ignorées.

## Règles
* Le fichier de données doit toujours être le premier argument
* Le fichier de données doit se situer dans le dossier <code>PROJET-MAIN</code>
* Assurez vous d'avoir un fichier dont la première ligne est <code>Route ID;Step ID;Town A;Town B;Distance;Driver name</code>.</br>Les données de votre fichiers doivent également être classées dans cet ordre.
* Le fichier de données doit avoir au moins 50 Route ID différents afin d'assurer le bon fonctionnement de tous les traitements.
