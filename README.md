# Buddycloud-VM

The VM can be run locally and also used as a way to setup Buddycloud on deployed into a cloud provider (examples for AWS and Google Cloud included in the Vagrantfile).

## Goals

**Quick:** The buddycloud-vm project is designed to a new developer a complete Buddycloud stack in about 10 mintues. Running locally.

**Ship identical bits to dev and production:** The Buddycloud-VM and the [BC saltstack project](https://github.com/buddycloud/saltstack) help you ship the same configuration to your developer environment as you ship to your production environment. 

Both environments use identical orchestration files and help you reduce the "but it worked in dev" scenarios.

## How it works

1. Vagrant to build a VM
2. Install a [definied list of components](https://github.com/buddycloud/buddycloud-vm/blob/master/saltstack/salt_local/salt/top.sls).
3. [Configure](https://github.com/buddycloud/saltstack/tree/master/salt) each package.

### Using the VM

The VM is designed to expose buddycloud-services out to your workstation:
```
 +-------------------------------------------------+ 
 |                                                 |
 |   Local workstation                             | 
 |   -----------------                             | 
 |                                                 | 
 |   * port forwards 5222,5269,5432,8080           | 
 |   * http://localhost.buddycloud.org:8080        |
 |                                                 | 
 +-------------------------------------------------+ 
             |          |             |
       (port 2222) (port 5222)  (port 8080)
             |          |             |
 +-------------------------------------------------+
 |                                                 |
 |   buddycloud-VM                                 |
 |   -------------                                 |
 |   * hostname: localhost.buddycloud.org          |
 |   * runs complete buddycloud stack              |
 |   * TLS functions disabled                      |
 |   * federation disabled                         |
 |                                                 |
 +-------------------------------------------------+
```

### Running the Buddycloud VM

- Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Install [Vagrant](http://www.vagrantup.com/) (v1.7.2 or later)

```bash
git clone https://github.com/buddycloud/buddycloud-vm.git
cd buddycloud-vm
vagrant up
```

This build process will take anywhere from 1 to 10 minutes. The log of the build is stored inside the guest-VM (see below for accessing) `/var/log/salt/minion`.

### Access Buddycloud services running on the VM

[Demo](https://github.com/buddycloud/buddycloud-angular-app): http://localhost.buddycloud.org:8080

SSHing into the VM using `vagrant ssh`

### Configure buddycloud-vm

|                 | Outside the VM                                  | Inside the VM                      |
|-----------------|-------------------------------------------------|------------------------------------|
| basic setup     | `buddycloud-vm/saltstack/salt_local/salt`       | `/srv/salt_local/salt`             |     
| basic config    | `buddycloud-vm/saltstack/salt_local/pillar`     | `/srv/salt_local/pillar`           | 
| your changes    | `buddycloud-vm/saltstack/my_saltstack_repo`     | `/srv/my_saltstack_repo`           |
| [buddycloud stack](https://github.com/buddycloud/saltstack)  | `buddycloud-vm/saltstack/buddycloud_saltstack_repo` | `/srv/buddycloud_saltstack_repo` |

### [Re]configure the VM

```bash
salt "*" state.highstate -l all
```

### Adding your own changes

1. Fork https://github.com/buddycloud/saltstack
2. [inside the VM] `sudo git clone https://github.com/my-repo/saltstack.git /srv/my_saltstack_repo`
3. [inside the VM] add to /etc/salt/master
4. [inside the VM] `service salt-master restart`

You now have a configuration that is checked in the following order:

1. `/srv/salt_local/salt` is checked for [configs](https://github.com/buddycloud/buddycloud-vm/tree/master/saltstack/salt_local/pillar) and [what to install](https://github.com/buddycloud/buddycloud-vm/blob/master/saltstack/salt_local/salt/top.sls)
3. `/srv/my_saltstack_repo` is checked incase you decide to run your own packages
2. `/srv/buddycloud_saltstack_repo` is there as a fallback for all packages

### Shutting down the VM

Shut down Vagrant with: `vagrant halt`. Running `vagrant kill` will remove all disks and configs.

### Depoloying Buddycloud to different providers

To deploy to a hosting provider, edit the `Vagrantfile` with your cloud-hosting-provider data.

Google Cloud [background reading](https://github.com/mitchellh/vagrant-google)
```
vagrant plugin install vagrant-google
vagrant up --provider=google
```

VSphere 
```
vagrant plugin install vagrant-vsphere
vagrant up --provider=vsphere
```

## localhost.buddycloud.org

`localhost.buddycloud.org` is a special sub-domain hosted for this project. It always answers DNS queries with `127.0.0.1` which is great for testing code inside a guest VM.

zone-file:
```bind
localhost.buddycloud.org.           A 127.0.0.1
$ORIGIN .localhost.buddycloud.org.
api                                 A 127.0.0.1
webclient                           A 127.0.0.1
friendfinder                        A 127.0.0.1
search                              A 127.0.0.1
topics                              A 127.0.0.1
pusher                              A 127.0.0.1
s2s                                 A 127.0.0.1
buddycloud                          A 127.0.0.1
media                               A 127.0.0.1
c2s                                 A 127.0.0.1
channels                            A 127.0.0.1
_xmpp-client._tcp                   SRV 5 0 5222 c2s.localhost.buddycloud.org.
_xmpp-server._tcp                   SRV 5 0 5269 s2s.localhost.buddycloud.org.
_xmpp-server._tcp                   SRV 5 0 5269 s2s.localhost.buddycloud.org.
_xmpp-server._tcp                   SRV 5 0 5269 s2s.localhost.buddycloud.org.
_xmpp-server._tcp                   SRV 5 0 5269 s2s.localhost.buddycloud.org.
_xmpp-server._tcp                   SRV 5 0 5269 s2s.localhost.buddycloud.org.
_xmpp-server._tcp                   SRV 5 0 5269 s2s.localhost.buddycloud.org.
_xmpp-server._tcp                   SRV 5 0 5269 s2s.localhost.buddycloud.org.
_bcloud-server._tcp                 TXT "v=1.0 server=channels.localhost.buddycloud.org"
_buddycloud-api._tcp                TXT "v=1.0 host=localhost.buddycloud.org protocol=https path=/api port=8080"
```
