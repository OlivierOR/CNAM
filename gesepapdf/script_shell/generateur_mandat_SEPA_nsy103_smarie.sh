#!/bin/bash
#
######################################################################
# Shell de génération d'un mandat SEPA
# Globals:
#   Le fichier CSV doit contenir une liste de débiteur,
#   sinon lancer le script en mode -x pour obtenir un template.
#   Le script contrôle la présence d'une base de données et injecte le contenue en base,
#   et utilise cette base pour générer les mandats.
# Arguments:
#   -e execute (injection en base des données, génération des mandats)
#   -h help
#   -t generation du fichier CSV vide
#   -f fichier contenant une liste de débiteurs
# Returns:
#   return 1 ou 0
########################################################################

# Chargement du template du madat SEPA
. template_mdt_sepa_nsy103_smarie.rc

#Recuperation du nom du script shell
readonly NOM=$(basename $0 .sh)

#Nom de la base
readonly NOM_BDD="ecole_ste_anne.db"

#Creation d'un repertoire de travail
readonly REP_TRAVAIL="repertoire_travail_nsy103_smarie"

#En tête du fichier CSV, de presentation des colonnes
readonly EN_TETE_CSV="Nom;Prenom;Email;Adresse;Ville;Code Postal;Iban;Commentaire"

#Requete SQL d'injection des données dans la base de donnée SQLite3
readonly SQL_INSERT_DEBITEUR="INSERT INTO debiteurs VALUES ('NOM', 'PRENOM', 'EMAIL', 'ADRESSE', 'VILLE', 'CP', 'IBAN', 'COMMENTAIRE');"

#Requete SQL de creation de la table parents
readonly SQL_TABLE_DEBITEUR="CREATE TABLE IF NOT EXISTS debiteurs ( nom text, prenom text, email text, adresse text, ville text, cp text, iban text, commentaire text, PRIMARY KEY(nom, prenom));"

# Requete SQL select les données
readonly SQL_SELECT_DEBITEUR="SELECT nom, prenom, adresse, ville, cp, iban FROM debiteurs;"

###########################
# Affichage de l'erreur
travail_personnel::err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

###################################
# Génération du fichier template CSV
travail_personnel::templateCSV() {

    local NOM_FICHIER_CSV="$1"

    # Vérification de la présence du fichier
    ls "$NOM_FICHIER_CSV" 1>/dev/null 2>&1
    if [[ "$?" -eq 0 ]] ; then
        travail_personnel::err "Le fichier $NOM_FICHIER_CSV existe déjà, merci de changer le nom."
        return 1
    else
        #Génération du template CSV
        echo "$EN_TETE_CSV" > $NOM_FICHIER_CSV
        if [[ "$?" -ne 0 ]]; then
            travail_personnel::err "La creation du fichier template n'a pas pu être crée"
            return 1
        fi
        return 0
    fi
}

#########################################
# Creation du repertoire de travail
travail_personnel::creationRepertoire() {

  mkdir -p $REP_TRAVAIL 2>/dev/null
  if [[ $? != 0 ]]; then
    travail_personnel::err "Erreur de creation du repertoire"
    return 1
  fi

  return 0
}

#################################################
# Creation de la base de données avec ses tables
travail_personnel::gestionBDD() {

  # Vérification de la présence du fichier NOM_BDD
  ls $REP_TRAVAIL/$NOM_BDD 1>/dev/null 2>&1
  if [[ "$?" -ne 0 ]] ; then
    # Si la base de données n'est pas présente alors création
    sqlite3 $REP_TRAVAIL/$NOM_BDD <<EOF
        $SQL_TABLE_DEBITEUR
EOF
    if [[ "$?" -ne 0 ]]; then
      travail_personnel::err "Erreur lors de la creation du schema de la base"
      return 1
    fi
  fi

  #TODO : travail_personnel::injectionDonnees
}

#################################################
# Injection des données en base, récuperé depuis le fichier csv
travail_personnel::injectionDonnees() {

  local NOM_FICHIER_CSV=$1
  local nbr_ligne_csv=0

  # Vérification de la présence du fichier
  ls $NOM_FICHIER_CSV 1>/dev/null 2>&1
  if [[ "$?" -ne 0 ]] ; then
      travail_personnel::err "Le fichier $NOM_FICHIER_CSV n'a pas ete trouve"
      travail_personnel::err "Pour generer un template passe l'argument -t"
      return 1
  fi

  # Vérification du nombre de lignes dans le fichier CSV,
  #   si inférieur à 2 le fichier n'est pas correcte
  nbr_ligne_csv=$(wc -l $NOM_FICHIER_CSV | cut -d ' ' -f1)
  if [[ $nbr_ligne_csv -le 1 ]] ; then
    travail_personnel::err "Le fichier ne contient que la ligne de description des colonnes"
    return 1
  fi

  #Extraction des données du fichier
  while read line ; do

    if [[ "$line" == "$EN_TETE_CSV" ]]; then
        continue;
    else

      nom=$(echo $line | cut -d ';' -f1)
      prenom=$(echo $line | cut -d ';' -f2)
      email=$(echo $line | cut -d ';' -f3)
      adresse=$(echo $line | cut -d ';' -f4)
      ville=$(echo $line | cut -d ';' -f5)
      codepostal=$(echo $line | cut -d ';' -f6)
      iban=$(echo $line | cut -d ';' -f7)
      commentaire=$(echo $line | cut -d ';' -f8)

      REQUETE_SQL_INSERT=$(echo $SQL_INSERT_DEBITEUR | sed -e 's/NOM/'"$nom"'/' | sed -e 's/PRENOM/'"$prenom"'/' \
        | sed -e 's/EMAIL/'"$email"'/' | sed -e 's/ADRESSE/'"$adresse"'/' | sed -e 's/VILLE/'"$ville"'/'  \
        | sed -e 's/CP/'"$codepostal"'/' | sed -e 's/IBAN/'"$iban"'/' | sed -e 's/COMMENTAIRE/'"$commentaire"'/')

      sqlite3 $REP_TRAVAIL/$NOM_BDD <<EOF
      $REQUETE_SQL_INSERT
EOF
      if [[ $? -ne 0 ]]; then
        travail_personnel::err "Erreur lors de l'injection des débiteurs"
      fi
    fi
  done < $NOM_FICHIER_CSV


  return 0
}

