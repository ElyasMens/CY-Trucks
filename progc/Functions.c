#include "Header.h"



// Retourne le max entre 2 variable

int max(int a, int b) {
    return (a > b) ? a : b;
}


// Retourne le min entre 2 variable

int min(int a, int b) {
    return (a < b) ? a : b;
}


// Retourne le max entre 3 variable

int max2(int a, int b, int c) {
    return max(max(a, b), c);
}


// Retourne le max entre 3 variable

int min2(int a, int b, int c) {
    return min(min(a, b), c);
}


// Retourne le nombre de ligne d'un fichier

int nbrL(FILE *file){

    int i =0;
    char c;
    while ((c=getc(file))!=EOF){
		if (c=='\n'){
            i++;
        }
	}
    rewind(file);
    return i+1;
}


// Cree un Avl

Avl *creerAvl(Town *e,Dist *f) {
    Avl *n = malloc(sizeof(Avl));
    if (n == NULL) {
        exit(1);
    }
    n->element = e;
    n->elem = f;
    n->fd = NULL;
    n->fg = NULL;
    n->equilibre = 0;
    return n;
}


// Fonction utilisé pour equilibré l'arbre

Avl *rotationG(Avl *a) {
    Avl *pivot = a->fd;
    a->fd = pivot->fg;
    pivot->fg = a;
    int eq_a = a->equilibre;
    int eq_pivot = pivot->equilibre;
    a->equilibre = eq_a - max(eq_pivot, 0) - 1;
    pivot->equilibre = min2(eq_a - 2, eq_a + eq_pivot - 2, eq_pivot - 1);
    a = pivot;
    return a;
}


// Fonction utilisé pour equilibré l'arbre

Avl *rotationD(Avl *a) {
    Avl *pivot = a->fg;
    a->fg = pivot->fd;
    pivot->fd = a;
    int eq_a = a->equilibre;
    int eq_pivot = pivot->equilibre;
    a->equilibre = eq_a - min(eq_pivot, 0) + 1;
    pivot->equilibre = max2(eq_a + 2, eq_a + eq_pivot + 2, eq_pivot + 1);
    a = pivot;
    return a;
}


// Fonction utilisé pour equilibré l'arbre

Avl *DoubleRG(Avl *a) {
    a->fd = rotationD(a->fd);
    return rotationG(a);
}


// Fonction utilisé pour equilibré l'arbre

Avl *DoubleRD(Avl *a) {
    a->fg = rotationG(a->fg);
    return rotationD(a);
}


// Fonction qui equilibre l'arbre

Avl *equilibreAVL(Avl *a) {
    if (a->equilibre >= 2) {
        if (a->fd->equilibre >= 0) {
            return rotationG(a);
        } else {
            return DoubleRG(a);
        }
    } else if (a->equilibre <= -2) {
        if (a->fg->equilibre <= 0) {
            return rotationD(a);
        } else {
            return DoubleRD(a);
        }
    }
    return a;
}


// Fonction utilisé pour inseré une element dans l'arbre

Avl *ajouterFD(Avl *a, Town *e,Dist *f) {
    if (a == NULL) {
        return creerAvl(e,f);
    }
    if (a->fd == NULL) {
        a->fd = creerAvl(e,f);
    }
    return a;
}


// Fonction utilisé pour inseré une element dans l'arbre

Avl *ajouterFG(Avl *a, Town *e,Dist *f) {
    if (a == NULL) {
        return creerAvl(e,f);
    }
    if (a->fg == NULL) {
        a->fg = creerAvl(e,f);
    }
    return a;
}


// Fonction qui insere une element dans l'arbre, selon le int o chosit on le trie d'une facon differente (0: nbr traversé croissant,1: ordre alphabétique des villes,2: max-min des distance croissant)

Avl *insertionAVL(Avl *a, Town *e, Dist *f, int *h, int o) {

    if (a == NULL) {

        *h = 1;
        return creerAvl(e,f);
    } 
    else if (o == 0 ? e->nbrT < a->element->nbrT : o == 1 ? strcmp(e->ville, a->element->ville) < 0 : f->max - f->min < a->elem->max - a->elem->min) {

        a->fg = insertionAVL(a->fg, e, f,h, o);
        *h = -*h;
    } 
    else if (o == 0 ? e->nbrT > a->element->nbrT : o == 1 ? strcmp(e->ville, a->element->ville) > 0 : f->max - f->min > a->elem->max - a->elem->min) {

        a->fd = insertionAVL(a->fd, e,f, h, o);
    } 
    else {

        *h = 0;
        return a;
    }

    if (*h != 0) {
    
        a->equilibre = a->equilibre + *h;
        a = equilibreAVL(a);

        if (a->equilibre == 0) {

            *h = 0;
        } 
        else {

            *h = 1;
        }
    }

    return a;
}


