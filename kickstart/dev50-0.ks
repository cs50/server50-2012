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
bootloader --append="crashkernel=auto noquiet selinux=0" --driveorder=sda --location=mbr
clearpart --all
cdrom

# TODO (doesn't work as intended)
firewall --enable --port=22:tcp,80:tcp,443:tcp --trust=eth1

install
keyboard us
lang en_US.UTF-8
network --hostname dev.localdomain

# move to files (DNS binds to eth1 and hardcodes MACs)
network --bootproto=dhcp --device=eth0 --noipv6 --onboot=yes
network --bootproto=dhcp --device=eth1 --nodns --noipv6 --onboot=yes
network --bootproto=dhcp --device=eth2 --nodns --noipv6 --onboot=no

repo --cost=1 --name=os --mirrorlist=http://mirrorlist.centos.org/?arch=x86_64&release=6.2&repo=os
repo --cost=1 --name=updates --mirrorlist=http://mirrorlist.centos.org/?arch=x86_64&release=6.2&repo=updates
repo --cost=2 --name=cs50 --baseurl=http://mirror.cs50.com/appliance/1/RPMS/

# http://fedoraproject.org/wiki/EPEL
repo --cost=3 --name=epel --baseurl=http://download.fedoraproject.org/pub/epel/6/x86_64/

# https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
repo --cost=3 --name=nodejs --baseurl=http://nodejs.tchol.org/stable/el6/x86_64/

rootpw --plaintext crimson
selinux --disabled
services --enabled httpd,iptables,memcached,mysqld,ntpd,ntpdate,sshd,udev-post
services --disabled ip6tables,netconsole,netfs,postfix,psacct,rdisc,saslauthd
text
timezone --utc Etc/GMT

%packages

@base
@core

#ack

# http://fedoraproject.org/wiki/EPEL
epel-release
ack
clang

gcc
gcc-c++
gdb
httpd
make
memcached
mysql
mysql-server

# https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
#nodejs-stable-release-6-2
nodejs-stable-release
nodejs-compat-symlinks
npm

perl
php
php-mysql
php-pdo
php-pecl-memcache
php-pecl-solr
php-pecl-xdebug
php-PHPMailer
php-phpunit-DbUnit
php-phpunit-PHPUnit
php-tidy
php-xml
python
#redis
ruby
ruby-devel
valgrind
vim

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
/usr/bin/chage -d 0 root

/bin/cat > /sbin/ifup-local << "EOF"
#!/bin/bash

# header
/bin/echo "This is CS50 Dev VM 0." > /etc/issue
/bin/echo >> /etc/issue

# eth1
declare eth1=$(/sbin/ifconfig eth1 | /bin/grep 'inet addr:' | /bin/cut -d: -f2 | /bin/awk '{print $1}')
if [ "$eth1" != "" ]; then
    /bin/echo "eth1: $eth1" >> /etc/issue
fi

# eth2
declare eth2=$(/sbin/ifconfig eth2 | /bin/grep 'inet addr:' | /bin/cut -d: -f2 | /bin/awk '{print $1}')
if [ "$eth2" != "" ]; then
    /bin/echo "eth2: $eth2" >> /etc/issue
fi

# footer
/bin/echo >> /etc/issue
EOF
/bin/chmod 0755 /sbin/ifup-local


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
