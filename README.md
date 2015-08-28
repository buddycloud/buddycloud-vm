## Buddycloud Developer Environment

This VM uses Vagrant to build a VM then uses the [Buddycloud Salt formuale](https://github.com/buddycloud/saltstack) to spin up a complete developer environment.

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

### Edit setup

|                    | Outside the VM                                      | Inside the VM                      |             |
|--------------------|-----------------------------------------------------|------------------------------------|----------------------------------|
| Public configs    | `buddycloud-vm/saltstack/salt_local/salt/*` (read-write)         | `/srv/salt_local/salt` (read-only)              |      |
| Private configs    | `buddycloud-vm/saltstack/salt_local/pillar/*` (read-write)      | `/srv/salt_local/pillar` (read-only)           | e.g. database passwords          |
| Connecting         | `ssh vagrant@localhost -p2222` (password is `vagrant`)  |                                   |                                  | add your own key to `buddycloud-vm/saltstack/salt_local/pillar/users.sls`  

### [Re]configure VM with new setup

```bash
salt "*" state.highstate -l all
```

### Shutting down the VM

Shut down Vagrant with: `vagrant halt`. Running `vagrant kill` will remove all disks and configs.

## Depoloying to providers

To deploy to a hosting provider, edit the `Vagrantfile` with your cloud-hosting-provider data.

### Google Cloud

Configure according to https://github.com/mitchellh/vagrant-google, then:
```
vagrant plugin install vagrant-google
vagrant up --provider=google
```

### VSphere 
```
vagrant plugin install vagrant-vsphere
vagrant up --provider=vsphere
```

## Running in Production

It's recommended to configure to:
- use your saltstack repo as priority (eg. /srv/dev-ops or gitfs from git://github.com/example/dev-ops.git)
- use gitfs with https://github.com/buddycloud/saltstack.git for everything you don't override.
