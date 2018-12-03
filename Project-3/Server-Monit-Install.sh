#!/bin/bash

#SendMail and Monit Are Installed 

echo "Installing The  Sendmail" | tee -a "logfile"
yum install sendmail -y >> logfile

echo "Starting The Sendmail" | tee -a "logfile"
systemctl start sendmail >> logfile

echo "Enabling The Sendmail" | tee -a "logfile"
systemctl enable sendmail >> logfile

echo "Installing epel-release" | tee -a "logfile"
yum install epel-release -y >> logfile

echo "Installing Stress For The Testing Purpose" >> logfile
yum install stress -y >> logfile

echo "Installing The Monit" | tee -a "logfile"
yum install monit -y >> logfile

echo "Attempting To Run Monit" | tee -a "logfile"
monit -h | tee -a "logfile"

firewall-cmd --zone=public --add-port=514/udp --permanent >> logfile
firewall-cmd --reload >> logfile
firewall-cmd --list-all >> logfile
