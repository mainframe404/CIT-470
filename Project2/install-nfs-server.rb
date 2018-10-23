#!/usr/bin/ruby -w
#NFS Server Install Script
require 'open3'
`sudo cp -R /home /tmp/oldhome >> logfile.log`
def addPart()
        puts "start Adding partition"
        Open3.popen2('sudo fdisk /dev/sda') { |i,o,t|
                i.puts 'n'
                i.puts 'p'
                i.puts ''
                i.puts '+4096M'
                i.puts 'w'
                i.close
                p o.read
                t.join
        }
        `sudo partprobe /dev/sda >> logfile.log`
        `sudo mkfs.xfs -f /dev/sda4 >> logfile.log`
        `sudo xfs_repair /dev/sda4 >> logfile.log`
        `sudo mount /dev/sda4 /home >> logfile.log`
        `sudo umount /home >> logfile.log`
        open('/etc/fstab', 'a') do |f|
                f.puts "/dev/sda4  /home  xfs  defaults 0 0"
        end
        `sudo mount /home >> logfile.log`
        `sudo mv /tmp/oldhome/home/* /home >> logfile.log`
        puts "End adding partition"
end
def editExports()
        puts "start editing exports"
        open('/etc/exports', 'w') do |f|
                f.puts "/home 10.2.6.*(rw)"
        end
        puts "End editing exports >> logfile.log"
end
def nfsSetup()
        puts "Start nfs Setup"
        `sudo chmod -R 755 /home >> logfile.log`
        puts "Installing nfs-utils"
        `sudo yum -y install nfs-utils >> logfile.log`
        puts "install finished"
        puts "enabling nfs"
        `sudo systemctl enable rpcbind >> logfile.log`
        `sudo systemctl enable nfs-server >> logfile.log`
        `sudo systemctl enable nfs-lock >> logfile.log`
        `sudo systemctl enable nfs-idmap >> logfile.log`
        puts "starting services"
        `sudo systemctl start rpcbind >> logfile.log`
        `sudo systemctl start nfs-server >> logfile.log`
        `sudo systemctl start nfs-lock >> logfile.log`
        `sudo systemctl start nfs-idmap >> logfile.log`
        puts "exporting NFS"
        `sudo exportfs -a >> logfile.log`
        puts "restarting NFS"
        puts "ending nfs setup"
end
def editFirewall()
        puts "Editing the firewall"
        `sudo systemctl restart nfs-server >> logfile.log`
        `sudo firewall-cmd --zone=public --add-port=2049/tcp --permanent >> logfile.log`
        `sudo firewall-cmd --zone=public --add-port=111/tcp --permanent >> logfile.log`
        `sudo firewall-cmd --zone=public --add-port=20048/tcp --permanent >> logfile.log`
        `sudo firewall-cmd --zone=public --add-port=2049/udp --permanent >> logfile.log`
        `sudo firewall-cmd --zone=public --add-port=111/udp --permanent >> logfile.log`
        `sudo firewall-cmd --zone=public --add-port=20048/udp --permanent >> logfile.log`
        `sudo firewall-cmd --reload >> logfile.log`
	puts "firewall edited"
end
addPart()
editExports()
nfsSetup()
editFirewall()
puts "NFS Setup complete"
