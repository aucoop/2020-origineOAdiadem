# Projecte Origen AUCOOP - Open Arms
Configuració del desplegament del Projecte Origen a Saint Louis

## Estructura de la xarxa

![network_diagram](/img/network_diagram.png)

## Connexió desde l'exterior via auto-ssh

Referencies: 
* [Persistent reverse (NAT bypassing) SSH tunnel access with autossh](https://raymii.org/s/tutorials/Autossh_persistent_tunnels.html)
* [Bypassing corporate firewall with reverse ssh port forwarding ](http://toic.org/blog/2009/reverse-ssh-port-forwarding/#.VbdKjWEvBGF)

### Idea general

![reverse-ssh](/img/reverese-ssh.png)

### Disposició de la xarxa a bypassejar:
![VPN_diagram](/img/VPN_diagram.png)

### Comandos: 

Els següents comandos s'executen al server de diadem:
```bash
diadem@diadem: sudo apt-get install autossh ssh
```
```bash
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

Desde una altra màquina qualsevol, per exemple el mobil connectat a la estació base (3G/4G):
```bash
ssh -p 22 duniakato@147.83.200.187
```

Ara, dins del servidor a la UPC:
```bash
ssh -p 6666 diadem@127.0.0
```

If all goes well, you should see a prompt to login to the restricted machine. Enter your password and go. If this goes well, you can continue. If this does not work, check the values in the command and the ssh configs. Also make sure you have executed the steps above correctly
