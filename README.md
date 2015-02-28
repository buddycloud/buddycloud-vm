# Vagrant+Saltstack+Docker+Buddycloud

(Based off the skeleton from http://blog.roblayton.com/2014/12/masterless-saltstack-provisioning-to.html)

### Getting Started

Install [Git]([http://git-scm.com/downloads)
Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](http://www.vagrantup.com/) (We require Vagrant 1.1.2+ or later)
Open a terminal
Clone the project: `git clone https://github.com/buddycloud/buddycloud-machine.git`
Enter the project directory: `cd buddycloud-machine`

### Building the machine (Vagrant)

```bash
# build and boot the machine
vagrant up

# remove old key if necessary
ssh-keygen -R '[localhost]:2222'
ssh vagrant@localhost -p2222 
# password is vagrant
```

### Configuring the machine (Saltstack)

```
ssh vagrant@localhost -p2222 
# password is vagrant
sudo salt-call  --local  state.highstate -l debug
```

### Configuring Buddycloud


Private config data (DB passwords, certs...) 
- put confidential information into `/srv/pillar/<filename.sls>`
- reference that file in `/srv/pillar/<top.sls>`

Public data of how the server should be
- put salt states (how you want the syteem to be) into `/srv/salt/<filename.sls>`
- reference that file in `/srv/salt/<top.sls>`
- Bring the machine to the desired state by running `sudo salt-call  --local  state.highstate -l debug`

### Shutting down the VM

When you're done working on Discourse, you can shut down Vagrant with:

```
vagrant halt
```

### Todo

- ~~/etc/motd~~
- ~~Firewall~~
- ~~Postgres~~
    - ~~Create database `buddycloud-server-java`~~
    - ~~Create database `buddycloud-media-server`~~
- ~~docker management~~
    - ~~buddycloud-server-java~~
    - prosody
    - buddycloud-server-java
    - http-api
    - media-server
    - nginx
- Postfix
- persistient media-store (shared into the buddycloud-media-server)
- munin/graphite for monitoring
- some logging from docker containers
