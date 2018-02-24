from google import google
from googlesearch import search
import os
import sys
import time

liste=[]
argument=""
liste_argument=[]


for arg in sys.argv: 
    #argument =  arg
    liste_argument.append(arg)

del(liste_argument[0])

for a in range(len(liste_argument)):
  argument +=liste_argument[a]+" "
print(argument)
for url in search(str(argument), stop=20):
            liste.append(url)

for i in range(len(liste)):
   var = str(liste[i])
   print(var)
   os.system("firefox --new-tab  "+var)
   #time.sleep(300)
