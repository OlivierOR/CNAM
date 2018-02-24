#!/bin/bash

#sudo apt-get install beep

#Dependencies: bash, beep

#from the Gnome Desktop: System → Sound → System Beep → Enable audible beep,
#from a Terminal window: Edit → General → Terminal bell.

#Edit /etc/modprobe.d/blacklist and remove these lines if they exist : (NOTE: You need to edit /etc/modprobe.d/blacklist.conf
#sudo modprobe pcspkr


   # run 'alsamixer'
    #move to PC Beep
  #  press m to unmute
   # set volume
    #press escape

#
#
#
#
#
#
#


echo "  "
echo "Il faut installer avant beep"
echo "  "

echo "  " 
echo -e '\E[1;32m'"\033[1mCONVERSEUR MORSE \033[0m"
echo "  "
echo "Notice d'utilisation: Une mot à chaque entrée, les lettres doivent êtrê séparées par un espace"
echo "  "

read -p "Pause entre les parts des lettres [ms]: " letter_part_pause
read -p "Pause entre les lettres [s]: " letter_pause




		a=(1 100 1 300 0 0 0 0 ".-")
		b=(1 300 3 100 0 0 0 0 "-...")
		c=(1 300 1 100 1 300 1 100 "-.-.")
		d=(1 300 2 100 0 0 0 0 "-..")
		e=(1 100 0 0 0 0 0 0 ".")
		f=(2 100 1 300 1 100 0 0 "..-.")
		g=(2 300 1 100 0 0 0 0 "--.")
		h=(4 100 0 0 0 0 0 0 "....") 
		i=(2 100 0 0 0 0 0 0 "..")
		j=(1 100 3 300 0 0 0 0 ".---")
		k=(1 100 1 300 1 100 0 0 ".-.")
		l=(1 100 1 300 2 100 0 0 ".-..")
		m=(2 300 0 0 0 0 0 0 "--")
		n=(1 300 1 100 0 0 0 0 "-.")
		o=(3 300 0 0 0 0 0 0 "---")
		p=(1 100 2 300 1 100 0 0 ".--.")
		q=(2 300 1 100 1 300 0 0 "--.-")
		r=(1 100 1 300 1 100 0 0 ".-.")
		s=(3 100 0 0 0 0 0 0 "...")
		t=(1 300 0 0 0 0 0 0 "-")
		u=(2 100 1 300 0 0 0 0 "..-")
		v=(3 100 1 300 0 0 0 0 "...-")
		w=(1 100 2 300 0 0 0 0 ".--")
		x=(1 300 2 100 1 300 0 0 "-..-")
	        y=(1 300 1 100 2 300 0 0 "-.--")
		z=(2 300 2 100 0 0 0 0 "--..")
		n1=(1 100 4 300 0 0 0 0 ".----")
		n2=(2 100 3 300 0 0 0 0 "..---")
		n3=(3 100 2 300 0 0 0 0 "...--")
		n4=(4 100 1 300 0 0 0 0 "....-")
		n5=(5 100 0 0 0 0 0 0 ".....")
		n6=(1 300 4 100 0 0 0 0 "-....")
		n7=(2 300 3 100 0 0 0 0 "--...")
		n8=(3 300 2 100 0 0 0 0 "---..")
		n9=(4 300 1 100 0 0 0 0 "----.")
		n0=(5 300 0 0 0 0 0 0 "-----")
		space=""

while true
	do
	
	       read -p "Texte à convertir: " test_in
	       test_in_ARRAY=(`echo $test_in | tr " " "\n"`) 
		
	       for as in ${test_in_ARRAY[@]}
					do 
  					eval 'morse0="${'"$as[0]"'}"' 
  					eval 'morse1="${'"$as[1]"'}"'
  					eval 'morse2="${'"$as[2]"'}"'
					eval 'morse3="${'"$as[3]"'}"'
					eval 'morse4="${'"$as[4]"'}"'
					eval 'morse5="${'"$as[5]"'}"'
					eval 'morse6="${'"$as[6]"'}"'
					eval 'morse7="${'"$as[7]"'}"'
					eval 'morse8="${'"$as[8]"'}"'

						echo "$as $morse8"
						
						beep -r $morse0 -D $letter_part_pause -f 600 -l $morse1 2 > /dev/null 
						beep -r $morse2 -D $letter_part_pause -f 600 -l $morse3 2 > /dev/null 
						beep -r $morse4 -D $letter_part_pause -f 600 -l $morse5 2 > /dev/null 
						beep -r $morse6 -D $letter_part_pause -f 600 -l $morse7 2 > /dev/null 
						sleep $letter_pause
						
		done
done
