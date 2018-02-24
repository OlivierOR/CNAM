read -p "entrez le nombre de jours    : " jrs;
read -p "entrez le nombre d'heures    : " hrs;
read -p "entrez le nombre de minutes  : " min;
read -p "entrez le nombre de secondes : " sec;

echo "$jrs*86400+$hrs*3600+$min*60+$sec" |bc;



