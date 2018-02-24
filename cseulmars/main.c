#include <stdio.h>
#include <stdlib.h>
int main()
{
    int ret = 0;
    ret = menu();
    switch ( ret ) {
    case 49: // Si choix 1
      ret = saisie();
      //sleep(5);
      break;
    case 50: // Si choix 2
      ret = fichier();
      //sleep(5);
      break;
    }
    printf("\nBye bye !");
    return 0;
}

int menu()
{
    int ret = 0;
    //system("clear");
    printf("\n!-------------------------------------------------!");
    printf("\n!                                                 !");
    printf("\n!            N   S   Y      1  0  3               !");
    printf("\n!                                                 !");
    printf("\n!     1 convertir une des caractère saisis ;      !");
    printf("\n!     2 convertir le fichier fichier_source.txt ; !");
    printf("\n!                                                 !");
    printf("\n!-------------------------------------------------!");
    printf("\n  Tapez votre choix : ");
    ret = getchar();
    while (getchar() != '\n');
    return ret;
}

 int saisie(){

    // Initialisation des variables
    char str[100];
    int i=0;
    int longueurChaine = 0;
    int compteur = 0;
    // saisie d'une phrase texte par l'utilisateur
    printf("Entrez une phrase: ");
    //scanf("%s",str);
    scanf("%[^\n]", str);

    // On récupère la longueur de la chaîne dans longueurChaine
    longueurChaine = strlen(str);

    // affichage code ascci dec
    printf("les codes ASCII(dec) de la phrase sont : ");

    while (compteur < longueurChaine)
    {
        printf("%d ",str[compteur]);
        compteur++;
    }

    // affichage code ascii hex
    i=0;
    printf("\nles codes ASCII(hex) de la phrase sont : ");
    while(str[i])
         printf("%x ",str[i++]);

    // saisie d'un caractère en code ascci(dec) par l'utilisateur

    printf("\nEntrez un caractère en code ascii(dec) : ");
    scanf("%d",str);

    // affichage texte correspondant
    i=0;
    printf("la caractère texte correspondant est : ");
    while(str[i])
         printf("%c ",str[i++]);

    return 0;
}

int fichier()
{
    FILE* fichier_source = NULL;
    FILE* fichier_cible = NULL;

    int caracterActuel = 0;
    char chaine[30];

    fichier_source = fopen("fichier_source.txt", "r+");
    fichier_cible = fopen("fichier_cible.txt", "w+");



    if (fichier_source != NULL)
    {
        printf("Le texte contenu dans le fichier fichier_source.txt est : ");

        fputs("!-----!-----!-----!\r", fichier_cible);
        fputs("! Car ! DEC ! HEX !\r", fichier_cible);
        fputs("!-----!-----!-----!\r", fichier_cible);
        // Boucle de lecture des caractères un à un
        do
        {
            caracterActuel = fgetc(fichier_source); // On lit le caractère
            if (caracterActuel!= EOF)
            {
                printf("%c", caracterActuel); // On l'affiche
                sprintf(chaine,"!  %c  ! %d !  %x !\r",caracterActuel,caracterActuel,caracterActuel);
                fputs(chaine, fichier_cible);
            }
        } while (caracterActuel != EOF); // On continue tant que fgetc n'a pas retourné EOF (fin de fichier)

        fclose(fichier_source); // On ferme le fichier qui a été ouvert
        fclose(fichier_cible); // On ferme le fichier qui a été ouvert

        printf("Le résultat est dans le fichier fichier_cible.txt ");
    }
    else
    {
        // On affiche un message d'erreur si on veut
        printf("Impossible d'ouvrir le fichier fichier_source.txt");
    }
    return 0;
}


