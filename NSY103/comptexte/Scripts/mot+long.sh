#!/bin/bash

#echo "Déterminer le nom le plus long dans un texte"
read -p 'Entrer le nom du fichier :' nomfic
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
