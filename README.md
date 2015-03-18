## Vagrant + Saltstack + Buddycloud = Buddycloud Stack in a Box

### Getting Started

Install [Git]([http://git-scm.com/downloads)
Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](http://www.vagrantup.com/) (We require Vagrant 1.1.2+ or later)

Open a terminal

```bash
git clone https://github.com/buddycloud/buddycloud-vm.git`
cd buddycloud-vm`
```

Add your username and public key to `/saltstack/pillar/users.sls`

### Building the VM

```bash
vagrant up
```

### SSH into the VM

```bash
# [if necessary] remove old key
ssh-keygen -R '[localhost]:2222'
ssh vagrant@localhost -p2222 
# password is vagrant
```

### Configuring the VM using Saltstack

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

### Depoloying to providers

Edit the `Vagrantfile` with your settings. And then:

#### Google Cloud
```
vagrant plugin install vagrant-google
vagrant up --provider=google
```

#### VSphere 
```
vagrant plugin install vagrant-vsphere
vagrant up --provider=vsphere
```

### Shutting down the VM

When you're done working on Buddycloud, you can shut down Vagrant with: `vagrant halt`

### Todo (pull requests welcomed)

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
- automate configuring: Take input domain and configure against this - probably will need to be in a /saltstack/pillar/<something>
- generate fake certificates where necessary
- export out VMs ready for Amazon / Digitial Ocean / Google Compute
