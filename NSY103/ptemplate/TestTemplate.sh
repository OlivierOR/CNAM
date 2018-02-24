#!/bin/bash
#__________________________________________________
#______________ Fonctions _________________________
Titre_P ()	# Argument (Titre)
#	Affiche l'argument en titre principal centré
{
echo
#echo "________________________________"
echo -e "\033[34m      $1\033[0m"      
#echo "________________________________"
}
#__________________________________________________
F_Service ()	# Argument (Service)
	#1) Affiche la sortie de la commande: systemctl is-enabled $1 , Attention retourne $?=0 pour enabled, static, indirect
	#2) Affiche la sortie de la commande: systemctl is-active $1
{
var="systemctl is-enabled $1     ... "
systemctl is-enabled $1 >/dev/null 2>&1
if [[ $? = 0 ]]
	then echo  "${var}" `systemctl is-enabled $1`
	else echo -e "${var} \033[31m" `systemctl is-enabled $1` "\033[0m" | tee -a Test_Template.log 
fi
var="systemctl is-active $1     ... "
systemctl is-active $1 >/dev/null 2>&1
if [[ $? = 0 ]]
	then echo  "${var}" `systemctl is-active $1`
	else echo -e "${var} \033[31m" `systemctl is-active $1` "\033[0m" | tee -a Test_Template.log
fi
}
#__________________________________________________
F_exe () # Argument (ligne de commande bash à exécuter)
{
eval $1 >/dev/null 2>&1
if [[  $? = 0 ]]
	then
		echo "$1     ... Vrai"
	else
		echo -n "$1     ... "  | tee -a Test_Template.log
		echo -e "\033[31mFaux\033[0m" | tee -a Test_Template.log
fi
}
#__________________________________________________
#______________ Programme principal _______________
Titre_P "  Test la configuration des templates"
echo "1: Debian"
echo "2: RHEL"
echo -n "Quelle distribution ? " #>&2
read distrib
if [[ "$distrib" != '1' ]] && [[ "$distrib" != '2' ]]
	then
	echo "Choix non lisible, arrêt."
	exit 1
fi
> Test_Template.log
#__________________________________________________
Titre_P  "Sychronisation heure : NTP"
case "$distrib" in
1)	# Debian
echo "# Avec le service systemd-timesyncd, commande pour activer ntp: timedatectl set-ntp true"
	F_Service "systemd-timesyncd"
	F_exe 'grep "^NTP= *ntp.obspm.fr *ntp1.jussieu.fr" /etc/systemd/timesyncd.conf'
	F_exe 'timedatectl | grep "Time zone: Europe/Paris"'
	F_exe 'timedatectl | grep "NTP synchronized: yes"'
	F_exe 'grep "^NTP= *ntp.obspm.fr *ntp1.jussieu.fr" /etc/systemd/timesyncd.conf'
	;;
2)	# RHEL
#echo " Avec ntpd, commande pour activer ntp: timedatectl set-ntp true"
#	commande_grep "timedatectl" "NTP enabled: yes"		#supprimer
	F_Service "systemd-timesyncd"
	F_exe 'ntpstat | grep "synchronised to NTP server"'
	F_exe 'grep "^server x.ac-lille.fr" /etc/ntp.conf'
	F_exe 'grep "^server y.ac-lille.fr" /etc/ntp.conf' 
	;;
esac
#__________________________________________________
Titre_P "Mise à jour de sécurité : unattended-upgrades" 
	F_Service "unattended-upgrades"
case "$distrib" in
1)	# Debian
	F_exe 'ls /etc/cron.daily/apt-compat'
	F_exe 'grep -P "^[ \t]*Acquire::http::proxy \"http://x.x.x.x:x\";" /etc/apt/apt.conf.d/50proxy'
	;;
2)	# RHEL
	F_exe 'ls /etc/cron.daily/yumsecurity'
	F_exe 'grep "^proxy_hostname =x.x.x.x" /etc/rhsm/rhsm.conf'
	F_exe 'grep "^proxy_port =x" /etc/rhsm/rhsm.conf'
	;;
esac
#__________________________________________________
Titre_P "Politique d’accès aux processus : SELinux"
	F_exe 'grep "SELINUX= *disabled" /etc/selinux/config'
	F_exe 'sestatus | grep disabled'
#__________________________________________________
Titre_P "Serveur de mail : PostFix"
	F_Service "postfix"
	F_exe 'grep "^myhostname =[ ]*$"  /etc/postfix/main.cf'
	F_exe 'grep "^myorigin = \$myhostname$"  /etc/postfix/main.cf'
	F_exe 'grep "^mydestination = \$myhostname, localhost$" /etc/postfix/main.cf'
	F_exe 'grep "^relayhost =[ ]*$" /etc/postfix/main.cf'
#__________________________________________________
Titre_P "Contrôle des connexion internet : xinetd"
#F_Service "xinetd"	#xinetd ne prend pas en charge systemd, réponse longue
	F_exe 'service xinetd status | grep "Loaded: loaded"'
	F_exe 'service xinetd status | grep "Active: active"'
#__________________________________________________
Titre_P "Supervision : check-mk"
case "$distrib" in
1)	# Debian
echo "Agent check-mk-agent : " `apt-cache policy check-mk-agent | grep Install` | tee -a Test_Template.log
	;;
2)	# RHEL

	paquet_installé_RedHat check-mk-agent
	;;
esac
	F_exe 'grep -P "^[ \t]*only_from[ \t]*=[ \t]*127.0.0.1 10.0.20.1 10.0.20.2" /etc/xinetd.d/check_mk'
 	F_exe 'ls /usr/lib/check_mk_agent/local/check_monit.py'
 	F_exe 'ls /usr/lib/check_mk_agent/local/sshd-rootlogin.sh'
 	F_exe 'ls /usr/lib/check_mk_agent/local/localhost-check.sh'
 	F_exe 'ls /usr/lib/check_mk_agent/local/mk-mercurial.sh'
 	F_exe 'ls /usr/lib/check_mk_agent/local/postfix_mailqueue'
 	F_exe 'ls /usr/lib/check_mk_agent/plugins/apt'
#__________________________________________________
Titre_P "Gestion des configurations : etckeeper et mercurial"
	F_exe 'systemctl is-enabled etckeeper'
	F_exe 'grep "^VCS=\"hg\"" /etc/etckeeper/etckeeper.conf'
case "$distrib" in
1)	# Debian
	F_exe 'dpkg --get-selections mercurial | grep install'
	;;
2)	# RHEL
	F_exe 'yum list installed mercurial | grep install'
		;;
esac
	F_exe 'ls -a /etc | grep .hg'
	F_exe '! ls /var/run/mercurial-depot'
#__________________________________________________
Titre_P "Connexion des administrateurs, SSH"
	F_Service "ssh"
 	F_exe 'grep "^PermitRootLogin without-password" /etc/ssh/sshd_config'
	F_exe '! ls /etc/ssh/ssh_host_*'
	F_exe 'ls -a /root/.ssh/authorized_keys'
#__________________________________________________
Titre_P "Autres"
# Liste des paquets à installer
LstPaquet="swaks mutt htop iftop iotop bmon"
case "$distrib" in
1)	# Debian
	for var1 in ${LstPaquet} ; do
		F_exe 'dpkg --get-selections ${var1} | grep install'
	done

	;;
2)	# RHEL
	for var1 in ${LstPaquet} ; do
		F_exe 'yum list installed ${var1} | grep install'
	done
	;;
esac
#__________________________________________________
echo
Titre_P "** Résumé des erreurs **"
cat Test_Template.log
rm Test_Template.log
exit
