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

### Building the VM

```bash
vagrant up
```

### SSHing into the VM

Log in as user: `vagrant`, password: `vagrant`. (for convenience, add your username and public key to `saltstack/salt_local/pillar/users/init.sls`)

### Using the VM

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



### SSH into the VM

```bash
# [if necessary] remove old key
ssh-keygen -R '[localhost]:2222'
ssh vagrant@localhost -p2222 # or your username if you configured it 
# password is vagrant
```

### Edit setup

|                 | Outside the VM                                  | Inside the VM                      |
|-----------------|-------------------------------------------------|------------------------------------|
| Public configs  | `buddycloud-vm/saltstack/salt_local/salt/*`     | `/srv/salt_local/salt`             |     
| Private configs | `buddycloud-vm/saltstack/salt_local/pillar/*`   | `/srv/salt_local/pillar`           | 
| Connecting      | `ssh vagrant@localhost -p2222` (password is `vagrant`)  |                            |

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
