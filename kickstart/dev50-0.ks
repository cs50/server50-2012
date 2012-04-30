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
repo --cost=99 --name=remi-test --baseurl=http://rpms.famillecollet.com/enterprise/6/test/x86_64

# http://wiki.centos.org/AdditionalResources/Repositories/RPMForge
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

# lock root
/usr/bin/passwd -l root


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
