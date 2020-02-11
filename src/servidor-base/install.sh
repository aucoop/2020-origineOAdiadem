#! /bin/bash

# A COMENTAR...
# ssh... systemctl enable...
# iniciar la interficie amb la configuracio i el docker copose up

#### FUNCIONS
SetDockerRepository() {
         sudo apt-get install -y \
         apt-transport-https \
         ca-certificates \
         curl \
         gnupg-agent \
         software-properties-common

        echo -n "Installing GPG key...  " ; 
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        echo "Verifying that the key with the fingerprint is correctly installed...";

        if (( ! $(sudo apt-key fingerprint 0EBFCD88 2>/dev/null | wc -c) )); then
                echo ""; echo "[-]      Error: Fingerprint not found!"; echo "";
                return 2;
        else 
                echo ""; echo "[+]      Fingerprint found!"; echo "";
        fi
        
        sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
        return 0;
}

### SCRIPT

IP="192.168.33.2"

if [ ! -f "./src/data/dhcpd.conf" ];then
echo "ERROR: Are you in the installation folder?"
exit 1
fi
if [[ -z $(grep "export AUCOOP_DIR=" ~/.bashrc) ]]; then
        echo "export AUCOOP_DIR=`pwd`" >> ~/.bashrc  #Això cal fer-ho abans de començar tot.
else
        #linea=`grep -m1 -n 'AUCOOP_DIR' ~/.bashrc | cut -d: -f1`
        sed -i "s|AUCOOP_DIR=.*|AUCOOP_DIR=`pwd`|" ~/.bashrc
fi
source ./config/config.sh

sudo apt-get update -y
#sudo apt-get upgrade -y

#ssh
sudo apt-get install openssh-server -y
sudo systemctl start ssh.service
#end ssh

#docker
a=$(which docker | grep usr)
if [[ -z $a ]]; then
echo "Installing docker"
        SetDockerRepository;
        if (( $? )); then
                echo "Error installing the docker repositories, exiting...";
        else
                sudo apt-get update -y;
                sudo apt-get install -y docker-ce docker-ce-cli containerd.io
                sudo apt autoremove -y;
        fi
else
echo "Docker already installed"
fi

a=$(which docker-compose | grep usr)
if [[ -z $a ]]; then
        echo "Installing docker-compose"
        sudo curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

fi
#end docker

#python
sudo apt-get install python3 python3-pip -y
sudo pip3 install getch

#dhcp config
IFACE=`ip link show | awk -F: '$0 !~ "lo|vir|docker*|wl|^[^0-9]"{print substr($2,2,length($2)); exit 0}'`

sudo ip link set dev $IFACE up #Iniciem la interface.
## CONFIGURACIÓ DE XARXA PELS UBUNTU

sudo rm -rf /etc/netplan/*
        sudo su -c "echo -e \"network:\n version: 2\n renderer: networkd\n ethernets: \n  ${IFACE}:\n   dhcp4: no\n   dhcp6: no\n   addresses: [${IP}/24]\n   gateway4: 192.168.33.1\n\" > /etc/netplan/01-netcfg.yaml"
        sudo netplan apply
#Estableix el dameon de producció
echo "Starting docker daemon..."
sudo service docker start
sleep 5
echo "Docker daemon started"
#sudo docker-compose up

cd src/

#iniciem docker.
sudo docker-compose pull
sudo docker swarm init
sudo docker stack deploy -c ./docker-compose.yml cccd

echo "SYSTEM IS GOING DOWN FOR REBOOT..."
sleep 5

sudo reboot

