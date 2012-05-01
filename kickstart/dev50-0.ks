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

# http://mirror.cs50.com/dev50/0/
repo --cost=2 --name=dev50 --baseurl=http://mirror.cs50.com/dev50/0/RPMS/

# http://mirror.cs50.net/appliance/3/
repo --cost=3 --name=cs50 --baseurl=http://mirror.cs50.net/appliance/3/RPMS/

# http://www.mongodb.org/display/DOCS/CentOS+and+Fedora+Packages
repo --cost=99 --name=10gen --baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64

# http://fedoraproject.org/wiki/EPEL
repo --cost=99 --name=epel --mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=x86_64

# https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
repo --cost=99 --name=nodejs --baseurl=http://nodejs.tchol.org/stable/el6/x86_64/

# http://blog.famillecollet.com/pages/Config-en
repo --cost=99 --name=remi --baseurl=http://rpms.famillecollet.com/enterprise/6/remi/x86_64

# http://wiki.centos.org/AdditionalResources/Repositories/RPMForge
#repo --cost=99 --name=rpmforge --baseurl=http://apt.sw.be/redhat/el6/en/x86_64/rpmforge

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

# lock root
/usr/bin/passwd -l root

# -abrt above doesn't work
/usr/bin/yum -y remove abrt

# updates
/usr/bin/yum -y update

# finish configuration after a boot
/bin/cat > /etc/rc.d/rc.local << "EOF"
#!/bin/bash

# ensure networking has enough time to start
/bin/sleep 10

# re-install dev50 (to configure iptables, which anaconda overwrites)
/usr/bin/yum -y reinstall dev50

# download and mount VMware Tools ISO
/usr/bin/wget --directory-prefix=/tmp http://softwareupdate.vmware.com/cds/vmw-desktop/fusion/4.1.1/536016/packages/com.vmware.fusion.tools.linux.zip.tar
/bin/tar xf /tmp/com.vmware.fusion.tools.linux.zip.tar -C /tmp
/usr/bin/unzip /tmp/com.vmware.fusion.tools.linux.zip -d /tmp
/bin/mount -r -o loop -t iso9660 /tmp/payload/linux.iso /mnt
/bin/tar xf /mnt/VMwareTools-8.8.1-528969.tar.gz -C /tmp
/bin/rm -f /tmp/vmware-tools-distrib/lib/sbin32/vmware-checkvm

# install VMware Tools
/tmp/vmware-tools-distrib/vmware-install.pl -d

# tidy up
/bin/rm -rf /tmp/vmware-tools-distrib
/bin/umount /mnt
/bin/rm -rf /tmp/payload
/bin/rm -f /tmp/com.vmware.fusion.tools.linux.zip
/bin/rm -f /tmp/com.vmware.fusion.tools.linux.zip.tar
;;
esac

# kthxbai
/bin/rm -f /etc/rc.d/rc.local
/bin/rm -f /root/*
/usr/bin/poweroff
EOF
/bin/chmod 0755 /etc/rc.d/rc.local


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
