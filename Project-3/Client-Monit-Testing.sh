#!/bin/bash
#Client Monit Testing
#Testing The Service Monitoring

echo "Testing The Service Monitoring."

  #Kill sendmail process
  echo "Stopping The Sendmail process."
  pkill sendmail
  
  #Kill SSH
  echo "Stopping The SSH process."
  pkill sshd

  #Kill syslog process
  echo "Stopping the Syslog process."
  pkill rsyslog
  echo "Testing takes 30 seconds to collect logs. Please wait..."
  sleep 30s
  tail -n 15 /var/log/messages
  echo "Monit sent the alerts and restarted the services."

#Test The  RAM, CPU, and Disk Usage
  echo "Testing RAM, CPU, and Disk Usage"
  echo "Testing takes few minutes to collect the logs. Please wait..."
  stress -c 8 -d 1 --hdd-bytes 5.5G --vm-bytes $(awk '/MemFree/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1 -t 200s
  sleep 30s
  tail -n 15 /var/log/messages
  echo "Test Successful."
