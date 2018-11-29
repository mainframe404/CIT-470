#!/bin/bash

#Client Monit Testing

#Testing The Service Monitoring

echo-e "\nTesting The Service Monitoring. \n"

  #Kill sendmail process
  echo -e "Stopping The Sendmail process. \n"
  pkill sendmail
  
  #Kill SSH
  echo -e "Stopping The  SSH Process. \n"
  pkill sshd

  #Kill syslog process
  echo -e "Stopping The Syslog Process. \n"
  pkill rsyslog
  echo -e "Testing takes 30 seconds to collect logs. \nPlease wait... \n"
  sleep 30s
  tail -n 15 /var/log/messages
  echo -e "\nMonit Sended The  Alerts and Restarted The Services. \n"

#Test The  RAM, CPU, and Disk Usage
  echo -e "Testing RAM, CPU, and Disk Usage \n"
  echo -e "Testing takes Few minutes To Collect  The Logs. \nPlease wait... \n"
  #stress -c 8 -d 1 --hdd-bytes 5.5G --vm-bytes $(awk '/MemFree/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1 -t 200s
  sleep 30s
  tail -n 15 /var/log/messages
  echo -e "\n Test Successfull."