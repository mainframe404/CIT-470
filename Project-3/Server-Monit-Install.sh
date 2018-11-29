#!/bin/bash

#SendMail and Monit Are Installed 

echo "\nInstalling The  Sendmail****\n" | tee -a "logfile"
yum install sendmail -y >> logfile

echo "\nStarting The Sendmail****\n" | tee -a "logfile"
systemctl start sendmail >> logfile

echo "\nEnabling The Sendmail****\n" | tee -a "logfile"
systemctl enable sendmail >> logfile



echo "\nInstalling epel-release***\n" | tee -a "logfile"
yum install epel-release -y >> logfile

echo "\nInstalling Stress For The Testing Purpose***\n" >> logfile
yum install stress -y >> logfile

echo "\nInstalling The Monit***\n" | tee -a "logfile"
yum install monit -y >> logfile

echo "\nAttempting To Run Monit***\n" | tee -a "logfile"
monit -h | tee -a "logfile"

firewall-cmd -- zone=public -- add-port=514/udp -–permanent >> logfile
firewall-cmd -- reload >> logfile
firewall-cmd -- list-all >> logfile
