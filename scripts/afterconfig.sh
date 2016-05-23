#!/bin/bash

echo "--- Setting Up Vagrant pub keys"
mkdir /home/vagrant/.ssh
wget --no-check-certificate -O authorized_keys https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub
mv authorized_keys /home/vagrant/.ssh
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
