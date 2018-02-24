#!/bin/bash

# script d'installation  pour extraction des logs. Nécessite les droits root

VERSION=$(getconf LONG_BIT)


if [ -d /root/script_log ]; then
sleep 0
else
	mkdir /root/script_log
	mkdir /root/script_log/PJS
	mkdir /root/script_log/PJS/tmp
	mkdir /root/script_log/PJS/current
	mkdir /root/script_log/PJS/old
fi

cp data/log-chk.sh  /root/script_log



if (dialog --title "installation SSMTP"  --yesno "faut-il installer ssmtp
et ses fichiers de configuration?" 15 50) then
		if [ $VERSION = "64" ]; then
			dpkg -i data/ssmtp_2.64-7_amd64.deb
			else 
			dpkg -i data/ssmtp_2.64-7_i386.deb
	
	cp data/header.txt /root/script_log
	cp data/ssmtp.conf /etc/ssmtp/ssmtp.conf
		fi
(dialog --title "installation SSMTP"  --infobox "L'installation s'est déroulée correctement.
Pour modifier les paramètres SSMTP, editez les fichiers :
- /root/script_log/header.txt
- /etc/ssmtp/ssmtp.conf" 15 50)

else
(dialog --title "installation SSMTP"  --infobox "le paquet SSMTP et ses fichiers de
configuration ne seront pas installés" 15 50)

fi

if (dialog --title "installation SSMTP"  --yesno "faut-il configurer le crontab
pour envoyer les logs par mail automatiquement?
(par defaut tous les jours à minuit)" 15 50) then

	if [[ $(cat /etc/crontab) =~ "00 0 * * * root bash /root/script_log/log-chk.sh" ]]; then
	echo "la tache est deja présente dans le crontab. Pas de modification"
	
	else
	echo "00 0 * * * root bash /root/script_log/log-chk.sh" >> /etc/crontab
	echo "la tache a bien été ajoutée"

fi
else
sleep 0
fi


if [[ $(cat /etc/crontab) =~ "bash /usr/local/citation.sh" ]]; then
	sleep 0
else
	cat data/profile >> /etc/profile
	cp data/citation.sh /usr/local/citation.sh
fi

echo 


exit 0