echo "[!] Début de l'installation ..."
sudo apt install  python-pip
unzip  Google-Search-API-master.zip
cd Google-Search-API-master/
pip install -r requirements.txt 
pip install google
sudo python setup.py install 
#pip install Google-Search-API
#pip install Google-Search-API --upgrade

pip install urllib3
pip install bs4

echo "Fin de l'installation..."
