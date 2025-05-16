# DDP-ehf
KEST2NL05EU LOKAVERKEFNI

!!! EKKI LESA SEM PREVIEW, LESTU SEM CODE !!!

Ég byrjaði á þessu verkefni með UTM, eftir endalaus vandamál er ég hér. (UTM-Report fyrir original skýrsluna) 
Ég mun ekki beint framkvæma verkefnið heldur skrifa skýrslu um hvernig ég myndi leysa verkefnið.
Þar sem ég framkvæmi þetta ekki í raun, gæti uppsetningin verið of einföld og/eða án villuleiðréttinga... þannig þetta líklegast verður ekki 100% rétt.

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

3. Install and configure DHCP on server1, so both clients get IP Addresses, Gateway, DNS IP address and domain name automatically via HDCP.
   3.1 Byrja á að installa DHCP:
      sudo apt install isc-dhcp-server
   3.2 Skoða hvaða netkort þjónar DHCP
      sudo vi /etc/default/isc-dhcp-server
      - Set inn: INTERFACESv4="enp0s1" (Netkort sem er oftast notað í UTM, eða amk í mínu tilfellli..)
   3.3. Stilla DHCP config.
      sudo vi /etc/dhcp/dhcpd.conf
   Set eftirfarandi í skrá:   
         subnet 192.168.100.0 netmask 255.255.255.0 {
           range 192.168.100.50 192.168.100.100;
           option routers 192.168.100.1;
           option domain-name-servers 1.1.1.1, 8.8.8.8;
           option domain-name "ddp.is";
           default-lease-time 600;
           max-lease-time 7200;
         }

      #Þetta config gefur IP bilinu 192.168.100.50–100 og setur gateway, DNS og domain sjálfkrafa með. 
   3.4 Keyra þetta í gang.
      sudo systemctl enable isc-dhcp-server
      sudo systemctl restart isc-dhcp-server   
   3.5 Fara í client1 & client2 og breyta /etc/netplan/01-netcfg.yaml:
      network:
        version: 2
        ethernets:
          enp0s1:
            dhcp4: true
   
      -Keyra svo sudo netplan apply

   3.6 Samantekt...
      server1 er kominn með isc-dhcp-server og gefur IP-tölur á bilinu 192.168.100.50–100,
      með netmask 255.255.255.0, gateway 192.168.100.1, DNS 1.1.1.1 og 8.8.8.8, og domain ddp.is.

4. Install and configure DNS server on server1, so Hostnames are resolved to IP Addresses.
   4.1 Setja upp DNS
      sudo apt install bind9 bind9utils bind9-doc
   4.2 Gera "zone" fyrir ddp.is
      sudo nano /etc/bind/named.conf.local
      - og bæta við neðst:
         zone "ddp.is" {
           type master;
           file "/etc/bind/db.ddp.is";
         };
   4.3 Copya template skrá og breyta aðeins..
      sudo cp /etc/bind/db.local /etc/bind/db.ddp.is
      sudo nano /etc/bind/db.ddp.is
         -Breyta innihaldinu svona:
           $TTL    604800
            @       IN      SOA     server1.ddp.is. root.ddp.is. (
                                          2         ; Serial
                                     604800         ; Refresh
                                      86400         ; Retry
                                    2419200         ; Expire
                                     604800 )       ; Negative Cache TTL
            @       IN      NS      server1.ddp.is.
            server1 IN      A       192.168.100.10
            client1 IN      A       192.168.100.11
            client2 IN      A       192.168.100.12
        
      -Þetta leyfir öllum vélum í netinu að spyrja DNS þjóninn server1 um þessi nöfn og fá réttar IP-tölur. (ATH að innihaldið er örugglega ekki 100% accurate.)
   
   4.4 Restarta DNS
      sudo systemctl restart bind9
   4.5 Láta clients nota server1 sem DNS.
      Fara í dhcpd.conf og breyta:
         option domain-name-servers 192.168.100.10;
      Gera svo:
         sudo systemctl restart isc-dhcp-server
   4.6 Prófun fyrir client1:
      nslookup server1.ddp.is
      nslookup client2.ddp.is
         Vona eftir svarinu:
            Name: server1.ddp.is
            Address: 192.168.100.10
   
5. Create the users accounts using a script, see the Users file.
   5.1 Keyra add_users.sh (getur séð skránna á GitHub): 
      chmod +x add_users.sh
      sudo ./add_users.sh
   
      Checka:
      id AndFri
      getent group Framkvaemdadeild

