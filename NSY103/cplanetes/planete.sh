#!/bin/bash

echo "Le saviez-vous..."

tableau=("Pluton est le dieu des enfers, ce qui équivaut à Hadès en grec."
 "Mercure, le dieu du commerce est l'équivalent de chez les romains du dieu grec Hermès, le messager des dieux."
 "La Terre est la seule planète qui ne possède une seule lune."
 "Jupiter est la plus grande planète de notre système solaire."
 "Saturne est nommée pour le dieu romain de la richesse et de l'agriculture."
 "Neptune est nommée pour le dieu romain de la mer."
 "Notre système solaire s'est formé il y a 4,5 milliards d années à partir d un nuage dense de gaz et de poussière interstellaire."
 "Les systèmes solaires peuvent également avoir plus d'une étoile. Ceux-ci sont appelés systèmes d'étoiles binaires s il y a deux étoiles, ou des systèmes multi-étoiles si il y a trois ou plusieurs étoiles."
 "La lune s'éloigne progressivement de la Terre d'environ 2 cm et demie chaque année."
 "L'étude du soleil est appelé héliophysique."
 "La lune a fait ses débuts au cinéma en 1902 dans un film silencieux en noir et blanc appelé Le voyage dans la lune."
 "Les Astéroïdes, parfois appelés planètes mineures, sont des vestiges rocheux laissés par la formation précosse de notre système solaire."
 "Les chercheurs ont trouvé des preuves suggérant qu'il y ait une planète X dans les profondeurs du système solaire."
 "Le nuage de Oort est considéré comme une bulle épaisse de débris glacés entourant notre système solaire."
 "Plus d'un millier d'exoplanètes ont été découvertes et des milliers d'autres sont en attentes.")

rand=$[$RANDOM % 15]
echo ${tableau[$rand]}

plt[0]=58
plt[1]=108
plt[2]=150
plt[3]=228
plt[4]=778
plt[5]=1429
plt[6]=2875
plt[7]=4504
plt[8]=5900


read -p "Entrer le nom de 2 planetes: "  a  b

case $a in
Mercure|mercure) echo La distance entre le soleil et Mercure est de 58 milions km
		  a=plt[0]
;;
Venus|venus) a=plt[1]
		 echo La distance entre le soleil et Vénus est de 108 millions de km
;;
Terre|terre) a=plt[2]
		 echo La distance entre le soleil et Terre est de 15O millions de km
;;
Mars|mars) a=plt[3]
		 echo La distance entre le soleil et Mars est de 228 million de km
;;
Jupiter|jupiter) a=plt[4]
		 echo La distance entre le soleil et Jupiter est de 778 millions de km
;;
Saturne|saturne) a=plt[5]
		 echo La distance entre le soleil et Saturne est de 1 429 millions de km
;;
Uranus|uranus) a=plt[6]
		 echo La distance entre le soleil et Uranus est de 2875 millions de km
;;
Neptune|neptune) a=plt[7]
		 echo La distance entre le soleil et Neptune est de 4 504 millions de km
;;
Pluton|pluton) a=plt[8]
		 echo La distance entre le soleil et Pluton est de 5900 millions de km
;;
*)
 echo mauvaise saisie
i;;
esac

case $b in
Mercure|mercure) b=plt[0]
		 echo La distance entre le soleil et Mercure est de 58 millions de km
;;
Venus|venus) b=plt[1]
		 echo La distance entre le soleil et Venus est de 108 millions de km
;;
Terre|terre) b=plt[2]
		 echo La distance entre le soleil et Terre est de 150 millions de km
;;
Mars|mars) b=plt[3]
		 echo La distance entre le soleil et Mars est de 228 millions de km
;;
Jupiter|jupiter) b=plt[4]
		 echo La distance entre le soleil et Jupiter est de 778 millions de km
;;
Saturne|saturne) b=plt[5]
		 echo La distance entre le soleil et Saturne est 1 429 millions de km
;;
Uranus|uranus) b=plt[6]
		 echo La distance entre le soleil et Uranus est de 2 875 millions de km
;;
Neptune|neptune) b=plt[7]
		 echo La distance entre le soleil et Neptune est de 4 504 million de km
;;
Pluton|pluton) b=plt[8]
		 echo La distance entre le soleil et Pluton est de 5 900 millions de km
;;
*)
 echo mauvaise saisie
esac


r=$((a-b)) 
r=`echo ${r#-} `
echo la distance entre ces 2 planètes est de : $r millions de km

l=`echo $r/150|bc -l` 


echo soit : $l unité astronomique

read -p 'Entrer une distance en kilomètres : ' distance

function convertir {
	let "resultat = $distance / 60000"
	echo Breakthrought Starshot mettra "$resultat" secondes pou atteindre cette destination;
}
 
convertir $resultat 

