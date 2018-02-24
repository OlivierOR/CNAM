#!/bin/bash


 wtmp () {
 last -Fwi | head -n 50
 }


 btmp () {
 lastb | head -n 50
 }


 securelog () {
cat  /var/log/auth.log* | grep USER=root | tail -n 30
 }

 lastlogs () {
 clear
 lastlog  | grep -v "**Never logged in**"
 }


mailing () {

DATE=$(date +%Y%m%d%H%M)
BODY=/root/script_log/body.ssmtp
TMPDIR=/root/script_log/PJS/tmp
DATADIR=/root/script_log/PJS/current
HEADER=/root/script_log/header.ssmtp
#EMAIL=alex.dk.snn@gmail.com
EMAIL=ayoub.abarji@gmail.com
SPACER=/root/script_log/spacer.ssmtp




last -Fwi | head -n 100 | sort -r > $TMPDIR/log_connexion_ok_$DATE.txt
lastb | head -n 100 | sort -r > $TMPDIR/log_connexion_NOK_$DATE.txt
cat  /var/log/auth.log* | grep USER=root | tail -n 100 > $TMPDIR/log_root_$DATE.txt
lastlog  | grep -v "**Never logged in**" > $TMPDIR/lastlogin$DATE.txt

uuencode $TMPDIR/log_connexion_ok_$DATE.txt log_connexion_ok_$DATE.txt > $DATADIR/pj1
uuencode $TMPDIR/log_connexion_NOK_$DATE.txt log_connexion_NOK_$DATE.txt > $DATADIR/pj2
uuencode $TMPDIR/log_root_$DATE.txt log_root_$DATE.txt > $DATADIR/pj3
uuencode $TMPDIR/lastlogin$DATE.txt lastlogin$DATE.txt > $DATADIR/pj4

#cat $HEADER $SPACER /tmp/log_connexion_ok_$DATE.txt $SPACER /tmp/log_connexion_NOK_$DATE.txt $SPACER /tmp/log_root_$DATE.txt $SPACER /home/alex/test> $BODY

cat $HEADER $SPACER $DATADIR/pj1 $DATADIR/pj2 $DATADIR/pj3 $DATADIR/pj4 > $BODY
/usr/sbin/ssmtp $EMAIL < $BODY

}


usage () {
echo "

Ce script permet d'afficher les logs de connexion au systeme.
Il s'utilise de la maniere suivante :

./security-chk.sh ok		==> affiche les connexions reussies au systeme
./serurity-chk.sh nok		==> affiche les connexions echouees au systeme
./security-chk.sh root		==> affiche les commandes lancees avec les droits root
./security-chk.sh last		==> affiche les dernieres connexions par utilisateur
./security-chk.sh mailing	==> cree l envoi automatique par mail des logs


Pour modifier les paramètres SSMTP, editez les fichiers :
- /root/script_log/header.txt
- /etc/ssmtp/ssmtp.conf

"
}




 if [ "$1" = "ok" ]; then
         wtmp

 elif [ "$1" = "nok" ]; then
         btmp

 elif [ "$1" = "root" ];then
         securelog

 elif [ "$1" = "last" ];then
         lastlogs

elif [ "$1" = "usage" ]; then
	usage

elif [ "$1" = "mailing" ]; then
	mailing

else 
usage


fi
exit 0
