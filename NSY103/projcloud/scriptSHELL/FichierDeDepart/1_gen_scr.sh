#!/bin/bash

#recupère les valeur passé en paramètre du fichier ( $1, $2 et $3) et les stock dans les variables IDomain, UName, sshkeyname
IDomain=$1
UName=$2
sshkeyname=$3


cp  instance.txt  instance_$IDomain.json
cp  master.txt master_$IDomain.json
cp  volume.txt volume_$IDomain.json


sed -i "s/<IdentityDomain>/$IDomain/g" instance_$IDomain.json
sed -i "s/<username>/$UName/g"  instance_$IDomain.json
sed -i "s/<your-ssh-keys>/$sshkeyname/g" instance_$IDomain.json
 
cat instance_$IDomain.json


sed -i "s/<IdentityDomain>/$IDomain/g" master_$IDomain.json
sed -i "s/<username>/$UName/g"  master_$IDomain.json

cat master_$IDomain.json



sed -i "s/<IdentityDomain>/$IDomain/g" volume_$IDomain.json
sed -i "s/<username>/$UName/g"  volume_$IDomain.json

cat volume_$IDomain.json

