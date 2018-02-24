#!/bin/bash

# auteur :  CORDIER - EYMENIER - KOBSCH
# version : 1.5
# date :    20/01/2016

# tout programme doit expliquer son fonctionnement
function usage {
    echo -e "usage : ${0} a.b.c.d/m"
    echo -e "      : ${0} a.b.c.d/w.x.y.z"
    echo -e "      : ${0} 11000000.10101000.10000000.00000000/111111111.00000000.00000000.00000000"
    echo -e "      : ${0} 11000000.10101000.10000000.00000000/m"
    echo -e "affiche les caracteristiques reseau de l'adresse Ip passee en parametre"

# retourne la casse d'adresse
# retourne l'adresse réseau
# retourne le nombre d'hotes possibles possible
# retourne la première adresse du reseau et la dernière
# retourne l'adresse de broadcast
    echo ""
    echo -e "exemple : 192.168.128.0/30"
}

# verification du nombre de parametre
if [ "$#" -ne 1 ]
then
    echo "nombre de parametre incorrect"
    usage
    exit
fi

#######################################
# initialisation des fonctions
#######################################

# on creer un tableau à 8 dimensions pour faire office de fonction de transformation decimal vers binaire
Dec2Bin=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})

#######################################
# initialisation des variables
#######################################

# on recupère l'argument passé en paramêtre
argument=$1

# on initialise les variables globales du script
ADDRESS=""
NETMASK=""
NETWORK=""
CIDRMASK=""
FIRSTIP=""
LASTIP=""
BROADCAST=""
WILDCARD=""

HOSTS=""
CLASS=""

BinADDRESS=""
BinNETMASK=""
BinNETWORK=""
BinCIDRMASK=""
BinFIRSTIP=""
BinLASTIP=""
BinBROADCAST=""
BinWILDCARD=""

bCase=0 # =1 pour la notation CIDR =2 pour la notation avec masque complet

# ensuite vient le passage des expressions régulières :-) c'est simple ( heureusement qu'on a pas fait IPv4 :-) )

# expression reguliere pour les adresses IP
# on veut juste s'assurer que les chiffre soit compris entre 0 et 255 ensuite
# les valeur doivent osciller entre 0-9 ou 10-99 ou 100-199 ou 200 à 249 ou 250 à 255
# la version prendre [0-9]{1,3} était trop simpliste et admettais des ip du style 353.999.242.2
regexpAddr='((([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]))'

# expression reguliere pour les masques d'adresse de type 255.255.0.0, ...
# j'ai pris les valeurs brutes car un masque ne peut pas prendre d'autre valeur des 1 suivis des 0, mais nous on manipule des valeurs décimales
regexpMaskOctal='(((0|128|192|224|240|248|252|254|255)\.){3}(0|128|192|224|240|248|252|254|255))'

# pour la notation CIDR on veut un /1 à /32 (voir wikipedia)
regexpMaskCIDR='(([1-9]|[1-2][0-9]|[3][0-2]))'

# cas n°1 : notation CIDR
regexpArg1='^'$regexpAddr'\/'$regexpMaskCIDR'$'

# cas n°2 : ADDRESS/MASQUE
regexpArg2='^'$regexpAddr'\/'$regexpMaskOctal'$'

# cas n°3 IP en binaire et masque en décimal
regexpArg3='^[01]{8}\.[01]{8}\.[01]{8}\.[01]{8}\/'$regexpMaskCIDR'$'

# cas n°4 IP en binaire et masque en binaire
regexpArg4='^[01]{8}\.[01]{8}\.[01]{8}\.[01]{8}\/[01]{8}\.[01]{8}\.[01]{8}\.[01]{8}$'


#######################################
# controle des arguments
#######################################

if [ $(echo $argument | grep -E $regexpArg1) ]
then
    #echo "cas n°1 a.b.c.d/m: $argument"
    bCase="1"
elif [ $(echo $argument | grep -E $regexpArg2) ]
then
    #echo "cas n°2 a.b.c.d/w.x.y.z : $argument"
    bCase="2"
