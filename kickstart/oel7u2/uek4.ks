#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512

# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=pt --xlayouts='pt'
# System language
lang en_US.UTF-8

# Use Text Install
text
skipx

# Network information
network  --bootproto=dhcp --device=eth0 --onboot=on  --activate --hostname=laboel7u2

# Root password
rootpw --iscrypted $6$DFJGUTIKSLDOFISK$uZWOctsgofa7lHLmHtNLT8mLqgkzboU4s6Q/FSmiuFrWNHraR65XbKHQ4/UMkdvK1iGQxN8iorAA5nQF4qnpB.
# System services
services --disabled="chronyd"
selinux --disabled
firewall --disabled

# System timezone
timezone Europe/Lisbon --isUtc --nontp
user --name=vagrant --password=$6$DFJGUTIKSLDOFISK$gzxAbWnsSlLEAl89oktrIn3Ds3NsNI/4hxElCBvWy4H25.UZVWY98teC3CcQLAFSVEe4JjW6/lgaIpUFmKkit. --iscrypted --gecos="vagrant"

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda

zerombr

# Partition clearing information
clearpart --all --initlabel
part /boot --fstype="ext4" --size=200 --ondisk=sda
part pv.0 --size=1 --grow --ondisk=sda
volgroup vg.0 pv.0
logvol swap --fstype="swap" --name=lv.swap --vgname=vg.0 --size=1024
logvol / --fstype="ext4" --name=lv.root --vgname=vg.0 --size=1 --grow


%packages
@^infrastructure-server-environment
@base
@core
telnet
openldap-clients
ocfs2-tools
# virtualization tools requirement
kernel-uek-devel
# Middleware requirement
oracle-rdbms-server-12cR1-preinstall

%end

reboot

%pre --log=/root/pre-install.log
%end

%post --log=/root/post-install.log
echo "vagrant        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/vagrant
echo "oracle        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers.d/oracle

chmod 0440 /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/oracle

sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

echo "127.0.0.1   localhost   $(hostname)" > /etc/hosts

echo "
[ol7_Latest]
name=Latest Unbreakable Enterprise Kernel Release 3 for Oracle Linux \$releasever (\$basearch)
baseurl=http://public-yum.oracle.com/​repo/​OracleLinux/​OL7/​latest/​\$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol7_UEKR3]
name=Unbreakable Enterprise Kernel Release 3 for Oracle Linux \$releasever (\$basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL7/UEKR3/\$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0

[ol7_UEKR4]
name=Unbreakable Enterprise Kernel Release 4 for Oracle Linux $releasever (\$basearch)
baseurl=http://public-yum.oracle.com/repo/OracleLinux/OL7/UEKR4/\$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=0
" > /etc/yum.repos.d/public-yum-ol7.repo

# Update all available packages
yum -y  --disablerepo="*" --enablerepo="ol7_UEKR4" update
yum -y clean all

%end
