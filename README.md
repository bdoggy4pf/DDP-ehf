# DDP-ehf
KEST2NL05EU LOKAVERKEFNI

!!! EKKI LESA SEM PREVIEW, LESTU SEM CODE !!!

Ég byrjaði á þessu verkefni með UTM, eftir endalaus vandamál er ég hér. (UTM-Report fyrir original skýrsluna) 
Ég mun ekki beint framkvæma verkefnið heldur skrifa skýrslu um hvernig ég myndi leysa verkefnið, þar sem ég get ekki beint sannreynt það.
Þetta verður flókið að gera og kannski aðeins of straight-forward því ég fæ ekki villur.. þannig þetta líklegast verður ekki 100% rétt.

#VERKEFNISLÝSING
As a Linus Engineer working with DDP ehf company, you are required to install and configure a new Linux
server (server1) for centralized proactive management and access. Two Linux clients, client1 running Debian
distro, and client2 running RedHat distribution (CentOS Stream 9). DDP has 30 employees that work in four
different departments as shown in the Users file.

1. Install and configure the server1, client1 and client2 with hostnames and domain as ddp.is
   
  1.1 Opna UTM / VirtualBox / VMWare og búa til Virtual Machine sem heitir server1
  1.2 Breyta Netkorti í Bridged (Advanced) (Gæti heitið annað á Vbox/VMWare)
  1.2 Clone-a VM 2x og skýra: client1, client2
  1.3 Fara í hvert einasta VM og skrifa í terminal:
    sudo hostnamectl set-hostname server1.ddp.is (fyrir server1)
    sudo hostnamectl set-hostname client1.ddp.is (fyrir client1)
    sudo hostnamectl set-hostname client2.ddp.is (fyrir client2)
    
  1.4 Fara í hvert einasta VM og skrifa í terminal:
    sudo vi /etc/hosts 
      Fyrir server1:
        127.0.0.1       localhost
        127.0.1.1       server1.ddp.is server1
        192.168.100.11  client1.ddp.is client1
        192.168.100.12  client2.ddp.is client2
      Fyrir client1:
        127.0.0.1       localhost
        127.0.1.1       client1.ddp.is client1
        192.168.100.10  server1.ddp.is server1
        192.168.100.12  client2.ddp.is client2
      Fyrir client2
        127.0.0.1       localhost
        127.0.1.1       client2.ddp.is client2
        192.168.100.10  server1.ddp.is server1
        192.168.100.11  client1.ddp.is client1
        
  1.5 Fyrir hvert einasta VM myndi ég svo gera:
        sudo reboot (reboot til að hostname virki alls staðar)
      Myndi svo gera:
        hostname
        hostname -f
      Sem ætti að skila t.d. fyrir server1:
        server1.ddp.is
      Sem að staðfestir að Hostname er breytt. 


2. Configure server1 with static IP Address, from the IP Address block 192.168.100.0/24. The server must be configured with the 10th usable IP Address.
   2.1 Skrifa í terminal
         sudo vi /etc/netplan/01-netcfg.yaml
      Set inn eftirfarandi í skrá:
            network:
              version: 2
              ethernets:
                enp0s1:
                  addresses:
                    - 192.168.100.10/24 # þetta er static IP með subnet mask /24 (sem er 255.255.255.0)

   2.2 Gera í terminal:
         sudo netplan apply
         ip a
      Þetta ætti að sýna mer:
         192.168.100.10/24 & 192.168.100.255
      og svo í framhaldi myndi ég prófa ping / curl til að staðfesta...
   

    
