#!/bin/bash

IDENTITY_DOMAIN=$1
USER=$2
PASSWORD=$3
DC=$4
Zone=$5

cp orch.dat LAB13_orch_api_$1.sh

sed -i "s/<IdentityDomain>/$IDENTITY_DOMAIN/g" LAB13_orch_api_$1.sh
sed -i "s/<username>/$USER/g"  LAB13_orch_api_$1.sh
sed -i "s/<Password>/$PASSWORD/g" LAB13_orch_api_$1.sh
sed -i "s/<zone>/$Zone/g" LAB13_orch_api_$1.sh
sed -i "s/<Datacentre>/$DC/g" LAB13_orch_api_$1.sh

