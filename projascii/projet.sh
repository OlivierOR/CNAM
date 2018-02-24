#!/bin/bash

#Traducteur ASCII vers string
#Pour le moment le projet ne traduit que un seul caractère 
#Dans un premier jet, je demande demande à l'utilisateur de saisir un code ASCII qui sera stocké dans la variable choix et ensuite traduit mais ça ne fonctionne pas pour plusieurs caractères
#awk permet de faire cette translation de l'ASCII vers l'alphanumerique
#Donc pour chaque argument passé au fichier on demande à awk de traduire l'ASCII en alphanumérique
#Penser à faire un switch case pour améliorer la lisibilité des contrôle . Ajouter un controle pour vérifier que l'utilisateur tape bien un chiffre quand on lui demande un ASCII et une lettre quand on lui demande un caractère
test=true
echo  "Bonjour, bienvenue dans le traducteur de l'ASCII/l'alphanumérique" 
read -p "Entrez 1 : Ascii -> Charactère
Entrez 2 : Charactère -> Ascii " choix
while $test
do
        if test -z $choix
        then 
		echo "Erreur, votre saisie est non valide"
		read choix
        else
	if [ $choix = 1 ] || [ $choix = 2 ]
	then
		test=false

		if [ $choix = 1 ]
		then  
 			read -p "Entrer un ASCII : " pied
                        awk 'BEGIN{printf "%c\n", '$pied'}'
		
		else
			echo "Entrer un Charactère : "
			read chat
			LC_CTYPE=C printf '%d' "'$chat"
		fi
		
	else
		echo "Erreur, votre saisie est non valide"
		read choix
		
	fi
fi
done
echo -e "\n A bientôt"




