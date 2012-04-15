###########################################################################
### CS50 Server
###
### David J. Malan
### malan@cs50.com
############################################################################


############################################################################
## Kickstart Options
############################################################################

autopart
bootloader --append=" crashkernel=auto quiet rhgb selinux=0" --driveorder=sda --location=mbr
clearpart --all
cdrom
firstboot --enable
install
keyboard us
lang en_US.UTF-8
network --hostname dev.localdomain
network --bootproto=dhcp --device=eth0 --noipv6 --onboot=yes
network --bootproto=dhcp --device=eth1 --nodns --noipv6 --onboot=yes
network --bootproto=dhcp --device=eth2 --nodns --noipv6 --onboot=yes
repo --cost=1 --name=os --mirrorlist=http://mirrorlist.centos.org/?arch=x86_64&release=6.2&repo=os
repo --cost=1 --name=updates --mirrorlist=http://mirrorlist.centos.org/?arch=x86_64&release=6.2&repo=updates
#rootpw --plaintext crimson
selinux --disabled
text
timezone --utc Etc/GMT

%packages

@base
@core

%end
