# Buddycloud-VM

This Vagrant-based virtual machine can be run locally as a complete buddycloud stack including the following components:
- xmpp server (Prosody and Tigase are included)
- buddycloud-server-java
- buddycloud-http-api
- buddycloud-media-server
- buddycloud-pusher
- buddycloud-angular-app

### Project Goals

**Ship identical bits to dev and production:** When development, staging and production environments use identical orchestration files you reduce the "but it worked in dev" scenarios.

**Quick:** The buddycloud-vm project is designed to a new developer a complete Buddycloud stack in about 10 mintues. Running locally.

### How it works

1. Vagrant to build a VM
2. Install a [definied list of components](https://github.com/buddycloud/buddycloud-vm/blob/master/saltstack/salt_local/salt/top.sls).
3. [Configure](https://github.com/buddycloud/saltstack/tree/master/salt) each package.

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

### Requirements

- [Vagrant](http://www.vagrantup.com/) (v1.7.2 or later)
- [Virtualbox](https://www.virtualbox.org/wiki/Downloads) (or libvirt)

### Setup

```bash
git clone https://github.com/buddycloud/buddycloud-vm.git
cd buddycloud-vm
vagrant up
```

Have patience! The build process will take anywhere from 5 to 10 minutes. You can watch progress with `sudo tail -F /var/log/salt/minion` inside the VM.

### Access

- Web: [demo](https://github.com/buddycloud/buddycloud-angular-app) at http://localhost.buddycloud.org:8080
- ssh: `vagrant ssh`

### Making Changes

|                 | Outside the VM                                  | Inside the VM                      |
|-----------------|-------------------------------------------------|------------------------------------|
| basic [what to install](https://github.com/buddycloud/buddycloud-vm/blob/master/saltstack/salt_local/salt/top.sls)    | `saltstack/salt_local/salt`       | `/srv/salt_local/salt`             |     
| basic [configs](https://github.com/buddycloud/buddycloud-vm/tree/master/saltstack/salt_local/pillar)   | `saltstack/salt_local/pillar`     | `/srv/salt_local/pillar`           | 
| somewhere for your own changes  | `saltstack/my_saltstack_repo`     | `/srv/my_saltstack_repo`           |
| [buddycloud stack](https://github.com/buddycloud/saltstack) as a fallback for all packages | `saltstack/buddycloud_saltstack_repo` | `/srv/buddycloud_saltstack_repo` |

Activating the changes
```bash
salt "*" state.highstate -l all
```

### about localhost.buddycloud.org

`localhost.buddycloud.org` is a special sub-domain hosted for this project. It answers all DNS queries with `127.0.0.1` which is great for testing code inside a VM.

for reference this is the current zone-file:
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

### Shutting down the VM

- Shut down Vagrant with: `vagrant halt`. 
- Running `vagrant kill` will remove all disks and configs.

### Deploying to cloud-providers

Generally you will want to run your own copy of saltstack to orchestrate changes to your production environment. If you would rather copy VMs around, edit the `Vagrantfile` and install the provider plugin. 

For example, Google Cloud ([background reading](https://github.com/mitchellh/vagrant-google)) uses
```
vagrant plugin install vagrant-google
vagrant up --provider=google
```
