#!/bin/bash

# This file installs necessary packages in the Vagrant image

result=`which java`

if ! [[ -z "$result" ]]; then
    exit;
fi

# Tell Ubuntu to not use ncurses to prompt for user input
export DEBIAN_FRONTEND=noninteractive

# Enable Ubuntu Multiverse repo to get to VirtualBox Guest Additions debs
sed -i '/^#.* trusty multiverse/s/^#//' /etc/apt/sources.list
sed -i '/^#.* trusty-updates multiverse/s/^#//' /etc/apt/sources.list

# Add PPA that has the Oracle 8 SDK packages in it for Ubuntu 14.04
echo -e "\n**** Installing Repository for Oracle JAVA Installers ****\n"
apt-get -qq -y install software-properties-common 2> /dev/null
add-apt-repository -y ppa:webupd8team/java 2> /dev/null

# Needed for ATOM Text Editor later...
add-apt-repository ppa:webupd8team/atom 2> /dev/null

# Needed for KiCAD later...
add-apt-repository ppa:js-reynaud/ppa-kicad 2> /dev/null

# Needed to get more current Ruby packages
apt-add-repository ppa:brightbox/ruby-ng 2> /dev/null


# Enable i386 Compatibility
sudo dpkg --add-architecture i386 2> /dev/null

# Update available packages
apt-get update > /dev/null

# Install some Ubuntu packages that are missing from the Desktop box we're using
apt-get -qq -y install whois curl wget giggle vim > /dev/null

#echo -e "\n**** Installing Lightweight X11 Desktop Environment ****\n"
#apt-get -qq -y install xorg lxde > /dev/null

echo -e "\n**** Installing Unity Desktop Environment. This might take a while... ****\n"
apt-get -qq -y install --no-install-recommends ubuntu-desktop^ > /dev/null
apt-get -qq -y install firefox > /dev/null

# Install Oracle Java 8 SDK
# state that you accepted the license
echo -e "\n**** Installing Oracle JAVA 8. This might take a while... ****\n"
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get -qq -y install oracle-java8-installer 2> /dev/null
apt-get -qq -y install oracle-java8-set-default 2> /dev/null

# Add JAVA_HOME to environment
cat <<EOL >> /etc/environment
JAVA_HOME=/usr/lib/jvm/java-8-oracle
EOL

# Install IA32 Libs to support 32bit apps in 64bit AMD Linux
echo -e "\n**** Installing 32bit support for ARM Tools ****\n"
apt-get -qq -y install libc6:i386 libncurses5:i386 libstdc++6:i386 >/dev/null

# Prep for EABI ARM Toolchain install
apt-get -qq -y install build-essential gdb manpages-dev curl flex bison libgmp3-dev libmpfr-dev texinfo libelf-dev autoconf libncurses5-dev libmpc-dev >/dev/null
apt-get -qq -y install libftdi1 libtool subversion git-core automake texinfo libnet-telnet-perl gtkterm ntp >/dev/null
apt-get -qq -y install libxslt-dev libxml2-dev git zip unzip zlib1g-dev libtool autoconf texinfo build-essential libftdi-dev libusb-1.0-0-dev pkg-config >/dev/null

# Eclipse & Eclipse CDT will be installed in the user's directory later

apt-get -qq install -q -y whois >/dev/null

usermod -a -G dialout vagrant
usermod -a -G video vagrant
usermod -a -G plugdev vagrant

sudo userdel ubuntu
sudo rm -r /home/ubuntu

apt-get -qq -y install jimsh >/dev/null

echo -e "\n**** Setting up udev rules to allow access to ST Link programmers (both onboard & separate) ****\n"
cat <<EOL >> /etc/udev/rules.d/99-stlink.rules
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666"
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666"
EOL

sudo udevadm control --reload-rules


# Installing Google Nameservers to help incase of needing TCP/IP services on VM
echo -e "\n**** Setting up Google DNS as default DNS Servers ****\n"
cat <<EOL >> /etc/resolvconf/resolv.conf.d/base
nameserver 8.8.8.8
nameserver 8.8.4.4
EOL

# Setup desktop link for Eclipse
cat <<EOL >> /usr/share/applications/eclipse.desktop
[Desktop Entry]
Name=Eclipse
Type=Application
Exec=/home/vagrant/eclipse/eclipse
Terminal=false
Icon=/home/vagrant/eclipse/icon.xpm
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE
Name[en]=Eclipse 4.4
EOL

# Installing ACK
echo -e "\n**** Installing Ack for use in Vim if needed ****\n"
apt-get -qq -y install ack-grep > /dev/null
dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

# Installing The Silver Searcher
echo -e "\n**** Installing The Silver Searcher for use in Vim if needed ****\n"
apt-get -qq -y install silversearcher-ag > /dev/null

# Installing CTags support
echo -e "\n**** Installing CTags support ****\n"
apt-get -qq -y install exuberant-ctags > /dev/null

# Installing a PDF reader
echo -e "\n**** Installing PDF Reader ****\n"
apt-get -qq -y install evince > /dev/null

# Installing ATOM Text Editor
echo -e "\n**** Installing ATOM Text Editor ****\n"
apt-get -qq -y install atom > /dev/null

echo -e "\n**** Installing KiCAD EDA Tool ****\n"
apt-get -qq -y install kicad > /dev/null

echo -e "\n**** Installing Ruby 2.2 as a baseline ****\n"
#apt-get -qq -y install ruby1.9.3 > /dev/null
apt-get -qq -y install ruby2.2 > /dev/null
#apt-get -qq -y install ruby-switch > /dev/null
#ruby-switch --set ruby2.2


# Reinstalling the VBox Guest Additions so we have X11 support!
/etc/init.d/vboxadd setup
/etc/init.d/vboxadd-x11 setup

cat > /etc/lightdm/lightdm.conf <<EOF
[SeatDefaults]
autologin-user=vagrant
autologin-user-timeout=0
user-session=ubuntu-2d
greeter-session=unity-greeter
EOF

sudo invoke-rc.d apparmor stop
sudo update-rc.d -f apparmor remove

apt-get -y -f purge thunderbird libreoffice empathy ubuntu-docs gnome-user-guide deja-dup xterm remmina transmission brasero cheese totem network-manager

