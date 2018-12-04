#!/bin/bash
#Installing Monit on Client 

#server IP parameter
SERV=$1
function installPack() {
#Installing Sendmail and Start Sendmail
yum install wget -y 
yum install syslog -y
yum install sendmail -y
systemctl start sendmail
systemctl enable sendmail

#Instaling Monit And Stress
yum install epel-release -y
yum install monit -y
yum install stress -y
}

function getFile() {
#Getting Client Monit File
cd ~
wget http://10.2.7.244/cMonitrc

#Backing Up Recent Monit File
cp /etc/monitrc /etc/monitrc.BACK

#Copying the Client Monit File Over to /etc/monitrc
mv -f cMonitrc /etc/monitrc
rm -f sMonitrc Server-Monit-Install.sh

#Initiating Monit 
systemctl start monit
#Backing Up rsyslog.conf
cp /etc/rsyslog.conf /etc/rsyslog.conf.BACK
#Modifying rsyslog.conf
sed -i 's/#*.* @@remote-host:514/*.* @'$SERV':514/g' /etc/rsyslog.conf
systemctl restart rsyslog
echo "Monit Configuration Complete!"
}

#Adding port 514 to firewall rules
firewall-cmd --add-port=514/tcp --add-port=514/udp --permanent
firewall-cmd --reload

#Main
installPack
getFile
