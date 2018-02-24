#! /bin/bash

sortie=4

Affiche()
{
echo "1 - Recherche sur google"
echo "2 - Recherche sur youtube"
echo "3 - Téléchargement de code source sur Github"
echo "4 - Sortie du programme"
echo "Entrez un  nombre entre 1 et 4 :"
}


Affiche

read nombre

#echo $nombre
while [ $nombre -ne $sortie ]; do
      if [ $nombre = 1 ]
      then
         echo "Quelle recherche vous voulez faire sur google : " 
         read recherche_google
         echo "Recherche sur google : "$recherche_google
         python recherche_google.py $recherche_google
      elif [ $nombre = 2 ]
      then
         echo "Quelle recherche vous voulez faire sur youtube :"
         read recherche_youtube
         echo "Recherche sur youtube :"$recherche_youtube
         python recherche_youtube.py $recherche_youtube
      elif [ $nombre = 3 ]
      then
         echo "Quelle recherche vous voulez faire avec github :"
         read recherche_github
         echo "Recherche sur github : "$recherche_github
         echo "Téléchargement des codes sources depuis github..."
         python  recherche_github.py $recherche_github
      else
        echo "Valeur incorrect"
      fi
      
      Affiche
      read nombre

done

echo  "Sortie du programme..."
