#!/bin/bash
bissextile(){
  local  reponse=false
   
un=$(echo "un=$1%4;un" |bc)
    if [ $un -eq 0 ]; then
       deux=$(echo "deux=$1%100;deux" |bc)
       reponse=true
        if [ $deux -eq 0 ]; then
             trois=$(echo "trois=$1%400;trois" |bc)
             if [ $trois -eq 0 ]; then
                 reponse="true"
             else
                reponse="false"
             fi
        else 
             reponse="true"
        fi
        
    else  
        reponse="false"
    fi
    echo $reponse
}

transforme_date(){
        annee=$(echo "annee=$ladte/31536000+1970;annee" |bc)
        mois=1
        jour=0
        quatre=$(echo "quatre=$1%31536000;quatre" |bc)
        cinq=$(echo "cinq=$quatre-2678400;cinq" |bc)
        if [ $cinq -le 0 ]; then
             jour=$(echo "jour=$qatre/86400;jour" |bc)
       
        else
             mois=$(echo "mois=$mois+1;mois" |bc)
            
              bissex=$(bissextile $annee)
            if [ "$bissex" = "true" ]; then

                six=$(echo "six=$cinq-2505600;six" |bc)
            else

                six=$(echo "six=$cinq-2419200;six" |bc)
            fi
            if [ $six -le 0 ]; then
                 jour=$(echo "jour=$cinq/86400;jour" |bc)
            else
                mois=$(echo "mois=$mois+1;mois" |bc)
                sept=$(echo "sept=$six-2678400;sept" |bc)
                if [ $sept -le 0 ]; then
                   jour=$(echo "jour=$six/86400;jour" |bc)
                 else
                    mois=$(echo "mois=$mois+1;mois" |bc)
                    huit=$(echo "huit=$sept-2592000;huit" |bc)
                    if [ $huit -le 0 ]; then
                       jour=$(echo "jour=$sept/86400;jour" |bc)
                    else 
                       mois=$(echo "mois=$mois+1;mois" |bc)
                       neuf=$(echo "neuf=$huit-2678400;neuf" |bc)
                       if [ $neuf -le 0 ]; then
                          jour=$(echo "jour=$huit/86400;jour" |bc)
                       else 
                          mois=$(echo "mois=$mois+1;mois" |bc)
                          dix=$(echo "dix=$neuf-2592000;dix" |bc)
                          if [ $dix -le 0 ]; then
                             jour=$(echo "jour=$neuf/86400;jour" |bc)
                          else 
                             mois=$(echo "mois=$mois+1;mois" |bc)
                             onze=$(echo "onze=$dix-2678400;onze" |bc)
                             if [ $onze -le 0 ]; then
                                jour=$(echo "jour=$dix/86400;jour" |bc)
                             else 
                                mois=$(echo "mois=$mois+1;mois" |bc)
                                douze=$(echo "douze=$onze-2678400;douze" |bc)
                                if [ $douze -le 0 ]; then
                                   jour=$(echo "jour=$onze/86400;jour" |bc)
                                else 
                                   mois=$(echo "mois=$mois+1;mois" |bc)
                                   treize=$(echo "treize=$douze-2592000;treize" |bc)
                                   if [ $treize -le 0 ]; then
                                      jour=$(echo "jour=$douze/86400;jour" |bc)
                                   else 
                                      mois=$(echo "mois=$mois+1;mois" |bc)
                                      quatorze=$(echo "quatorze=$treize-2678400;quatorze" |bc)
                                      if [ $quatorze -le 0 ]; then
                                         jour=$(echo "jour=$treize/86400;jour" |bc)
                                      else 
                                         mois=$(echo "mois=$mois+1;mois" |bc)
                                         quinze=$(echo "quinze=$quatorze-2592000;quinze" |bc)
                                         if [ $quinze -le 0 ]; then
                                            jour=$(echo "jour=$quatorze/86400;jour" |bc)
                                         else
                                            mois=$(echo "mois=$mois+1;mois" |bc)
                                            seize=$(echo "seize=$quinze-2678400;seize" |bc)
                                            if [ $seize -le 0 ]; then
                                               jour=$(echo "jour=$quinze/86400;jour" |bc)
                                            fi
                                         fi
                                      fi
                                   fi
                                fi
                             fi
                          fi
                       fi
                    fi
                 fi
              fi
           fi
    jour=$(echo "jour=$jour+1;jour" |bc)
   echo "$jour/$mois/$annee"   
}

read -p 'de quelle forme est votre date 1: en seconde 2: jj/mm/aaaa ?' forme

if [ $forme = "2" ]; then

    read -p 'veuillez entrer une date au format jj/mm/aaaa:' i
    annee=${i:6:4}  
    mois=${i:3:2}
    jour=${i:0:2}

        bissex=$(bissextile $i)
compteur=0
for i in `seq 1970 $annee`;
do
           
        bissex=$(bissextile $i)
       
        if [ "$bissex" = "true" ]; then
            compteur=$(echo "compteur=$compteur+1;compteur" |bc)

        fi
done  
     
     vingtetun=$(echo "vingtetun=($annee-1970)*31536000+$compteur*86400;vingtetun" |bc)      

     if [ $mois -eq 01 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+$jour*86400;vingtetun" |bc)
     elif [ $mois -eq 02 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 03 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 04 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 05 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+30+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 06 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+30+31+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 07 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+30+31+30+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 08 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+30+31+30+31+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 09 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+30+31+30+31+31+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 10 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+30+31+30+31+31+30+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 11 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+30+31+30+31+31+30+31+$jour)*86400;vingtetun" |bc)
     elif [ $mois -eq 12 ]; then
            vingtetun=$(echo "vingtetun=$vingtetun+(31+28+31+30+31+30+31+31+30+31+30+$jour)*86400;vingtetun" |bc)
     fi
     echo "$vingtetun"
elif [ $forme = "1" ]; then
    read -p 'veuillez entrer une date en seconde :' ladte
    annee=$(echo "annee=$ladte/31536000+1970;annee" |bc)
      compteur=0 
for i in `seq 1970 $annee`;
do
           
        bissex=$(bissextile $i)
       
        if [ "$bissex" = "true" ]; then
            compteur=$(echo "compteur=$compteur+1;compteur" |bc)

        fi
done        
     vingt=$(echo "vingt=$compteur*86400;vingt" |bc)
    ladte=$(echo "ladte=$ladte-$vingt;ladte" |bc)
    transforme_date $ladte 
     
 else
    echo 'erreur de saisie'

fi