elif [ $(echo $argument | grep -E $regexpArg3) ]
then
    bCase="3"
elif [ $(echo $argument | grep -E $regexpArg4) ]
then
    bCase="4"
else
    echo "l'adresse entree est incorrecte"
    usage
    exit
fi

#######################################
# recuperation des l'adresse IP
#######################################


#######################################
# Adresse IP
#######################################

if [ $bCase = "1" ] || [ $bCase = "2" ]
then

    # l'adresse IP est découper en 4 octet
    ADDRESS=$(echo $argument | cut -d"/" -f 1 )
    ADDRESSa=$(echo $ADDRESS | cut -d"." -f 1 )
    ADDRESSb=$(echo $ADDRESS | cut -d"." -f 2 )
    ADDRESSc=$(echo $ADDRESS | cut -d"." -f 3 )
    ADDRESSd=$(echo $ADDRESS | cut -d"." -f 4 )

    # transformation en binaire pour faciliter les calculs
    BinADDRESSa=${Dec2Bin[$ADDRESSa]}
    BinADDRESSb=${Dec2Bin[$ADDRESSb]}
    BinADDRESSc=${Dec2Bin[$ADDRESSc]}
    BinADDRESSd=${Dec2Bin[$ADDRESSd]}

    # pour l'affichage de l'ip en binaire avec les points
    BinADDRESS=$BinADDRESSa"."$BinADDRESSb"."$BinADDRESSc"."$BinADDRESSd

elif [ $bCase = "3" ] || [ $bCase = "4" ]
then

    BinADDRESS=$(echo $argument | cut -d"/" -f 1 )
    BinADDRESSa=$(echo $BinADDRESS | cut -d"." -f 1 )
    BinADDRESSb=$(echo $BinADDRESS | cut -d"." -f 2 )
    BinADDRESSc=$(echo $BinADDRESS | cut -d"." -f 3 )
    BinADDRESSd=$(echo $BinADDRESS | cut -d"." -f 4 )

    # transformation en binaire pour faciliter les calculs
    ADDRESSa=$(echo "ibase=2; $BinADDRESSa"|bc)
    ADDRESSb=$(echo "ibase=2; $BinADDRESSb"|bc)
    ADDRESSc=$(echo "ibase=2; $BinADDRESSc"|bc)
    ADDRESSd=$(echo "ibase=2; $BinADDRESSd"|bc)

    # pour l'affichage de l'ip en binaire avec les points
    ADDRESS=$ADDRESSa"."$ADDRESSb"."$ADDRESSc"."$ADDRESSd

fi

#######################################
# MASQUE SOUS RESEAUX
#######################################


if [ $bCase = "1" ] || [ $bCase = "3" ] # cas 1 et 4 : netmask /x
then

    # le masque en notation CIDR est recuperer facilement
    CIDRMASK=$(echo $argument | cut -d"/" -f 2 )

    # a partir du masque on va reconstruire une chaine de bit qui seront codé en decimal
    # 0_____________________________31
    # si i < CIDR alors chaine[i]=1
    # sinon chaine[i]=0
    # Na=cut

    # construction de la chaine de bit
    BinNETMASK=""
    for i in {1..32}
    do
        if [ $i -le $CIDRMASK ]
        then
            BinNETMASK=$BinNETMASK"1"
        else
            BinNETMASK=$BinNETMASK"0"
        fi

        # ne pas oublier de rajouter les points entre les octets
        if [ $(( $i %8 )) -eq 0 ] && [ $i -ne 1 ] && [ $i -ne 32 ]
        then
            BinNETMASK=$BinNETMASK"."
        fi
    done

    # on recupere les different octet
    BinNETMASKa=$(echo $BinNETMASK | cut -d"." -f 1 )
    BinNETMASKb=$(echo $BinNETMASK | cut -d"." -f 2 )
    BinNETMASKc=$(echo $BinNETMASK | cut -d"." -f 3 )
    BinNETMASKd=$(echo $BinNETMASK | cut -d"." -f 4 )

    BinNETMASK=$BinNETMASKa"."$BinNETMASKb"."$BinNETMASKc"."$BinNETMASKd

    # on converti en decimal avec la commande interne bc
    NETMASKa=$(echo "ibase=2; $BinNETMASKa"|bc)
    NETMASKb=$(echo "ibase=2; $BinNETMASKb"|bc)
    NETMASKc=$(echo "ibase=2; $BinNETMASKc"|bc)
    NETMASKd=$(echo "ibase=2; $BinNETMASKd"|bc)

    NETMASK=$NETMASKa"."$NETMASKb"."$NETMASKc"."$NETMASKd

