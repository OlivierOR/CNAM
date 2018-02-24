#!/bin/bash

#Calculer les mots du texte par ordre alphabétique:

read -p 'Entrez le nom du fichier et valider : ' nomfic
sed -e 's/[^a-z^A-Z^0-9]/\n/g' -e '/^$/d' $nomfic | tr 'A-Z' 'a-z' | sort | uniq  

#avec sed -e 's/[^a-z^A-Z^0-9]/\n/g' : remplacer tout sauf lettres et chiffres par un renvoi à la ligne
#avec sed -e '/^$/d' : supprime les lignes vides
#avec tr 'A-Z' 'a-z' : remplace les majuscules par des minuscules
#sort : classe par ordre alphabétique 
#uniq : supprime les doublons 
