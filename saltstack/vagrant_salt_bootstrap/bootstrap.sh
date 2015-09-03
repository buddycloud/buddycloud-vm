#!/bin/sh
apt-get --yes -q install python-software-properties
add-apt-repository ppa:saltstack/salt2015-5
apt-get --yes -q update
apt-get --yet -q install python-git salt-master salt-minion
cp /srv/salt_bootstrap/master /etc/salt/master
cp /srv/salt_bootstrap/minion /etc/salt/minon 
service salt-minion restart
service salt-master restart
sleep 10
salt-key -A 
