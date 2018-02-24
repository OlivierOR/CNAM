#!/bin/bash
cd questions
for i in `ls`
do
sed -i -e "s/#BonneReponseQ:.*/#BonneReponseQ:0/g" $i
sed -i -e "s/#MauvaiseReponseQ:.*/#MauvaiseReponseQ:0/g" $i
done
