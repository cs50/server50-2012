###########################################################################
### CS50 Dev VM
###
### David J. Malan
### malan@harvard.edu
############################################################################


############################################################################
## Kickstart Options
############################################################################

autopart
bootloader --append="crashkernel=auto selinux=0" --driveorder=sda --location=mbr
clearpart --all --initlabel
cdrom
install
keyboard us
lang en_US.UTF-8
reboot

repo --cost=1 --name=os --mirrorlist=http://mirrorlist.centos.org/?arch=x86_64&release=6.2&repo=os
repo --cost=1 --name=updates --mirrorlist=http://mirrorlist.centos.org/?arch=x86_64&release=6.2&repo=updates
repo --cost=2 --name=dev50 --baseurl=http://mirror.cs50.com/dev50/0/RPMS/
repo --cost=3 --name=cs50 --baseurl=http://mirror.cs50.net/appliance/3/RPMS/

# http://fedoraproject.org/wiki/EPEL
repo --cost=99 --name=epel --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=x86_64

# https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
#repo --cost=99 --name=nodejs --mirrorlist=http://nodejs.tchol.org/mirrors/nodejs-stable-el6
repo --cost=99 --name=nodejs --baseurl=http://nodejs.tchol.org/stable/el6/x86_64/

# http://blog.famillecollet.com/pages/Config-en
repo --cost=99 --name=remi --mirrorlist=http://rpms.famillecollet.com/enterprise/6/remi/mirror
repo --cost=99 --name=remi-test --mirrorlist=http://rpms.famillecollet.com/enterprise/6/test/mirror

# http://wiki.centos.org/AdditionalResources/Repositories/RPMForge
#repo --cost=99 --name=rpmforge --mirrorlist=http://apt.sw.be/redhat/el6/en/mirrors-rpmforge
repo --cost=99 --name=rpmforge --baseurl=http://apt.sw.be/redhat/el6/en/x86_64/rpmforge

# http://www.webmin.com/rpm.html
repo --cost=99 --name=webmin --mirrorlist=http://download.webmin.com/download/yum/mirrorlist

rootpw --plaintext crimson
selinux --disabled
text
timezone --utc Etc/GMT

%packages

@base
@core

dev50

# unneeded
-at
-cpuspeed
-kexec-tools
-mdadm
-quota
-rng-tools
-smartmontools

%end


############################################################################
## Post-installation Script
############################################################################

%post

# -abrt and -policycoreutils above doesn't work
/usr/bin/yum -y remove abrt policycoreutils

# force developer to change password
/usr/bin/passwd -d root
/usr/bin/chage -d 0 root

# finish configuration after a boot
#/bin/cat > /etc/rc.d/rc.local << "EOF"
##!/bin/bash

# ensure networking has enough time to start
#/bin/sleep 10

# re-install dev50's RPM (to configure MySQL)
#/usr/bin/yum -y reinstall dev50

# only do this once
#/bin/rm -f /etc/rc.d/rc.local
#/usr/bin/poweroff
#EOF
#/bin/chmod 755 /etc/rc.d/rc.local


############################################################################
# clean up
############################################################################

# delete yum's cache
/usr/bin/yum clean all
/usr/bin/yum clean metadata
/bin/rm -rf /var/cache/yum/*

# delete temporary files
/bin/rm -f /root/*
/bin/rm -rf /tmp/.[^.]* && /bin/rm -rf /tmp/..?*

# just in case it exists
/bin/rm -f /etc/udev/rules.d/70-persistent-net.rules

# fill disk with 0s, to facilitate VMDK's compression
/bin/cat /dev/zero > /tmp/zero.fill
/bin/sync
/bin/sleep 1
/bin/sync
/bin/rm -f /tmp/zero.fill

%end
