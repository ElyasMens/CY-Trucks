#ifndef HEADER_H
#define HEADER_H
#endif

#include<stdio.h>
#include<stdlib.h>
#include<string.h>


typedef struct town {
    char ville[50];
    int nbrT;
    int nbrP;
} Town;

typedef struct dist {
    int id;
    float min;
    float moy;
    float max;
} Dist;

typedef struct avl {
    Town *element;
    Dist *elem;
    struct avl *fd;
    struct avl *fg;
    int equilibre;
} Avl;




//Fonction utilitaire

int max(int a, int b);
int min(int a, int b);
int max2(int a, int b, int c);
int min2(int a, int b, int c);
int nbrL(FILE *file);


//Fonction vue en cours modifié pour le projet

Avl *creerAvl(Town *e,Dist *f);
Avl *rotationG(Avl *a);
Avl *rotationD(Avl *a);
Avl *ajouterFD(Avl *a, Town *e,Dist *f);
Avl *ajouterFG(Avl *a, Town *e,Dist *f);
Avl *DoubleRG(Avl *a);
Avl *DoubleRD(Avl *a);
Avl *equilibreAVL(Avl *a);
void parcoursDecroissantAvecInfos(Avl *a, FILE *Fich, int *i, int limite,int o);
Avl *insertionAVL(Avl *a, Town *e, Dist *f, int *h, int o);




// Tri S et T

int trouverVille( char *ville, Town *tableau, int taille);
void Tri_t();
void Tri_s();