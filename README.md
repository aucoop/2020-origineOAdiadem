# Projecte Origen AUCOOP - Open Arms

Configuració del desplegament del Projecte Origen a Saint Louis

## Estructura de la xarxa

![network_diagram](/img/network_diagram.png)

## Connexió desde l'exterior via auto-ssh

**Refèrencies:**

* [Persistent reverse (NAT bypassing) SSH tunnel access with autossh](https://raymii.org/s/tutorials/Autossh_persistent_tunnels.html)
* [Bypassing corporate firewall with reverse ssh port forwarding](http://toic.org/blog/2009/reverse-ssh-port-forwarding/#.VbdKjWEvBGF)
* [Conexión a un servidor mediante un tunel inverso ssh](https://openwebinars.net/blog/conexion-servidor-mediante-tunel-inverso-ssh/)

### Idea general

Per tal de tenir accès remot permanent al servidor, s'ha optat per utilitzar el mètode del tunel invers ssh. És un mètode senzill, però eficaç, ja que ha donat resultats amb una xarxa certament complexa com és la d'aquest projecte. Es mostra a continuació un diagrama de la xarxa a bypassejar:

![VPN_diagram](/img/VPN_diagram.png)

Bàsicament, consisteix d'una connexió entre màquines port a port via ssh, amb la característica de que aquesta petició la realitza la màquina a la que volem accedir i no la màquina desde la queal accedirem. Una imatge general que exemplifica aquesta idea:

![reverse-ssh](/img/reverese-ssh.png)

El que farem per conectar-nos al **servidor restrictiu** (servidor al qual no tenim accès), és establir una connexió desde el servidor restrictiu a una tercera màquina que si tenim accès ssh desde l'exterior, és a dir el **servidor de la UPC**. Després utilitzarem aquesta connexió permanent per accedir desde una tercera màquina al servidor restrictiu via el servidor de la UPC. Amb una imatge espero que quedi molt més clar:

![reverse-tuneling](/img/reverse-tuneling.png)


### Implementació: 

#### Provant el tunel autossh

Per implementar el mètode explicat anteriorment es fa ús del programa `autossh`. Desde la [man page](https://linux.die.net/man/1/autossh):

> autossh is a program to start a copy of ssh and monitor it, restarting it as necessary should it die or stop passing traffic.

Bàsicament aixeca un tunel ssh i el manté sempre viu. Una vegada tenim això, cal configurar un daemon que aixequi aquest programa sempre que l'ordinador es reencengui, perdi la connexió, etc. Aquest servei s'ha configurat a través de `systemd`. L'autoaixecament, però s'explica a la secció [Auto-aixecament del tunel ssh](#auto-aixecament-del-tunel-ssh) al final del document.

#### Hands on

Les següents ordres s'executen al server de diadem/duniakato:

Primer, assegurar que està instalat el client `ssh` i el software `autossh`.

```bash
diadem@diadem: sudo apt-get install autossh ssh
```

Ara, es genera el parell de claus a través del programa `ssh-keygen`. Es generarà una clau RSA de 4096 bits sense passphrase per encriptar la clau privada. (Això és simplement per simplicitat, en un futur es podria ~~s'hauria~~ d'encriptar per millorar la seguretat).

```source
diadem@diadem: ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): ~/.ssh/nopwd
Enter passphrase (empty for no passphrase): *leave empty*
Enter same passphrase again: *leave empty*
```

Ara cal afegir la clau pública del client al fitxer `authorized_hosts` del servidor. Hi han dos mètodes per fer-ho:

  * Amb la utilitat `ssh-copy-id` és la forma més senzilla de realitzar aquest procés. Per executar-ho:
  
    ```bash
    diadem@diadem: ssh-copy-id -i nopwd.pub -p 22 duniakato@147.83.200.187
    ```

    Aquesta utilitat, però, no funciona si el servidor no accepta contrasenyes per accedir.
    **Per si tens curiositat**, això és el que fa `ssh-copy-id` under the hood:
  
    ```bash
    scp .ssh/id_rsa.pub user@other-host:
    ssh user@other-host 'cat id_rsa.pub >> .ssh/authorized_keys'
    ssh user@other-host 'rm id_rsa.pub'
    ```

  * Si el servidor no accepta contrasenya per accedir via ssh, simplement s'ha de copiar la clau pública del client al        fitxer `authorized_keys` del servidor. Per fer-ho, cal accedir desde una màquina que ja tingui accés al servidor i copiar la  clau pública del client desitjat en una línia al final del fitxer `authorized_keys`.
  
    ```bash
    user@server: echo "*contenido del portapapeles, es decir, la clave publica del cliente*" >> ~/.ssh/authorized_keys`
    ```

Ara, per establir el primer tunel utilitzem el programa autossh.

```bash
diadem@diadem: autossh -M 10984 -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -i /home/diadem/.ssh/nopwd -R 6666:localhost:22 aucoop@147.83.200.187
```

Desde una altra màquina qualsevol, per exemple el mòbil connectat a la estació base (3G/4G):

```bash
ssh -p 22 aucoop@147.83.200.187
```

Ara, dins del servidor a la UPC:

```bash
ssh -p 6666 diadem@127.0.0
```

Si tot va bé, hauries de veure un prompt per fer login a diadem/duniakato. Entra la password i endavant. Si això no funciona, revisa els valors de l'ordre i la configuració del ssh. També assegura't de que tots els passos s'han executat correctament.

#### Gestió de hosts i claus

Per afegir un nou client SSH cal que el **servidor** tingui la clau pública del **client** en el fitxer `authorized_keys`. Despres, el **client** ha de realitzar la connexio ssh utilitzant com a indentificador la seva clau privada.

Les ordres per realitzar el proces descrit abans son les seguents:

* Client side:

```source
user@client: ssh-keygen -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): client.key
Enter passphrase (empty for no passphrase): *leave empty*
Enter same passphrase again: *leave empty*
```

Aquesta ordre crea un parell de claus pública i privada. Un cop creades, cal copiar la **clau pública del client** i enganxarla al fitxer `authorized_keys` del servidor.

* Server side:

```bash
user@server: echo "*contenido del portapapeles, es decir, la clave publica del cliente*" >> ~/.ssh/authorized_keys`
```

* Client side:

```bash
user@client: ssh -i ~/.ssh/client.key user@X.X.X.X 
```

On `client.key` és la clau privada del client i `X.X.X.X` és l'adressa IP del servidor.

Un cop fet aquest procés, el client ja estarà en la llista de hosts autoritzats.

#### Auto-aixecament del tunel ssh

A continuació es mostren els passos a seguir:

```bash
sudo nano /etc/systemd/system/autossh-tunel.service
```

Afegir aquest contingut al unit file:

```source
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
ExecStart=/usr/bin/autossh -M 10988 -N -o "ExitOnForwardFailure=yes" -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -i /home/konte/.ssh/konte.key -R 6666:localhost:22 aucoop@147.83.200.187

# Restart every >2 seconds to avoid StartLimitInterval failure
RestartSec=5
Restart=always

[Install]
WantedBy=multi-user.target
```

Cal prestar atenció a aquesta línia:

```source
ExecStart=/usr/bin/autossh -M 10988 -N -o "ExitOnForwardFailure=yes" -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -i /home/username/.ssh/restricted_server_private.key -R 6666:localhost:22 aucoop@147.83.200.187
```

* `username` és el nom del usuari de la màquina restringida a la qual es vol tenir accés.
* `restricted_server_private.key` clau privada del servidor al qual es vol tenir accés.
