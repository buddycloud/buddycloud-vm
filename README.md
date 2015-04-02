## Vagrant + Saltstack + Buddycloud = Buddycloud Stack in a Box

### Getting Started

Install [Git]([http://git-scm.com/downloads)
Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](http://www.vagrantup.com/) (v1.7.2 or later)

Open a terminal

```bash
# in this example we'll assume you work in ~/src/
git clone https://github.com/buddycloud/buddycloud-vm.git
cd buddycloud-vm
```

Add your username and public key to `~/src/buddycloud-vm/saltstack/pillar/users.sls`

### Building the VM

```bash
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

|                    | Outside the VM                                      | Inside the VM                      | Comment                          |
|--------------------|-----------------------------------------------------|------------------------------------|----------------------------------|
| General Configs    | `buddycloud-vm/saltstack/salt/*` (read-write)         | `/srv/salt` (read-only)              | e.g. `nginx.conf`                  |
| Private configs    | `buddycloud-vm/saltstack/pillars/*` (read-write)      | `/srv/pillars` (read-only)           | e.g. database passwords          |
| Connecting         | `ssh vagrant@localhost -p2222` (password is `vagrant`)  |                                    |                                  |
| Activating changes |                                                     | `salt-call --local state.highstate`  |                                  |
| Webroot            | `buddycloud-vm/buddycloud-webapp` (read-write)        | `/opt/buddycloud-webapp` (read-only) | visible on http://localhost:8080 |
| When deployed to AWS/GCE/your-server  |          | edit `/etc/salt/minion` to pull updates from Git | this will pull all future system configs from your private git repo |


### Depoloying to providers

To deploy to a hosting provider, edit the `Vagrantfile` with your cloud-hosting-provider data.

#### Google Cloud

Configure according to https://github.com/mitchellh/vagrant-google, then:
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

- add logrotate for all packages