# cas 2 : netmask 255.255.255.0
# cas n°3 : netmask binaire
elif [ $bCase = "2" ]  || [ $bCase = "4" ]
then
    if [ $bCase = "2" ]
    then
        # cas simple, on recupère le masque et on découpe en 4 octet
        NETMASK=$(echo $argument | cut -d"/" -f 2 )
        NETMASKa=$(echo $NETMASK | cut -d"." -f 1 )
        NETMASKb=$(echo $NETMASK | cut -d"." -f 2 )
        NETMASKc=$(echo $NETMASK | cut -d"." -f 3 )
        NETMASKd=$(echo $NETMASK | cut -d"." -f 4 )

        # on transforme en binaire pour faciliter les calculs
        BinNETMASKa=${Dec2Bin[$NETMASKa]}
        BinNETMASKb=${Dec2Bin[$NETMASKb]}
        BinNETMASKc=${Dec2Bin[$NETMASKc]}
        BinNETMASKd=${Dec2Bin[$NETMASKd]}


    elif [ $bCase = "4" ]
    then

        # on transforme en binaire pour faciliter les calculs
        BinNETMASK=$(echo $argument | cut -d"/" -f 2 )
        BinNETMASKa=$(echo $BinNETMASK | cut -d"." -f 1 )
        BinNETMASKb=$(echo $BinNETMASK | cut -d"." -f 2 )
        BinNETMASKc=$(echo $BinNETMASK | cut -d"." -f 3 )
        BinNETMASKd=$(echo $BinNETMASK | cut -d"." -f 4 )

        NETMASKa=$(echo "ibase=2; $BinNETMASKa"|bc)
        NETMASKb=$(echo "ibase=2; $BinNETMASKb"|bc)
        NETMASKc=$(echo "ibase=2; $BinNETMASKc"|bc)
        NETMASKd=$(echo "ibase=2; $BinNETMASKd"|bc)

        NETMASK=$NETMASKa"."$NETMASKb"."$NETMASKc"."$NETMASKd
    fi

    # on concatene pour faire les verifications
    BinNETMASK=$BinNETMASKa""$BinNETMASKb""$BinNETMASKc""$BinNETMASKd

    # verification du masque
    # doit contenir uniquement des 1111 suivis de zero
    if [ ! $(echo $BinNETMASK | grep -E '^[1]*[0]*$' ) ]
    then
        echo "mauvais netmask"
        usage
        exit
    fi

    # comptage du nombre de 1 pour avoir le masque CIDR
    nb1="${BinNETMASK//[0]/}"
    CIDRMASK=${#nb1}

    # pour l'affichage du masque
    BinNETMASK=$BinNETMASKa"."$BinNETMASKb"."$BinNETMASKc"."$BinNETMASKd

fi

#######################################
# MASQUE SOUS RESEAUX INVERSE
#######################################
# sert pour le calcul du broadcast

BinWILDCARD=""

for i in {1..32}
do
    if [ $i -le $CIDRMASK ]
    then
        BinWILDCARD=$BinWILDCARD"0"
    else
        BinWILDCARD=$BinWILDCARD"1"
    fi
    # ne pas oublier de rajouter les points entre les octets
    if [ $(( $i %8 )) -eq 0 ] && [ $i -ne 1 ] && [ $i -ne 32 ]
    then
        BinWILDCARD=$BinWILDCARD"."
    fi
done

BinWILDCARDa=$(echo $BinWILDCARD | cut -d"." -f 1 )
BinWILDCARDb=$(echo $BinWILDCARD | cut -d"." -f 2 )
BinWILDCARDc=$(echo $BinWILDCARD | cut -d"." -f 3 )
BinWILDCARDd=$(echo $BinWILDCARD | cut -d"." -f 4 )

BinWILDCARD=$BinWILDCARDa"."$BinWILDCARDb"."$BinWILDCARDc"."$BinWILDCARDd

# on converti en decimal avec la commande interne bc
WILDCARDa=$(echo "ibase=2; $BinWILDCARDa"|bc)
WILDCARDb=$(echo "ibase=2; $BinWILDCARDb"|bc)
WILDCARDc=$(echo "ibase=2; $BinWILDCARDc"|bc)
WILDCARDd=$(echo "ibase=2; $BinWILDCARDd"|bc)
WILDCARD=$WILDCARDa"."$WILDCARDb"."$WILDCARDc"."$WILDCARDd

#######################################
# ADRESSE RESEAUX
#######################################

# s'obtient en faisant un ET entre l'adresse et le masque sous reseaux
NETWORKa=$(($ADDRESSa & $NETMASKa))
NETWORKb=$(($ADDRESSb & $NETMASKb))
NETWORKc=$(($ADDRESSc & $NETMASKc))
NETWORKd=$(($ADDRESSd & $NETMASKd))
NETWORK=$NETWORKa"."$NETWORKb"."$NETWORKc"."$NETWORKd

BinNETWORKa=${Dec2Bin[$NETWORKa]}
BinNETWORKb=${Dec2Bin[$NETWORKb]}
BinNETWORKc=${Dec2Bin[$NETWORKc]}
BinNETWORKd=${Dec2Bin[$NETWORKd]}
BinNETWORK=$BinNETWORKa"."$BinNETWORKb"."$BinNETWORKc"."$BinNETWORKd

#######################################
# BROAD CAST
#######################################
# s'obtient en faisant un OU entre le masque inverser et l'adresse reseau

BROADCASTa=$(($NETWORKa | $WILDCARDa))
BROADCASTb=$(($NETWORKb | $WILDCARDb))
BROADCASTc=$(($NETWORKc | $WILDCARDc))
BROADCASTd=$(($NETWORKd | $WILDCARDd))
BROADCAST=$BROADCASTa"."$BROADCASTb"."$BROADCASTc"."$BROADCASTd

BinBROADCASTa=${Dec2Bin[$BROADCASTa]}
BinBROADCASTb=${Dec2Bin[$BROADCASTb]}
BinBROADCASTc=${Dec2Bin[$BROADCASTc]}
BinBROADCASTd=${Dec2Bin[$BROADCASTd]}
BinBROADCAST=$BinBROADCASTa"."$BinBROADCASTb"."$BinBROADCASTc"."$BinBROADCASTd

#######################################
# NOMBRE D'HOSTS
#######################################

# on calcul le nombre d'hosts possibles
# nbr d'hote = 2 puissance (32 - le masque en CIDR) - 2 sauf en cas de /31 et /32
if [ $CIDRMASK -gt 30 ] ; then
    HOSTS=$[2**(32-$CIDRMASK)]
else
    HOSTS=$[2**(32-$CIDRMASK)-2]
fi

# nombres d'ip totales
HOSTSTOT=$[2**(32-$CIDRMASK)]


#######################################
# 1ere et last IP du reseau on fait d'abord les calculs
#######################################

#######################################
# 1ere Ip du reseau
#######################################


# on travail sur les valeurs décimales, c'est plus simple
# quand le masque est /31 ou /32 le premier hote et le dernier empiète sur l'adresse réseaux et sur le broadcast et sont même confondues dans le cas du /32
if [ $CIDRMASK -eq 31 ] || [ $CIDRMASK -eq 32 ]
then
    FIRSTIPa=$NETWORKa
    FIRSTIPb=$NETWORKb
    FIRSTIPc=$NETWORKc
    FIRSTIPd=$NETWORKd
else
# pour la première IP on part de l'adresse reseau et on fait +1
    FIRSTIPa=$NETWORKa
    FIRSTIPb=$NETWORKb
    FIRSTIPc=$NETWORKc
    FIRSTIPd=$(($NETWORKd +1))
fi

# on converti en binaire
BinFIRSTIPa=${Dec2Bin[$FIRSTIPa]}
BinFIRSTIPb=${Dec2Bin[$FIRSTIPb]}
BinFIRSTIPc=${Dec2Bin[$FIRSTIPc]}
BinFIRSTIPd=${Dec2Bin[$FIRSTIPd]}

# pour l'affichage
BinFIRSTIP=$BinFIRSTIPa"."$BinFIRSTIPb"."$BinFIRSTIPc"."$BinFIRSTIPd
FIRSTIP=$FIRSTIPa"."$FIRSTIPb"."$FIRSTIPc"."$FIRSTIPd

#######################################
# Dernière Ip du reseau
#######################################


# on travail sur les valeurs décimales, c'est plus simple
# quand le masque est /31 ou /32 le premier hote et le dernier empiète sur l'adresse réseaux et sur le broadcast et sont même confondues dans le cas du /32
if [ $CIDRMASK -eq 31 ] || [ $CIDRMASK -eq 32 ]
then
    LASTIPa=$BROADCASTa
    LASTIPb=$BROADCASTb
    LASTIPc=$BROADCASTc
    LASTIPd=$BROADCASTd
else
# pour la dernière IP on part du broadcast et on fait -1
    LASTIPa=$BROADCASTa
    LASTIPb=$BROADCASTb
    LASTIPc=$BROADCASTc
    LASTIPd=$(($BROADCASTd -1))
fi

# on converti en binaire
BinLASTIPa=${Dec2Bin[$LASTIPa]}
BinLASTIPb=${Dec2Bin[$LASTIPb]}
BinLASTIPc=${Dec2Bin[$LASTIPc]}
BinLASTIPd=${Dec2Bin[$LASTIPd]}

# pour l'affichage
BinLASTIP=$BinLASTIPa"."$BinLASTIPb"."$BinLASTIPc"."$BinLASTIPd
LASTIP=$LASTIPa"."$LASTIPb"."$LASTIPc"."$LASTIPd



#######################################
# Classe du réseau
#######################################
# On regarde les bits les plus à gauche
#   -> 0 classe A
#   -> 10 classe B
#   -> 110 classe C
#   -> 1110 classe D
#   -> 1111 classe E

# merci les expressions régulières
if [ $( echo $BinNETWORK | grep -E '^0' ) ]; then
    CLASS="Class A"
elif [ $( echo $BinNETWORK | grep -E '^10' ) ]; then
    CLASS="Class B"
elif [ $( echo $BinNETWORK | grep -E '^110' ) ]; then
    CLASS="Class C"
elif [ $( echo $BinNETWORK | grep -E '^1110' ) ]; then
    CLASS="Class D"
elif [ $( echo $BinNETWORK | grep -E '^1111' ) ]; then
    CLASS="Class E"
fi

#######################################
# affichage
#######################################

echo ""
echo -e "         Address:" $ADDRESS
echo -e "         Netmask:" $NETMASK
echo -e "        Wildcard:" $WILDCARD
echo -e "         Network:" $NETWORK"/"$CIDRMASK
echo -e "        First IP:" $FIRSTIP
echo -e "         Last IP:" $LASTIP
echo -e "       Broadcast:" $BROADCAST
echo ""
echo -e "  Address Binary:" $BinADDRESS
echo -e "  Netmask Binary:" $BinNETMASK
echo -e " Wildcard Binary:" $BinWILDCARD
echo -e "  Network Binary:" $BinNETWORK
echo -e "        First IP:" $BinFIRSTIP
echo -e "         Last IP:" $BinLASTIP
echo -e "Broadcast Binary:" $BinBROADCAST
echo ""
echo -e "   IP utilisable:" $HOSTS
echo -e "      IP totales:" $HOSTSTOT
echo -e "           Class:" $CLASS
echo ""

exit
