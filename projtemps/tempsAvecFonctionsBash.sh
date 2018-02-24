#!/bin/bash

read -p 'de quelle forme est votre date 1: en seconde 2: jj/mm/aaaa ?' forme

if [ $forme = "2" ]; then

    read -p 'veuillez entrer une date au format jj/mm/aaaa:' i;
    jour=${i:0:2}
    mois=${i:3:2}
    annee=${i:6:4}
elif [ $forme = "1" ]; then
    read -p 'veuillez entrer une date en seconde :' j;         
 else
    echo 'erreur de saisie'

fi
if [ $forme = "2" ]; then
    i=$(echo "$mois/$jour/$annee")
    date --date=$i +%s;

elif [ $forme = "1" ]; then
   
    date -d @$j ;
else

     echo 'erreur'
fi 
    
