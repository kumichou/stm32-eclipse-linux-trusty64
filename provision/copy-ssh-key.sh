#!/bin/bash

mkdir -p /home/vagrant/.ssh
mv /vagrant/id_rsa /home/vagrant/.ssh/
mv /vagrant/id_rsa.pub /home/vagrant/.ssh/

chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/id_rsa*

