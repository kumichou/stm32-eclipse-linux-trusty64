# Vagrant-based VirtualBox environment for STM32 ARM Development using Ubuntu 14.04 Server

## Attention!

This project requires a relatively recent computer that supports Hardware Virtualization. You MUST make sure you have AMD-V or VT-x extensions enabled in your computer's BIOS otherwise the Virtual Machine will not boot!

If you encounter other problems, check out the [Gotchas](#gotchas) section below

## Host OS Requirements

*  Windows 7 or higher, or Mac OS X Mountain Lion or higher
*  About 15GB of Free Space on OS hard drive

## Prerequisites before you begin building the virtual machine

*  Install VirtualBox v5.0.0 [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
*  Install VirtualBox Extension Pack v5.0.0 [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
*  Install Vagrant v1.7.4 [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)
*  If you haven't already installed the above items, you will most likely be asked to reboot your computer, please do so before continuing...

## Building the environment for the first time

*  Download a copy of this repository as a zip file
*  Unzip on your local system
*  Open a terminal/command prompt, navigate to the unzipped folder, execute `vagrant up`
*  If you have never used Vagrant before, Vagrant will try to install some required plugins the first time you execute `vagrant up`. Vagrant will install them first, prompt for you to restart `vagrant up`, then exit the program. Execute `vagrant up` to continue building the Virtual Machine after the plugins install.
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
*  GNU ARM Tools 2015-Q2 Release
*  Firefox web browser
*  KiCAD EDA Software Suite

## Removing the Dev Environment Image from your hard drive

*  Open a terminal, navigate to the unzipped folder, execute `vagrant destroy` This will delete the VM from your system.

## Gotchas

### Space in Home Directory Name

If you are using Windows and receive an error that the Vagrant Home Directory can't have spaces in it due to a bug in Ruby, your User home directory probably has a space in it.

* Create a folder "home" within C:\Hashicorp\Vagrant - `C:\Hashicorp\Vagrant\home`
* Add the environment variable `VAGRANT_HOME` to Windows, see [http://www.computerhope.com/issues/ch000549.htm](http://www.computerhope.com/issues/ch000549.htm) if you don't know how.
* Reboot your system for the new environment variable to take effect.
* Try again...

### Confirm VT-x or AMD-V CPU Extension Support

Check your CPU on the Intel website to see if it supports VT-x. If you have an AMD processor, confirm that it supports AMD-V extensions. Then, make sure to turn on Virtualization support in your BIOS. Apple computers that have a compatible Intel processor already have the VT-x extensions enabled in EFI.

### Hyper-V interfering with VirtualBox

If needed turn off Hyper-V (go to Windows Features on your machine and uncheck Hyper-v – in Win10 use the search box on the bottom toolbar to get to the Windows Features)


