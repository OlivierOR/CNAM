#!/bin/bash

#Calculer les occurrences de chaque mot:
#Toujours à partir de la même trame de sed:
#sed -e 's/[^a-z^A-Z^0-9]/\n/g' -e '/^$/d' texte1 | sort | uniq -c | sort -nr

read -p 'Entrez le nom du fichier et valider : ' nomfic
sed -e 's/[^a-z^A-Z^0-9]/\n/g' -e '/^$/d' $nomfic | tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr

#avec sort : classer par ordre alphabétique
#uniq -c : supprime les doublons et préfixe avec le nombre d'occurences
#sort -nr : classe pat valeur numérique inversé

