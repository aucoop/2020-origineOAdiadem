

## Estructura de la xarxa

TODO revisar xarxa

![network_diagram](/docs/img/network_diagram.png)

## Connexió desde l'exterior via auto-ssh

### Idea general
TODO
Per veure com s'implementa un tunel autossh consultar XXXXX

Per tal de tenir accès remot permanent al servidor, s'ha optat per utilitzar el mètode del tunel invers ssh. És un mètode senzill, però eficaç, ja que ha donat resultats amb una xarxa certament complexa com és la d'aquest projecte. Es mostra a continuació un diagrama de la xarxa a bypassejar:

![VPN_diagram](/docs/img/VPN_diagram.png)

Bàsicament, consisteix d'una connexió entre màquines port a port via ssh, amb la característica de que aquesta petició la realitza la màquina a la que volem accedir i no la màquina desde la queal accedirem. Una imatge general que exemplifica aquesta idea:

![reverse-ssh](/docs/img/reverese-ssh.png)

El que farem per conectar-nos al **servidor restrictiu** (servidor al qual no tenim accès), és establir una connexió desde el servidor restrictiu a una tercera màquina que si tenim accès ssh desde l'exterior, és a dir el **servidor de la UPC**. Després utilitzarem aquesta connexió permanent per accedir desde una tercera màquina al servidor restrictiu via el servidor de la UPC. Amb una imatge espero que quedi molt més clar:

TODO actualitzar diagrama amb la IP de backup

![reverse-tuneling](/docs/img/reverse-tuneling.png)


#### Connexió remota via reverse-tunneling i autossh

Per realitzar la connexió ssh al servidor desde qualsevol lloc. Cal executar les següents comandes.

```bash
ssh aucoop@147.83.200.148 -i private_key.key
```

Com es pot veure, perquè un client es connecti al servidor d'AUCOOP, aquest ha de tenir guardada la clau pública del client. Si no és el cas, cal posar-se en contacte amb algun dels administradors del servidor d'AUCOOP, ja que només es permet autenticació SSH via intercanvi de claus (no per contrasenya).

Un cop dins del servidor d'aucoop, cal accedir al servidor de Fatim Konte via reverse-tunneling:

```bash
aucoop@localhost:~$ ssh -p 5555 konte@localhost
```

Si el tunel està actiu, haura de sortir un prompt per escriure la contrasenya:

```source
konte@localhost's password:
```
### Configuració del daemon

TODO
Per configurar el autoaixecament del tunel, consultar xxxxxxx

S'ha configurat un daemon que activa sempre el servei del reverse-tunneling després de que l'ordinador s'encengui.

A continuació es mostra el Unit file del servidor de Fatim Konte.

```bash
[Unit]

Description=AutoSSH tunnel service 
Documentation=https://github.com/aucoop/origineOAdiadem/

# This will ensure that all configured network devices are up and have an IP address assigned before the
# service is started. network-online.target will time out after 90s.
# Enabling this might considerably delay your boot even if the timeout is not reached.
After=network-online.target ssh.service
Wants=network-online.target

[Service]

# autossh is a program to start a copy of ssh and monitor it, restarting it as necessary should it die or stop passing traffic.
# Man page: https://linux.die.net/man/1/autossh
# Flags:
# * AUTOSSH_GATETIME=0 Equivale a el flag -f
# * -M : specifies the base monitoring port to use
# * -N : Just establish the tunnel, no command input (no interactive).
# * -o "ExitOnForwardFailure=yes" : f the client cuts the connection to the server (like power goes off), the port may still be considered in use on the server.
# * -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no": Force key exchange authentication, avoiding password auth.
Environment="AUTOSSH_GATETIME=0"
ExecStart=/usr/bin/autossh -M 20000 -N -o "ExitOnForwardFailure=yes" -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -i /home/konte/.ssh/konte_server.key -R 5555:localhost:22 aucoop@147.83.200.148

# Restart every >2 seconds to avoid StartLimitInterval failure
RestartSec=30
Restart=always
User=konte
[Install]
WantedBy=multi-user.target
```

Per tal de que el tunel sigui més robust i estigui viu la major part del temps possible, hi ha un reboot del servidor programat cada dia a les 19:00 h. Aquest reboot està programat a través de la utilitat de Unix cron:

```bash
konte@konte:~$ crontab -l

# m h  dom mon dow   command
0 19  *   *   *    /sbin/shutdown -r 0
```