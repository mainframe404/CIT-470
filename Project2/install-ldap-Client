#!/bin/bash

#Installing ldap  on virtual machine of  clients 
#To record all the logs
echo "\n***Log file is generated to store all the logs**\n" | tee -a "logfile"
touch logfile

#To install LDAP client packages
echo "\n**nstalling openldap-clients....\n" | tee -a "logfile"
yum install openldap-clients -y >> logfile

#Edit the LDAP conf file and back up it 
echo "\n**Backing up the configuration file of LDAP**\n" | tee -a "logfile"
cp /etc/openldap/ldap.conf /etc/openldap/ldap.conf.backup

echo "\n***Configuring the  LDAP-Client***\n" | tee -a "logfile"

echo "HOST     10.2.7.239:389\nBASE     dc=CIT470_001-Team5_s1,dc=hh,dc=nku,dc=edu\n" > /etc/openldap/ldap.conf
cat /etc/openldap/ldap.conf.backup >> /etc/openldap/ldap.conf

