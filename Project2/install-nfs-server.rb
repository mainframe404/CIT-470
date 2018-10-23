#!/usr/bin/ruby -w
#NFS Server Install Script
require 'open3'
`sudo cp -R /home /tmp/oldhome`
#Creates and fixes the part for /home
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
        `sudo partprobe /dev/sda`
        `sudo mkfs.xfs -f /dev/sda4`
        `sudo xfs_repair /dev/sda4`
        `sudo mount /dev/sda4 /home`
        `sudo umount /home`
        open('/etc/fstab', 'a') do |f|
                f.puts "/dev/sda4  /home  xfs  defaults 0 0"
        end
        `sudo mount /home`
        `sudo mv /tmp/oldhome/home/* /home`
        puts "End adding partition"
end
#edits the exports file
def editExports()
        puts "start editing exports"
        open('/etc/exports', 'w') do |f|
                f.puts "/home 10.2.6.*(rw)"
        end
        puts "End editing exports"
end
#sets up NFS and change the permisssions
def nfsSetup()
        puts "Start nfs Setup"
        `sudo chmod -R 755 /home`
        puts "Installing nfs-utils"
        `sudo yum -y install nfs-utils`
        puts "install finished"
        puts "enabling nfs"
        `sudo systemctl enable rpcbind`
        `sudo systemctl enable nfs-server`
        `sudo systemctl enable nfs-lock`
`sudo systemctl enable nfs-idmap`
        puts "starting services"
        `sudo systemctl start rpcbind`
        `sudo systemctl start nfs-server`
        `sudo systemctl start nfs-lock`
        `sudo systemctl start nfs-idmap`
        puts "exporting NFS"
        `sudo exportfs -a`
        puts "restarting NFS"
        puts "ending nfs setup"
end
#Edits the firewall to allow NFS and it's services to get through
def editFirewall()
        puts "Editing the firewall"
        `sudo systemctl restart nfs-server`
        `sudo firewall-cmd --zone=public --add-port=2049/tcp --permanent`
        `sudo firewall-cmd --zone=public --add-port=111/tcp --permanent`
        `sudo firewall-cmd --zone=public --add-port=20048/tcp --permanent`
        `sudo firewall-cmd --zone=public --add-port=2049/udp --permanent`
        `sudo firewall-cmd --zone=public --add-port=111/udp --permanent`
        `sudo firewall-cmd --zone=public --add-port=20048/udp --permanent`
        `sudo firewall-cmd --reload`
        puts "firewall edited"
end
addPart()
editExports()
nfsSetup()
editFirewall()
puts "NFS Setup complete"
