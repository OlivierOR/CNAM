#!/bin/sh

HOST='ftp://192.168.2.246'
USER='transfert'
PASSWD='passwrd'
DATE=$(date)

cd /var/PDF/
for FICTI in $(ls TI* -R)
do
	if [ -f $FICTI ];
	then
	ftp -n -i -v $HOST <<EOF
user $USER $PASSWD
put $FICTI ./OUTPUT/TI/$FICTI
EOF
	mv $FICTI /var/PDF/archives
	cat '$FICTI' >> /var/PDF/${DATE} +%Y-%M-%d.txt
	fi
done

for FICTE in $(ls PE* -R)
do
	if [ -f $FICTE ];
	then
	ftp -n -i -v $HOST <<EOF
user $USER $PASSWD
put $FICTE ./OUTPUT/TE/$FICTE
EOF
	mv $FICTE /var/PDF/archives
	cat '$FICTE' >> /var/PDF/${DATE} +%Y-%M-%d.txt
	fi
done

for FICZZ in $(ls ZZ* -R)
do
	if [ -f $FICZZ ];
	then
	ftp -n -i -v $HOST <<EOF
user $USER $PASSWD
put $FICZZ ./OUTPUT/ZZ/$FICZZ
EOF
	mv $FICZZ /var/PDF/archives
	cat '$FICZZ' >> /var/PDF/${DATE} +%Y-%M-%d.txt
	fi
done

echo "PDF transférés et déplacés. Fichier du jour créé"


