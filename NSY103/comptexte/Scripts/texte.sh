#!/bin/bash

read -p 'Entrez le nom du fichier et valider : ' nomfic

echo "  ";

#Calculer les mots du texte par ordre alphabétique:

alpha=$(sed -e 's/[^a-z^A-Z^0-9]/\n/g' -e '/^$/d' $nomfic | tr 'A-Z' 'a-z' | sort | uniq)
echo "Classement des mots du texte par ordre alphabétique: $alpha";  

echo "  ";

#avec sed -e 's/[^a-z^A-Z^0-9]/\n/g' : remplacer tout sauf lettres et chiffres par un renvoi à la ligne
#avec sed -e '/^$/d' : supprime les lignes vides
#avec tr 'A-Z' 'a-z' : remplace les majuscules par des minuscules
#sort : classe par ordre alphabétique 
#uniq : supprime les doublons 

#Calculer les occurrences de chaque mot:
#Toujours à partir de la même trame de sed:
#sed -e 's/[^a-z^A-Z^0-9]/\n/g' -e '/^$/d' texte1 | sort | uniq -c | sort -nr

occ=$(sed -e 's/[^a-z^A-Z^0-9]/\n/g' -e '/^$/d' $nomfic | tr 'A-Z' 'a-z' | sort | uniq -c | sort -nr)
echo -e "Les occurences des mots du texte sont:\n$occ";

#avec sort : classer par ordre alphabétique
#uniq -c : supprime les doublons et préfixe avec le nombre d'occurences
#sort -nr : classe pat valeur numérique inversé

echo "  ";

#echo "Déterminer le nom le plus long dans un texte"
lepluslong=0
for mot in $(<$nomfic)
do
	len=${#mot}
	if (( len > lepluslong ))
	then
		lepluslong=$len
		longueur=$mot
	fi
done
printf 'Le plus long mot est %s et sa longueur est %d.\n' "$longueur" "$lepluslong"
