# DDP-ehf
KEST2NL05EU LOKAVERKEFNI

Byrja á að installa CentOS en það virkar ekki vegna M1 örgjörva og UTM stuðnings. þannig ég nota bara 3 Debian í staðinn (Ubuntu)
Geri 3 Virtual Machine sem heita: server1.ddp.is, client1.ddp.is, client2.ddp.is


Netstillingar.
Breyti Shared Network -> Bridged
ip a sem sýnir mér að netkortið heitir enp0s1
sudo nano /etc/netplan/01-netcfg.yaml
En nano gefur mér villuna command not found... reyni að gera update/upgrade en virkar ekki.

sudo vi /etc/netplan/01-netcfg.yaml virkar, set config1 í skjalið


geri sudo netplan apply en virkar ekki
ip a segir mér svo að enp0s1 er ekki með 192.168.100.10.
Eftir smá tíma næ ég að laga þetta og sudo netplan apply virkar.

Hostname & Domain.
sudo hostnamectl set-hostname server1.ddp.is
sudo vi /etc/hosts
en lendi í villum. ég leiðrétti þær og set 192.168.100.10 server1.ddp.is server1
Reyni að pinga server1.ddp.is en ping er not found?! sudo apt upgrade og sudo apt update gerir ekkert fyrir mig...
Til að checka á overall nettengingu geri geri ég curl google.com en fæ: Could not resolve host: google.com
sudo vi /etc/netplan/01-netcfg.yaml skilar mér:

sudo: unable to resolve host server.ddp.is: Temporary failure in name resolution... okay breyti skránni með config2.


sudo netplan apply skilar mér aftur fullt af WARNINGS... curl google.com skilar ekki ennþá neinu. 
cat /etc/resolv.conf 
nameserver 127.0.0.53 en ekki 1.1.1.1
sudo systemctl restart systemd-resolved
sudo: unable to resolve host server.ddp.is: Temporary failure in name resolution
hostname
server.ddp.is
Ég þarf að breyta þessu í server1.ddp.is sem ég geri, núna virkar t.d sudo echo test




