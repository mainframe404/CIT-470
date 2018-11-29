#!/bin/bash

function killServices() {
printf "\nTesting Server Monitoring Service....\n"

printf "\nKilling sendmail process....\n"
pkill sendmail

#printf "\nKilling SSH process....\n"
#pkill sshd

printf "\nKilling Syslog process....\n"
pkill rsyslog

printf "\nKilling LDAP process....\n"
pkill slapd

printf "\nKilling NFS process....\n"
pkill nfs

printf "\nKilling httpd process....\n"
pkill httpd
}
function testingNow() {
printf "\nTesting takes 90 seconds to collect logs. \nPlease wait....\n"
sleep 90s
tail -n 30 /var/log/messages | tee -a "alerts_services"

printf "\nMonit sent alerts and restarted services....\n"

printf "\nTesting remote services. Changing Firewall Rules....\n"
# 443/tcp 80/tcp 2049/udp 111/udp 20048/udp 389/tcp 20048/tcp 514/udp 2049/tcp 111/tcp 636/tcp
firewall-cmd --zone=public --remove-port=2049/udp --permanent
firewall-cmd --zone=public --remove-port=111/udp --permanent
firewall-cmd --zone=public --remove-port=20048/udp --permanent
firewall-cmd --zone=public --remove-port=389/tcp --permanent
firewall-cmd --zone=public --remove-port=20048/tcp --permanent
firewall-cmd --zone=public --remove-port=2049/tcp --permanent
firewall-cmd --zone=public --remove-port=111/tcp --permanent
firewall-cmd --zone=public --remove-port=636/tcp --permanent
firewall-cmd --reload
}
function fixMe() {
printf "\nPlease wait....\n"
sleep 90s

tail -n 30 /var/log/messages | tee -a "alerts_remote"
printf "\nMonit sent alerts and restarted services....\n"

firewall-cmd --zone=public --add-port=2049/udp --permanent 
firewall-cmd --zone=public --add-port=111/udp --permanent 
firewall-cmd --zone=public --add-port=20048/udp --permanent 
firewall-cmd --zone=public --add-port=389/tcp --permanent 
firewall-cmd --zone=public --add-port=20048/tcp --permanent 
firewall-cmd --zone=public --add-port=2049/tcp --permanent 
firewall-cmd --zone=public --add-port=111/tcp --permanent 
firewall-cmd --zone=public --add-port=636/tcp --permanent
firewall-cmd --reload

tail -n 30 /var/log/messages | tee -a "alerts_remote_solve"
printf "\nMonit sent alerts and restarted services....\n"

#Test CPU, RAM, and Disk Usage   
printf "Testing CPU, RAM, and Disk Usage \n"   
printf "Testing takes four minutes to collect logs. \nPlease wait... \n"   
stress -c 8 -d 1 --hdd-bytes 5.5G --vm-bytes $(awk '/MemFree/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1 -t 200s   
sleep 45s
tail -n 30 /var/log/messages | tee -a "alerts_local"
printf "\nSystem tests succeeded.\n"
}
killServices
testingNow
fixMe