6. Install and configure MySQL on server1 and create Human Resource database. The database
   stores information about employees, employees are identified by their Kennitala, Firstname,
   Lastname, Email, phone Number, hire date and salary. Employees work in Departments where
   each department has one manager, departments are identified by department ID, department
   name. Each department is in a different location. Locations are identified by their location ID, city,
   Address, and zip code. One or more employees work in different jobs, and the jobs are identified
   by Job ID, job title, Min salary and max salary.

   6.1 Byrja á að setja upp MySQL
      sudo apt update
      sudo apt install -y mysql-server
      sudo mysql_secure_installation (mælt með en ekkert endilega nauðsynlegt fyrir verkefnið..)

   6.2 Keyra human_resource.sql skránna. (Getur séð hana á GitHub.)
         sudo mysql -u root -p #Skipta yfir í MySQL-skel
         SOURCE /full/path/to/human_resource.sql; #loada þessu upp
         SHOW TABLES IN human_resource; #til að staðfesta
   6.3 Dæmi til að prófa fyrir frekari staðfestingu.
      -- Bæta við staðsetningu\INSERT INTO Locations VALUES (1, 'Reykjavík', 'Borgartún 1', '101');

      -- Bæta við starfi
      INSERT INTO Jobs VALUES (100, 'Forritari', 350000.00, 700000.00);
      
      -- Bæta við deild (ákveða manager_id seinna)
      INSERT INTO Departments VALUES (10, 'Tolvudeild', 1, 1010);
      
      -- Bæta við starfsmanni (mætir gagnaskipan)
      INSERT INTO Employees VALUES
      (1010, 'Bjarni Dagur', 'Akason', 'Bdog', 'bda@ddp.is', '777-1000', '2024-05-15', 450000.00, 10, 100);
      
      -- Skoða innihald Employee töflu
      SELECT * FROM Employees;

7. Due to data loss the company policy requires backups weekly, as system engineer you are required
to schedule backups of home directories to run weekly at midnight each Friday.

   7.1 Notum cron jobs í þetta, notum tar til að safna öllu í skrá.
      tar -czf /var/backups/home_backup_$(date +\%F).tar.gz /home
      - sem save-ar allt í t.d. /var/backups/home_backup_2025-05-15.tar.gz
   7.2 Látum keyra þetta alla föstudaga um miðnætti.
      sudo crontab -e
      0 0 * * 5 tar -czf /var/backups/home_backup_$(date +\%F).tar.gz /home

8. Install and configure NTP on server1 and clients, server1 must be master server and client
must synchronize their time with the server.

   8.1 Fer í allar vélar og geri:
      sudo apt install ntp
   8.2 Stilla server1 sem NTP master
      sudo nano /etc/ntp.conf
   8.3 Hætta að nota ytri NTP
      set # fyrir framan línur eins og pool 0.ubuntu.pool.ntp.org iburst
   8.4 Bæta við „local clock“ sem master
      server 127.127.1.0
      fudge 127.127.1.0 stratum 10
   8.5 Restart
      sudo systemctl restart ntp
      sudo systemctl enable ntp
   8.6 Stilla client1 og client2 til að nota server1
      sudo nano /etc/ntp.conf
      server 192.168.100.10 iburst #bæti þessu við
   8.7 Restarta á clients
      sudo systemctl restart ntp
      sudo systemctl enable ntp
   8.8 Prófa/staðfesti tengingu
      ntpq -p #server1 ætti að birtast

9. Install and configure syslog server on server1, server1 should get logs from both the clients for
proactive management and monitoring.

   9.1 Fyrir syslog á server1, opna:
      sudo nano /etc/rsyslog.conf #þetta er pre-installað á Ubuntu.
   9.2 Breyta svo rsyslog getur hlustað á UDP og TCP port 514 (default syslog port).
      #module(load="imudp")
      #input(type="imudp" port="514")
      
      #module(load="imtcp")
      #input(type="imtcp" port="514")
   
      (eina sem ég breyti er að setja # fyrir framan)
   9.3 Bæta við í endan (þetta vistar öll skilaboð frá öðrum vélum í /var/log/remote/nafnvélar.log):
      $template RemoteLogs,"/var/log/remote/%HOSTNAME%.log"
      *.* ?RemoteLogs
   
   9.4 Búa til möppu sem heldur utan um client logs
      sudo mkdir /var/log/remote
   9.5 Restart rsyslog
      sudo systemctl restart rsyslog

   NÆSTA SKREF - Senda logs frá clients til servers.
   9.2.1 Opna;
      sudo nano /etc/rsyslog.conf
      Bæta við neðst til að senda öll logs með UDP á server1 (192.168.100.10):
         *.* @192.168.100.10:514
      Ef ég vildi nota TCP í staðinn þá væri það:
         Ef þú vilt nota TCP í stað UDP:
         *.* @@192.168.100.10:514
   9.2.2 Restarta
      sudo systemctl restart rsyslog
   9.2.3 Testa þetta á server1:
      ls /var/log/remote/
      - Ætti að skila mér:
        client1.log
        client2.log

10. Install and configure Postfix on server1, so users can send and receive emails using Round Cube
open-source software.
   10.1 Fyrir server1:
    sudo apt install postfix
      -Vel Internet Site
       -Nota ddp.is sem mail name (domain)
   10.2 Checka á /etc/postfix/main.cf ef þarf
   10.3 Restart postfix
       sudo systemctl restart postfix
   10.4 RoundCube:
       Þetta command installar Roundcube & Apache samstundis. (með öllum php pökkum)
       sudo apt install apache2 php php-mbstring php-xml php-intl php-mysql php-common php-curl php-zip php-bz2 php-gd php-imagick php-cli php-json php-ldap php-soap php-          sqlite3 roundcube
         - Nota apache2 sem server með dbconfig-common og set svo upp Roundcube með SQLite.
    10.5 Prófun.
       Ætti að virka t.d. http://192.168.100.10/roundcube
       Innskráning: notandi á kerfinu (t.d. user1)
       Netfang: user1@ddp.is
    


    
