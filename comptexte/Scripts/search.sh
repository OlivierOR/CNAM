#!/bin/bash

read -p 'Indiquer le nom du fichier:' nomfic
#entrer le nom de fichier
read -p 'Indiquer le mot à rechercher:' mot
#entrer le mot à rechercher
echo "  ";

echo "Le mot \"$mot\":"
echo "  ";

# boucle
while read line
do
   echo "$line" | awk -F ":" '{ $1 = "" ; print $0 }' | sed -e 's/[^a-z^A-Z^0-9]/\n/g' | sed -e '/^$/d' | grep -n $mot | cut -d: -f1 | sed -e '1,1s/^/est le mot n°\ /g'
   #pour chaque ligne on supprimme la colonne 1 (numéro de grep -n), on met un mot par ligne sans ligne vide, on cherche le mot, on récupère uniquement le numéro de la ligne,
   #on rajoute avant le texte "est le mot n°")
   echo "$line" | cut -d: -f1 | sed -e '1,1s/^/de la ligne\ /g' | awk '{print $0"\n"}'
   #pour chaque ligne on conserve uniquement la colonne 1 (numéro de grep -n), on rajoute avant le texte "de la ligne", retour chariot à la fin.
done < <(cat $nomfic | tr 'A-Z' 'a-z'| grep -n $mot)
# en entrée de boucle: on passe le texte uniquement en minuscule, on isole les lignes contenant le mot recherché
