Vagrant+Saltstack+Docker+Buddycloud
===================================

based off the skeleton from http://blog.roblayton.com/2014/12/masterless-saltstack-provisioning-to.html

Get it running
--------------

```bash
git clone https://github.com/buddycloud/buddycloud-dev-machine.git

cd buddycloud-dev-machine

# build and boot the machine
vagrant up

# remove old key if necessary
ssh-keygen -R '[localhost]:2222'

ssh vagrant@localhost -p2222 # password is vagrant
```

Getting things back to state
```
vagrant provision

sudo salt-call  --local  state.highstate -l debug
```

How this works
---------------
Private config data (DB passwords, certs...) 
- put confidential information into `/srv/pillar/<filename.sls>`
- reference that file in `/srv/pillar/<top.sls>`

Public data of how the server should be
- put salt states (how you want the syteem to be) into `/srv/salt/<filename.sls>`
- reference that file in `/srv/salt/<top.sls>`

Bring the machine to the desired state by running `sudo salt-call  --local  state.highstate -l debug`

Status
------

Currently working:
- Firewall
- Postgres (creates `buddycloud-server-java` and `buddycloud-media-server` databases)
- /etc/motd

Todo
- docker (buddycloud-server-java, http-api, media-server, webserver)
- postfix
- persistient media-store (shared into the buddycloud-media-server)
- munin/graphite for monitoring
- some logging from docker containers


