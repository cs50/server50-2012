###########################################################################
Summary: Configures the CS50 dev VM.
Name: dev50
Version: 0
Release: 1 
License: CC BY-NC-SA 3.0
Group: System Environment/Base
Vendor: CS50
BuildArch: x86_64
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
Requires: centos-release = 6-2.el6.centos.7
Requires: bc

# gcov, gprof
Requires: binutils

Requires: bind-utils

Requires: coreutils 

Requires: cs50-library-c
Requires: cs50-library-php
Requires: ctags
Requires: diffutils
Requires: dkms
Requires: emacs
Requires: ftp
Requires: gcc
Requires: gdb
Requires: git
Requires: httpd
Requires: indent
Requires: iptables

# http://www.oracle.com/technetwork/java/javase/downloads/
Requires: jdk
Requires: jre

Requires: kernel
Requires: kernel-devel
Requires: kernel-headers
Requires: lynx
Requires: make
Requires: man
Requires: man-pages
Requires: mercurial
Requires: mlocate
Requires: mod_suphp
Requires: mysql
Requires: mysql-server
Requires: nano
Requires: ncftp

# -lncurses
Requires: ncurses
Requires: ncurses-devel

Requires: ntp
Requires: openssh-clients
Requires: openssh-server
Requires: patch

Requires: php
Requires: php-devel
Requires: php-mysql
Requires: php-pear
Requires: php-pecl-xdebug
Requires: php-PHPMailer
Requires: php-tidy
Requires: php-xml
Requires: phpMyAdmin
Requires: python
Requires: redhat-rpm-config
Requires: render50
Requires: rpm 
Requires: rpm-build
Requires: rsnapshot
Requires: rsync
Requires: ruby
Requires: rubygems
Requires: screen
Requires: sed
Requires: setup
Requires: shadow-utils
Requires: sudo
Requires: system-config-firewall-tui
Requires: system-config-network-tui
Requires: telnet
Requires: tidy
Requires: traceroute
Requires: tree
Requires: valgrind
Requires: vim
Requires: webmin
Requires: wget
Requires: words
Requires: yum-plugin-fastestmirror
Requires: yum-plugin-priorities
Requires: yum-plugin-protectbase
Requires: yum-utils

Requires(post): coreutils 
Requires(post): mlocate
Requires(post): mysql
Requires(post): mysql-server
Requires(post): php-pear
Requires(post): rpm 
Requires(post): rsync
Requires(post): sed
Requires(post): shadow-utils
Requires(post): yum-utils


############################################################################
%description
This is CS50.


############################################################################
%prep
/bin/rm -rf %{_builddir}/%{name}-%{version}-%{release}/
/bin/cp -a %{_sourcedir}/%{name}-%{version}-%{release} %{_builddir}/


############################################################################
%install
/bin/rm -rf %{buildroot}
/bin/mkdir -p %{buildroot}/tmp/
/bin/cp -a %{_builddir}/%{name}-%{version}-%{release} %{buildroot}/tmp/


############################################################################
%clean
/bin/rm -rf %{buildroot}


############################################################################
%post

# /tmp/%{name}-%{version}-%{release}
declare tmp=/tmp/%{name}-%{version}-%{release}

# remove deprecated directories and files
declare -a deprecated=()
for dst in "${deprecated[@]}"
do
    if [ -e $dst.lock ]
    then
        echo "   Did not remove $dst because of lockfile."
    else
        /bin/rm -rf $dst
        echo "   Removed $dst."
    fi
done

