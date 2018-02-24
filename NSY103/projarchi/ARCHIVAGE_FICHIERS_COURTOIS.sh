#!/bin/bash
#parametres = $1:path, $2:taille(avec unité en maj sans le o de octet), $3:temps en jours
#EXEMPLE : bash projet.bash /home 50K 10

myDate=( $(date +"%Y-%m-%d") )
log_path=$PWD"/"

find_path=${1:-$PWD}
size=${2:-"50k"}
time=${3:-"2"}

#cherche les IDs et Noms des utilisateurs
USER_name=( $(awk -F: '/\/home/ && ($3 >= 1000) {printf "%s\n",$1}' /etc/passwd) )
USER_id=( $(awk  -F: '/\/home/ && ($3 >= 1000) {printf "%s\n",$3}' /etc/passwd) )

#cherche l'espace occupé par chaque utilisateurs dans un volume defini par $find_path
for i in ${USER_id[@]}
do
	SIZE+=( $(find $find_path -uid $i -type f -printf "%s\n" | awk '{t+=$1}END{print t/1048576}') )
done


#affiche un tableau de la forme ID | Utilisateur | Espace occupé
printf "%10s %s %15s %s %15s\n" "ID" "|" "Utilisateur" "|" "Espace Occupé (Mo)"
printf "%10s %s %15s %s %15s\n" "----------" "|" "---------------" "|" "---------------"

for((i=0; i<${#USER_id};i++))
do	
	printf "%10d %s %15s %s %15s\n" ${USER_id[i]} "|" ${USER_name[i]} "|" ${SIZE[i]}
done

#choisir l'uid qui nous interresse ou ALL
printf "Précisez l'ID de l'utilisateur qui vous interresse (ALL pour selectionner tout les utilisateurs) : "
read ID

echo
echo ----------
echo
echo Liste des fichiers dont le poids est supérieur à $size''o et qui n\'est utilisé depuis + de $time jours ;
echo Le fichier de log se trouve dans $log_path ;
echo

shopt -s nocasematch
if [[ "$ID" = "ALL" ]]; then
	for i in ${USER_id[@]}
	do
		LOG=$log_path"ID="$i"_"$myDate".log"
		find $find_path -uid $i -size +$size -atime +$time -type f -print0 | xargs -0 du -BM | sort -rn > $LOG
	done
else
	LOG=$log_path"ID="$ID"_"$myDate".log"
	find $find_path -uid $ID -size +$size -atime +$time -type f -print0 | xargs -0 du -BM | sort -rn > $LOG
fi
