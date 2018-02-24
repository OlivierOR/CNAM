#!/bin/bash

trap "" 2 3 15 # ignorer les signaux
clear
cd /home/$USER/projet/questions
repetition="o"
while [ $repetition == "o" ]
	do 
	echo -e "===========================================================================\n"
	echo -e "bonjour $USER afin de progresser dans l'apprentissage de linux,\nje te propose de repondre à 5 question à chaque fois que tu lance la console\n"
	echo -e "===========================================================================\n"
	#initialisation du nombre de fois à 1 puis s'arretter à la 5em question
	#-n pour rester sur la meme ligne, le -e pour faire la tabulation ou retour a la ligne
	echo -en "3"
	sleep 1
	echo -en "\t2"
	sleep 1
	echo -en "\t1"
	sleep 1
	echo -en "\tBooooooom !!"
	sleep 1
	clear
	apt moo
	sleep 1
	clear
	let "nbFois=1"
	let "score=0"
	while [ $nbFois -le 5 ]
		do
		#chercher aleatoirement un fichier(dans chaque fichier il ya une question)
		nbFichiers=`ls|wc -l`
		let "nbFichiers=nbFichiers"
		nomFichier=$(( ( RANDOM % $nbFichiers ) + 1 ))
		reponseQuestion=$(grep SolutionQ $nomFichier.txt|cut -d: -f2)
		echo -e "\033[42mQuestion : $nbFois \n\033[0m"
		grep -E -v '^(#)' $nomFichier.txt
		echo -e "\n!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		nbBonnesReponses=$(grep BonneReponseQ $nomFichier.txt|cut -d: -f2)
		echo -e "!!! Vous avez repondu correctement à cette question $nbBonnesReponses fois !!!"
		nbMauvaisesReponses=$(grep MauvaiseReponseQ $nomFichier.txt|cut -d: -f2)
                echo -e "!!! Vous avez mal repondu à cette question $nbMauvaisesReponses fois          !!!"
		echo -e "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n" 
		read -p 'Entrer le numero de la reponse sans appuyer sur entree ' -n 1 reponseUtilisateur 
		if [ $reponseUtilisateur -eq $reponseQuestion ]
		 then
       		 echo -e "\n\n\033[42m bravo c'est une bonne reponse \033[0m"
		 let "nbBonnesReponses=nbBonnesReponses+1"
		 sed -i -e "s/#BonneReponseQ:.*/#BonneReponseQ:$nbBonnesReponses/g" $nomFichier.txt
       		 let "score=score+1"
  		 else
       		 echo -e "\n\n\033[41m Faux La bonne reponse est la reponse n° $reponseQuestion \033[0m" 
		let "nbMauvaisesReponses=nbMauvaisesReponses+1"
                 sed -i -e "s/#MauvaiseReponseQ:.*/#MauvaiseReponseQ:$nbMauvaisesReponses/g" $nomFichier.txt
		fi
		sleep 2
		clear
		let "nbFois=nbFois+1"
		done
	let "score=score*20"
	echo "votre score est de $score %"
	read -p "taper o pour refaire un quiz, autre chose pour quitter " -n 1 repetition 
	clear
	done
trap 2 3 15 # revenir à l'état par défaut

