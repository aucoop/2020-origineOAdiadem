#!/bin/bash
                                         # Per una execucio no interactiva
                                         # substituir les comandes `read` 
                                         # per els respectius comentaris:   

read -p "Router IP: " IP;                # IP="192.168.33.1"
read -p "Router user: " USR ;            # USR="ubnt" 
read -p "Router password: " -s PSSWD ;   # PSSWD="ubnt"

echo ' ';


/usr/bin/expect << EOF
spawn ssh -oStrictHostKeyChecking=no -oCheckHostIP=no $USR@$IP
expect "password"
send "$PSSWD\n"
expect "#"
send "configure\n"
expect "#"
send "if show firewall | grep 'name INT'; then  delete interfaces ethernet eth0 firewall out; commit; delete firewall name INT ; else  set firewall name INT description 'Toogle internet'; set firewall name INT default-action accept; set firewall name INT rule 20 action accept; set firewall name INT rule 10 action drop; set firewall name INT rule 10 protocol tcp_udp ; set firewall name INT rule 10 destination port 80,8080,8000,443 ; set interfaces ethernet eth0 firewall out name INT; fi\n"
expect "#"
send "commit\n"
expect "#"
send "save\n"
expect "#" 
send "exit\n"
exit
EOF


