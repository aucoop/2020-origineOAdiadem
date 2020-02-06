# Projecte Origen AUCOOP - Open Arms

ConfiguraciÃ³ del desplegament del Projecte Origen a Saint Louis

## Estructura de la xarxa

![network_diagram](/img/network_diagram.png)

## ConnexiÃ³ desde l'exterior via auto-ssh

Referencies:

* [Persistent reverse (NAT bypassing) SSH tunnel access with autossh](https://raymii.org/s/tutorials/Autossh_persistent_tunnels.html)

* [Bypassing corporate firewall with reverse ssh port forwarding](http://toic.org/blog/2009/reverse-ssh-port-forwarding/#.VbdKjWEvBGF)

### Idea general

![reverse-ssh](/img/reverese-ssh.png)

### DisposiciÃ³ de la xarxa a bypassejar

![VPN_diagram](/img/VPN_diagram.png)

### Hosts and key management
Per afegir un nou client SSH cal que el servidor tingui la clau publica del client en el fitxer `authorized_keys`. Despres, el client ha de realitzar la connexio ssh utilitzant com a indentificador la seva clau privada. **Â¿Aixo nomes caldra fer-ho la primera vegada?**

Les ordres per realitzar el proces descrit abans son les seguents:

Client side:

```source
user@client: ssh-keygen -b 4096
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): client.key
Enter passphrase (empty for no passphrase): *leave empty*
Enter same passphrase again: *leave empty*
```

Esta orden crea un par de claves privada y publica. Una vez creadas,copiar la clave pÃºblica al portapapeles mediante `cat client.key.pub`.

Server side:

```bash
user@server: echo "*contenido del portapapeles, es decir, la clave publica del cliente*" >> ~/.ssh/authorized_keys`
```

Client side:
```bash
user@client: ssh -i ~/.ssh/client.key user@X.X.X.X 
```

Donde `client.key` es la clave privada de cliente y `X.X.X.X` es la direccion IP del servidor.

Un cop fet aquest proces, 

### Tunel autossh

Els segÃ¼ents comandos s'executen al server de diadem:

```bash
diadem@diadem: sudo apt-get install autossh ssh
```

```source
diadem@diadem: ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): ~/.ssh/nopwd
Enter passphrase (empty for no passphrase): *leave empty*
Enter same passphrase again: *leave empty*
```

```bash
diadem@diadem: ssh-copy-id -i nopwd.pub -p 22 duniakato@147.83.200.187
```

```bash
diadem@diadem: autossh -M 10984 -o "PubkeyAuthentication=yes" -o "PasswordAuthentication=no" -i /home/diadem/.ssh/nopwd -R 6666:localhost:22 duniakato@147.83.200.187
```

Desde una altra mÃ quina qualsevol, per exemple el mobil connectat a la estaci base (3G/4G):

```bash
ssh -p 22 duniakato@147.83.200.187
```

Ara, dins del servidor a la UPC:

```bash
ssh -p 6666 diadem@127.0.0
```

If all goes well, you should see a prompt to login to the restricted machine. Enter your password and go. If this goes well, you can continue. If this does not work, check the values in the command and the ssh configs. Also make sure you have executed the steps above correctly.