## Vagrant + Saltstack + Buddycloud = Buddycloud Stack in a Box

### Getting Started

Install [Git]([http://git-scm.com/downloads)
Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](http://www.vagrantup.com/) (We require Vagrant 1.1.2+ or later)

Open a terminal

```bash
# in this example we'll assume you work in ~/src/
git clone https://github.com/buddycloud/buddycloud-vm.git ~/src/buddycloud-vm 
cd ~/src/buddycloud-vm
```

Add your username and public key to `~/src/buddycloud-vm/saltstack/pillar/users.sls`

### Building the VM

```bash
cd ~/src/buddycloud-vm
vagrant up
```

### SSH into the VM

```bash
# [if necessary] remove old key
ssh-keygen -R '[localhost]:2222'
ssh vagrant@localhost -p2222 # or your username if you configured it 
# password is vagrant
```

### Configure changes

You can configure changes to the VM by editing files on your local machine `~/src/buddycloud-vm/saltstack/`. These changes automatically appear inside your VM at `/srv/salt`.

To make these changes live run `sudo salt-call  --local  state.highstate` inside the VM. 

### Configuring Buddycloud

- put confidential information into `~/src/buddycloud-vm/saltstack/pillar/`
- add service configuration to files in `~/src/buddycloud-vm/saltstack/salt/`

### Working on the website

Your webroot is exposed outside of the VM at `~/src/buddycloud-vm/buddycloud-webapp/`. Changes in here are served out by the nginx process inside the vm and avaliable on `http://localhost:8080`

### Depoloying to providers

To deploy to a hosting provider, edit the `Vagrantfile` with your cloud-hosting-provider data.

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

Shut down Vagrant with: `vagrant halt`. And `vagrant kill` will remove all disks and configs.

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
    - ~~create a persistient media-store directory~~
    - buddycloud-pusher (check that it comes up)
- ~~nginx~~
    - ~~configure nginx to reverse proxy~~
- ~~automate configuring: Take input domain and configure against this - probably will need to be in a /saltstack/pillar/<something>~~
- ~~generate fake certificates where necessary (won't do)~~
- ~~export out VMs ready for Amazon / Digitial Ocean / Google Compute~~
- add logrotate for all packages