###################################################
#
travail_personnel::genMandatSepa(){
  old_ifs=$IFS
  IFS=$'\n'

  #Récuperation des débiteurs
  listeDebiteur=($(sqlite3 $REP_TRAVAIL/$NOM_BDD "$SQL_SELECT_DEBITEUR"))
  if [[ $? -ne 0 ]]; then
    IFS=$old_ifs
    travail_personnel::err "Erreur lors de la récupération des débiteurs"
    return 1
  else
    IFS=$old_ifs
  fi

  for ligne in "${listeDebiteur[@]}"; do

    rum=$(cat /proc/sys/kernel/random/uuid | sed 's/-//g')
    nom=$(echo $ligne | cut -d '|' -f1)
    prenom=$(echo $ligne | cut -d '|' -f2)
    adresse=$(echo $ligne | cut -d '|' -f3)
    ville=$(echo $ligne | cut -d '|' -f4)
    codepostal=$(echo $ligne | cut -d '|' -f5)
    iban=$(echo $ligne | cut -d '|' -f6)

    MANDAT_SEPA_FINAL=$(echo $TEMPLATE_MANDAT | sed -e "s/SEPA_NOM/$nom/" | sed -e "s/SEPA_PRENOM/$prenom/" | sed -e "s/SEPA_ADRESSE/$adresse/" \
        | sed -e "s/SEPA_VILLE/$ville/" | sed -e "s/SEPA_CP/$codepostal/" | sed -e "s/SEPA_IBAN/$iban/" | sed -e "s/SEPA_RUM/$rum/")

    echo "$MANDAT_SEPA_FINAL" > "$nom.$prenom.tex"
    if [ "$?" -ne 0 ]; then
        travail_personnel::err "Erreur dans la production du fichier .tex"
    fi

    pdflatex -output-directory $REP_TRAVAIL/ $nom.$prenom.tex 1>&2 2>>/dev/null
    if [ "$?" -ne 0 ]; then
        travail_personnel::err "Erreur dans la génération du pdf"
    fi

    echo "TODO : Supprimer le fichier .tex "
    rm -f $nom.$prenom.tex $REP_TRAVAIL/$nom.$prenom.aux $REP_TRAVAIL/$nom.$prenom.log
    if [ "$?" -ne 0 ]; then
      travail_personnel::err ""
    fi
  done


}

##################################
# Fonction d'affichage de l'aide
travail_personnel::help() {
  echo -e "==================================="
  echo -e "-- Travail Personnel CNAM NSY103 --"
  echo -e "---- Auteur : Marié Sébastien -----"
  echo -e "---- Tuteur : Roussel Olivier -----"
  echo -e "==================================="

  echo -e "$NOM - Programme de génération de mandat SEPA"
  echo -e "-e : execution"
  echo -e "-t : production du fichier template"
  echo -e "-f : fichier à injecter"
  echo -e "-h : help"
  echo -e "Exemple :"
  echo -e " ./generateur_mandat_SEPA_nsy103_smarie.sh -e -f monfichier"
  echo -e " ./generateur_mandat_SEPA_nsy103_smarie.sh -e -t monfichier"
}

################
# Fonction main
main() {

  local EXEC=false
  local param=0
  local nom_csv=""

  while getopts "eht:f:" arg ; do
    case $arg in
      e) EXEC=true ;;
      f) param=1; nom_csv="$OPTARG" ;;
      t) param=2; nom_csv="$OPTARG";;
      h) travail_personnel::help; return 0 ;;
      *) travail_personnel::help; return 1 ;;
    esac
  done

  #[Garde Fou] : Controle de la presence de l'argument -e
  if ! $EXEC ; then
      travail_personnel::help
      return 1
  fi

  case $param in
      #Injection des données en base et production des mandats SEPA
      1)
          #Création du répertoire de travail
          if ! travail_personnel::creationRepertoire ; then
            return 1
          fi

          #Gestion de la base de données
          if ! travail_personnel::gestionBDD ; then
            return 1
          fi

          #Lecture du fichier et injection des données dans la basename
          if ! travail_personnel::injectionDonnees "$nom_csv"; then
            return 1
          fi

          # Création des mandats SEPA au format PDF dans le repertoire de travail
          if ! travail_personnel::genMandatSepa ; then
            return 1
          fi
        ;;
      #Production d'un fichier template CSV
      2)
          travail_personnel::templateCSV "$nom_csv"
        ;;
      *) travail_personnel::help; return 1 ;;
  esac

  return 0
}

main "$@"
