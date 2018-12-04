#!/bin/bash

#Client Monit Testing

#Testing The Service Monitoring

testType=$1
function ClientTest {

  echo -e "Testing The Client Service Monitoring"
  
  #Kill SSH
  echo -e "Stopping The SSH Process"
  pkill sshd

  #Kill LDAP
  echo -e "Stopping LDAP"
  pkill slapd

  #Kill NFS
  echo -e "Stopping NFS"
  pkill nfs


  #Kill syslog process
  echo -e "Stopping The Syslog Process"
  pkill rsyslog
  echo -e "Testing takes 5 seconds to collect logs. Please wait... "
  sleep 5s
  tail -n 15 /var/log/messages
  echo -e "Monit Sended The  Alerts and Restarted The Services"


  #Test The  RAM, CPU, and Disk Usage
  echo -e "Testing RAM, CPU, and Disk Usage"
  echo -e "Testing takes Few minutes To Collect  The Logs. Please wait..."
  stress -c 8 -d 1 --hdd-bytes 5.5G --vm-bytes $(awk '/MemFree/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1 -t 200s
  sleep 5s
  tail -n 15 /var/log/messages
  echo -e "Test Successfull."
 
  echo -e "Restarting the stopped processes"
}
function ServerTest {

  echo -e "Testing The Server Service Monitoring"

  #Kill SSH
  echo -e "Stopping The SSH Process"
  pkill sshd
  
  #Kill Apache
  echo -e "Stopping The Apache Server "
  pkill httpd

  #Kill LDAP
  echo -e "Stopping LDAP"
  pkill slapd

  #Kill NFS
  echo -e "Stopping NFS"
  pkill nfs

  #Kill syslog process
  echo -e "Stopping The Syslog Process"
  pkill rsyslog
  echo -e "Testing takes 5 seconds to collect logs. Please wait... "
  sleep 5s
  tail -n 15 /var/log/messages
  echo -e "Monit Sended The  Alerts and Restarted The Services"

  #Test The  RAM, CPU, and Disk Usage
  echo -e "Testing RAM, CPU, and Disk Usage"
  echo -e "Testing takes Few minutes To Collect  The Logs. Please wait..."
  stress -c 8 -d 1 --hdd-bytes 5.5G --vm-bytes $(awk '/MemFree/{printf "%d\n", $2 * 0.9;}' < /proc/meminfo)k --vm-keep -m 1 -t 200s
  sleep 5s
  tail -n 15 /var/log/messages
  echo -e "Test Successfull."

  echo -e "Restarting the stopped processes"
}
  if [ $testType  = 'C' ] 
  then  
    ClientTest
  fi

  if [ $testType = 'S' ]
  then
    ServerTest
    /usr/local/apache/bin/apachectl -k start
  fi

  systemctl restart sshd
  systemctl restart rsyslog
  systemctl restart slapd
  systemctl restart nfs
  monit reload
