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

Add your username and public key to `/saltstack/pillar/users.sls`

```bash
# build and boot the machine
vagrant up

# [if necessary] remove old key
ssh-keygen -R '[localhost]:2222'
ssh vagrant@localhost -p2222 
# password is vagrant
```

### Configuring the machine (Saltstack)

```
ssh vagrant@localhost -p2222 
# password is vagrant
sudo salt-call  --local  state.highstate
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

When you're done working on Buddycloud, you can shut down Vagrant with:

```
vagrant halt
```

### Todo

- ~~/etc/motd~~
- ~~Firewall~~
- ~~Postgres~~
    - ~~Create database `buddycloud-server-java`~~
    - ~~Create database `buddycloud-media-server`~~
    - ~~Create database `tigase_server`~~
- ~~Buddycloud Services~~
    - ~~buddycloud-server-java~~
    - ~~buddycloud-http-api~~
    - ~~buddycloud-media-server~~
    - create a persistient media-store directory
- ~~nginx~~
    - configure nginx to reverse proxy
- Take input domain and configure against this - probably will need to be in a /saltstack/pillar/<something>
- export out VM for running on other systems (EC2 / Digital Ocean etc) - not sure how to do this with Vagrant