# install directories
for src in $(/bin/find $tmp -mindepth 1 -type d | /bin/sort)
do
    declare dst=${src#$tmp}
    declare dir=$(/usr/bin/dirname $dst)
    declare base=$(/bin/basename $dst)
    if [ -e $dir/$base.lock ] || [ -e $dir/.$base.lock ]
    then
        echo "   Did not install $dst because of lockfile."
    else
        /usr/bin/rsync --devices --dirs --links --perms --quiet --specials --times $src $dir > /dev/null 2>&1
        echo "   Installed $dst."
    fi
done

# install files
for src in $(/bin/find $tmp ! -type d | /bin/sort)
do
    declare dst=${src#$tmp}
    declare dir=$(/usr/bin/dirname $dst)
    declare base=$(/bin/basename $dst)
    if [ -e $dir/$base.lock ] || [ -e $dir/.$base.lock ]
    then
        echo "   Did not install $dst because of lockfile."
    else
        if [ -e $dst ] && ! /usr/bin/cmp -s $src $dst
        then
            /bin/mv $dst $dst.rpmsave
        fi
        /usr/bin/rsync --devices --links --perms --quiet --specials --times $src $dst > /dev/null 2>&1
        echo "   Installed $dst."
    fi
done

# /boot/grub2/grub.cfg
#/bin/sed -i -e 's/^GRUB_TIMEOUT=.*$/GRUB_TIMEOUT=2/' /etc/default/grub
#/sbin/grub2-mkconfig -o /boot/grub2/grub.cfg > /dev/null 2>&1

# /etc/passwd
/usr/sbin/adduser --comment "John Harvard" --gid apache --groups wheel jharvard > /dev/null 2>&1
/bin/echo crimson | /usr/bin/passwd --stdin jharvard > /dev/null 2>&1
echo "   Reset John Harvard's password to \"crimson\"."

# /home/jharvard/logs
/bin/mkdir /home/jharvard/logs > /dev/null 2>&1
/bin/chown -R jharvard:apache /home/jharvard/logs > /dev/null 2>&1
/bin/chmod 0770 /home/jharvard/logs > /dev/null 2>&1
/bin/chmod 0660 /home/jharvard/logs/* > /dev/null 2>&1

# disable services
declare -a off=(ip6tables netconsole netfs postfix psacct rdisc saslauthd)
for service in "${off[@]}"
do
    /sbin/chkconfig $service off > /dev/null 2>&1
    echo "   Disabled $service."
done

# enable services
declare -a on=(httpd iptables memcached mysqld ntpd ntpdate sshd udev-post)
for service in "${on[@]}"
do
    /sbin/chkconfig $service on > /dev/null 2>&1
    echo "   Enabled $service."
done

# reset MySQL privileges
/sbin/service mysqld stop > /dev/null 2>&1
/bin/mv /etc/my.cnf /etc/.my.cnf
/bin/cp -a /etc/.my.cnf /etc/my.cnf
/bin/cat > /etc/my.cnf <<"EOF"
[mysqld]
datadir=/var/lib/mysql
skip-grant-tables
skip-networking
socket=/var/lib/mysql/mysql.sock
user=mysql
EOF
/sbin/service mysqld start > /dev/null 2>&1
/usr/bin/mysql --user=root > /dev/null 2>&1 <<"EOF"
DELETE FROM mysql.user WHERE User = '';
DELETE FROM mysql.user WHERE User = 'root';
INSERT INTO mysql.user (Host, User, Password, Grant_priv, Super_priv) VALUES('localhost', 'root', PASSWORD('crimson'), 'Y', 'Y');
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'localhost';
EOF
/sbin/service mysqld stop > /dev/null 2>&1
/bin/mv /etc/.my.cnf /etc/my.cnf
/sbin/service mysqld start > /dev/null 2>&1
echo "   Reset superuser's password for MySQL to \"crimson\"."

# reset John Harvard's password for MySQL
/usr/bin/mysql --force --user=root --password=crimson > /dev/null 2>&1 <<"EOF"
DROP USER 'jharvard'@'%';
CREATE USER 'jharvard'@'%' IDENTIFIED BY 'crimson';
GRANT ALL PRIVILEGES ON `jharvard\_%`.* TO 'jharvard'@'%';
FLUSH PRIVILEGES;
EOF
echo "   Reset John Harvard's password for MySQL to \"crimson\"."

# restart services
declare -a restart=(httpd iptables network smb sshd usermin webmin)
for service in "${restart[@]}"
do
    /sbin/service $service restart > /dev/null 2>&1
    echo "   Restarted $service."
done

# import keys (to avoid warnings during future software updates)
/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6 > /dev/null 2>&1
/bin/rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt > /dev/null 2>&1
/bin/rpm --import http://www.webmin.com/jcameron-key.asc > /dev/null 2>&1

# remove /etc/httpd/conf.d/welcome.conf (because its presence disables Indexes)
/bin/rm -f /etc/httpd/conf.d/welcome.conf > /dev/null 2>&1

# remove sources
/bin/rm -rf /tmp/%{name}-%{version}-%{release}

# rebuild mlocate.db
/etc/cron.daily/mlocate.cron

# return 0
/bin/true


##########################################################################
%files
%defattr(-,root,root,-)
/tmp/%{name}-%{version}-%{release}


##########################################################################
%changelog
* Sat Apr 21 2012 David J. Malan <malan@harvard.edu> - 1-1
- Initial build
