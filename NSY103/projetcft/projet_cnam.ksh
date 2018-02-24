###############################################
## Shell d'extraction   
##    des données pour la datafactory 
###############################################
##
## Produit un fichier.gz pour datafactory
## lance la commande CFT d'envoie du fichier
###############################################

####################################################################
# Verification d'un parametre obligatoire
# sortie en echec si le parametre est vide
# parametres:
# $1: nom de la variable a tester
# $2: mode = ALERTE (affichage d'un message), ERREUR(sortie en erreur)
####################################################################
CheckParam()
{
if [ "$(eval echo \${$1})" = "" ]
then
  case "$2" in 
    "ERREUR")
    	printLog ERREUR "Le parametre $1 est manquant" 
    	printLog KO "" 
    	exit 1
    	;;
    "ALERTE")
    	printLog ALERTE "Le parametre $1 est manquant" 
    	;;
  esac
fi
}

####################################################################
# Initialise les fichiers de log et d'erreur
# parametres: aucun
####################################################################
InitLogFiles()
{
# cree les fichiers de log et d'erreurs
FICHIER_TRACE_LOG=$REP_TRACES/${FLUX}_${DATE}.log
FICHIER_TRACE_ERR=$REP_TRACES/${FLUX}_${DATE}.err
touch $FICHIER_TRACE_LOG
RETOUR_TOUCH_LOG=$?
touch $FICHIER_TRACE_ERR
RETOUR_TOUCH_ERR=$?
#retour a stdout/stderr et sortie si impossible d'ouvrir le fichier
[ $RETOUR_TOUCH_LOG -ne 0 ] && FICHIER_TRACE_LOG=
[ $RETOUR_TOUCH_ERR -ne 0 ] && FICHIER_TRACE_ERR=
if [ $RETOUR_TOUCH_LOG -ne 0 ]
then
  printLog ERREUR "Impossible d'ouvrir le fichier de log $REP_TRACES/${FLUX}_${DATE}.log"
  printLog KO ""
  exit 1
fi
if [ $RETOUR_TOUCH_ERR -ne 0 ]
then
  printLog ERREUR "Impossible d'ouvrir le fichier de log $REP_TRACES/${FLUX}_${DATE}.err"
  printLog KO "" 
  exit 1
fi
printLog INFO "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
printLog INFO "Lancement du traitement batch $FLUX"
printLog INFO "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
printLog INFO "Purge fichiers logs et erreurs"
for FILE_LOG in `find ${REP_TRACES}/${FLUX}*.log -type f -mtime +7`
do
  DeleteFile ${FILE_LOG}
done
for FILE_ERR in `find ${REP_TRACES}/${FLUX}*.err -type f -mtime +30`
do
  DeleteFile ${FILE_ERR}
done
}



####################################################################
# Initialise les variables contenant les noms des repertoires
# de travail du flux
# parametres: 
# $1: type de flux S (Sortant)
####################################################################
InitWorkDirsParams()
{
case "$1" in 
 S)
    REP_EXPORT=$REP_DATA_OUT
    REP_TMP=$REP_DATA_OUT/tmp
    REP_EXPORTCREER=$REP_DATA_OUT/creer
    REP_EXPORTECHEC=$REP_DATA_OUT/envoyerechec
    REP_EXPORTRAITE=$REP_DATA_OUT/envoyer

    CheckDir $REP_EXPORT
    CheckDir $REP_TMP
    CheckDir $REP_EXPORTCREER
    CheckDir $REP_EXPORTECHEC
    CheckDir $REP_EXPORTRAITE 

  ;;
esac
}


####################################################################
# ecrit un message dans les fichiers de log
# parametres
# $1: type de message INFO/ALERTE/ERREUR/OK/KO
# $2: Message (passer le param entre quotes)
####################################################################
printLog()
{
DATE_LOG=$(date "+%d/%m/%Y %H:%M:%S")
PREFIX="$DATE_LOG : <$1> <29B> <> $(basename $0)"
if [ ! "$FICHIER_TRACE_LOG" = "" ]
then
  case $1 in
	INFO)
  	echo "$PREFIX: $2" >>$FICHIER_TRACE_LOG
  	;;
	ALERTE|ERREUR)
  	echo "$PREFIX: $2" >>$FICHIER_TRACE_LOG
  	if [ ! "$FICHIER_TRACE_LOG" = "$FICHIER_TRACE_ERR" ]
  	then 
  	  echo "$PREFIX: $2" >>$FICHIER_TRACE_ERR
  	fi
  	;;
	OK)
  	echo "$PREFIX: Flux $FLUX pour le fichier $FICHIER_SOURCE" >>$FICHIER_TRACE_LOG 
  	;;
	KO)
  	echo "$PREFIX: Flux $FLUX pour le fichier $FICHIER_SOURCE" >>$FICHIER_TRACE_LOG 
  	if [ ! "$FICHIER_TRACE_LOG" = "$FICHIER_TRACE_ERR" ]
	then 
  	  echo "$PREFIX: Flux $FLUX pour le fichier $FICHIER_SOURCE" >>$FICHIER_TRACE_ERR
	fi
  	;;
  esac