// Fonction qui parcours de facon décroissante un arbre et le sauvegarde dans des fichiers (0: pour le tri S, 1: pour le tri T)

void parcoursDecroissantAvecInfos(Avl *a, FILE *Fich, int *i, int limite,int o) {

    if (a != NULL && *i < limite) {

        parcoursDecroissantAvecInfos(a->fd, Fich, i, limite,o);

        if(o){
            fprintf(Fich, "%s;%d;%d\n", a->element->ville, a->element->nbrT, a->element->nbrP);
        }
        else{

            fprintf(Fich, "%d;%f;%f;%f\n", a->elem->id, a->elem->min, a->elem->moy,a->elem->max);
        }

        (*i)++;
        parcoursDecroissantAvecInfos(a->fg, Fich, i, limite,o);
    }
}


// Fonction qui cherche une ville dans un tableau de structure Town, si elle existe retourne sont index, sinon -1

int trouverVille( char *ville, Town *tableau, int taille) {

    if (tableau == NULL){

        return -1;
    }

    for (int i = 0; i < taille; i++) {

        if (strcmp(ville, tableau[i].ville) == 0) {

            return i;
        }
    }

    return -1;
}


// Fonction tri T

void Tri_t() {

    //Tri par ordre décroissant
    FILE *f, *Fich, *fichier;
    f = fopen("../temp/tmp.txt", "r");
    Fich = fopen("../temp/tmp2.txt", "w+");
    if (f == NULL) {
        printf("Erreur d'ouverture du fichier.\n");
    return;
    }


    Town *allTown = malloc(35000 * sizeof(Town)); 
    Avl *a = NULL;
    int h, lim=0, nbl=nbrL(f);

    // Stock les info du fichier dans le tableau de structure
    for(int c=0; c < nbl;c++){
        fscanf(f,"\n%49[^;];%d;%d",allTown[c].ville,&allTown[c].nbrT,&allTown[c].nbrP);
    }

    // Tri des info avec AVL 
    for(int c=0; c < nbl;c++){
        if(allTown->ville[0]=='\0'){break;}
        a = insertionAVL(a, allTown+c,NULL,&h,0); 
    }

    parcoursDecroissantAvecInfos(a,Fich,&lim,10,1);

 
    fclose(f);
    rewind(Fich);
    free(allTown);
    free(a);
    

    //Tri par ordre alphabétique
    h=0,lim=0;
    Town *someTown = malloc(10 * sizeof(Town)); 
    Avl *b = NULL;

    fichier = fopen("../temp/finalT.txt", "w");

    // Stock les info du fichier dans le tableau de structure
    for(int c=0; c < 10;c++){
        fscanf(Fich,"\n%49[^;];%d;%d",someTown[c].ville,&someTown[c].nbrT,&someTown[c].nbrP);
    }

    // Tri des info avec AVL 
    for(int c=0; c < 10;c++){
        if(someTown->ville[0]=='\0'){break;}
        b = insertionAVL(b, someTown+c,NULL,&h,1); 
    }

    parcoursDecroissantAvecInfos(b,fichier,&lim,50,1);

    free(someTown);
    free(b);
    fclose(fichier);
}


// Fonction tri S

void Tri_s() {

    
    FILE *f, *Fich,*fichier;
    f = fopen("../temp/tmp.txt", "r");
    Fich = fopen("../temp/tmp2.txt", "w+");
    fichier = fopen("../temp/finalS.txt", "w");
    if (f == NULL) {
        printf("Erreur d'ouverture du fichier.\n");
    return;
    }


    Dist *allDist = malloc(300000 * sizeof(Dist)); 
    Avl *a = NULL;
    int h, lim=0, c=0, nbl=nbrL(f);
    char line[100]; 

    // Stock les info du fichier dans le tableau de structure
    for(int c=0; c < nbl;c++){
        fscanf(f,"%d;%f;%f;%f",&allDist[c].id,&allDist[c].min,&allDist[c].max,&allDist[c].moy);
    }

    // Tri des info avec AVL 
    for(int c=0; c < nbl;c++){
        if(allDist->id==0){break;}
        a = insertionAVL(a, NULL, allDist+c,&h,2); 
    }

    parcoursDecroissantAvecInfos(a,Fich,&lim,60,0);
    rewind(Fich);

    // Garde les 50 premieres lignes
    while (fgets(line, sizeof(line), Fich) && c < 50) {
        fputs(line, fichier);
        c++;
    }


    fclose(f);
    fclose(Fich);
    fclose(fichier);
    free(allDist);
    free(a);
}



