# Buddycloud-VM

The VM can be run locally and also used as a way to setup Buddycloud on deployed into a cloud provider (e.g. AWS and Google-Cloud). 

## Goals

**Quick:** The buddycloud-vm project is designed to give developers a complete Buddycloud stack in about 10 mintues. 

**Ship identical bits to dev and production:** The Buddycloud-VM and the [BC saltstack project](https://github.com/buddycloud/saltstack) help you ship the same configuration to your developer environment as you ship to your production environment. Both environments use identical orchestration files and help you reduce the "but it worked in dev" type scenarios.

## How it works

# Vagrant to build a VM
# Install a [definied list of  components](https://github.com/buddycloud/buddycloud-vm/blob/master/saltstack/salt_local/salt/top.sls) using Stalstack formuae from the Buddycloud [saltstack project](https://github.com/buddycloud/saltstack).
* [Configure](https://github.com/buddycloud/saltstack/tree/master/salt) each package.

### Using the VM

The VM is designed to expose buddycloud-services out to your workstation. A quick ascii-art diagram explaines.

```
 +-------------------------------------------------+ 
 |                                                 |
 |   Local workstation                             | 
 |   -----------------                             | 
 |   * set local DNS to use 127.0.0.1              | 
 |   * port forwards 53,5222,8080 -> buddycloud-vm | 
 |   * http://buddycloud.dev:8080                  |
 |                                                 | 
 +-------------------------------------------------+ 
             |          |             |
         (port 53)  (port 5222)  (port 8080)
             |          |             |
 +-------------------------------------------------+
 |                                                 |
 |   buddycloud-VM                                 |
 |   -------------                                 |
 |   * hostname: buddycloud.dev                    |
 |   * listening for DNS queries on port 53        |
 |   * answers *.buddycloud.dev with 127.0.0.1     |
 |   * forwards  other queries to 8.8.8.8          |
 |   * runs complete buddycloud stack              |
 |   * TLS functions disabled                      |
 |   * federation disabled                         |
 |                                                 |
 +-------------------------------------------------+
```

### Run the Buddycloud VM

Install [Git](http://git-scm.com/downloads)
Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](http://www.vagrantup.com/) (v1.7.2 or later)

Open a terminal

```bash
git clone https://github.com/buddycloud/buddycloud-vm.git
cd buddycloud-vm
vagrant up
```

This build process will take anywhere from 1 to 10 minutes depending on the speed of your network and disk. The log of the build is stored inside the VM (see below for accessing) `/var/log/salt/minion`.

### Access Buddycloud services running on the VM

1. set your workstation DNS server to use `127.0.0.1`
2. browse to http://buddycloud.dev:8080

### SSHing into the VM

```bash
vagrant ssh

# or, 
ssh-keygen -R '[localhost]:2222' # remove old key
ssh vagrant@localhost -p2222     # password is `vagrant`
```

(for convenience, add your username and public key to `saltstack/salt_local/pillar/users/init.sls`)

### Edit VM configuration (e.g. domainname, ssh keys, buddycloud config)

|                 | Outside the VM                                  | Inside the VM                      |
|-----------------|-------------------------------------------------|------------------------------------|
| Public configs  | `buddycloud-vm/saltstack/salt_local/salt/*`     | `/srv/salt_local/salt`             |     
| Private configs | `buddycloud-vm/saltstack/salt_local/pillar/*`   | `/srv/salt_local/pillar`           | 

### [Re]configure the VM

```bash
salt "*" state.highstate -l all
```

### Adding your own changes

Fork https://github.com/buddycloud/saltstack

Inside the VM:
```bash
sudo git clone https://github.com/example/my-buddycloudstack.git /srv/my-buddycloudstack
```

Edit `/etc/salt/master` to include the second `file_roots:` like this:
``` 
file_roots:
  base:
    - /srv/salt_local/salt
    - /srv/my-buddycloudstack/salt
```

Edit your configuration in `/srv/my-buddycloudstack/salt` and update `/srv/salt_local/salt/top.sls` where necessary.

You now have a configuration:

1. /srv/salt_local/salt is checked first (e.g. salt formula for buddycloud-server-java)
2. /srv/my-buddycloud-stack/salt is checked second,
3. finally, https://github.com/buddycloud/saltstack/tree/master/salt is checked. 

Activate your changes:
```bash
salt "*" state.highstate -l all
```

(and don't forget to commit /srv/my-buddycloudstack back to git before you destroy your VM)

### Shutting down the VM

Shut down Vagrant with: `vagrant halt`. Running `vagrant kill` will remove all disks and configs.

# Depoloying Buddycloud to different providers

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
