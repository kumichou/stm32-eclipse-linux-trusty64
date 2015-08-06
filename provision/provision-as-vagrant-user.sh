#!/bin/bash

echo -e "\n**** Installing a sane global .gitconfig in the VM ****\n"
cat <<EOL >> ~/.gitconfig
[color]
  diff = auto
  status = auto
  branch = auto
  interactive = auto
  ui = auto
[gc]
  auto = 1
[merge]
  summary = true
[alias]
  co = checkout
  ci = commit -v
  st = status
  cp = cherry-pick -x
  rb = rebase
  pr = pull --rebase
  br = branch
  b = branch -v
  r = remote -v
  t = tag -l
  put = push origin HEAD
  unstage = reset HEAD
  uncommit = reset --soft HEAD^
  recommit = commit -C head --amend
  d = diff
  c = commit -v
  s = status
  dc = diff --cached
  pr = pull --rebase
  ar = add -A
EOL

echo -e "\n**** Generating an OpenSSH public & private key pair inside of Vagrant VM for use by Git/SSH/SCP/etc ****\n"

if ! [[ -d ~/.ssh ]]; then
    mkdir ~/.ssh
    echo -e "\n\n\n" | ssh-keygen -t rsa
fi

echo -e "\n**** Grabbing the GCC ARM Embedded Toolkit for GCC 4.7.2 ****\n"
curl -sLo ~/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 https://launchpad.net/gcc-arm-embedded/4.9/4.9-2015-q2-update/+download/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 >/dev/null

if [[ -f ~/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 ]]; then
    echo -e "\n******  gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 has been downloaded  ******\n"
fi

tar xjf ~/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 -C ~/
rm ~/gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2

echo -e "\n**** Done downlading GCC ARM Embedded Toolkit ****\n"

echo -e "\n**** Grabbing Eclipse 4.4 Luna with CDT built in ****\n"
curl -sLo ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz http://ftp.osuosl.org/pub/eclipse/technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz >/dev/null

if [[ -f ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz ]]; then
    echo -e "\n******  eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz has been downloaded  ******\n"
fi

tar xzf ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz -C ~/
rm ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz

# Install OpenOCD from GNU ARM Eclipse project
echo -e "\n**** Installing OpenOCD 0.9.0 from built tar ****\n"
curl -sLo openocd-0.9.0.tar.gz 'http://downloads.sourceforge.net/project/gnuarmeclipse/OpenOCD/GNU%20Linux/gnuarmeclipse-openocd-debian64-0.9.0-201505190955.tgz' > /dev/null

if [[ -f openocd-0.9.0.tar.gz ]]; then
    echo -e "\n******  openocd-0.9.0.tar.gz has been downloaded  ******\n"
fi

tar xzf openocd-0.9.0.tar.gz
rm openocd-0.9.0.tar.gz


echo -e "\n**** Adjusting Bash PATH Environment Variable to include newly installed tooling ****\n"
cat >> ~/.bashrc <<'EOL'

OPENOCD_PATH=$(find ~/openocd/0.9.0-*/bin -print | head -n 1)
ARM_TOOLS_PATH=$(find ~/gcc-arm-none-eabi-*/bin -print | head -n 1)

export PATH=$PATH:"$ARM_TOOLS_PATH"
export PATH=$PATH:"$OPENOCD_PATH"

alias ll='ls -la'

if [[ -d ~/eclipse ]]; then
    export PATH=$PATH:$HOME/eclipse
fi

EOL

source ~/.bashrc

echo -e "\n**** Installing GNU Eclipse ARM Plugin ****\n"
~/eclipse/eclipse -nosplash -followReferences \
    -application org.eclipse.equinox.p2.director \
    -repository http://gnuarmeclipse.sourceforge.net/updates/ \
    -repository http://download.eclipse.org/releases/luna/ \
    -destination /home/vagrant/eclipse \
    -installIUs ilg.gnuarmeclipse.codered.feature.group,ilg.gnuarmeclipse.managedbuild.cross.feature.group,ilg.gnuarmeclipse.doc.user.feature.group,ilg.gnuarmeclipse.templates.cortexm.feature.group,ilg.gnuarmeclipse.debug.gdbjtag.jlink.feature.group,ilg.gnuarmeclipse.debug.gdbjtag.openocd.feature.group,ilg.gnuarmeclipse.packs.feature.group,ilg.gnuarmeclipse.templates.stm.feature.group

echo -e "\n**** Installing EmbSysRegView Plugin ****\n"
~/eclipse/eclipse -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository http://embsysregview.sourceforge.net/update \
    -destination /home/vagrant/eclipse \
    -installIUs org.eclipse.cdt.embsysregview_feature.feature.group,org.eclipse.cdt.embsysregview.data_feature.feature.group

echo -e "\n**** Installing TCF Terminal View Plugin ****\n"
~/eclipse/eclipse -nosplash \
    -application org.eclipse.equinox.p2.director \
    -repository http://download.eclipse.org/releases/luna \
    -destination /home/vagrant/eclipse \
    -installIUs org.eclipse.tcf.te.terminals.feature.feature.group,org.eclipse.cdt.native.feature.group,org.eclipse.tm.terminal.serial.feature.group,org.eclipse.tm.terminal.ssh.feature.group,org.eclipse.tm.terminal.telnet.feature.group,org.eclipse.tm.terminal.feature.group

echo -e "\n**** Installing ST Link command line Tools ****\n"
git clone https://github.com/texane/stlink.git ~/stlink
cd ~/stlink
./autogen.sh
./configure
make
sudo make install
rm -rf ~/stlink

echo -e "\n**** \n**** Installation is done!!\n**** \n"

