#!/bin/bash
#mkdir dir
#cd ../
reset
source=input_files
destination=../backup
date=`date +%d%m%Y%H%M%S`
echo -e `date +%d-%m-%Y" "%H:%M:%S` "recuperation fichiers"
#On verifie si la commande est bien exécuté
ERR=$?
echo "Code retour : $ERR"
if [ $ERR -eq 0 ]; 
    then
        echo "pas d'erreur"
        #On recupere fichiers sources
        sleep 2
fi
echo  "liste des fichiers récupérés"
cd $source 
#ls
	#Suppression espaces nom de fichiers sinon traitement extension impossible
	for i in * ; 
	do 
		a=`echo $i | tr "[:blank:]" "_"` 
		mv "$i" "$a" 
	done
	
param='ls -l *'
data=${param%%.*}
for words in ${data} #avec nos parametres on va recuperer l'extension des fichiers'
    do                            
       echo "trie par extension" | mkdir -p ${words#*.}  #on creer le repertoire s'il existe pas d'erreur retournee
       for file in ${words%%*.} #On itere sur tous les fichiers
         do rep="${words#*.}" #variable contenant tous les repertoires
         mv "$file" "$rep" #pour chaque type d'extension, on va deplacer les fichiers dans le repertoire correspondant
       done
    done 
#Gerer fichiers avec noms comportants des espaces (impossible d'evaluer')
#Suite --> deplacer les différents repertoires dans le dossier d'archivage


#On compte le nombre de fichiers par extension
#On recupere les extensions pour creer autant de parametres 
#On creer un parametre
#ls
echo -e `date +%d-%m-%Y" "%H:%M:%S` "trie et déplacement fichiers\n\a"
folder=backup_$date 
mkdir $destination/$folder
mv * $destination/$folder
cd $destination

ERR=$?
if [ $ERR -eq 0 ]; 
    then
      echo "commande 1 pas d'erreur"
      echo `date +%d-%m-%Y" "%H:%M:%S` "Compression pour archivage..."
      cd $folder
      rm -r ls
      cd ..
zip -r $folder.zip $destination
sleep 5
echo -e `date +%d-%m-%Y" "%H:%M:%S` "purge repertoire en cours\n\a"
rm -r $folder
sleep 5
echo -e "Archivage terminé avec succès\n\a"
    else
        echo "erreur, le programme ne peut pas continuer"
fi
#if [ $ERR -eq 0 ]; then
#echo `date +%Y%m%d.%H%M%S` $param

#donnee= $myData
#zip -r $dir/$data.zip $dir/$data
#date=`date +%d%m%Y`
#On verifie si le fichier existe
#if [ -f "archive_$date.zip" ];
#then
#echo "Le fichier existe !";
#fi
