#!/bin/sh
export DEBIAN_FRONTEND=noninteractive
apt-get --yes -q install python-software-properties
add-apt-repository ppa:saltstack/salt2015-5 -y
apt-get --yes -q update
mkdir /etc/salt
apt-get --yes -q install python-git salt-master salt-minion
cp /srv/vagrant_salt_bootstrap/master /etc/salt/master
cp /srv/vagrant_salt_bootstrap/minion /etc/salt/minion
# add the https://github.com/buddycloud/saltstack repo (the heavy lifting part)
git clone https://github.com/buddycloud/saltstack.git /srv/buddycloud_saltstack_repo
restart salt-minion
restart salt-master
sleep 10
salt-key -y -a '*'
sleep 10
echo "this next step will take around 10 minutes to run... be patient"
echo "if you are curious sudo tail -F /var/log/salt/minion on the VM"
salt -v "*" state.highstate -l debug
