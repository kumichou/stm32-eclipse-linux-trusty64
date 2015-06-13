# Vagrant-based VirtualBox environment for STM32 ARM Development using Ubuntu 14.04 Server

## Host OS Requirements

*  Relatively recent computer that supports Hardware Virtualization. Make sure you have AMD-V or VT-x extensions enabled in your computer's BIOS!
*  Windows 7 or higher, or Mac OS X Mountain Lion or higher
*  About 15GB of Free Space on OS hard drive
*  Install VirtualBox v5.0.0 [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
*  Install VirtualBox Extension Pack v5.0.0 [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
*  Install Vagrant v1.7.4 [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

## Starting the first time

*  Download a copy of this repository as a zip file
*  Unzip on your local system
*  Open a terminal, navigate to the unzipped folder, execute `vagrant up`
*  Most likely your system will not have the necessary Vagrant plugins installed, so Vagrant will install them first and prompt for you to restart `vagrant up`
*  Go get something to drink, eat, or otherwise occupy your time as it will take a while to download & configure the Virtual Machine
*  Eventually, after the VM reboots twice, you will have an Ubuntu Desktop that is prompting you to log in. The password is `vagrant`

## Installed Tools

*  Eclipse 4.4 (Luna)
*  Eclipse CDT for C/C++
*  EmbSysRegViewer for Eclipse
*  TCF Terminal View for Eclipse
*  GNU ARM Plugin for Eclipse
*  ATOM Text Editor
*  Evince PDF Reader
*  Vim Text Editor
*  ack-grep
*  Git
*  stlink command line tools
*  OpenOCD 0.9.0 2015-05-19 Release
*  GNU ARM Tools 2015-Q1 Release
*  Firefox web browser
*  KiCAD EDA Software Suite

## Removing the Dev Environment Image from your hard drive

*  Open a terminal, navigate to the unzipped folder, execute `vagrant destroy` This will delete the VM from your system.
