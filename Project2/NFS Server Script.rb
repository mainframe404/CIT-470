#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	exit 1
fi
yum install ruby
#!/usr/bin/ruby
#NFS Server Install Script
`cp -R /home /tmp/oldhome`
def addPart()
	`fdisk /dev/sda`
	`n`
	`p`
	`"\n"`
	`+4096M`
	`w`
	`partprobe /dev/sda`
	`mkfs.xfs /dev/sda4`
	`xfs_repair /dev/sda`
	`mount /dev/sda4 /home`
	`umount /home`
	open('/etc/fstab', 'a') do |f|
		f.puts "/dev/sda4  /home  xfs  defaults 0 0"
	end
	`mount /home`
	`mv -R /tmp/oldhome/* /home`
end
def editExports()
	open('/etc/exports', 'w') do |f|
		f.puts "/home 10.2.6.*(rw)"
	end
end
def nfsSetup()
	`chmod -R 755 /home`
	`yum install nfs-utils`
	`systemctl enable rpcbind`
	`systemctl enable nfs-server`
	`systemctl enable nfs-lock`
	`systemctl enable nfs-idmap`
	`systemctl start rpcbind`
	`systemctl start nfs-server`
	`systemctl start nfs-lock`
	`systemctl start nfs-idmap`
	`exportfs -a`
	`systemctl restart nfs-server`
	`firewall-cmd --zone=public --add-port=2049/tcp --permanent`
	`firewall-cmd --zone=public --add-port=111/tcp --permanent`
	`firewall-cmd --zone=public --add-port=20048/tcp --permanent`
	`firewall-cmd --zone=public --add-port=2049/udp --permanent`
	`firewall-cmd --zone=public --add-port=111/udp --permanent`
	`firewall-cmd --zone=public --add-port=20048/udp --permanent`
	`firewall-cmd --reload`
end
addPart()
editExports()
nfsSetup()
