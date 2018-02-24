import urllib3
import os
from bs4 import BeautifulSoup
import sys
import time
http = urllib3.PoolManager()
liste=[]
argument=""
liste_argument=[]

for arg in sys.argv: 
    #argument =  arg
    liste_argument.append(arg)

del(liste_argument[0])

for a in range(len(liste_argument)):
  argument +=liste_argument[a]+"+"
print(argument)
query = str(argument)
r = http.request('GET', 'https://www.youtube.com/results?search_query='+query)

html = r.data
soup = BeautifulSoup(html,'html.parser')
for vid in soup.findAll(attrs={'class':'yt-uix-tile-link'}):
  liste.append('https://www.youtube.com' + vid['href'])
   #print 'https://www.youtube.com' + vid['href']

for i in range(len(liste)):
   var = str(liste[i])
   print(var)
   os.system("firefox --new-tab  "+var)
   #time.sleep(5000)
