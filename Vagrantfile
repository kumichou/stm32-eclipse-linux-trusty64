# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'lib/better_usb.rb'
require_relative 'lib/calculate_hardware.rb'
require_relative 'lib/os_detector.rb'


if ARGV[0] == "up" then
  has_installed_plugins = false

  unless Vagrant.has_plugin?("vagrant-vbguest")
    system("vagrant plugin install vagrant-vbguest")
    has_installed_plugins = true
  end

  unless Vagrant.has_plugin?("vagrant-reload")
    system("vagrant plugin install vagrant-reload")
    has_installed_plugins = true
  end

  unless Vagrant.has_plugin?("copy_my_conf")
    system("vagrant plugin install copy_my_conf")
    has_installed_plugins = true
  end

  if has_installed_plugins then
    puts "Vagrant plugins were installed. Please run vagrant up again to install the VM"
    exit
  end
end

vagrant_dir = File.expand_path(File.dirname(__FILE__))

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  #
  # Ubuntu 14.04 minimal desktop.
  #
  # The following modifications are made to this image:
  #
  # Installed vim
  # Performed Updates and dist-upgrade ( on 06.06.2014 )
  # Removed network-manager
  # Disabled apparmor
  # Removed older kernels
  #
  # The following packages were removed:
  #
  # thunderbird
  # libreoffice
  # rythmbox
  # empathy
  # ubuntu-docs
  # gnome-user-guide
  # deja-dup
  # xterm
  # remmina
  # transmission
  # brasero
  # cheese
  # totem


  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "stm32-eclipse"

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.synced_folder(".", "/vagrant",
    :owner => "vagrant",
    :group => "vagrant",
    :mount_options => ['dmode=777','fmode=777']
  )

  config.vm.provider "virtualbox" do |vb|

    # Tell VirtualBox that we're expecting a UI for the VM
    vb.gui = true

    # Turn on USB 2.0 support, requires the VirtualBox Extras to be installed
    vb.customize ["modifyvm", :id, "--usb", "on", "--usbehci", "on"]

    # Enable sharing the clipboard
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]

    # Set # of CPUs and the amount of RAM, in MB, that the VM should allocate for itself, from the host
    CalculateHardware.set_minimum_cpu_and_memory(vb, 2, 2048)

    # Set Northbridge
    vb.customize ["modifyvm", :id, "--chipset", "ich9"]

    # Set the amount of RAM that the virtual graphics card should have
    vb.customize ["modifyvm", :id, "--vram", "128"]

    # Advanced Programmable Interrupt Controllers (APICs) are a newer x86 hardware feature
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    # Enable the use of hardware virtualization extensions (Intel VT-x or AMD-V) in the processor of your host system
    vb.customize ["modifyvm", :id, "--hwvirtex", "on"]

    # Enable, if Guest Additions are installed, whether hardware 3D acceleration should be available
    vb.customize ["modifyvm", :id, "--accelerate3d", "on"]

    # Setup rule to automatically attach ST Link v2.1 Debugger when plugging in Nucleo board
    BetterUSB.usbfilter_add(vb, "0x0483", "0x374b", "ST Link v2.1 Nucleo")

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

  end


  # Provisioning
  #
  # Process one or more provisioning scripts depending on the existence of custom files.
  #
  # provison-pre.sh
  #
  # provison-pre.sh acts as a pre-hook to the default provisioning script. Anything that
  # should run before the shell commands laid out in bootstrap.sh (or your provision-custom.sh
  # file) should go in this script. If it does not exist, no extra provisioning will run.
  #
  if File.exist?(File.join(vagrant_dir,'provision','provision-pre.sh')) then
    config.vm.provision :shell, path: File.join( "provision", "provision-pre.sh" )
  end

  #
  # bootstrap.sh or provision-custom.sh
  #
  # By default, our Vagrantfile is set to use the bootstrap.sh bash script located in the
  # provision directory. If it is detected that a provision-custom.sh script has been
  # created, it is run as a replacement. This is an opportunity to replace the entirety
  # of the provisioning provided by the default bootstrap.sh.
  #
  if File.exist?(File.join(vagrant_dir,'provision','provision-custom.sh')) then
    config.vm.provision :shell, path: File.join( "provision", "provision-custom.sh" )
  else
    config.vm.provision :shell, path: File.join( "provision", "bootstrap.sh" )
  end

  #
  # provision-post.sh
  #
  # provision-post.sh acts as a post-hook to the default provisioning. Anything that should
  # run after the shell commands laid out in bootstrap.sh or provision-custom.sh should be
  # put into this file. This provides a good opportunity to install additional packages
  # without having to replace the entire default provisioning script.
  #
  if File.exist?(File.join(vagrant_dir,'provision','provision-post.sh')) then
    config.vm.provision :shell, path: File.join( "provision", "provision-post.sh" )
  end

  #
  # Reload/Reboot the VM
  #
  config.vm.provision :reload

  #
  # provision-as-vagrant-user.sh
  #
  # provision-as-vagrant-user.sh is a post-provision hook to run commands as the vagrant user on the system.
  #
  if File.exist?(File.join(vagrant_dir,'provision','provision-as-vagrant-user.sh')) then
    config.vm.provision :shell, path: File.join( "provision", "provision-as-vagrant-user.sh" ), :privileged => false
  end

  #
  # Copy SSH configuration, Global Git config & Vim configuration to the VM
  #
  # If you are running on Mac OSX or Linux as a Host OS, then copy your SSH key if you have one.
  # If you don't, or are on Windows, the provisioning that has already ran has generated a new one for you to use with GitHub.
  #

  if [:macosx, :linux, :unix].include? OsDetector.os
    # Assumes you have Git, Vim & OpenSSH installed on your *nix system already.

    config.vm.provision :copy_my_conf do |copy_conf|
      copy_conf.git
      copy_conf.vim
      copy_conf.ssh
    end
  end

  #
  # Reload/Reboot the VM
  #
  config.vm.provision :reload

end
