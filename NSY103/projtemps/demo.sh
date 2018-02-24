read -p "saisissez votre nombre en seconde : " i
((d=$i/86400, i=$i%86400, hrs=i/3600, i=$i%3600, min=i/60, i=$i%60, sec=i))
timestamp=$(printf "%d:%02d:%s:%02d" $d $hrs $min $sec);
echo "$d jours";
echo "$hrs heures";
echo "$min minutes";
echo "$sec secondes";	
echo $timestamp
