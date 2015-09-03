#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
apt-get --yes -q install python-software-properties
add-apt-repository ppa:saltstack/salt2015-5 -y
apt-get --yes -q update
apt-get --yes -q install python-git salt-master salt-minion
service salt-minion stop
service salt-master stop
cp /srv/vagrant_salt_bootstrap/master /etc/salt/master
cp /srv/vagrant_salt_bootstrap/minion /etc/salt/minon 
salt-key --gen-keys=buddycloud-vm
cp buddycloud-vm.pub /etc/salt/pki/master/minions/buddycloud-vm.pub
service salt-minion start
service salt-master start
sleep 10
salt -v "*" state.highstate -l debug