else
  echo "$PREFIX: $2"
fi
}


#####################################################################################################

# export de toutes les variables
set -a

##################################################################
## Interfaces sortantes
##################################################################
export REP_APPLIS=/exec/applis/29b
export REP_DATA=/data/flf/29b
export REP_TRACES=$REP_APPLIS/logs
export REP_BATCH_OUT=$REP_APPLIS/export
export REP_DATA_OUT_DATAFACTORY=$REP_DATA/outcft/datafactory
export PARTENAIRE_DATAFACTORY=op21ddb1
export IDENT_FLUX_DATAFACTORY=29BDTF1

# Nom du flux
FLUX=DATAFACTORY


# Recuperation repertoire de travail
REP_BASE_OUT=$REP_BATCH_OUT
REP_DATA_OUT=$REP_DATA_OUT_DATAFACTORY


# verifie les parametres d'entree
CheckParam FLUX ERREUR


# Initialise les fichiers de log et erreurs de ce script
DATE=`date "+%Y%m%d"`
InitLogFiles


# verifie que tous les repertoires de travail sont accessibles
InitWorkDirsParams S


Init()
{ 
  hloc=`date +%H`

  
  printLog INFO "Lancement de l extration "
  printLog INFO `date `
  printLog INFO "***************************"
}


Arret(){
CodeRetour=${1}
exit ${CodeRetour}
}


## extraction des donnees
lc_sql()
{


printLog INFO "Lancement du shell $ficSQL"

sqlplus -s ${DB_USER}/${DB_PWD} <<EOF 
WHENEVER SQLERROR EXIT SQL.SQLCODE
@${ficSQL} 
EOF
chmod 777 ${ficdata}
}

##Main
Init

## Pour chaque table à exporter, récupération du nom de la table sur chaque ligne du fichier Liste_Table.txt
cat ${REP_BASE_OUT}/sqlfiles/Liste_Table.txt | while read line
do
  table=`echo ${line} | awk 'FS=":" {print $1}'`
  ficSQL=${REP_BASE_OUT}/sqlfiles/${table}.sql

  ## Création du fichier qui contiendra l'extraction de la table
  ficdata=${REP_TMP}/${table}.dat
  touch ${ficdata}
lc_sql
done

##tous les fichiers dat sont fait on tar
fictar="29BDTF_"${DATE}
printLog INFO "Nom du fichier tar $fictar" 
tar cvf ${REP_EXPORTCREER}/${fictar}.tar ${REP_TMP}/*.dat
 

#purger les fichiers dat ?
printLog INFO "Destruction des fichiers de donnees"
rm -rf ${REP_TMP}/*.dat

#afficher Envoie par cft des fichiers tar


    fictran=${fictar}.tar

## Suppression d'éventuels fichiers zippés existants et zip du fichier à envoyer
printLog INFO "CFTSEND $fictran"
    if test -e   ${REP_EXPORTCREER}/*.gz
     then
       rm -f   ${REP_EXPORTCREER}/*.gz
    fi
    gzip ${REP_EXPORTCREER}/${fictran}

printLog INFO "EXTRACTION DATAFACTORY FINIE ${fictran}.gz"

printLog INFO "Debut ENVOIE CFT"
 
if [ ! -s ${REP_EXPORTCREER}/${fictran}.gz ]
then
   printLog INFO "Fichier introuvable ${REP_EXPORTCREER}/${fictran}.gz"
   Arret 1
fi

cd ${REP_EXPORTCREER}
cftutil send TYPE=file,PART=${PARTENAIRE_DATAFACTORY},IDF=${IDENT_FLUX_DATAFACTORY},fname='/data/flf/29b/outcft/datafactory/creer/&parm',parm= ${fictran}.gz


CodeRetour=$?
if [ ${CodeRetour} -ne 0 ]
then
   printLog INFO "ERREUR CFTUTIL SEND"
   Arret 1
fi
   printLog INFO "CFTUTIL SEND OK"
Arret 0
exit

printLog INFO "Fin ENVOIE CFT"

